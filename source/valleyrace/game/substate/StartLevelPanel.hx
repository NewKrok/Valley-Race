package valleyrace.game.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.HPPVUIBox;
import hpp.flixel.ui.PlaceHolder;
import hpp.ui.HAlign;
import hpp.util.NumberUtil;
import openfl.net.URLRequest;
import valleyrace.AppConfig;
import valleyrace.assets.Fonts;
import valleyrace.common.view.LongButton;
import valleyrace.common.view.SmallButton;
import valleyrace.common.view.ReachedStarView;
import valleyrace.util.LevelUtil;
import valleyrace.util.SavedDataUtil.LevelSavedData;

/**
 * ...
 * @author Krisztian Somoracz
 */
class StartLevelPanel extends FlxSubState
{
	var youtubeHelps:Array<String> = [
		"https://www.youtube.com/watch?v=rXURdr8JVrg",
		"https://www.youtube.com/watch?v=rXURdr8JVrg",
		"https://www.youtube.com/watch?v=rXURdr8JVrg",
		"https://www.youtube.com/watch?v=rXURdr8JVrg",
		"https://www.youtube.com/watch?v=rXURdr8JVrg"
	];

	var header:FlxSpriteGroup;
	var footer:FlxSpriteGroup;
	var reachedStarView:ReachedStarView;

	var startButton:HPPButton;
	var exitButton:HPPButton;
	var nextButton:HPPButton;
	var prevButton:HPPButton;
	var youtubeButton:HPPButton;

	var startRequest:HPPButton->Void;
	var exitRequest:HPPButton->Void;
	var nextLevelRequest:HPPButton->Void;
	var prevLevelRequest:HPPButton->Void;

	var baseBack:FlxSprite;
	var container:FlxSpriteGroup;
	var levelInfo:LevelSavedData;

	function new(levelInfo:LevelSavedData, startRequest:HPPButton->Void, exitRequest:HPPButton->Void, nextLevelRequest:HPPButton->Void, prevLevelRequest:HPPButton->Void):Void
	{
		super();

		this.levelInfo = levelInfo;
		this.startRequest = startRequest;
		this.exitRequest = exitRequest;
		this.nextLevelRequest = nextLevelRequest;
		this.prevLevelRequest = prevLevelRequest;
	}

	override public function create():Void
	{
		super.create();

		build();
	}

	function build():Void
	{
		buildHeader();
		buildFooter();
	}

	function canStartPrevLevel():Bool
	{
		return levelInfo.levelId != 0;
	}

	function canStartNextLevel():Bool
	{
		return levelInfo.isCompleted && levelInfo.levelId != 23;
	}

