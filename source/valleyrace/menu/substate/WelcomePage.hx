package valleyrace.menu.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPHUIBox;
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
	var youtubeButton:HPPButton;
	var settingsButton:HPPButton;
	var aboutUsButton:HPPButton;
	var gitHubButton:HPPButton;
	var newsButton:HPPButton;

	var logo:FlxSprite;

	var openSettings:HPPButton->Void;
	var openWorldSelector:HPPButton->Void;
	var openAboutUs:HPPButton->Void;

	function new(openSettings:HPPButton->Void, openAboutUs:HPPButton->Void, openWorldSelector:HPPButton->Void):Void
	{
		super();

		this.openAboutUs = openAboutUs;
		this.openSettings = openSettings;
		this.openWorldSelector = openWorldSelector;
	}

	override public function create():Void
	{
		super.create();

		build();
	}

	function build():Void
	{
		logo = HPPAssetManager.getSprite("game_logo");
		logo.x = FlxG.stage.stageWidth / 2 - logo.width / 2;
		logo.y = 50;
		logo.scrollFactor.set();
		add(logo);

		startButton = new HPPButton("", openWorldSelector, "play_button");
		startButton.overScale = .98;
		startButton.x = FlxG.stage.stageWidth / 2 - startButton.width / 2;
		startButton.y = FlxG.stage.stageHeight / 2 - startButton.height / 2;
		add(startButton);

		var leftContainer = new HPPHUIBox(10);
		leftContainer.scrollFactor.set();

		homeButton = new HPPButton("", goToHome, "home_button");
		homeButton.overScale = .98;
		leftContainer.add(homeButton);

		facebookButton = new HPPButton("", goToFacebook, "facebook_button");
		facebookButton.overScale = .98;
		leftContainer.add(facebookButton);

		youtubeButton = new HPPButton("", goToYoutube, "youtube_button");
		youtubeButton.overScale = .98;
		leftContainer.add(youtubeButton);

		gitHubButton = new HPPButton("", goToGithub, "github_button");
		gitHubButton.overScale = .98;
		leftContainer.add(gitHubButton);

		leftContainer.x = 20;
		leftContainer.y = FlxG.stage.stageHeight - leftContainer.height - 20;
		add(leftContainer);

		var rightContainer = new HPPHUIBox(10);
		rightContainer.scrollFactor.set();

		settingsButton = new HPPButton("", openSettings, "options_button");
		settingsButton.overScale = .98;
		settingsButton.x = FlxG.stage.stageWidth - facebookButton.width - 20;
		settingsButton.y = FlxG.stage.stageHeight - facebookButton.height - 20;
		rightContainer.add(settingsButton);

		aboutUsButton = new HPPButton("", openAboutUs, "about_us_button");
		aboutUsButton.overScale = .98;
		aboutUsButton.x = settingsButton.x - aboutUsButton.width - 20;
		aboutUsButton.y = settingsButton.y;
		rightContainer.add(aboutUsButton);

		rightContainer.x = FlxG.stage.stageWidth - rightContainer.width - 20;
		rightContainer.y = FlxG.stage.stageHeight - rightContainer.height - 20;
		add(rightContainer);
	}

	function goToHome(target:HPPButton):Void
	{
		var homeURL:URLRequest = new URLRequest("http://flashplusplus.net/?utm_source=Valley-Race&utm_medium=welcome-page&utm_campaign=HTML5-Games");
		openfl.Lib.getURL(homeURL, "_blank");
	}

	function goToFacebook(target:HPPButton):Void
	{
		var facebookURL:URLRequest = new URLRequest("https://www.facebook.com/flashplusplus");
		openfl.Lib.getURL(facebookURL, "_blank");
	}

	function goToYoutube(target:HPPButton):Void
	{
		var youtubeURL:URLRequest = new URLRequest("https://www.youtube.com/watch?v=rXURdr8JVrg");
		openfl.Lib.getURL(youtubeURL, "_blank");
	}

	function goToGithub(target:HPPButton):Void
	{
		var githubURL:URLRequest = new URLRequest("https://github.com/NewKrok/Valley-Race");
		openfl.Lib.getURL(githubURL, "_blank");
	}
}