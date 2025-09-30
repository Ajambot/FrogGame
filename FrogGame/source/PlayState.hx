package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxState;
import Frog;
import flixel.FlxSprite;
import flixel.FlxG;

class PlayState extends FlxState {
	var floor:FlxSprite;
	var player:Frog;
	var wall:FlxSprite;
	var terrain:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	override public function create() {
		super.create();
		floor = new FlxSprite(0, FlxG.height - 20);
		floor.makeGraphic(FlxG.width, 20, FlxColor.BROWN);
		floor.immovable = true;
		floor.solid = true;
		terrain.add(floor);

		wall = new FlxSprite(0, 0);
		wall.makeGraphic(20, FlxG.height, FlxColor.BROWN);
		wall.immovable = true;
		wall.solid = true;
		terrain.add(wall);

		wall = new FlxSprite(FlxG.width - 20, 0);
		wall.makeGraphic(20, FlxG.height, FlxColor.BROWN);
		wall.immovable = true;
		wall.solid = true;
		terrain.add(wall);

		wall = new FlxSprite(150, 0);
		wall.makeGraphic(20, FlxG.height - 100, FlxColor.BROWN);
		wall.immovable = true;
		wall.solid = true;
		terrain.add(wall);

		add(terrain);

		player = new Frog(100, 100, terrain);
		player.solid = true;
		add(player);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
