package valleyrace.util;

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