package valleyrace.assets;

import haxe.Json;
import haxe.Log;
import valleyrace.util.SavedDataUtil;

import valleyrace.datatype.CarData;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CarDatas
{
	public static var MAX_SPEED(default, null):Float = 0;
	public static var MIN_SPEED(default, null):Float = 0;
	public static var MAX_ROTATION(default, null):Float = 0;
	public static var MIN_ROTATION(default, null):Float = 0;
	public static var MAX_ELASTICITY(default, null):Float = 0;
	public static var MIN_ELASTICITY(default, null):Float = 0;

	static var carDatas:Array<CarData>;

	public static function loadData(jsonData:String):Void
	{
		try
		{
			carDatas = Json.parse(jsonData).carDatas;

			for (data in carDatas)
			{
				for (prop in data.speed)
				{
					if (MAX_SPEED == 0 || prop > MAX_SPEED) MAX_SPEED = prop;
					if (MIN_SPEED == 0 || prop < MIN_SPEED) MIN_SPEED = prop;
				}
				for (prop in data.rotation)
				{
					if (MAX_ROTATION == 0 || prop > MAX_ROTATION) MAX_ROTATION = prop;
					if (MIN_ROTATION == 0 || prop < MIN_ROTATION) MIN_ROTATION = prop;
				}
				for (prop in data.elasticity)
				{
					if (MIN_ELASTICITY == 0 || prop > MIN_ELASTICITY) MIN_ELASTICITY = prop;
					if (MAX_ELASTICITY == 0 || prop < MAX_ELASTICITY) MAX_ELASTICITY = prop;
				}
			}
		}
		catch(e:String)
		{
			Log.trace("[CarDatas] parsing error");
			carDatas = null;
		}
	}

	public static function getData(carId:UInt):CarData
	{
		for (i in 0...carDatas.length)
		{
			if (carDatas[i].id == carId)
			{
				return carDatas[i];
			}
		}
		return null;
	}

	public static function getLeveledData(carId:UInt):CarLeveledData
	{
		var baseData:CarData = getData(carId);
		//var level:UInt = 0;//SavedDataUtil.getPlayerInfo().carDatas[carId].level;
		var level:UInt = SavedDataUtil.getPlayerInfo().carDatas[carId].level;

		return {
			name: baseData.name,
			id: baseData.id,
			speed: baseData.speed[level],
			rotation: baseData.rotation[level],
			elasticity: baseData.elasticity[level]
		}
	}
}