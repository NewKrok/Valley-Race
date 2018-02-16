package valleyrace.game.view;

import hpp.flixel.ui.HPPHUIBox;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ReachedStarView extends HPPHUIBox
{
	var stars:Array<StarView>;

	public function new()
	{
		super(15);

		stars = [];
		for (i in 0...3)
		{
			var star:StarView = new StarView();
			add(star);
			stars.push(star);
		}
	}

	public function setStarCount(c:UInt):Void
	{
		for (i in 0...3)
			stars[i].reached = i < c;
	}
}