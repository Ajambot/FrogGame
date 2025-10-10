import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class LevelState {
	public static function createLevel() {
		final map = new TiledMap("assets/TiledProjects/map.tmx");
		trace(map.layers);
		// final terrain:TiledObjectLayer = cast(map.getLayer("Terrain"));
		// final platformsGrp = new FlxTypedGroup<FlxSprite>();

		// for (platform in terrain.objects) {
		//	final platformSprt = new FlxSprite(platform.x, platform.y);
		//	platformSprt.loadGraphic("assets/images/Terrrain.png");
		//	platformsGrp.add(platformSprt);
		// }
		// FlxG.state.add(platformsGrp);
	}
}
