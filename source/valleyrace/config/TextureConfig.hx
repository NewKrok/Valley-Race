package valleyrace.config;

/**
 * ...
 * @author Krisztian Somoracz
 */
class TextureConfig
{
	static inline var POLYGON_TERRAIN_0 = "polygon_terrain_0";
	static inline var POLYGON_TERRAIN_1 = "polygon_terrain_1";
	static inline var POLYGON_TERRAIN_2 = "polygon_terrain_2";

	static var polygonTerrainConfig:Map<String, PolygonTerrainConfig> = [
		POLYGON_TERRAIN_0 => { fillGraphic: "terrain_fill_texture_00000", groundGraphic: "terrain_ground_texture_00000" },
		POLYGON_TERRAIN_1 => { fillGraphic: "terrain_fill_texture_10000", groundGraphic: "terrain_ground_texture_10000" },
		POLYGON_TERRAIN_2 => { fillGraphic: "terrain_fill_texture_20000", groundGraphic: "terrain_ground_texture_20000" }
	];

	public static function getPolygonTerrainFillGraphic(polygonTerrainId:String):String
	{
		return polygonTerrainConfig[polygonTerrainId].fillGraphic;
	}

	public static function getPolygonTerrainGroundGraphic(groundTerrainId:String):String
	{
		return polygonTerrainConfig[groundTerrainId].groundGraphic;
	}
}

typedef PolygonTerrainConfig =
{
	var fillGraphic:String;
	var groundGraphic:String;
}