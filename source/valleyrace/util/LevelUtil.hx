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
	private static var worldNames:Array<String> = [
		"Pine Mountain",
		"Ice World",
		"Desert Valley",
		"Candy Land"
	];

	public static function LevelDataFromJson(jsonData:String):LevelData
	{
		var level:LevelData;

		try
		{
			level = Json.parse(jsonData);

			for (background in level.polygonGroundData)
				for (i in 0...background.polygon.length)
					background.polygon[i] = new FlxPoint(background.polygon[i].x, background.polygon[i].y);

			if (level.polygonBackgroundData != null)
			{
				for (background in level.polygonBackgroundData)
					for (i in 0...background.polygon.length)
						background.polygon[i] = new FlxPoint(background.polygon[i].x, background.polygon[i].y);
			} else level.polygonBackgroundData = [];

			for (i in 0...level.collectableItems.length)
				level.collectableItems[i] = new FlxPoint(level.collectableItems[i].x, level.collectableItems[i].y);

			if (level.staticElementData == null) level.staticElementData = [];
			level.staticElementData.push({
				position: { x: level.finishPoint.x, y: level.finishPoint.y },
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