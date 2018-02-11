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
class SmallRock extends FlxSprite
{
	var tweenA:VarTween;
	var tweenB:VarTween;
	var tweenC:VarTween;

	var releaserRutin:SmallRock->Void;

	public function new( assetId:String, releaserRutin:SmallRock->Void )
	{
		super();

		loadGraphic( HPPAssetManager.getGraphic( assetId ) );
		this.releaserRutin = releaserRutin;

		origin.set( width / 2, height / 2 );
	}

	override public function reset( x:Float, y:Float ):Void
	{
		super.reset( x, y );

		visible = false;
		alpha = 1;

		disposeTween();
	}

	function disposeTween():Void
	{
		if ( tweenA != null )
		{
			tweenA.cancel();
			tweenA.destroy();
			tweenA = null;
		}

		if ( tweenB != null )
		{
			tweenB.cancel();
			tweenB.destroy();
			tweenB = null;
		}

		if ( tweenC != null )
		{
			tweenC.cancel();
			tweenC.destroy();
			tweenC = null;
		}
	}

	public function startAnim( direction:Int, angle:Float ):Void
	{
		tweenA = FlxTween.tween(
			this,
			{
				x: x + Math.cos( Math.PI * 2 - angle + ( Math.random() * ( Math.PI / 4 ) ) ) * direction * ( Math.random() * 40 + 20 ),
				angle: Math.random() * ( Math.PI * 4 )
			},
			.4,
			{ type: FlxTween.ONESHOT, ease: FlxEase.quadIn }
		);

		tweenB = FlxTween.tween(
			this,
			{
				y: y + Math.sin( Math.PI * 2 - angle + ( Math.random() * ( Math.PI / 4 ) ) ) * ( Math.random() * 30 + 10 ) - 20
			},
			.2,
			{ type: FlxTween.ONESHOT, ease: FlxEase.quadIn }
		);

		tweenC = FlxTween.tween(
			this,
			{
				y: y + Math.sin( Math.PI * 2 - angle + ( Math.random() * ( Math.PI / 4 ) ) ) * ( Math.random() * 10 ),
				alpha: AppConfig.IS_ALPHA_ANIMATION_ENABLED ? 0 : 1
			},
			.3,
			{ type: FlxTween.ONESHOT, startDelay: .2, onComplete: animationEnded }
		);
	}

	function animationEnded( tween:FlxTween ):Void
	{
		reset( 0, 0 );
		releaserRutin( this );
	}
}