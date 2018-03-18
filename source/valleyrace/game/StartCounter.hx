package valleyrace.game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import hpp.flixel.util.HPPAssetManager;

/**
 * ...
 * @author Krisztian Somoracz
 */
class StartCounter extends FlxSpriteGroup
{
	var onCompleteCallback:Void->Void;

	var counterImages:Array<FlxSprite>;
	var animationIndex:UInt;
	var tween:VarTween;

	public function new(onCompleteCallback:Void->Void)
	{
		super();

		this.onCompleteCallback = onCompleteCallback;

		build();

		scrollFactor.set();
	}

	function build():Void
	{
		counterImages = [];
		for (i in 0...3)
		{
			var counterImage:FlxSprite = HPPAssetManager.getSprite("counter_" + i);
			counterImages.push(counterImage);
			counterImage.visible = false;
			counterImage.x = FlxG.stage.stageWidth  - 200;
			counterImage.y = FlxG.stage.stageHeight / 2 - counterImage.height / 2;
			add(counterImage);
		}
	}

	function resetCounterImages():Void
	{
		for (i in 0...3)
		{
			var counterImage:FlxSprite = counterImages[i];
			counterImage.visible = false;
		}
	}

	public function stop():Void
	{
		resetCounterImages();

		if (tween != null)
		{
			tween.cancel();
			tween.destroy();
			tween = null;
		}
	}

	public function start():Void
	{
		animationIndex = 0;
		resetCounterImages();
		handleNextStep();
	}

	function handleNextStep():Void
	{
		if (animationIndex == 3)
		{
			counterImages[ animationIndex - 1 ].visible = false;

			FlxG.sound.play("assets/sounds/start_game.ogg", AppConfig.SOUND_VOLUME);

			onCompleteCallback();
			return;
		}
		else
		{
			FlxG.sound.play("assets/sounds/start_timer.ogg", AppConfig.SOUND_VOLUME);
		}

		if (animationIndex > 0)
			counterImages[ animationIndex - 1 ].visible = false;

		counterImages[ animationIndex++ ].visible = true;

		tween = FlxTween.tween(this, {}, 1, { onComplete: function(_) { handleNextStep(); }});
	}
}