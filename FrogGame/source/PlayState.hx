package;

import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxState;
import Frog;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledMap;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;

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

		if (FlxG.sound.music == null) {
			FlxG.sound.playMusic(AssetPaths.BACKGROUND_music__ogg, 1, true);
		}
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
	override public function create():Void {
		super.create();
		FlxG.sound.music.stop();
		FlxG.sound.music = null;
		FlxG.sound.load(AssetPaths.GameWin__wav).play();

		//  Background image
		var bg = new FlxSprite(0, 0, "assets/images/win_bg.png");
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		//  YOU WIN text
		var winText = new FlxText(0, 60, FlxG.width, "🎉 YOU WIN! 🎉");
		winText.setFormat(null, 48, 0xFFFFFF, "center");
		add(winText);

		// "Return to Menu" button
		var menuBtn = new FlxButton(FlxG.width / 2 - 70, 240, "Return to Menu", function() {
			FlxG.switchState(() -> new MenuState());
		});
		menuBtn.scale.set(1.5, 1.5); // make it larger
		add(menuBtn);

		// "Play Again" button
		var retryBtn = new FlxButton(FlxG.width / 2 - 70, 180, "Play Again", function() {
			FlxG.switchState(() -> new PlayState());
		});
		retryBtn.scale.set(1.5, 1.5); // make it larger
		add(retryBtn);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Shortcut: ENTER to play again
		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(() -> new PlayState());
	}
}

class LoseState extends FlxState {
	override public function create():Void {
		super.create();
		FlxG.sound.music.stop();
		FlxG.sound.music = null;
		FlxG.sound.load(AssetPaths.GameLose__wav).play();

		//  Background image
		var bg = new FlxSprite(0, 0, "assets/images/lose_bg.png");
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		//  YOU LOSE text
		var loseText = new FlxText(0, 60, FlxG.width, "💀 YOU LOSE 💀");
		loseText.setFormat(null, 48, 0xFFFFFF, "center");
		add(loseText);

		// "Try Again" button
		var retryBtn = new FlxButton(FlxG.width / 2 - 70, 200, "Try Again", function() {
			FlxG.switchState(() -> new PlayState());
		});
		retryBtn.scale.set(1.5, 1.5); // make it larger
		add(retryBtn);

		// "Return to Menu" button
		var menuBtn = new FlxButton(FlxG.width / 2 - 70, 260, "Return to Menu", function() {
			FlxG.switchState(() -> new MenuState());
		});
		menuBtn.scale.set(1.5, 1.5); // make it larger
		add(menuBtn);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Shortcut: ENTER to retry quickly
		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(() -> new PlayState());
	}
}
