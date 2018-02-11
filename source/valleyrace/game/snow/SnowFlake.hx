package valleyrace.game.snow;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import hpp.flixel.util.HPPAssetManager;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SnowFlake extends FlxSprite
{
	var speedVector:FlxPoint;

	public function new()
	{
		super();

		loadGraphic( HPPAssetManager.getGraphic( "snowflake" ) );

		init();

		x = Math.random() * FlxG.width;
		y = Math.random() * FlxG.height - 50;
	}

	function init():Void
	{
		x = Math.random() * ( FlxG.width + 200 ) + 100;
		y = Math.random() * -50 - 100;

		setSpeed();
		setScale();
		setAlpha();
	}

	function setSpeed():Void
	{
		speedVector = new FlxPoint( Math.random() * -8, Math.random() * 8 + 4 );
	}

	function setScale():Void
	{
		var newScale:Float = Math.random() * 2 + .2;
		scale.set( newScale, newScale );
	}

	function setAlpha():Void
	{
		alpha = Math.random() + .3 - scale.x / 5;
	}

	override public function update(elapsed:Float):Void
	{
		x += speedVector.x;
		y += speedVector.y;

		if( x > FlxG.width || y > FlxG.height )
		{
			init();
		}
	}
}