package valleyrace.state;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.util.HPPAssetManager;
import js.Browser;
import valleyrace.game.Background;
import valleyrace.menu.substate.AboutUsPage;
import valleyrace.menu.substate.LevelSelector;
import valleyrace.menu.substate.SettingsPage;
import valleyrace.menu.substate.WelcomePage;
import valleyrace.menu.substate.WorldSelector;
import valleyrace.util.SavedDataUtil;
import openfl.Lib;
import openfl.display.Stage;
import openfl.events.MouseEvent;
import valleyrace.AppConfig;

/**
 * ...
 * @author Krisztian Somoracz
 */
class MenuState extends FlxState
{
	var stage:Stage;

	var background:Background;
	var backgroundTween:VarTween;
	var offsetPercent:FlxPoint = new FlxPoint();

	var welcomePage:WelcomePage;
	var settingsPage:SettingsPage;
	var aboutUsPage:AboutUsPage;
	var worldSelector:WorldSelector;
	var levelSelector:LevelSelector;

	var startState:MenuSubStateType;
	var config:MenuStateConfig;

	function new(startState:MenuSubStateType = MenuSubStateType.WELCOME_PAGE, config:MenuStateConfig)
	{
		super();

		this.startState = startState;

		// Only for test to start with an exact state
		/*this.startState = startState = MenuSubStateType.WELCOME_PAGE;
		config = {worldId:0};*/

		this.config = config;
	}

	override public function create():Void
	{
		super.create();

		loadAssets();
		build();

		switch (startState)
		{
			case MenuSubStateType.WELCOME_PAGE:
				openWelcomePage();

			case MenuSubStateType.WORLD_SELECTOR:
				openWorldSelector();

			case MenuSubStateType.LEVEL_SELECTOR:
				openLevelSelector(config.worldId);

			case MenuSubStateType.SETTINGS_PAGE:
				openSettingsPage();

			case MenuSubStateType.ABOUT_US_PAGE:
				openAboutUsPage();
		}

		if(AppConfig.IS_MOBILE_DEVICE)
		{
			#if html5
				Browser.window.addEventListener('devicemotion', accelerometerMove, true);
			#end
		}
		else
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		FlxG.sound.playMusic("assets/music/menu_loop.ogg", AppConfig.MUSIC_VOLUME == 1 ? .75 : 0, true);
	}

	function loadAssets():Void
	{
		HPPAssetManager.loadXMLAtlas("assets/images/atlas1.png", "assets/images/atlas1.xml");
		HPPAssetManager.loadXMLAtlas("assets/images/atlas2.png", "assets/images/atlas2.xml");
		HPPAssetManager.loadXMLAtlas("assets/images/atlas3.png", "assets/images/atlas3.xml");
	}

	function build():Void
	{
		persistentUpdate = true;

		stage = Lib.current.stage;

		add(background = new Background(SavedDataUtil.getLastPlayedWorldId()));

		destroySubStates = false;
		welcomePage = new WelcomePage(openSettingsPage, openAboutUsPage, openWorldSelector);
		settingsPage = new SettingsPage(openWelcomePage);
		aboutUsPage = new AboutUsPage(openWelcomePage);
		worldSelector = new WorldSelector(openWelcomePage, openLevelSelector);

		camera.scroll.set(stage.stageWidth / 2, stage.stageHeight / 2);
		onMouseMove(null);

		// To start immediately the game...
		//FlxG.switchState(new GameState(0, 0));
	}

	function openWelcomePage(target:HPPButton = null):Void
	{
		FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);
		openSubState(welcomePage);
	}

	function openSettingsPage(target:HPPButton = null):Void
	{
		FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);
		openSubState(settingsPage);
	}

	function openAboutUsPage(target:HPPButton = null):Void
	{
		FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);
		openSubState(aboutUsPage);
	}

	function openLevelSelector(worldId:UInt):Void
	{
		FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);

		var needCreateNewLevelSelector:Bool = true;

		if (levelSelector != null)
		{
			if (levelSelector.worldId != worldId)
			{
				levelSelector.destroy();
				levelSelector = null;
			}
			else
			{
				needCreateNewLevelSelector = false;
			}
		}

		if (needCreateNewLevelSelector)
		{
			levelSelector = new LevelSelector(openWorldSelector);
			levelSelector.worldId = worldId;
		}

		background.worldId = worldId;

		openSubState(levelSelector);
	}

	function openWorldSelector(target:HPPButton = null):Void
	{
		FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);

		openSubState(worldSelector);
	}

	#if html5
	function accelerometerMove(e):Void
	{
		offsetPercent.set(stage.stageWidth / 2 + e.accelerationIncludingGravity.y * 15, stage.stageHeight / 2 + e.accelerationIncludingGravity.x * 15);

		removeBackgroundTween();
		backgroundTween = FlxTween.tween(
			camera.scroll,
			{ x: offsetPercent.x, y: offsetPercent.y },
			.4,
			{ ease: FlxEase.expoOut }
		);
	}
	#end

	function onMouseMove(e:MouseEvent):Void
	{
		var centerX:Float = stage.stageWidth / 2;
		var centerY:Float = stage.stageHeight / 2;

		var xDirection:Int = stage.mouseX > centerX ? -1 : 1;
		var yDirection:Int = stage.mouseY > centerY ? -1 : 1;

		var xRatio:Float = (stage.mouseX - centerX) / centerX * -1;
		var yRatio:Float = (stage.mouseY - centerY) / centerY;

		offsetPercent.set(stage.stageWidth / 2 - xRatio * 50, stage.stageHeight / 2 + yRatio * 50 + 500);

		if (e != null)
		{
			removeBackgroundTween();
			backgroundTween = FlxTween.tween(
				camera.scroll,
				{ x: offsetPercent.x, y: offsetPercent.y },
				.4,
				{ ease: FlxEase.expoOut }
			);
		}
		else
		{
			camera.scroll.set(offsetPercent.x, offsetPercent.y);
		}
	}

	function removeBackgroundTween():Void
	{
		if (backgroundTween != null)
		{
			backgroundTween.cancel();
			backgroundTween.destroy();
			backgroundTween = null;
		}
	}

	override public function destroy():Void
	{
		HPPAssetManager.clear();

		#if html5
		Browser.window.removeEventListener('devicemotion', accelerometerMove, true);
		#end

		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

		FlxG.sound.music.stop();

		super.destroy();
	}
}

@:enum
abstract MenuSubStateType(String) {
  var WELCOME_PAGE = "welcome page";
  var WORLD_SELECTOR = "world selector";
  var LEVEL_SELECTOR = "level selector";
  var SETTINGS_PAGE = "settings page";
  var ABOUT_US_PAGE = "about us page";
}

typedef MenuStateConfig = {
	@:optional var worldId:UInt;
	@:optional var levelId:UInt;
}