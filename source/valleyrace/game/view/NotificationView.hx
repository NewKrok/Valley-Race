package valleyrace.game.view;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.AppConfig;

/**
 * ...
 * @author Krisztian Somoracz
 */
class NotificationView extends FlxSprite
{
	var tween:VarTween;
	var remove:NotificationView->Void;

	public function new(remove:NotificationView->Void, imageName:String)
	{
		super();

		this.remove = remove;

		loadGraphic(HPPAssetManager.getGraphic(imageName));
	}

	public function show():Void
	{
		if (AppConfig.IS_ALPHA_ANIMATION_ENABLED)
		{
			alpha = 0;

			FlxTween.tween(
				this,
				{ alpha: 1 },
				.5
			);
		}

		FlxTween.tween(
			this,
			{ x: -width + 10, alpha: AppConfig.IS_ALPHA_ANIMATION_ENABLED ? 0 : 1 },
			.5,
			{ startDelay: 2, onComplete: function(_) { remove(this); } }
		);
	}

	public function animateY(requestedY:Float):Void
	{
		disposeTween();

		tween = FlxTween.tween(
			this,
			{ y: requestedY },
			.5
		);
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