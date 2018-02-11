package valleyrace.game;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import hpp.flixel.display.HPPMovieClip;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.AppConfig;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Coin extends FlxSpriteGroup
{
	public var isCollected(default, null):Bool;

	var tween:VarTween;
	var mc:HPPMovieClip;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		add(mc = HPPAssetManager.getMovieClip("coin00", "00"));
		mc.frameRate = 8;
		mc.play();
	}

	public function collect():Void
	{
		isCollected = true;

		disposeTween();

		tween = FlxTween.tween(
			this,
			{ alpha: AppConfig.IS_ALPHA_ANIMATION_ENABLED ? 0 : 1 },
			.6,
			{ type: FlxTween.ONESHOT, onComplete: tweenCompleted }
		);

		FlxTween.tween(
			scale,
			{ x: 1.5, y: 1.5 },
			.3
		);

		FlxTween.tween(
			scale,
			{ x: .2, y: .2 },
			.3,
			{ startDelay: .3, ease: FlxEase.quadIn }
		);
	}

	function tweenCompleted(tween:FlxTween):Void
	{
		visible = false;

		disposeTween();
	}

	override public function reset(x:Float, y:Float):Void
	{
		super.reset(x, y);

		isCollected = false;
		visible = true;
		alpha = 1;
		angle = 0;
		scale.set(1, 1);

		disposeTween();
	}

	function disposeTween():Void
	{
		if (tween != null)
		{
			tween.cancel();
			tween.destroy();
			tween = null;
		}
	}
}