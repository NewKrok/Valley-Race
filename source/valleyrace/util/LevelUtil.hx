package valleyrace.util;

import flixel.math.FlxPoint;
import haxe.Json;
import haxe.Log;
import valleyrace.datatype.LevelData;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelUtil
{
	static inline var LEVEL_SCALE:Float = 1;

	static var worldNames:Array<String> = [
		"Pine Mountain",
		"Rocky Hill",
		"Challenges"
	];

	public static function LevelDataFromJson(jsonData:String):LevelData
	{
		var level:LevelData;

		try
		{
			level = Json.parse(jsonData);

			level.starValues = level.starValues == null ? [0, 0, 0] : level.starValues;

			level.startPoint = new FlxPoint(
				level.startPoint.x * LEVEL_SCALE,
				level.startPoint.y * LEVEL_SCALE
			);

			level.cameraBounds.x *= LEVEL_SCALE;
			level.cameraBounds.y *= LEVEL_SCALE;
			level.cameraBounds.width *= LEVEL_SCALE;
			level.cameraBounds.height *= LEVEL_SCALE;

			for (backgroundDataRow in level.polygonGroundData)
				for (backgroundDataCol in backgroundDataRow)
					for (background in backgroundDataCol)
						for (i in 0...background.polygon.length)
							background.polygon[i] = new FlxPoint(
								background.polygon[i].x * LEVEL_SCALE,
								background.polygon[i].y * LEVEL_SCALE
							);

			for (backgroundDataRow in level.polygonBackgroundData)
				for (backgroundDataCol in backgroundDataRow)
					for (background in backgroundDataCol)
						for (i in 0...background.polygon.length)
							background.polygon[i] = new FlxPoint(
								background.polygon[i].x * LEVEL_SCALE,
								background.polygon[i].y * LEVEL_SCALE
							);

			for (bridge in level.bridgePoints)
			{
				bridge.bridgeAX *= LEVEL_SCALE;
				bridge.bridgeAY *= LEVEL_SCALE;
				bridge.bridgeBX *= LEVEL_SCALE;
				bridge.bridgeBY *= LEVEL_SCALE;
			}

			for (i in 0...level.collectableItems.length)
				level.collectableItems[i] = new FlxPoint(
					level.collectableItems[i].x * LEVEL_SCALE,
					level.collectableItems[i].y * LEVEL_SCALE
				);

			if (level.staticElementData == null) level.staticElementData = [];
			level.staticElementData.push({
				position: { x: level.finishPoint.x * LEVEL_SCALE, y: level.finishPoint.y * LEVEL_SCALE },
				pivotX: 0,
				pivotY: 0,
				scaleX: 1,
				scaleY: 1,
				rotation: 0,
				elementId: "finish_table",
			});
		}
		catch( e:String )
		{
			Log.trace( "[LevelUtil] parsing error" );
			level = null;
		}

		return level;
	}

	public static function getWorldNameByWorldId(id:UInt):String
	{
		return worldNames[id];
	}
}