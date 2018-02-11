package valleyrace.game.library.crate;

import hpp.flixel.util.HPPAssetManager;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SmallRampCrate extends AbstractCrate
{
	static inline var WIDTH:UInt = 50;
	static inline var HEIGHT:UInt = 25;

	override private function createPhysics():Void
	{
	}

	override private function createImage():Void
	{
		loadGraphic( HPPAssetManager.getGraphic( "crate_5" ) );
	}
}