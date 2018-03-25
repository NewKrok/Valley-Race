package valleyrace.game.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.ui.ButtonLabelStyle;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.HPPVUIBox;
import openfl.net.URLRequest;
import valleyrace.AppConfig;
import valleyrace.assets.Fonts;

/**
 * ...
 * @author Krisztian Somoracz
 */
class PausePanel extends FlxSubState
{
	var resumeButton:HPPButton;
	var restartButton:HPPButton;
	var exitButton:HPPButton;

	var buttonContainer:HPPHUIBox;
	var baseBack:FlxSprite;
	var container:FlxSpriteGroup;

	var resumeRequest:HPPButton->Void;
	var restartRequest:HPPButton->Void;
	var exitRequest:HPPButton->Void;

	function new(resumeRequest:HPPButton->Void, restartRequest:HPPButton->Void, exitRequest:HPPButton->Void):Void
	{
		super();

		this.exitRequest = exitRequest;
		this.restartRequest = restartRequest;
		this.resumeRequest = resumeRequest;
	}

	override public function create():Void
	{
		super.create();

		build();
	}

	function build():Void
	{
		add(container = new FlxSpriteGroup());
		container.scrollFactor.set();

		container.add(baseBack = new FlxSprite());
		baseBack.makeGraphic(FlxG.stage.stageWidth, FlxG.stage.stageHeight, FlxColor.BLACK);
		baseBack.alpha = .8;

		var label:FlxText = new FlxText(0, 0, 235, "GAME PAUSED", 45);
		label.autoSize = true;
		label.color = 0xFFFFE301;
		label.alignment = "center";
		label.font = Fonts.HOLLYWOOD;

		var subContainer:HPPVUIBox = new HPPVUIBox(10);
		subContainer.add(label);

		buttonContainer = new HPPHUIBox(30);

		buttonContainer.add(resumeButton = new HPPButton("", resumeRequest, "large_resume_button", "large_resume_button_over"));
		resumeButton.overScale = .95;

		buttonContainer.add(restartButton = new HPPButton("", restartRequest, "large_restart_button", "large_restart_button_over"));
		restartButton.overScale = .95;

		buttonContainer.add(exitButton = new HPPButton("", exitRequest, "large_exit_button", "large_exit_button_over"));
		exitButton.overScale = .95;

		subContainer.add(buttonContainer);

		subContainer.x = FlxG.stage.stageWidth / 2 - subContainer.width / 2;
		subContainer.y = FlxG.stage.stageHeight / 2 - subContainer.height / 2 - 100;

		container.add(subContainer);


		var moreGamesButton = new HPPButton(
			"More games from Flash++",
			function (_) {
				openfl.Lib.getURL(new URLRequest("http://flashplusplus.net/?utm_source=Valley-Race&utm_medium=pause-panel&utm_campaign=HTML5-Games"), "_blank");
			}
		);
		moreGamesButton.label.fieldWidth = 700;
		moreGamesButton.label.color = FlxColor.WHITE;
		moreGamesButton.label.alignment = "center";
		moreGamesButton.label.font = Fonts.HOLLYWOOD;
		moreGamesButton.label.borderStyle = FlxTextBorderStyle.SHADOW;
		moreGamesButton.up_style = new ButtonLabelStyle(null, null, FlxColor.WHITE);
		moreGamesButton.over_style = new ButtonLabelStyle(null, null, FlxColor.YELLOW);
		moreGamesButton.labelSize = 30;
		moreGamesButton.loadGraphicFromSprite(new FlxSprite().makeGraphic(700, 30, FlxColor.TRANSPARENT));
		add(moreGamesButton);
		moreGamesButton.x = FlxG.stage.stageWidth / 2 - moreGamesButton.width / 2;
		moreGamesButton.y = FlxG.stage.stageHeight - moreGamesButton.height - 20;

		openCallback = function() {
			FlxG.sound.music.volume = AppConfig.MUSIC_VOLUME == 1 ? .2 : 0;
		}

		closeCallback = function() {
			FlxG.sound.music.volume = AppConfig.MUSIC_VOLUME == 1 ? .75 : 0;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (AppConfig.IS_DESKTOP_DEVICE)
		{
			if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.P)
			{
				resumeRequest(null);
			}

			if (FlxG.keys.justPressed.R)
			{
				restartRequest(null);
			}

			if (FlxG.keys.justPressed.X)
			{
				exitRequest(null);
			}
		}
	}
}