package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.group.FlxGroup.FlxTypedGroup;


class Ants extends FlxSprite {
    public var collideWith:FlxTypedGroup<FlxSprite>;
    public var walkSpeed:Float = 40;

    public function new(x:Float, y:Float, color:String = "red", collideObjects:FlxTypedGroup<FlxSprite> = null) {
        super(x, y);
        collideWith = collideObjects;

        
        setFacingFlip(LEFT, true, false);
        setFacingFlip(RIGHT, false, false);

        
        var normalized = color.toLowerCase();
        var path = if (normalized == "grey" || normalized == "gray") "assets/images/GreyAnt.png" else "assets/images/RedAnt.png";

       
        loadGraphic(path, false);
        
        
        var fullWidth = (graphic != null && graphic.bitmap != null) ? graphic.bitmap.width : 0;
        var fullHeight = (graphic != null && graphic.bitmap != null) ? graphic.bitmap.height : 0;
        
        trace("Ants: Loaded '" + path + "', fullWidth=" + fullWidth + ", fullHeight=" + fullHeight);
        
       
        if (fullWidth > 0 && fullHeight > 0) {
            var detectedFrameWidth = Std.int(fullWidth / 2);
            var detectedFrameHeight = fullHeight;
            
            trace("Ants: Auto-detected frame size: " + detectedFrameWidth + "x" + detectedFrameHeight);
            
           
            loadGraphic(path, true, detectedFrameWidth, detectedFrameHeight);
            animation.add("walk", [0, 1], 6, true);
            animation.play("walk");
            
            
            var hitboxW = Std.int(detectedFrameWidth * 0.6);
            var hitboxH = Std.int(detectedFrameHeight * 0.8);
            setSize(hitboxW, hitboxH);
            offset.set((detectedFrameWidth - hitboxW) / 2, detectedFrameHeight - hitboxH);
        } else {
            trace("Ants: Failed to load graphic '" + path + "' - using debug fallback.");
            
            makeGraphic(16, 16, FlxColor.MAGENTA);
            setSize(16, 16);
            offset.set(0, 0);
        }

        
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
        } else {
            velocity.x = if (facing == LEFT) -walkSpeed else walkSpeed;
        }

        if (isTouching(DOWN)) {
            animation.play("walk");
        }
    }
}
