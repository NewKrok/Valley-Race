package valleyrace.game;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.AppConfig;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CarFog extends FlxSprite
{
	var tweenA:VarTween;
	var tweenB:VarTween;

	var releaserRutin:CarFog->Void;

	public function new(assetId:String, releaserRutin:CarFog->Void)
	{
		super();

		loadGraphic(HPPAssetManager.getGraphic(assetId));
		this.releaserRutin = releaserRutin;

		origin.set(width / 2, height / 2);
	}

	override public function reset(x:Float, y:Float):Void
	{
		super.reset(x, y);

		visible = false;
		alpha = 1;

		disposeTween();
	}

	function disposeTween():Void
	{
		if (tweenA != null)
		{
			tweenA.cancel();
			tweenA.destroy();
			tweenA = null;
		}
		if (tweenB != null)
		{
			tweenB.cancel();
			tweenB.destroy();
			tweenB = null;
		}
	}

	public function startAnim(angle:Float):Void
	{
		var baseScale:Float = Math.random() * .4 + .2;
		var newScale:Float = Math.random() * .4 + .6;
		scale.set(baseScale, baseScale);

		tweenA = FlxTween.tween(
			this,
			{
				x: x - Math.cos(Math.PI * 2 - angle + (Math.random() * (Math.PI / 4))) * (Math.random() * 40 + 20),
				y: y + Math.sin(Math.PI * 2 - angle + (Math.random() * (Math.PI / 4))) * (Math.random() * 40 - 20),
				angle: Math.random() * 360,
			},
			.4,
			{ type: FlxTween.ONESHOT, ease: FlxEase.quadIn, onComplete: animationEnded }
		);

		tweenB = FlxTween.tween(
			scale,
			{
				x: newScale,
				y: newScale
			},
			.4,
			{ type: FlxTween.ONESHOT, ease: FlxEase.linear }
		);
	}

	function animationEnded(tween:FlxTween):Void
	{
		reset(0, 0);
		releaserRutin(this);
	}
}