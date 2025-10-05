package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;

class Frog extends FlxSprite {
	var collideWith:FlxTypedGroup<FlxSprite>;
	var isAttacking:Bool = false;
	var isWallJumping:Bool = false;

	public function new(x:Float, y:Float, collideObjects:FlxTypedGroup<FlxSprite>) {
		super(x, y);
		collideWith = collideObjects;
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
		loadGraphic("assets/images/Frog.png", true, 71, 32);
		setSize(16, 32);
		offset.set((71 - 16) / 2, 0);

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

		if ((isTouching(LEFT) || isTouching(RIGHT)) && !isTouching(DOWN)) {
			facing = facing == LEFT ? RIGHT : LEFT;
			animation.play("wallGrab");
		}

		if (!isWallJumping) {
			velocity.x = 0;
		}

		if (FlxG.keys.anyPressed([LEFT, A]) && !isWallJumping) {
			velocity.x = -100;
			facing = LEFT;
		} else if (FlxG.keys.anyPressed([RIGHT, D]) && !isWallJumping) {
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

		if (FlxG.keys.anyJustPressed([UP, W]) && (isTouching(DOWN) || isTouching(LEFT) || isTouching(RIGHT))) {
			if (isTouching(LEFT)) {
				velocity.x = 200;
				isWallJumping = true;
				new FlxTimer().start(0.2, function(tmr:FlxTimer) {
					isWallJumping = false;
				});
			} else if (isTouching(RIGHT)) {
				velocity.x = -200;
				isWallJumping = true;
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
					isWallJumping = false;
				});
			}
			velocity.y = -200;
		}
	}
}
