package valleyrace.menu.view;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.util.HPPAssetManager;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelStarView extends FlxSpriteGroup
{
	var stars:Array<FlxSprite>;
	var starContainer:HPPHUIBox;

	public function new()
	{
		super();

		add( starContainer = new HPPHUIBox( 11 ) );

		stars = [];
		for ( i in 0...3 )
		{
			stars.push( HPPAssetManager.getSprite( "level_button_star" ) );
			starContainer.add( stars[i] );
		}
	}

	public function setStarCount( value:UInt ):Void
	{
		for ( i in 0...3 )
		{
			stars[i].visible = i < value;
		}
	}

	override function get_height():Float
	{
		return super.get_height() + 3;
	}
}