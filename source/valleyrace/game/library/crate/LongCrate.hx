package valleyrace.game.library.crate;

import hpp.flixel.util.HPPAssetManager;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Polygon;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LongCrate extends AbstractCrate
{
	static inline var WIDTH:UInt = 150;
	static inline var HEIGHT:UInt = 75;

	override private function createPhysics():Void
	{
		body = new Body();
		body.shapes.add( new Polygon( Polygon.box( WIDTH, HEIGHT ) ) );
		body.setShapeMaterials( new Material( .5, .5, .5, 2, 0.001 ) );
		body.setShapeFilters( filter );
		body.space = space;
	}

	override private function createImage():Void
	{
		loadGraphic( HPPAssetManager.getGraphic( "crate_2" ) );
	}
}