import flash.geom.Point;

import descendent.hud.reticle.Arc;

class descendent.hud.reticle.ArcBar
{
	private var _r_inner:Point;

	private var _r_outer:Point;

	private var _angle_a:Number;

	private var _angle_b:Number;

	public function ArcBar(r:Number, angle_a:Number, angle_b:Number, thickness:Number)
	{
		this._r_inner = new Point(r, r);
		this._r_outer = new Point(r + thickness, r + thickness);
		this._angle_a = angle_a;
		this._angle_b = angle_b;
	}

	public function traceShape(o:MovieClip, c:Point):Void
	{
		var p:Point;

		Arc.traceArc(o, c, this._r_inner, this._angle_a, this._angle_b);

		p = Arc.getPoint(c, this._r_outer, this._angle_b);
		o.lineTo(p.x, p.y);

		Arc.traceArc(o, c, this._r_outer, this._angle_b, this._angle_a);

		p = Arc.getPoint(c, this._r_inner, this._angle_a);
		o.lineTo(p.x, p.y);
	}

	public function traceNotch(o:MovieClip, c:Point, thickness:Number, t:Number):Void
	{
		var angle:Number = this._angle_a + this.getDelta(t);

		var r:Point = new Point(
			(this._r_inner.x + this._r_outer.x) / 2.0,
			(this._r_inner.y + this._r_outer.y) / 2.0);

		var notch_c:Point = Arc.getPoint(c, r, angle);
		var notch_r:Point = new Point(thickness / 2.0, thickness / 2.0);

		Arc.traceEllipse(o, notch_c, notch_r);
	}

	public function getDelta(t:Number):Number
	{
		return t * (this._angle_b - this._angle_a);
	}
}
