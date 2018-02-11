package valleyrace.assets;

import haxe.Json;
import haxe.Log;

import valleyrace.datatype.CarData;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CarDatas
{
	public static inline var MAX_SPEED:Float = 42;
	public static inline var MIN_SPEED:Float = 32;
	public static inline var MAX_ROTATION:Float = 2500;
	public static inline var MIN_ROTATION:Float = 1500;
	public static inline var MAX_ELASTICITY:Float = 0;
	public static inline var MIN_ELASTICITY:Float = 1;

	static var carDatas:Array<CarData>;

	public static function loadData( jsonData:String ):Void
	{
		try
		{
			carDatas = Json.parse( jsonData ).carDatas;
		}
		catch( e:String )
		{
			Log.trace( "[CarDatas] parsing error" );
			carDatas = null;
		}
	}

	public static function getData( carId:UInt ):CarData
	{
		for( i in 0...carDatas.length )
		{
			if( carDatas[i].id == carId )
			{
				return carDatas[i];
			}
		}
		return null;
	}
}