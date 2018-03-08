package valleyrace.common.view;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import hpp.flixel.util.HPPAssetManager;

/**
 * ...
 * @author Krisztian Somoracz
 */
class WarningSign extends FlxSpriteGroup
{
	public function new()
	{
		super();

		var sign:FlxSprite = HPPAssetManager.getSprite("warning_icon");
		sign.x = -sign.width / 2 - 6;
		sign.y = -sign.height / 2 + 6;
		add(sign);
	}
}