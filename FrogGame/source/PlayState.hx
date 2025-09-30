package;

import flixel.FlxState;
import Frog;

class PlayState extends FlxState {
	override public function create() {
		super.create();
		add(new Frog(100, 100));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
