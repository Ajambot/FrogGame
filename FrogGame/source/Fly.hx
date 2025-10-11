package;

import flixel.sound.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

enum FlyState {
	FLYING;
	LANDING;
	SITTING;
	TAKING_OFF;
	DEAD;
}

class Fly extends Enemy {
	private var bullets:FlxTypedGroup<FlxSprite>;
	private var terrain:FlxTilemap;
	private var currentState:FlyState = FlyState.FLYING;

	private var landCycleTimer:FlxTimer;
	private var canShoot:Bool = true;
	private var groundY:Float;
	private var velX:Int;
	private var velY:Int;
	var deathSound:FlxSound;

	public function new(x:Float, y:Float, bullets:FlxTypedGroup<FlxSprite>, terrain:FlxTilemap) {
		super(x, y);
		velX = FlxG.random.bool() ? -40 : 40;
		velY = FlxG.random.int(20, 40);
		deathSound = FlxG.sound.load(AssetPaths.KILLING_sound__wav);

		this.bullets = bullets;
		this.terrain = terrain;
		setFacingFlip(LEFT, true, false);

		// Load 3-frame sprite sheet (16x16 per frame)
		loadGraphic("assets/images/fly.png", true, 16, 16);

		// Define animations using only 3 frames [0, 1, 2]
		animation.add("fly", [0, 1, 2], 10, true); // All 3 frames for flying
		animation.add("sit", [2], 0, false); // Frame 2 for sitting
		animation.add("pop", [0, 1, 2], 15, false); // Quick cycle for death

		animation.play("fly");
		scale.set(2, 2);
		updateHitbox();

		groundY = FlxG.height - 70;
	}

	override public function damage():Void {
		kill();
		deathSound.play();
	}

	private function shoot():Void {
		if (currentState == FlyState.DEAD)
			return;

		var bullet = new FlxSprite(x + width / 2 - 2, y + height / 2);
		bullet.makeGraphic(4, 4, FlxColor.RED);
		bullet.velocity.x = facing == LEFT ? -200 : 200;

		new FlxTimer().start(3, function(_) {
			bullet.kill();
		});

		bullets.add(bullet);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(this, terrain);
		velocity.x = velX;
		velocity.y = velY;
		if (velX < 0) {
			facing = LEFT;
		}
		if (velX > 0) {
			facing = RIGHT;
		}
		if (canShoot) {
			shoot();
			canShoot = false;
			new FlxTimer().start(3, function(_) {
				canShoot = true;
			});
		}

		// Keep flies within screen bounds
		if (x < 20 || isTouching(LEFT)) {
			velX = velX > 0 ? velX : -velX;
		}
		if (x > FlxG.width - width - 20 || isTouching(RIGHT)) {
			velX = velX < 0 ? velX : -velX;
		}
		if (y < 20 || isTouching(UP)) {
			velY = velY > 0 ? velY : -velY;
		}
		if (y > FlxG.height - height - 40 || isTouching(DOWN)) {
			velY = velY < 0 ? velY : -velY;
		}
	}

	override public function destroy():Void {
		if (landCycleTimer != null) {
			landCycleTimer.destroy();
			landCycleTimer = null;
		}
		super.destroy();
	}
}
