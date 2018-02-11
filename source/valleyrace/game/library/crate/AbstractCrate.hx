package valleyrace.game.library.crate;

import flixel.FlxSprite;
import flixel.math.FlxAngle;
import valleyrace.game.constant.CPhysicsValue;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AbstractCrate extends FlxSprite
{
	var baseXPosition:Float;
	var baseYPosition:Float;
	var baseScale:Float;

	var filter:InteractionFilter;
	var body:Body;
	var space:Space;

	public function new( space:Space, x:Float, y:Float, scale:Float )
	{
		super();

		this.space = space;

		baseXPosition = x;
		baseYPosition = y;
		baseScale = scale;

		filter = new InteractionFilter();
		filter.collisionGroup = CPhysicsValue.CRATE_FILTER_CATEGORY;
		filter.collisionMask = CPhysicsValue.CRATE_FILTER_MASK;

		createPhysics();
		createImage();

		resetToDefault();
	}

	function createPhysics():Void
	{
	}

	function createImage():Void
	{
	}

	public function resetToDefault():Void
	{
		scale.set( baseScale, 1 );

		if ( body != null )
		{
			body.rotation = 0;
			body.velocity.setxy( 0, 0 );
			body.angularVel = 0;
			body.position.set( new Vec2( baseXPosition, baseYPosition ) );
		}
	}

	override public function update( elapsed:Float ):Void
	{
		super.update( elapsed );

		if ( body != null )
		{
			x = body.position.x - origin.x;
			y = body.position.y - origin.y;
			angle = body.rotation * FlxAngle.TO_DEG;
		}
	}
}