package valleyrace.common.view;

import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import hpp.flixel.ui.HPPExtendableButton;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ExtendedButtonWithTween extends HPPExtendableButton
{
	var tween:VarTween;

	override function onMouseOver()
	{
		removeTween();

		tween = FlxTween.tween(
			scale,
			{ x: overScale, y: overScale },
			.05
		);
	}

	override function onMouseOut()
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