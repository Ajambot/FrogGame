package;

import flixel.FlxSprite;
import flixel.FlxG;

class Frog extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic("assets/images/FrogWalking.png", true, 16, 16);
		animation.add("idle", [0], 15);
		animation.add("move", [0, 1, 2, 3, 4, 5, 6, 7], 15);
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (velocity.x != 0) {
			animation.play("move");
		} else {
			animation.play("idle");
		}
		velocity.x = 0;
		velocity.y = 0;

		if (FlxG.keys.anyPressed([LEFT, A])) {
			velocity.x = -100;
			facing = LEFT;
		} else if (FlxG.keys.anyPressed([RIGHT, D])) {
			velocity.x = 100;
			facing = RIGHT;
		} // else if (FlxG.keys.anyPressed([UP, W])) {
		//	velocity.y = -100;
		//	facing = UP;
		// } else if (FlxG.keys.anyPressed([DOWN, S])) {
		//	velocity.y = 100;
		//	facing = DOWN;
		// }
	}
}
