import flash.geom.Point;

class descendent.hud.reticle.Arc
{
	private static var _2_MUL_PI:Number = 2.0 * Math.PI;

	private static var _PI_DIV_2:Number = Math.PI / 2.0;

	private static var _PI_DIV_4:Number = Math.PI / 4.0;

	private static var _PI_DIV_8:Number = Math.PI / 8.0;

	private function Arc()
	{
	}

	public static function getPoint(c:Point, r:Point, angle:Number):Point
	{
		return Arc.traceArc_point(c, r, angle);
	}

	public static function traceArc(o:MovieClip, c:Point, r:Point, angle_a:Number, angle_b:Number,
		concatenate:Boolean):Void
	{
		// http://www.spaceroots.org/documents/ellipse/elliptical-arc.pdf

		// https://www.joecridge.me/content/pdf/bezier-arcs.pdf
		// http://timotheegroleau.com/Flash/articles/cubic_bezier_in_flash.htm

		var point_a:Point = Arc.traceArc_point(c, r, angle_a);
		var point_b:Point = Arc.traceArc_point(c, r, angle_b);

		if (!concatenate)
			o.moveTo(point_a.x, point_a.y);

		Arc.traceArc_clamp(o, c, r, angle_a, angle_b);
	}

	private static function traceArc_clamp(o:MovieClip, c:Point, r:Point, angle_a:Number, angle_b:Number):Void
	{
		var range:Number = angle_b - angle_a;

		if (range == 0)
			return;

		var theta_b:Number = (Math.abs(range) > _2_MUL_PI)
			? angle_a + ((range / Math.abs(range)) * _2_MUL_PI)
			: angle_b;

		Arc.traceArc_split(o, c, r, angle_a, theta_b);
	}

	private static function traceArc_split(o:MovieClip, c:Point, r:Point, angle_a:Number, angle_b:Number):Void
	{
		var range:Number = angle_b - angle_a;

		var count:Number = Math.ceil(Math.abs(range) / _PI_DIV_8);
		var delta:Number = range / count;

		for (var i:Number = 0; i < count; ++i)
		{
			Arc.traceArc_trace(
				o, c, r,
				angle_a + (delta * i),
				angle_a + (delta * (i + 1)));
		}
	}

	private static function traceArc_trace(o:MovieClip, c:Point, r:Point, angle_a:Number, angle_b:Number):Void
	{
		var point_a:Point = Arc.traceArc_point(c, r, angle_a);
		var slope_a:Point = Arc.traceArc_slope(c, r, angle_a);

		var point_b:Point = Arc.traceArc_point(c, r, angle_b);
		var slope_b:Point = Arc.traceArc_slope(c, r, angle_b);

		var k:Number = ((slope_b.y * (point_b.x - point_a.x)) - (slope_b.x * (point_b.y - point_a.y)))
			/ ((slope_a.x * slope_b.y) - (slope_a.y * slope_b.x));

		o.curveTo(
			point_a.x + (k * slope_a.x), point_a.y + (k * slope_a.y),
			point_b.x, point_b.y);
	}

	private static function traceArc_point(c:Point, r:Point, angle:Number):Point
	{
		return new Point(
			c.x + (r.x * Math.cos(angle)),
			c.y + (r.y * Math.sin(angle)));
	}

	private static function traceArc_slope(c:Point, r:Point, angle:Number):Point
	{
		return new Point(
			-(r.x * Math.sin(angle)),
			r.y * Math.cos(angle));
	}

	public static function traceEllipse(o:MovieClip, c:Point, r:Point):Void
	{
		Arc.traceArc(o, c, r, 0.0, _2_MUL_PI);
	}
}
