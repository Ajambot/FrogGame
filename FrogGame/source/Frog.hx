package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.effects.FlxFlicker;

class Frog extends FlxSprite {
	public var health:Int = 10;

	var collideWith:FlxTypedGroup<FlxSprite>;

	public var isAttacking:Bool = false;

	var isWallJumping:Bool = false;
	var isImmune:Bool = false;

	public function new(x:Float, y:Float, collideObjects:FlxTypedGroup<FlxSprite>) {
		super(x, y);
		collideWith = collideObjects;
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
		loadGraphic("assets/images/Frog.png", true, 71, 32);
		setSize(16, 32);
		offset.set(31, 0);

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
			setFacingFlip(LEFT, isTouching(LEFT), false);
			animation.play("wallGrab");
		} else {
			setFacingFlip(LEFT, true, false);
		}

		if (!isWallJumping) {
			velocity.x = 0;
		}

		if (facing == LEFT && !isAttacking) {
			var diffPos = offset.x - 23;
			offset.x = 23;
			x -= diffPos;
		} else if (facing == RIGHT) {
			var diffPos = offset.x - 31;
			offset.x = 31;
			x -= diffPos;
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
			setSize(40, 32);
			if (facing == LEFT) {
				var diffPos = offset.x - 0;
				offset.x = 0;
				x -= diffPos;
			}
			new FlxTimer().start(0.5, function(tmr:FlxTimer) {
				isAttacking = false;
				setSize(16, 32);
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

	public function damage() {
		if (isImmune)
			return;

		isImmune = true;
		health -= 1;
		FlxFlicker.flicker(this, 1, 0.1, true, true, function(flick:FlxFlicker) {
			isImmune = false;
		});

		if (health <= 0) {
			kill();
		}
	}

	override public function kill() {
		FlxG.resetState();
	}
}
