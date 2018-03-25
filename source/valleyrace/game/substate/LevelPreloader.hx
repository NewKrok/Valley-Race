package valleyrace.game.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPVUIBox;
import valleyrace.assets.Fonts;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelPreloader extends FlxSubState
{
	static inline var MAX_STEP:UInt = 8;

	var container:HPPVUIBox;
	var baseBack:FlxSprite;
	var progressBar:FlxSpriteGroup;
	var progressBarLine:FlxSprite;

	var currentStep:UInt = 0;

	override public function create():Void
	{
		super.create();

		build();
	}

	function build()
	{
		add(baseBack = new FlxSprite());
		baseBack.makeGraphic(FlxG.stage.stageWidth, FlxG.stage.stageHeight, FlxColor.BLACK);
		baseBack.scrollFactor.set();

		container = new HPPVUIBox( -20);
		container.scrollFactor.set();

		var label:FlxText = new FlxText(0, 0, 0, "LOADING...", 45);
		label.autoSize = true;
		label.color = 0xFFFFE300;
		label.alignment = "center";
		label.font = Fonts.HOLLYWOOD;
		label.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		container.add(label);

		progressBar = new FlxSpriteGroup();
		progressBar.add(new FlxSprite().makeGraphic(155, 5, 0xFF555555));
		progressBar.add(progressBarLine = new FlxSprite().makeGraphic(155, 5, 0xFFFFE300));
		progressBarLine.offset.set(0, 0);
		progressBarLine.scale.x = .8;
		progressBarLine.origin.set();
		container.add(progressBar);

		container.x = baseBack.width / 2 - container.width / 2;
		container.y = baseBack.height / 2 - container.height / 2;
		add(container);
	}

	public function step():Void
	{
		currentStep++;
		var value:Float = currentStep / MAX_STEP;
		progressBarLine.scale.x = Math.min(1, Math.max(0.05, value));
	}

	public function hide(callback:Void->Void):Void
	{
		FlxTween.tween(
			container,
			{ alpha: AppConfig.IS_ALPHA_ANIMATION_ENABLED ? .1 : 1 },
			.5,
			{ onComplete: function(_) { callback(); } }
		);
	}
}