package valleyrace.util;

import flixel.util.FlxSave;
import hpp.util.DeviceData;
import valleyrace.datatype.LevelData;
import openfl.Assets;
import valleyrace.AppConfig;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SavedDataUtil
{
	static private var gameSave:FlxSave;

	public static function load( dataName:String )
	{
		gameSave = new FlxSave();
		gameSave.bind( dataName );

		if (gameSave.data.baseInfo == null)
		{
			gameSave.data.baseInfo = {gameName: AppConfig.GAME_NAME, version: AppConfig.GAME_VERSION};
		}

		if (gameSave.data.playerInfo == null)
		{
			gameSave.data.playerInfo = {
				coin: 99999,
				selectedCar: 0,
				carDatas: [
					{ id: 0, isUnlocked: true, level: 0 },
					{ id: 1, isUnlocked: false, level: 0 },
					{ id: 1, isUnlocked: false, level: 0 }
				]
			};
		}

		if (gameSave.data.settings == null)
		{
			gameSave.data.settings = {
				showFPS: false,
				enableAlphaAnimation: DeviceData.isMobile() ? false : true
			};
		}

		if (gameSave.data.lastPlayedWorldId == null)
		{
			gameSave.data.lastPlayedWorldId = 0;
		}

		if (gameSave.data.levelInfos == null)
		{
			gameSave.data.levelInfos = [
				{
					worldId:0,
					levelId:0,
					score:0,
					starCount:0,
					collectedCoins:0,
					time:0,
					isEnabled:true,
					isCompleted:false,
					isLastPlayed:true
				},
				{
					worldId:1,
					levelId:0,
					score:0,
					starCount:0,
					collectedCoins:0,
					time:0,
					isEnabled:true,
					isCompleted:false,
					isLastPlayed:true
				}
			];
		}
	}

	public static function save():Void
	{
		gameSave.data.baseInfo.version = AppConfig.GAME_VERSION;
		gameSave.flush();
	}

	public static function getBaseAppInfo():AppSavedData
	{
		return gameSave.data.baseInfo;
	}

	public static function getPlayerInfo():PlayerSavedData
	{
		return gameSave.data.playerInfo;
	}

	public static function getAllLevelInfo():Array<LevelSavedData>
	{
		return gameSave.data.levelInfos;
	}

	public static function getLevelInfo(worldId:UInt, levelId:UInt):LevelSavedData
	{
		for ( i in 0...gameSave.data.levelInfos.length )
		{
			var levelInfo:LevelSavedData = gameSave.data.levelInfos[i];

			if (levelInfo.worldId == worldId && levelInfo.levelId == levelId)
			{
				return levelInfo;
			}
		}

		var newEntry:LevelSavedData = {
			worldId:worldId,
			levelId:levelId,
			score:0,
			starCount:0,
			collectedCoins:0,
			time:0,
			isEnabled:false,
			isCompleted:false,
			isLastPlayed:false
		};
		gameSave.data.levelInfos.push(newEntry);

		return newEntry;
	}

	static public function resetLastPlayedInfo()
	{
		for ( i in 0...gameSave.data.levelInfos.length )
		{
			var levelInfo:LevelSavedData = gameSave.data.levelInfos[i];
			levelInfo.isLastPlayed = false;
		}
	}

	public static function setLastPlayedWorldId(value:UInt):Void
	{
		gameSave.data.lastPlayedWorldId = value;
	}

	public static function getLastPlayedWorldId():UInt
	{
		return gameSave.data.lastPlayedWorldId;
	}

	static public function getLastPlayedLevel(worldId:UInt):UInt
	{
		for (i in 0...gameSave.data.levelInfos.length)
		{
			if (gameSave.data.levelInfos[i].worldId == worldId && gameSave.data.levelInfos[i].isLastPlayed)
			{
				return gameSave.data.levelInfos[i].levelId;
			}
		}

		return 0;
	}

	public static function getSettingsInfo():SettingsInfo
	{
		return gameSave.data.settings;
	}
}

typedef AppSavedData = {
	var gameName:String;
	var version:String;
}

typedef PlayerSavedData = {
	var coin:UInt;
	var selectedCar:UInt;
	var carDatas:Array<CarSavedData>;
}


typedef CarSavedData = {
	var id:UInt;
	var isUnlocked:Bool;
	var level:UInt;
}

typedef SettingsInfo = {
	var enableAlphaAnimation:Bool;
}

typedef LevelSavedData = {
	var worldId:UInt;
	var levelId:UInt;
	var score:UInt;
	var starCount:UInt;
	var collectedCoins:UInt;
	var time:Float;
	var isEnabled:Bool;
	var isCompleted:Bool;
	var isLastPlayed:Bool;
}