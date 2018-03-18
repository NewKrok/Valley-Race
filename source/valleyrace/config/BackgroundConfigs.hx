package valleyrace.config;

import flixel.math.FlxPoint;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BackgroundConfigs
{
	static var config:Array<Array<BackgroundConfig>> = [
		[
			{
				assetId: 'back_world_0_a00',
				baseYOffset: 200,
				easing: new FlxPoint(.1, .1),
				xOverlap: -.5
			},
			{
				assetId: 'back_world_0_b00',
				baseYOffset: 300,
				easing: new FlxPoint(.25, .25),
				xOverlap: -.5
			},
			{
				assetId: 'back_world_0_c00',
				baseYOffset: 450,
				easing: new FlxPoint(.35, .35),
				xOverlap: -.5
			},
			{
				assetId: 'back_world_0_d00',
				baseYOffset: 640,
				easing: new FlxPoint(.45, .45),
				xOverlap: -.5
			}
		],
		[
			{
				assetId: 'back_world_1_a00',
				baseYOffset: 200,
				easing: new FlxPoint(.1, .1),
				xOverlap: -.5
			},
			{
				assetId: 'back_world_1_b00',
				baseYOffset: 300,
				easing: new FlxPoint(.25, .25),
				xOverlap: -.5
			},
			{
				assetId: 'back_world_1_c00',
				baseYOffset: 450,
				easing: new FlxPoint(.35, .35),
				xOverlap: -.5
			},
			{
				assetId: 'back_world_1_d00',
				baseYOffset: 640,
				easing: new FlxPoint(.45, .45),
				xOverlap: -.5
			}
		],
		[
			{
				assetId: 'back_world_0_a00',
				baseYOffset: 200,
				easing: new FlxPoint(.1, .1),
				xOverlap: -.5
			},
			{
				assetId: 'back_world_2_b00',
				baseYOffset: 300,
				easing: new FlxPoint(.25, .25),
				xOverlap: -.5
			},
			{
				assetId: 'back_world_2_c00',
				baseYOffset: 450,
				easing: new FlxPoint(.35, .35),
				xOverlap: -.5
			},
			{
				assetId: 'back_world_2_d00',
				baseYOffset: 640,
				easing: new FlxPoint(.45, .45),
				xOverlap: -.5
			}
		]
	];

	public static function getConfigConfigByWorld(worldId:UInt):Array<BackgroundConfig>
	{
		return config[worldId];
	}
}

typedef BackgroundConfig =
{
	var assetId:String;
	var baseYOffset:Float;
	var easing:FlxPoint;
	var xOverlap:Float;
}