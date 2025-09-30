package;

import flixel.util.FlxColor;
import flixel.FlxState;
import Frog;
import flixel.FlxSprite;
import flixel.FlxG;

class PlayState extends FlxState {
	var floor:FlxSprite;
	var player:Frog;

	override public function create() {
		super.create();
		floor = new FlxSprite(0, FlxG.height - 20);
		floor.makeGraphic(FlxG.width, 20, FlxColor.BROWN);
		floor.immovable = true;
		floor.solid = true;
		add(floor);
		player = new Frog(100, 100, floor);
		player.solid = true;
		add(player);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
