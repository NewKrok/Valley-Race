package valleyrace.menu.view;

import flixel.FlxSprite;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.common.view.ExtendedButtonWithTween;
import valleyrace.util.SavedDataUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class WorldButton extends ExtendedButtonWithTween
{
	var playEffect:FlxSprite;

	public function new(worldId:UInt, onClick:Void->Void, graphicId:String)
	{
		var data = SavedDataUtil.getLevelInfo(worldId, 0);

		super(data.isEnabled ? function(_) { onClick(); } : null, graphicId);

		if (!data.isEnabled)
		{
			var locked = HPPAssetManager.getSprite("world_selector_locked");
			locked.x = width / 2 - locked.width / 2;
			locked.y = height / 2 - locked.height / 2;
			add(locked);
		}
		else
		{
			playEffect = HPPAssetManager.getSprite("world_selector_play");
			playEffect.x = width / 2 - playEffect.width / 2;
			playEffect.y = height / 2 - playEffect.height / 2;
			add(playEffect);
			playEffect.visible = false;
		}
	}

	override function onMouseOver()
	{
		super.onMouseOver();

		if (playEffect != null) playEffect.visible = true;
	}

	override function onMouseOut()
	{
		super.onMouseOut();

		if (playEffect != null) playEffect.visible = false;
	}
}