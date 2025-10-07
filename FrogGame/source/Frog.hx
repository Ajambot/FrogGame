package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.effects.FlxFlicker;

class Frog extends FlxSprite {
	public var health:Int = 10;

	var collideWith:FlxTypedGroup<FlxSprite>;
	var enemies:FlxTypedGroup<Ants>;

	public var tongueHitbox:FlxSprite;
	public var tongueActive:Bool = false;
	public var isAttacking:Bool = false;

	var isWallJumping:Bool = false;
	var isImmune:Bool = false;

	public function new(x:Float, y:Float, collideObjects:FlxTypedGroup<FlxSprite>, enemyObjects:FlxTypedGroup<Ants>) {
		super(x, y);
		collideWith = collideObjects;
		enemies = enemyObjects;
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
			FlxG.collide(this, collideWith);
		} else if (facing == RIGHT) {
			var diffPos = offset.x - 31;
			offset.x = 31;
			x -= diffPos;
			FlxG.collide(this, collideWith);
		}

		if (FlxG.keys.anyPressed([LEFT, A]) && !isWallJumping) {
			velocity.x = -100;
			facing = LEFT;
		} else if (FlxG.keys.anyPressed([RIGHT, D]) && !isWallJumping) {
			velocity.x = 100;
			facing = RIGHT;
		}

		if (FlxG.keys.anyJustPressed([SPACE]) && !isAttacking && animation.name != "wallGrab") {
			animation.play("attack");
			isAttacking = true;
			doTongueAttack();

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

	public function doTongueAttack():Void {
		if (tongueActive)
			return; // prevent spamming

		tongueActive = true;

		var tongueLength:Float = 32;
		var tongueThickness:Float = 10;
		var halfThickness:Float = tongueThickness / 2;
		var tongueMiddleY:Float = y + height - 20;
		var tongueTop:Float = tongueMiddleY - halfThickness;
		var midX:Float = x + width / 2;

		var tongueX:Float;
		if (facing == RIGHT)
			tongueX = midX;
		else
			tongueX = midX - tongueLength;

		// Create the hitbox sprite
		tongueHitbox = new FlxSprite(tongueX, tongueTop);
		tongueHitbox.makeGraphic(Std.int(tongueLength), Std.int(tongueThickness), FlxColor.RED);
		tongueHitbox.alpha = 0; // invisible (set to 0.4 to debug)
		tongueHitbox.immovable = true;
		tongueHitbox.solid = true; // overlap only

		FlxG.state.add(tongueHitbox); // add to world

		// Check for overlap immediately
		FlxG.overlap(tongueHitbox, enemies, (_, enemy:Ants) -> {
			trace("Enemy hit!");
			enemy.damage();
		});

		// Remove hitbox after short delay (e.g., 0.1 sec)
		new FlxTimer().start(0.5, (_) -> {
			if (tongueHitbox != null && tongueHitbox.exists) {
				tongueHitbox.kill();
				tongueHitbox.destroy();
			}
			tongueActive = false;
		});
	}
}
