package valleyrace.game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import haxe.Timer;
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

	var mc:HPPMovieClip;
	var effects:Array<FlxSprite>;
	var effectTweens:Array<VarTween>;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		add(mc = HPPAssetManager.getMovieClip("coin00", "00"));
		mc.frameRate = 8;
		mc.play();

		effectTweens = [];
		effects = [];
		for (i in 0...10)
		{
			var e = HPPAssetManager.getSprite("coin_pick_up_effect");
			e.origin.set(e.width / 2, e.height / 2);
			add(e);
			e.visible = false;
			effects.push(e);
		}
	}

	public function collect():Void
	{
		isCollected = true;

		FlxG.sound.play("assets/sounds/coin_pick_up.ogg", AppConfig.SOUND_VOLUME == 1 ? .5 : 0);

		mc.visible = false;
		Timer.delay(disableCoin, 600);

		for (e in effects)
		{
			effectTweens.push(FlxTween.tween(
				e,
				{ x: x + Math.random() * 100 - 50, y: y + Math.random() * 100 - 50 },
				Math.random() * .4,
				{
					onComplete: function(_) { e.visible = false; },
					onStart: function(_) { e.visible = true; },
					startDelay: Math.random() * .2
				}
			));
		}
	}

	function disableCoin():Void
	{
		visible = false;
		alpha = 1;
		mc.stop();
	}

	override public function reset(x:Float, y:Float):Void
	{
		super.reset(x, y);

		mc.gotoAndPlay(1);
		scale.set(1, 1);
		isCollected = false;
		visible = true;
		mc.visible = true;

		for (t in effectTweens)
		{
			t.cancel();
			t.destroy();
			t = null;
		}

		for (e in effects)
		{
			e.x = x + mc.width / 2;
			e.y = y + mc.height / 2;
			e.visible = false;
		}
	}
}