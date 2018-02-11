package valleyrace.game.terrain;

import openfl.geom.Point;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BrushArea extends Point
{
	public static var fullLength:Float = 0;
	public static var lw:Float = 25;

	public var currentLength:Float;
	public var l:Float;
	public var xL:Float;
	public var yL:Float;
	public var xR:Float;
	public var yR:Float;
	public var angle:Float = 0;
	public var prevPoint:BrushArea;

	public function new( xPos:Float, yPos:Float, prevPoint:BrushArea = null )
	{
		super( xPos, yPos );
		this.prevPoint = prevPoint;

		if ( prevPoint != null )
		{
			l = Point.distance( this, prevPoint );
			fullLength += l;
			currentLength = fullLength;
			angle = Math.atan2( this.y - prevPoint.y, this.x - prevPoint.x );
			var pR:Point = Point.polar( lw, angle + Math.PI / 2 );
			xR = pR.x + x;
			yR = pR.y + y;
			var pL:Point = Point.polar( lw, angle - Math.PI / 2 );
			xL = pL.x + x;
			yL = pL.y + y;
			if ( prevPoint.prevPoint != null )
			{
				prevPoint.setAngel ( this );
			}
		}
		else
		{
			xR = x;
			yR = y;
			xL = x;
			yL = y;
		}
	}

	function setAngel ( nextPoint:BrushArea ):Void
	{
		angle = Math.atan2( nextPoint.y - prevPoint.y, nextPoint.x - prevPoint.x );
		var ll:Float = l + prevPoint.l + nextPoint.l;
		var pR:Point = Point.polar( lw, angle + Math.PI / 2 );
		xR = pR.x + x;
		yR = pR.y + y;
		var pL:Point = Point.polar( lw, angle - Math.PI / 2 );
		xL = pL.x + x;
		yL = pL.y + y;
	}

	function intersect( p1:Point, p2:Point, p3:Point, p4:Point ):Bool
	{
		var nx:Float, ny:Float, dn:Float;
		var x4_x3:Float = p4.x - p3.x;
		var pre2:Float = p4.y - p3.y;
		var pre3:Float = p2.x - p1.x;
		var pre4:Float = p2.y - p1.y;
		var pre5:Float = p1.y - p3.y;
		var pre6:Float = p1.x - p3.x;
		nx = x4_x3 * pre5 - pre2 * pre6;
		ny = pre3 * pre5 - pre4 * pre6;
		dn = pre2 * pre3 - x4_x3 * pre4;
		nx /= dn;
		ny /= dn;

		if ( nx >= 0 && nx <= 1 && ny >= 0 && ny <= 1 )
		{
			return true;
		}

		return false;
	}
}