package valleyrace.util;

import flixel.util.FlxSave;
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

		if (gameSave.data.settings == null)
		{
			gameSave.data.settings = {
				showFPS: false,
				enableAlphaAnimation: false,
				show3StarsReplay: true,
				showPlayersReplay: true
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
					isLastPlayed:true,
					replay:null,
					replayCarId:0,
					isFullReplay: false
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
					isLastPlayed:true,
					replay:null,
					replayCarId:0,
					isFullReplay: false
				}
			];
		}
		// Recalculate level stars if the player changed from v1.2.1 or lower to v1.3.0 or higher
		else if (AppVersionUtil.isLowerThan(gameSave.data.baseInfo.version, "1.3.0"))
		{
			for (i in 0...gameSave.data.levelInfos.length)
			{
				var levelInfo:LevelInfo = gameSave.data.levelInfos[i];
				if (levelInfo.levelId > 23) break;

				var levelData:LevelData = LevelUtil.LevelDataFromJson( Assets.getText( "assets/data/level/world_" + levelInfo.worldId + "/level_" + levelInfo.worldId + "_" + levelInfo.levelId + ".json" ) );
				levelInfo.starCount = 0;
				for( i in 0...levelData.starValues.length)
				{
					if(levelInfo.score >= levelData.starValues[i])
						levelInfo.starCount = i + 1;
					else
						break;
				}
			}
			save();
		}

		// Hotfix for version 1.2.0
		getLevelInfo(1, 0).isEnabled = true;
	}

	public static function save():Void
	{
		gameSave.data.baseInfo.version = AppConfig.GAME_VERSION;
		gameSave.flush();
	}

	public static function getBaseAppInfo():BaseAppInfo
	{
		return gameSave.data.baseInfo;
	}

	public static function getAllLevelInfo():Array<LevelInfo>
	{
		return gameSave.data.levelInfos;
	}

	public static function getLevelInfo(worldId:UInt, levelId:UInt):LevelInfo
	{
		for ( i in 0...gameSave.data.levelInfos.length )
		{
			var levelInfo:LevelInfo = gameSave.data.levelInfos[i];

			if (levelInfo.worldId == worldId && levelInfo.levelId == levelId)
			{
				// Hotfix for some debug version
				if (Math.isNaN(levelInfo.replayCarId)) levelInfo.replayCarId = 0;

				return levelInfo;
			}
		}

		var newEntry:LevelInfo = {
			worldId:worldId,
			levelId:levelId,
			score:0,
			starCount:0,
			collectedCoins:0,
			time:0,
			isEnabled:false,
			isCompleted:false,
			isLastPlayed:false,
			replay:null,
			replayCarId:0,
			isFullReplay: false
		};
		gameSave.data.levelInfos.push(newEntry);

		return newEntry;
	}

	static public function resetLastPlayedInfo()
	{
		for ( i in 0...gameSave.data.levelInfos.length )
		{
			var levelInfo:LevelInfo = gameSave.data.levelInfos[i];
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

typedef BaseAppInfo = {
	var gameName:String;
	var version:String;
}

typedef SettingsInfo = {
	var enableAlphaAnimation:Bool;
	var show3StarsReplay:Bool;
	var showPlayersReplay:Bool;
}

typedef LevelInfo = {
	var worldId:UInt;
	var levelId:UInt;
	var score:UInt;
	var starCount:UInt;
	var collectedCoins:UInt;
	var time:Float;
	var isEnabled:Bool;
	var isCompleted:Bool;
	var isLastPlayed:Bool;
	var replay:String;
	var replayCarId:UInt;
	var isFullReplay:Bool;
}