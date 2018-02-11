package;

import flixel.FlxG;
import hpp.flixel.system.HPPFlxMain;
import hpp.util.DeviceData;
import hpp.util.JsFullScreenUtil;
import js.Browser;
import valleyrace.AppConfig;
import valleyrace.assets.Fonts;
import valleyrace.state.MenuState;
import valleyrace.util.SavedDataUtil;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		SavedDataUtil.load( "ValleyRaceSavedData" );
		var settingsInfo:SettingsInfo = SavedDataUtil.getSettingsInfo();

		AppConfig.IS_ALPHA_ANIMATION_ENABLED = settingsInfo.enableAlphaAnimation;
		AppConfig.SHOW_3_STAR_REPLAY = settingsInfo.show3StarsReplay;
		AppConfig.SHOW_PLAYER_REPLAY = settingsInfo.showPlayersReplay;
		AppConfig.IS_MOBILE_DEVICE = DeviceData.isMobile();

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
}