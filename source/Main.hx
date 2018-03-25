package;

import flixel.FlxG;
import hpp.flixel.system.HPPFlxMain;
import hpp.util.BrowserData;
import hpp.util.DeviceData;
import hpp.util.JsFullScreenUtil;
import openfl.Assets;
import openfl.display.Sprite;
import valleyrace.AppConfig;
import valleyrace.assets.CarDatas;
import valleyrace.assets.Fonts;
import valleyrace.state.MenuState;
import valleyrace.util.SavedDataUtil;

class Main extends Sprite
{
	// Only for fast level test
	public static var DEBUG_LEVEL:String = "";

	public function new()
	{
		super();

		// Only for fast level test
		//untyped __js__("window.addEventListener('paste', (e)=>this.onPaste(e));");

		SavedDataUtil.load( "FPP_ValleyRaceSavedData" );
		var settingsInfo:SettingsInfo = SavedDataUtil.getSettingsInfo();

		AppConfig.IS_ALPHA_ANIMATION_ENABLED = settingsInfo.enableAlphaAnimation;
		AppConfig.MUSIC_VOLUME = settingsInfo.musicVolume;
		AppConfig.SOUND_VOLUME = settingsInfo.soundVolume;
		AppConfig.IS_MOBILE_DEVICE = DeviceData.isMobile();
		AppConfig.IS_SVG_FONT = BrowserData.get().type == BrowserType.Safari;

		CarDatas.loadData(Assets.getText("assets/data/car_datas.json"));

		JsFullScreenUtil.init("openfl-content");
		Fonts.init();

		addChild( new HPPFlxMain( 0, 0, MenuState ) );

		FlxG.mouse.unload();
		FlxG.mouse.useSystemCursor = true;

		untyped __js__("
			window.addEventListener('keydown', function(e) {
				if([32, 37, 38, 39, 40].indexOf(e.keyCode) > -1) {
					e.preventDefault();
				}
			}, false);
		");
	}

	// Only for fast level test
	/*function onPaste(e:Dynamic)
	{
		try
		{
			DEBUG_LEVEL = e.clipboardData.getData('text/plain');
			trace("Level loaded!");
		}
		catch (e:Dynamic)
		{
			DEBUG_LEVEL = "";
			trace("Wrong data! Update your clipboard and try again.");
		}
	}*/
}