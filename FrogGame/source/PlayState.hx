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
	var ants:FlxTypedGroup<Ants> = new FlxTypedGroup<Ants>();
	var timer:Float = 60;
	var timerText:FlxText;
	var frogLifeText:FlxText;

	public var antsToKill = 5;

	var antsToKillText:FlxText;

	override public function create() {
		super.create();
		add(new FlxSprite().loadGraphic("assets/TiledProjects/bgimage.jpg"));
		// LevelState.createLevel();
		collidables = new FlxTilemap();
		collidables.loadMapFromCSV(AssetPaths.map_Collidables__csv, AssetPaths.frog__png, 16, 16);
		add(collidables);
		add(new FlxTilemap().loadMapFromCSV(AssetPaths.map_Decoration__csv, AssetPaths.frog__png, 16, 16));
		add(new FlxTilemap().loadMapFromCSV(AssetPaths.map_Timer__csv, AssetPaths.frog__png, 16, 16));

		timerText = new flixel.text.FlxText(25, 50, 0, "Time left: " + Std.string(timer).split(".")[0], 16);
		add(timerText);

		antsToKillText = new flixel.text.FlxText(250, 50, 0, "Ants to kill: " + Std.string(antsToKill), 16);
		add(antsToKillText);

		// floor = new FlxSprite(0, FlxG.height - 20);
		// floor.makeGraphic(FlxG.width, 20, FlxColor.BROWN);
		// floor.immovable = true;
		// floor.solid = true;
		// terrain.add(floor);

		// wall = new FlxSprite(0, 0);
		// wall.makeGraphic(20, FlxG.height, FlxColor.BROWN);
		// wall.immovable = true;
		// wall.solid = true;
		// terrain.add(wall);

		// wall = new FlxSprite(FlxG.width - 20, 0);
		// wall.makeGraphic(20, FlxG.height, FlxColor.BROWN);
		// wall.immovable = true;
		// wall.solid = true;
		// terrain.add(wall);

		// wall = new FlxSprite(150, 0);
		// wall.makeGraphic(20, FlxG.height - 100, FlxColor.BROWN);
		// wall.immovable = true;
		// wall.solid = true;
		// terrain.add(wall);

		// add(terrain);

		// Add ants for testing: one red and one grey
		var antKill = () -> {
			antsToKill -= 1;
			return null;
		};
		var redAnt = new Ants(200, 0, "red", collidables, antKill);
		redAnt.solid = true;
		ants.add(redAnt);

		var greyAnt = new Ants(260, 0, "grey", collidables, antKill);
		greyAnt.solid = true;
		ants.add(greyAnt);

		var redAnt = new Ants(220, 0, "red", collidables, antKill);
		redAnt.solid = true;
		ants.add(redAnt);

		var greyAnt = new Ants(280, 0, "grey", collidables, antKill);
		greyAnt.solid = true;
		ants.add(greyAnt);
		add(ants);

		var redAnt = new Ants(240, 0, "red", collidables, antKill);
		redAnt.solid = true;
		ants.add(redAnt);

		var greyAnt = new Ants(300, 0, "grey", collidables, antKill);
		greyAnt.solid = true;
		ants.add(greyAnt);

		player = new Frog(100, 100, collidables, ants);
		player.solid = true;
		add(player);

		frogLifeText = new flixel.text.FlxText(400, 50, 0, "Player Health: " + Std.string(player.health), 16);
		add(frogLifeText);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		timer -= elapsed;
		timerText.text = "Time left: " + Std.string(timer).split(".")[0];

		frogLifeText.text = "Player health: " + Std.string(player.health);

		antsToKillText.text = "Ants to kill: " + Std.string(antsToKill);

		if (timer <= 0) {
			FlxG.switchState(() -> new LoseState());
		}

		if (antsToKill <= 0) {
			FlxG.switchState(() -> new WinState());
		}

		if (!player.alive) {
			FlxG.switchState(() -> new LoseState());
		}

		FlxG.overlap(player, ants, function(player:Frog, ant:Ants) {
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
