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
	public static inline var MAX_SPEED:Float = 25;
	public static inline var MIN_SPEED:Float = 15;
	public static inline var MAX_ROTATION:Float = 3750;
	public static inline var MIN_ROTATION:Float = 2500;
	public static inline var MAX_ELASTICITY:Float = .2;
	public static inline var MIN_ELASTICITY:Float = .7;

	static var carDatas:Array<CarData>;

	public static function loadData(jsonData:String):Void
	{
		try
		{
			carDatas = Json.parse(jsonData).carDatas;
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