package valleyrace.game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.AppConfig;

/**
 * ...
 * @author Krisztian Somoracz
 */
class StartCounter extends FlxSpriteGroup
{
	var onCompleteCallback:Void->Void;

	var counterImages:Array<FlxSprite>;
	var animationIndex:UInt;
	var showTween:VarTween;
	var hideTween:VarTween;

	var tweenData:Array<TweenData>;

	public function new( onCompleteCallback:Void->Void )
	{
		super();

		this.onCompleteCallback = onCompleteCallback;

		build();

		scrollFactor.set();
	}

	function build():Void
	{
		counterImages = [];
		for ( i in 0...3 )
		{
			var counterImage:FlxSprite = HPPAssetManager.getSprite( "counter_" + ( 3 - i ) );
			counterImages.push( counterImage );
			counterImage.alpha = 0;
			add( counterImage );
		}
	}

	function resetCounterImages():Void
	{
		for ( i in 0...3 )
		{
			var counterImage:FlxSprite = counterImages[i];
			counterImage.x = FlxG.width / 2 - counterImage.width / 2;
			counterImage.y = FlxG.height / 2;
			counterImage.alpha = 0;
		}
	}

	public function stop():Void
	{
		disposeTweens();
		animationIndex = 0;
		resetCounterImages();
	}

	public function start():Void
	{
		disposeTweens();
		animationIndex = 0;
		resetCounterImages();
		handleNextAnimation( null );
	}

	function disposeTweens():Void
	{
		if ( hideTween != null )
		{
			hideTween.cancel();
			hideTween.destroy();
			hideTween = null;
		}

		if ( showTween != null )
		{
			showTween.cancel();
			showTween.destroy();
			showTween = null;
		}

		tweenData = [];
	}

	function handleNextAnimation( tween:FlxTween ):Void
	{
		if( animationIndex > 0 )
		{
			hideTween = FlxTween.tween(
				counterImages[ animationIndex - 1 ],
				{ alpha: AppConfig.IS_ALPHA_ANIMATION_ENABLED ? 0 : 1, y: animationIndex == counterImages.length ? counterImages[ animationIndex - 1 ].y : FlxG.height / 2 - 200 },
				.4,
				{ startDelay: .3, ease: FlxEase.cubeOut, onComplete: AppConfig.IS_ALPHA_ANIMATION_ENABLED ? null : hideInstantCounterImage }
			);

			tweenData.push( { tween: hideTween, tweenTarget: counterImages[ animationIndex - 1 ] } );
		}

		if ( animationIndex == counterImages.length )
		{
			onCompleteCallback();
		}
		else
		{
			if( animationIndex < counterImages.length )
			{
				showTween = FlxTween.tween(
					counterImages[ animationIndex ],
					{ alpha: 1, y: FlxG.height / 2 - 100 },
					.4,
					{ startDelay: .2, onComplete: handleNextAnimation, onStart: AppConfig.IS_ALPHA_ANIMATION_ENABLED ? null : showInstantCounterImage, ease: FlxEase.cubeOut }
				);

				tweenData.push( { tween: showTween, tweenTarget: counterImages[ animationIndex ] } );
			}

			animationIndex++;
		}
	}

	function showInstantCounterImage( tween:FlxTween ):Void
	{
		var tweenTarget = tweenData.filter( function ( tweenData:TweenData ):Bool { return tween == tweenData.tween; } )[0].tweenTarget;
		tweenTarget.alpha = 1;
	}

	function hideInstantCounterImage( tween:FlxTween ):Void
	{
		var tween:TweenData = tweenData.filter( function ( tweenData:TweenData ):Bool { return tween == tweenData.tween; } )[0];

		if ( tween != null )
		{
			tween.tweenTarget.alpha = 0;
		}
	}
}

typedef TweenData = {
	var tween:VarTween;
	var tweenTarget:FlxSprite;
}