	function buildHeader():Void
	{
		header = new FlxSpriteGroup();
		header.scrollFactor.set();

		var background:FlxSprite = new FlxSprite().makeGraphic(1136, 150, FlxColor.BLACK);
		background.y = -50;
		background.alpha = .8;
		header.add(background);

		var scoreWrapper = new HPPVUIBox(0, HAlign.LEFT);
		var scoreContainer = new HPPHUIBox(15);

		var bestScoreLabelText:FlxText = new FlxText(0, 0, 0, "Best score ", 25);
		bestScoreLabelText.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		bestScoreLabelText.autoSize = true;
		bestScoreLabelText.color = FlxColor.WHITE;
		bestScoreLabelText.alignment = "left";
		bestScoreLabelText.font = Fonts.HOLLYWOOD;
		scoreContainer.add(bestScoreLabelText);
		var bestScoreText:FlxText = new FlxText(0, 0, 0, levelInfo.isCompleted ? NumberUtil.formatNumber(levelInfo.score) : "N/A", 25);
		bestScoreText.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		bestScoreText.autoSize = true;
		bestScoreText.color = FlxColor.YELLOW;
		bestScoreText.alignment = "left";
		bestScoreText.font = Fonts.HOLLYWOOD;
		scoreContainer.add(bestScoreText);
		scoreWrapper.add(scoreContainer);

		reachedStarView = new ReachedStarView();
		reachedStarView.setStarCount(levelInfo.starCount);
		scoreWrapper.add(reachedStarView);

		scoreWrapper.x = 30;
		scoreWrapper.y = 17;
		header.add(scoreWrapper);

		var titleContainer:HPPVUIBox = new HPPVUIBox(-20, HAlign.RIGHT);
		var levelText:FlxText = new FlxText(0, 0, 0, (levelInfo.worldId < 2 ? "RACE " : "LEVEL ") + (levelInfo.levelId + 1), 45);
		levelText.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		levelText.autoSize = true;
		levelText.color = 0xFFC9B501;
		levelText.font = Fonts.HOLLYWOOD;
		titleContainer.add(levelText);
		var worldText:FlxText = new FlxText(0, 0, 0, LevelUtil.getWorldNameByWorldId(levelInfo.worldId).toUpperCase(), 35);
		worldText.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		worldText.autoSize = true;
		worldText.color = 0xFFFFFF00;
		worldText.font = Fonts.HOLLYWOOD;
		titleContainer.add(worldText);
		titleContainer.x = FlxG.stage.stageWidth - titleContainer.width - 30;
		titleContainer.y = 17;
		header.add(titleContainer);

		add(header);

		if (levelInfo.worldId == 2)
		{
			add(youtubeButton = new HPPButton("", youtubeHelpRequest, "youtube_level_help_button", "youtube_level_help_button_over"));
			youtubeButton.x = FlxG.stage.stageWidth - youtubeButton.width - 30;
			youtubeButton.y = 110;
		}
	}

	function buildFooter():Void
	{
		footer = new FlxSpriteGroup();
		footer.scrollFactor.set();

		var background:FlxSprite = new FlxSprite().makeGraphic(1136, 150, FlxColor.BLACK);
		background.alpha = .8;
		footer.add(background);

		var buttonContainer:HPPHUIBox = new HPPHUIBox(30);

		buttonContainer.add(exitButton = new SmallButton("EXIT", exitRequest));
		if (canStartPrevLevel()) buttonContainer.add(prevButton = new SmallButton("PREV RACE", prevLevelRequest));
		if (canStartNextLevel()) buttonContainer.add(nextButton = new SmallButton("NEXT RACE", nextLevelRequest));

		buttonContainer.x = 30;
		buttonContainer.y = (background.height - 50) / 2 - buttonContainer.height / 2;
		footer.add(buttonContainer);
		footer.add(startButton = new SmallButton("START RACE", startPreRequest));
		startButton.x = FlxG.stage.stageWidth - startButton.width - 30;
		startButton.y = buttonContainer.y;

		footer.add(buttonContainer);

		footer.y = FlxG.stage.stageHeight - footer.height + 50;
		add(footer);
	}

	function startPreRequest(e)
	{
		if (levelInfo.worldId == 2) youtubeButton.visible = false;

		FlxTween.tween(
			header,
			{ y: -header.height - 10, alpha: AppConfig.IS_ALPHA_ANIMATION_ENABLED ? 0 : 1 },
			.5,
			{ ease: FlxEase.backIn }
		);

		FlxTween.tween(
			footer,
			{ y: FlxG.stage.stageHeight + 10, alpha: AppConfig.IS_ALPHA_ANIMATION_ENABLED ? 0 : 1 },
			.5,
			{ ease: FlxEase.backIn, onComplete: function(_) { startRequest(e); } }
		);
	}

	function youtubeHelpRequest(_)
	{
		var youtubeURL:URLRequest = new URLRequest(youtubeHelps[levelInfo.levelId]);
		openfl.Lib.getURL(youtubeURL, "_blank");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (AppConfig.IS_DESKTOP_DEVICE)
		{
			if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.S)
			{
				startRequest(null);
			}

			if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.X)
			{
				exitRequest(null);
			}

			if (FlxG.keys.justPressed.P && canStartPrevLevel())
			{
				prevLevelRequest(null);
			}

			if (FlxG.keys.justPressed.N && canStartNextLevel())
			{
				nextLevelRequest(null);
			}
		}
	}
}