package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;

class Frog extends FlxSprite {
	var collideWith:FlxObject;
	var isAttacking:Bool = false;

	public function new(x:Float, y:Float, collideObject:FlxObject) {
		super(x, y);
		collideWith = collideObject;
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
		loadGraphic("assets/images/Frog.png", true, 71, 32);
		animation.add("idle", [0, 1], 5);
		animation.add("move", [2, 3, 4, 5, 6, 7, 8, 9], 10);
		animation.add("jump", [10], 15);
		animation.add("fall", [11], 15);
		animation.add("attack", [12, 13, 14, 15, 16, 12], 15, false);
		animation.add("wallGrab", [17], 15);
		acceleration.y = 300;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		FlxG.collide(this, collideWith);

		if (isTouching(DOWN) && velocity.x != 0 && !isAttacking) {
			animation.play("move");
		} else if (isTouching(DOWN) && velocity.x == 0 && !isAttacking) {
			animation.play("idle");
		} else if (velocity.y < 0 && !isAttacking) {
			animation.play("jump");
		} else if (velocity.y > 0 && !isAttacking) {
			animation.play("fall");
		}

		velocity.x = 0;

		if (FlxG.keys.anyPressed([LEFT, A])) {
			velocity.x = -100;
			facing = LEFT;
		} else if (FlxG.keys.anyPressed([RIGHT, D])) {
			velocity.x = 100;
			facing = RIGHT;
		}

		if (FlxG.keys.anyJustPressed([SPACE]) && !isAttacking) {
			animation.play("attack");
			isAttacking = true;
			new FlxTimer().start(0.5, function(tmr:FlxTimer) {
				isAttacking = false;
			});
		}

		if (FlxG.keys.anyJustPressed([UP, W]) && isTouching(DOWN)) {
			velocity.y = -200;
			facing = UP;
		}
	}
}
