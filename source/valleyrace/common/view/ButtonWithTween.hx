package valleyrace.common.view;

import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import hpp.flixel.ui.HPPButton;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ButtonWithTween extends HPPButton
{
	var tweenOverScale:Float;
	var tween:VarTween;

	public function new(title:String = "", callBack:HPPButton->Void = null)
	{
		super(title, callBack);

		onMouseOver = onTweenMouseOver;
		onMouseOut = onTweenMouseOut;
	}

	function onTweenMouseOver()
	{
		removeTween();

		tween = FlxTween.tween(
			scale,
			{ x: tweenOverScale, y: tweenOverScale },
			.05
		);
	}

	function onTweenMouseOut()
	{
		removeTween();

		tween = FlxTween.tween(
			scale,
			{ x: 1, y: 1 },
			.05
		);
	}

	function removeTween():Void
	{
		if (tween != null)
		{
			tween.cancel();
			tween.destroy();
			tween = null;
		}
	}
}