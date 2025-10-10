package;

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

class Fly extends FlxSprite {
    private var bullets:FlxTypedGroup<FlxSprite>;
    private var terrain:FlxTypedGroup<FlxSprite>;
    private var currentState:FlyState = FlyState.FLYING;

    private var landCycleTimer:FlxTimer;
    private var shootTimer:FlxTimer;
    private var groundY:Float;

    public function new(x:Float, y:Float, bullets:FlxTypedGroup<FlxSprite>, terrain:FlxTypedGroup<FlxSprite>) {
        super(x, y);

        this.bullets = bullets;
        this.terrain = terrain;

        loadGraphic("assets/images/fly.png", true, 32, 32);
        animation.add("fly", [0, 1, 2, 3], 10, true);
        animation.add("land", [4, 5, 6], 6, false);
        animation.add("sit", [6], 0, false);
        animation.add("takeoff", [6, 5, 4], 8, false);
        animation.add("pop", [7, 8, 9], 12, false);

        animation.play("fly");
        velocity.y = FlxG.random.float(-50, 50);
        velocity.x = FlxG.random.float(-30, 30);

        groundY = FlxG.height - 60;

        // === LANDING CYCLE ===
        landCycleTimer = new FlxTimer();
        landCycleTimer.start(FlxG.random.int(15, 20), function(_) {
            if (currentState == FlyState.FLYING)
                changeState(FlyState.LANDING);
        }, 0); // repeat indefinitely

        // === SHOOTING ===
        shootTimer = new FlxTimer();
        shootTimer.start(FlxG.random.float(2, 4), function(_) {
            if (currentState == FlyState.FLYING)
                shoot();
        }, 0);
    }

    private function changeState(newState:FlyState):Void {
        switch (newState) {
            case FlyState.LANDING:
                currentState = FlyState.LANDING;
                animation.play("land");
                velocity.set(0, 100);
                FlxTween.tween(this, { y: groundY }, 0.5, {
                    onComplete: function(_) {
                        changeState(FlyState.SITTING);
                    }
                });

            case FlyState.SITTING:
                currentState = FlyState.SITTING;
                animation.play("sit");
                velocity.set(0, 0);

                // Stay for 2–3 seconds, then take off
                new FlxTimer().start(FlxG.random.float(2, 3), function(_) {
                    changeState(FlyState.TAKING_OFF);
                });

            case FlyState.TAKING_OFF:
                currentState = FlyState.TAKING_OFF;
                animation.play("takeoff");
                FlxTween.tween(this, { y: y - 100 }, 0.5, {
                    onComplete: function(_) {
                        changeState(FlyState.FLYING);
                    }
                });

            case FlyState.FLYING:
                currentState = FlyState.FLYING;
                animation.play("fly");
                velocity.y = FlxG.random.float(-50, 50);
                velocity.x = FlxG.random.float(-40, 40);

            case FlyState.DEAD:
                currentState = DEAD;
                animation.play("pop");
                velocity.set(0, 0);
                
                // Stop shooting timer
                // if (shootTimer != null) shootTimer.kill();

                new FlxTimer().start(0.3, function(_) {
                    kill();
                });
        }
    }

    public function hitByFrog():Void {
        if (currentState == FlyState.SITTING) {
            changeState(FlyState.DEAD);
        }
    }
private function shoot():Void {
    if (currentState == FlyState.DEAD) return; // <-- STOP shooting if dead

    var bullet = new FlxSprite(x + width / 2 - 2, y + height / 2);
    bullet.makeGraphic(4, 4, FlxColor.RED);
    bullet.velocity.y = 200;

    new FlxTimer().start(3, function(_) { bullet.kill(); });

    bullets.add(bullet);
}

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Keep flies within screen bounds
        if (x < 20 || x > FlxG.width - width - 20)
            velocity.x *= -1;
        if (y < 0 || y > FlxG.height - height - 40)
            velocity.y *= -1;
    }
}
//  //  add this in playstate === FLIES ===
        // add(bullets);
        // var fly1 = new Fly(350, 100, bullets, terrain);
        // var fly2 = new Fly(500, 150, bullets, terrain);
        // flies.add(fly1);
        // flies.add(fly2);
        // add(flies);
        //  // === Frog vs Ants ===
        // FlxG.overlap(player, ants, function(p:Frog, a:Ants) {
        //     p.damage();
        // });

        // // === Frog vs Flies (touching the fly) ===
        // FlxG.overlap(player, flies, function(p:Frog, f:Fly) {
        //     f.hitByFrog(); // kills if sitting
        // });

        // // === Frog vs Red Bullets === 🩸
        // FlxG.overlap(player, bullets, function(p:Frog, b:FlxSprite) {
        //     b.kill();       // remove bullet
        //     p.damage();     // blink frog / lose life
        // });
