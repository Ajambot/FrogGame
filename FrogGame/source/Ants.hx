package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.tile.FlxTilemap;

class Ants extends Enemy {
	public var health:Int = 1;

	var isImmune:Bool = false;

	public var collideWith:FlxTilemap;
	public var walkSpeed:Float = 40;

	public function new(x:Float, y:Float, color:String = "red", collideObjects:FlxTilemap) {
		super(x, y);
		collideWith = collideObjects;
		solid = true;

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);

		var normalized = color.toLowerCase();
		var path:String;
		if (normalized == "grey" || normalized == "gray") {
			path = "assets/images/GreyAnt.png";
		} else {
			path = "assets/images/RedAnt.png";
			walkSpeed = 60;
			health = 2;
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

		var offsetX = facing == LEFT ? 1 : 33;
		var offsetY = height + 1;
		var ahead = collideWith.getTileDataAt(x + offsetX, y + offsetY);
		if (ahead == null || (ahead != null && !ahead.visible)) {
			facing = facing == LEFT ? RIGHT : LEFT;
			velocity.x *= -1;
		}

		if (isTouching(DOWN)) {
			animation.play("walk");
		}
	}

	override public function damage() {
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
