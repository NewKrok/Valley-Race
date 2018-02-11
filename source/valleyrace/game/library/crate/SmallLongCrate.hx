package valleyrace.game.library.crate;

import hpp.flixel.util.HPPAssetManager;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Polygon;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SmallLongCrate extends AbstractCrate
{
	static inline var WIDTH:UInt = 100;
	static inline var HEIGHT:UInt = 50;

	override private function createPhysics():Void
	{
		body = new Body();
		var shape:Array<Vec2>;

		if( baseScale == 1 )
		{
			shape = [
				new Vec2( WIDTH / 2 * -1, HEIGHT / 2 * -1 ),
				new Vec2( WIDTH / 2, HEIGHT / 2 ),
				new Vec2( WIDTH / 2 * -1, HEIGHT / 2 )
			];
		}
		else
		{
			shape = [
				new Vec2( WIDTH / 2, HEIGHT / 2 * -1 ),
				new Vec2( WIDTH / 2, HEIGHT / 2 ),
				new Vec2( WIDTH / 2 * -1, HEIGHT / 2 )
			];
		}

		body.shapes.add( new Polygon( shape ) );
		body.setShapeMaterials( new Material( .5, .5, .5, 2, 0.001 ) );
		body.setShapeFilters( filter );
		body.space = space;
	}

	override private function createImage():Void
	{
		loadGraphic( HPPAssetManager.getGraphic( "crate_3" ) );
	}
}