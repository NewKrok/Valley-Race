package valleyrace.common.view;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import hpp.flixel.util.HPPAssetManager;

/**
 * ...
 * @author Krisztian Somoracz
 */
class StarView extends FlxSpriteGroup
{
	public var reached(default, set):Bool;

	var normalStar:FlxSprite;
	var reachedStar:FlxSprite;

	public function new()
	{
		super();

		add(normalStar = HPPAssetManager.getSprite("level_star"));
		add(reachedStar = HPPAssetManager.getSprite("level_star_reached"));

		reached = false;
	}

	function set_reached(value:Bool):Bool
	{
		reachedStar.visible = value;
		normalStar.visible = !value;

		return reached = value;
	}
}