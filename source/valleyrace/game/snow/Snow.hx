package valleyrace.game.snow;

import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Snow extends FlxSpriteGroup
{
	static inline var NUMBER_OF_SNOWFLAKE:UInt = 100;

	var snowFlakes:Array<SnowFlake>;

	public function new()
	{
		super();

		snowFlakes = [];

		for ( i in 0...NUMBER_OF_SNOWFLAKE )
		{
			var snowFlake:SnowFlake = new SnowFlake();

			snowFlakes.push( snowFlake );
			add( snowFlake );
		}

		scrollFactor.set();
	}
}