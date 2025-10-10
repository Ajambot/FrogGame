package;

import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxState;
import Frog;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledMap;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState {
	var floor:FlxSprite;
	var player:Frog;
	var wall:FlxSprite;
	var collidables:FlxTilemap;
	var enemies:FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();
	var timer:Float = 60;
	var timerText:FlxText;
	var frogLifeText:FlxText;
	var bullets:FlxTypedGroup<FlxSprite>;

	override public function create() {
		super.create();

		add(new FlxSprite().loadGraphic("assets/TiledProjects/bgimage.jpg"));
		collidables = new FlxTilemap();
		collidables.loadMapFromCSV(AssetPaths.map_Collidables__csv, AssetPaths.frog__png, 16, 16);
		add(collidables);
		add(new FlxTilemap().loadMapFromCSV(AssetPaths.map_Decoration__csv, AssetPaths.frog__png, 16, 16));
		add(new FlxTilemap().loadMapFromCSV(AssetPaths.map_Timer__csv, AssetPaths.frog__png, 16, 16));

		timerText = new flixel.text.FlxText(583, 24, 0, Std.string(timer).split(".")[0], 10,);
		timerText.color = FlxColor.fromString("#C5CCB8");
		add(timerText);

		enemies.add(new Ants(128, 256, "red", collidables));
		enemies.add(new Ants(464, 256, "grey", collidables));
		enemies.add(new Ants(560, 256, "red", collidables));
		enemies.add(new Ants(448, 80, "red", collidables));
		enemies.add(new Ants(64, 80, "grey", collidables));

		bullets = new FlxTypedGroup<FlxSprite>();
		add(bullets);
		enemies.add(new Fly(128, 256, bullets, collidables));

		add(enemies);

		player = new Frog(10, 240, collidables, enemies);
		player.solid = true;
		add(player);

		frogLifeText = new flixel.text.FlxText(20, 15, 0, "Player Health: " + Std.string(player.health), 16);
		add(frogLifeText);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		timer -= elapsed;
		timerText.text = Std.string(timer).split(".")[0];

		frogLifeText.text = "Player health: " + Std.string(player.health);

		if (timer <= 0) {
			FlxG.switchState(() -> new LoseState());
		}

		trace("Enemies: " + enemies.getFirstAlive() == null);
		if (enemies.getFirstAlive() == null) {
			FlxG.switchState(() -> new WinState());
		}

		if (!player.alive) {
			FlxG.switchState(() -> new LoseState());
		}

		FlxG.overlap(player, enemies, function(player:Frog, ant:Ants) {
			player.damage();
		});

		FlxG.overlap(player, bullets, function(player:Frog, bullet:FlxSprite) {
			player.damage();
		});
	}
}

class WinState extends FlxState {
	override public function create() {
		super.create();
		var text = new flixel.text.FlxText(0, 0, 0, "You win", 64);
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}

class LoseState extends FlxState {
	override public function create() {
		super.create();
		var text = new flixel.text.FlxText(0, 0, 0, "You lose", 64);
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
