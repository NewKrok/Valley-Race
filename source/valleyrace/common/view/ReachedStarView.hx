package valleyrace.common.view;

import flixel.group.FlxSpriteGroup;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.util.HPPAssetManager;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ReachedStarView extends FlxSpriteGroup
{
	var starContainer:HPPHUIBox;
	var stars:Array<StarView>;

	public function new(withBackground:Bool = false)
	{
		super();

		if (withBackground)
			add(HPPAssetManager.getSprite("level_button_star_back"));

		starContainer = new HPPHUIBox(15);

		stars = [];
		for (i in 0...3)
		{
			var star:StarView = new StarView();
			starContainer.add(star);
			stars.push(star);
		}

		add(starContainer);
		starContainer.x = width / 2 - starContainer.width / 2;
		starContainer.y = height / 2 - starContainer.height / 2;
	}

	public function setStarCount(c:UInt):Void
	{
		for (i in 0...3)
			stars[i].reached = i < c;
	}
}