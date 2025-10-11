package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;

class MenuState extends FlxState
{
    override public function create():Void
    {
        super.create();

       
        var bg = new FlxSprite(0, 0, "assets/images/menu_bg.jpg");
        bg.setGraphicSize(FlxG.width, FlxG.height);
        bg.updateHitbox();
        add(bg);

        //  Game Title
        var title = new FlxText(0, 80, FlxG.width, "FROG Game");
        title.setFormat(null, 40, 0xFFFFFF, "center");
        add(title);

        //  Play Button
        var playBtn = new FlxButton(FlxG.width / 2 - 60, FlxG.height / 2 + 30, "PLAY", function() {
            FlxG.switchState(() -> new PlayState());
        });
        playBtn.scale.set(2, 2); // Make it big
        add(playBtn);

        //  Optional credits line
        var credits = new FlxText(0, FlxG.height - 40, FlxG.width, "Created by Group 3");
        credits.setFormat(null, 10, 0xDDDDDD, "center");
        add(credits);
    }
}
