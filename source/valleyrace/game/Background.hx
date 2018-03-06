package valleyrace.game;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import hpp.flixel.display.HPPMovieClip;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.datatype.BackgroundData;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Background extends FlxSpriteGroup
{
	public var worldId(default, set):UInt;

	var backgroundDatas:Array<BackgroundData>;
	var lastCameraStepOffset:FlxPoint;

	public function new(worldId:UInt)
	{
		super();

		lastCameraStepOffset = new FlxPoint();

		this.worldId = worldId;

		scrollFactor.set();
	}

	function set_worldId(value:UInt):UInt
	{
		if (value != worldId)
		{
			worldId = value;
			build();
		}

		return  worldId;
	}

	function build():Void
	{
		removeCurrent();

		backgroundDatas = [];
		addBackground('back_world_' + worldId + '_a00', 200, new FlxPoint(.1, .1), -.5);
		addBackground('back_world_' + worldId + '_b00', 300, new FlxPoint(.25, .25), -.5);
		addBackground('back_world_' + worldId + '_c00', 450, new FlxPoint(.35, .35), -.5);
		addBackground('back_world_' + worldId + '_d00', 640, new FlxPoint(.45, .45), -.5);

		update(1);
	}

	function removeCurrent():Void
	{
		if (backgroundDatas != null)
		{
			for (backgroundData in backgroundDatas)
			{
				backgroundData.container.destroy();
				backgroundData = null;
			}
		}

		backgroundDatas = null;
	}

	function addBackground(assetId:String, baseYOffset:Float, easing:FlxPoint, xOverlap:Float):Void
	{
		var backgroundData:BackgroundData = {
			easing: easing,
			container: new FlxSpriteGroup(),
			elements: []
		};
		backgroundDatas.push(backgroundData);

		add(backgroundData.container);
		backgroundData.container.scrollFactor.set();

		for (i in 0...5)
		{
			var backgroundPiece:HPPMovieClip = HPPAssetManager.getMovieClip(assetId, "00");
			backgroundData.container.add(backgroundPiece);
			backgroundData.elements.push(backgroundPiece);

			backgroundPiece.gotoAndStop(i == 4 ? 0 : i);
			backgroundPiece.x = i * (backgroundPiece.width + xOverlap);
			backgroundPiece.y = baseYOffset;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		lastCameraStepOffset.set(camera.scroll.x - lastCameraStepOffset.x, camera.scroll.y - lastCameraStepOffset.y);

		for (i in 0...backgroundDatas.length)
		{
			var backgroundData:BackgroundData = backgroundDatas[i];

			backgroundData.container.x -= lastCameraStepOffset.x * backgroundData.easing.x;

			while (backgroundData.container.x > 0)
			{
				for (j in 0...backgroundData.elements.length)
				{
					backgroundData.elements[j].currentFrame = backgroundData.elements[j].currentFrame == 0 ? backgroundData.elements[j].numFrames - 1 : backgroundData.elements[j].currentFrame - 1;
				}
				backgroundData.container.x -= backgroundData.elements[ 0 ].width;
			}

			while (backgroundData.container.x < -backgroundData.elements[ 0 ].width)
			{
				for (j in 0...backgroundData.elements.length)
				{
					backgroundData.elements[j].currentFrame = (backgroundData.elements[j] .currentFrame == cast(backgroundData.elements[j].numFrames - 1)) ? 0 : backgroundData.elements[j].currentFrame + 1;
				}
				backgroundData.container.x += backgroundData.elements[ 0 ].width;
			}

			backgroundData.container.y = FlxG.height - backgroundData.container.height - camera.scroll.y * backgroundData.easing.y;
		}

		lastCameraStepOffset.set(camera.scroll.x, camera.scroll.y);
	}

	override public function destroy():Void
	{
		removeCurrent();

		super.destroy();
	}
}