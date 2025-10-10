import flixel.FlxSprite;

class Enemy extends FlxSprite {
	public function damage():Void {
		kill();
	}
}
