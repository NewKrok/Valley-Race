package valleyrace.menu.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.ui.ButtonLabelStyle;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.HPPVUIBox;
import openfl.net.URLRequest;
import valleyrace.assets.Fonts;
import valleyrace.common.view.SmallButton;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AboutUsPage extends FlxSubState
{
	var openWelcomePage:HPPButton->Void;

	var backButton:HPPButton;

	function new( openWelcomePage:HPPButton->Void ):Void
	{
		super();

		this.openWelcomePage = openWelcomePage;
	}

	override public function create():Void
	{
		super.create();

		build();
	}

	function build()
	{
		var baseBack:FlxSprite = new FlxSprite();
		baseBack.makeGraphic( FlxG.width, FlxG.height, 0xAA000000 );
		baseBack.scrollFactor.set();
		add( baseBack );

		var container:HPPVUIBox = new HPPVUIBox( 20 );
		container.scrollFactor.set();

		var developerInfoText = new FlxText();
		developerInfoText.color = FlxColor.WHITE;
		developerInfoText.alignment = "center";
		developerInfoText.size = 30;
		developerInfoText.font = Fonts.HOLLYWOOD;
		developerInfoText.borderStyle = FlxTextBorderStyle.SHADOW;
		developerInfoText.fieldWidth = 800;
		developerInfoText.text = "Valley Race game created by Krisztian Somoracz (NewKrok).";
		container.add(developerInfoText);

		var graphicInfo = new HPPButton(
			"Base graphics from GameDev Market by Nido",
			function (_) {
				openfl.Lib.getURL(new URLRequest("https://www.gamedevmarket.net/asset/monster-truck-game-assets/"), "_blank");
			}
		);
		graphicInfo.label.fieldWidth = 700;
		graphicInfo.label.color = FlxColor.WHITE;
		graphicInfo.label.alignment = "center";
		graphicInfo.label.font = Fonts.HOLLYWOOD;
		graphicInfo.label.borderStyle = FlxTextBorderStyle.SHADOW;
		graphicInfo.up_style = new ButtonLabelStyle(null, null, FlxColor.WHITE);
		graphicInfo.over_style = new ButtonLabelStyle(null, null, FlxColor.YELLOW);
		graphicInfo.labelSize = 30;
		graphicInfo.loadGraphicFromSprite(new FlxSprite().makeGraphic(700, 30, FlxColor.TRANSPARENT));
		container.add(graphicInfo);

		var poweredByContainer:HPPHUIBox = new HPPHUIBox(20);

		var poweredByInfoText = new FlxText();
		poweredByInfoText.color = FlxColor.WHITE;
		poweredByInfoText.alignment = "center";
		poweredByInfoText.size = 25;
		poweredByInfoText.font = Fonts.HOLLYWOOD;
		poweredByInfoText.borderStyle = FlxTextBorderStyle.SHADOW;
		poweredByInfoText.text = "Game powered by:";
		poweredByContainer.add(poweredByInfoText);

		var haxeLogo:HPPButton = new HPPButton("", goToHaxePage, "haxe_logo");
		haxeLogo.overScale = .95;
		poweredByContainer.add(haxeLogo);

		var haxeFlixelLogo:HPPButton = new HPPButton("", goToHaxeFlixelPage, "flixel_logo");
		haxeFlixelLogo.overScale = .95;
		poweredByContainer.add(haxeFlixelLogo);

		var napeLogo:HPPButton = new HPPButton("", goToNapePage, "nape_logo");
		napeLogo.overScale = .95;
		poweredByContainer.add(napeLogo);

		var hppLogo:HPPButton = new HPPButton("", goToHppPage, "hpp_logo");
		hppLogo.overScale = .95;
		poweredByContainer.add(hppLogo);

		container.add(poweredByContainer);

		container.x = FlxG.width / 2 - container.width / 2;
		container.y = FlxG.height / 2 - container.height / 2 - 100;
		developerInfoText.fieldWidth = container.width;
		add( container );

		add( backButton = new SmallButton( "BACK", openWelcomePage ) );
		backButton.x = FlxG.width / 2 - backButton.width / 2;
		backButton.y = FlxG.height - 40 - backButton.height;
	}

	function goToHppPage( target:HPPButton )
	{
		var homeURL:URLRequest = new URLRequest( "https://github.com/NewKrok/HPP-Package" );
		openfl.Lib.getURL( homeURL, "_blank" );
	}

	function goToNapePage( target:HPPButton )
	{
		var homeURL:URLRequest = new URLRequest( "http://napephys.com/" );
		openfl.Lib.getURL( homeURL, "_blank" );
	}

	function goToHaxeFlixelPage( target:HPPButton )
	{
		var homeURL:URLRequest = new URLRequest( "http://haxeflixel.com/" );
		openfl.Lib.getURL( homeURL, "_blank" );
	}

	function goToHaxePage( target:HPPButton )
	{
		var homeURL:URLRequest = new URLRequest( "http://haxe.org/" );
		openfl.Lib.getURL( homeURL, "_blank" );
	}
}