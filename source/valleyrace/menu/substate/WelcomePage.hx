package valleyrace.menu.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.util.HPPAssetManager;
import openfl.net.URLRequest;

/**
 * ...
 * @author Krisztian Somoracz
 */
class WelcomePage extends FlxSubState
{
	var startButton:HPPButton;
	var homeButton:HPPButton;
	var facebookButton:HPPButton;
	var settingsButton:HPPButton;
	var aboutUsButton:HPPButton;
	var gitHubButton:HPPButton;
	var newsButton:HPPButton;
	var appStoreButton:HPPButton;

	var logo:FlxSprite;

	var openSettings:HPPButton->Void;
	var openWorldSelector:HPPButton->Void;
	var openNews:HPPButton->Void;
	var openAboutUs:HPPButton->Void;

	function new( openSettings:HPPButton->Void, openAboutUs:HPPButton->Void, openNews:HPPButton->Void, openWorldSelector:HPPButton->Void ):Void
	{
		super();

		this.openAboutUs = openAboutUs;
		this.openSettings = openSettings;
		this.openWorldSelector = openWorldSelector;
		this.openNews = openNews;
	}

	override public function create():Void
	{
		super.create();

		build();
	}

	function build():Void
	{
		logo = HPPAssetManager.getSprite( "logo" );
		logo.x = FlxG.stage.stageWidth / 2 - logo.width / 2;
		logo.y = 30;
		logo.scrollFactor.set();
		add( logo );

		appStoreButton = new HPPButton( "", openAppStore, "app_store_logo" );
		appStoreButton.overScale = 1.05;
		appStoreButton.x = FlxG.stage.stageWidth / 2 - appStoreButton.width / 2;
		appStoreButton.y = logo.y + logo.height;
		add( appStoreButton );

		startButton = new HPPButton( "", openWorldSelector, "play_game_button" );
		startButton.overScale = .98;
		startButton.x = FlxG.stage.stageWidth / 2 - startButton.width / 2;
		startButton.y = FlxG.stage.stageHeight / 2 - startButton.height / 2 + 70;
		add( startButton );

		homeButton = new HPPButton( "", goToHome, "home_button" );
		homeButton.overScale = .98;
		homeButton.x = 20;
		homeButton.y = 20;
		add( homeButton );

		facebookButton = new HPPButton( "", goToFacebook, "facebook_button" );
		facebookButton.overScale = .98;
		facebookButton.x = FlxG.stage.stageWidth - facebookButton.width - 20;
		facebookButton.y = 20;
		add( facebookButton );

		gitHubButton = new HPPButton( "", goToGithub, "github_button" );
		gitHubButton.overScale = .98;
		gitHubButton.x = facebookButton.x;
		gitHubButton.y = facebookButton.y + facebookButton.height + 10;
		add( gitHubButton );

		settingsButton = new HPPButton( "", openSettings, "options_button" );
		settingsButton.overScale = .98;
		settingsButton.x = FlxG.stage.stageWidth - facebookButton.width - 20;
		settingsButton.y = FlxG.stage.stageHeight - facebookButton.height - 20;
		add( settingsButton );

		aboutUsButton = new HPPButton( "", openAboutUs, "about_us_button" );
		aboutUsButton.overScale = .98;
		aboutUsButton.x = settingsButton.x - aboutUsButton.width - 20;
		aboutUsButton.y = settingsButton.y;
		add( aboutUsButton );

		newsButton = new HPPButton( "", openNews, "info_button" );
		newsButton.overScale = .98;
		newsButton.x = 20;
		newsButton.y = FlxG.stage.stageHeight - facebookButton.height - 20;
		add( newsButton );
	}

	function goToHome(target:HPPButton):Void
	{
		var homeURL:URLRequest = new URLRequest( "http://flashplusplus.net/?utm_source=Mountain-Monster-HTML5&utm_medium=welcome-page&utm_campaign=HTML5-Games" );
		openfl.Lib.getURL( homeURL, "_blank" );
	}

	function goToFacebook(target:HPPButton):Void
	{
		var facebookURL:URLRequest = new URLRequest( "https://www.facebook.com/flashplusplus" );
		openfl.Lib.getURL( facebookURL, "_blank" );
	}

	function goToGithub(target:HPPButton):Void
	{
		var githubURL:URLRequest = new URLRequest( "https://github.com/NewKrok/Mountain-Monster-X" );
		openfl.Lib.getURL( githubURL, "_blank" );
	}

	function openAppStore(target:HPPButton):Void
	{
		var appStoreURL:URLRequest = new URLRequest("https://itunes.apple.com/us/app/mountain-monster/id1041815415");
		openfl.Lib.getURL(appStoreURL, "_blank");
	}
}