package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.effects.FlxFlicker;

class Ants extends FlxSprite {
	public var health:Int = 2;

	var isImmune:Bool = false;

	public var collideWith:FlxTypedGroup<FlxSprite>;
	public var walkSpeed:Float = 40;

	public function new(x:Float, y:Float, color:String = "red", collideObjects:FlxTypedGroup<FlxSprite> = null) {
		super(x, y);
		collideWith = collideObjects;

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);

		var normalized = color.toLowerCase();
		var path:String;
		if (normalized == "grey" || normalized == "gray") {
			path = "assets/images/GreyAnt.png";
		} else {
			path = "assets/images/RedAnt.png";
			walkSpeed = 60;
		}

		loadGraphic(path, true, 32, 32);

		animation.add("walk", [0, 1], 6, true);

		acceleration.y = 300;
		maxVelocity.set(100, 400);

		facing = LEFT;
		velocity.x = -walkSpeed;

		solid = true;
		immovable = false;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (collideWith != null) {
			FlxG.collide(this, collideWith);
		}

		if (isTouching(LEFT)) {
			facing = RIGHT;
			velocity.x = walkSpeed;
		} else if (isTouching(RIGHT)) {
			facing = LEFT;
			velocity.x = -walkSpeed;
		}

		if (isTouching(DOWN)) {
			animation.play("walk");
		}
	}

	public function damage() {
		if (isImmune)
			return;

		isImmune = true;
		health -= 1;
		FlxFlicker.flicker(this, 0.5, 0.1, true, true, function(flick:FlxFlicker) {
			isImmune = false;
		});

		if (health <= 0) {
			kill();
		}
	}
}
