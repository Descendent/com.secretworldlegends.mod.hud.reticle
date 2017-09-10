import flash.geom.Point;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.greensock.easing.Sine;

import descendent.hud.reticle.ArcBar;
import descendent.hud.reticle.Color;
import descendent.hud.reticle.IMeter;
import descendent.hud.reticle.Rad;
import descendent.hud.reticle.Shape;

class descendent.hud.reticle.ReflectArcBarMeter extends Shape implements IMeter
{
	private var _color_shaft:Color;

	private var _color_meter:Color;

	private var _color_notch:Color;

	private var _maximum:Number;

	private var _shape:ArcBar;

	private var _shape_a:ArcBar;

	private var _shape_b:ArcBar;

	private var _shaft:MovieClip;

	private var _notch_shaft:MovieClip;

	private var _meter_a:MovieClip;

	private var _meter_stencil_a:MovieClip;

	private var _meter_b:MovieClip;

	private var _meter_stencil_b:MovieClip;

	private var _notch_meter_a:MovieClip;

	private var _notch_meter_stencil_a:MovieClip;

	private var _notch_meter_b:MovieClip;

	private var _notch_meter_stencil_b:MovieClip;

	private var _tween_pulse:TweenMax;

	private var _value_meter:Number;

	private var _value_notch:/*Number*/Array;

	public function ReflectArcBarMeter(r:Number, angle_a:Number, angle_b:Number, thickness:Number,
		color_shaft:Color, color_meter:Color, color_notch:Color,
		maximum:Number, reverse:Boolean)
	{
		super();

		this._color_shaft = color_shaft;
		this._color_meter = color_meter;
		this._color_notch = color_notch;
		this._maximum = maximum;

		var angle_m:Number = angle_a + ((angle_b - angle_a) / 2.0);

		this._shape = new ArcBar(r, angle_a, angle_b, thickness);
		this._shape_a = (reverse)
			? new ArcBar(r, angle_a, angle_m, thickness)
			: new ArcBar(r, angle_m, angle_a, thickness);
		this._shape_b = (reverse)
			? new ArcBar(r, angle_b, angle_m, thickness)
			: new ArcBar(r, angle_m, angle_b, thickness);

		this._value_meter = 0.0;
		this._value_notch = null;
	}

	public function getMaximum():Number
	{
		return this._maximum;
	}

	public function setMaximum(value:Number):Void
	{
		if (value == this._maximum)
			return;

		this._maximum = value;

		this.refresh_notch();
		this.refresh_meter();
	}

	public function getMeter():Number
	{
		return this._value_meter;
	}

	public function setMeter(value:Number):Void
	{
		this._value_meter = value;

		this.refresh_meter();
	}

	public function getNotch():/*Number*/Array
	{
		return this._value_notch;
	}

	public function setNotch(value:/*Number*/Array):Void
	{
		this._value_notch = (value != null)
			? value.sort(Array.DESCENDING | Array.NUMERIC)
			: value;

		this.refresh_notch();
	}

	public function prepare(o:MovieClip):Void
	{
		super.prepare(o);

		this.prepare_shaft();
		this.prepare_notch_shaft();
		this.prepare_meter();
		this.prepare_notch_meter();
		this.prepare_pulse();

		this.refresh_notch();
		this.refresh_meter();
	}

	private function prepare_shaft():Void
	{
		if (this._color_shaft == null)
			return;

		var a:MovieClip = this.content.createEmptyMovieClip("", this.content.getNextHighestDepth());

		a.lineStyle();
		a.beginFill(0x000000, 25);
		this._shape.traceShape(a, new Point(0.0, 0.0));
		a.endFill();

		var o:MovieClip = this.content.createEmptyMovieClip("", this.content.getNextHighestDepth());

		o.lineStyle();
		o.beginFill(this._color_shaft.color, this._color_shaft.alpha);
		this._shape.traceShape(o, new Point(0.0, 0.0));
		o.endFill();

		this._shaft = o;
	}

	private function prepare_notch_shaft():Void
	{
		if (this._color_shaft == null)
			return;

		if (this._color_notch == null)
			return;

		var o:MovieClip = this.content.createEmptyMovieClip("", this.content.getNextHighestDepth());

//		o.blendMode = "invert";

		this._notch_shaft = o;
	}

	private function prepare_meter():Void
	{
		this.prepare_meter_a();
		this.prepare_meter_b();
	}

	private function prepare_meter_a():Void
	{
		var o:MovieClip = this.content.createEmptyMovieClip("", this.content.getNextHighestDepth());

		o.lineStyle();
		o.beginFill(this._color_meter.color, this._color_meter.alpha);
		this._shape_a.traceShape(o, new Point(0.0, 0.0));
		o.endFill();

		var m:MovieClip = this.content.createEmptyMovieClip("", this.content.getNextHighestDepth());

		m.lineStyle();
		m.beginFill(0x000000, 100);
		this._shape_a.traceShape(m, new Point(0.0, 0.0));
		m.endFill();

		o.setMask(m);

		this._meter_a = o;
		this._meter_stencil_a = m;
	}

	private function prepare_meter_b():Void
	{
		var o:MovieClip = this.content.createEmptyMovieClip("", this.content.getNextHighestDepth());

		o.lineStyle();
		o.beginFill(this._color_meter.color, this._color_meter.alpha);
		this._shape_b.traceShape(o, new Point(0.0, 0.0));
		o.endFill();

		var m:MovieClip = this.content.createEmptyMovieClip("", this.content.getNextHighestDepth());

		m.lineStyle();
		m.beginFill(0x000000, 100);
		this._shape_b.traceShape(m, new Point(0.0, 0.0));
		m.endFill();

		o.setMask(m);

		this._meter_b = o;
		this._meter_stencil_b = m;
	}

	private function prepare_notch_meter():Void
	{
		this.prepare_notch_meter_a();
		this.prepare_notch_meter_b();
	}

	private function prepare_notch_meter_a():Void
	{
		if (this._color_notch == null)
			return;

		var o:MovieClip = this.content.createEmptyMovieClip("", this.content.getNextHighestDepth());

//		o.blendMode = "invert";

		var m:MovieClip = this.content.createEmptyMovieClip("", this.content.getNextHighestDepth());

		m.lineStyle();
		m.beginFill(0x000000, 100);
		this._shape_a.traceShape(m, new Point(0.0, 0.0));
		m.endFill();

		m.lineStyle();
		m.beginFill(0x000000, 100);
		this._shape_a.traceNotch(m, new Point(0.0, 0.0), 4.0, 1.0);
		m.endFill();

		o.setMask(m);

		this._notch_meter_a = o;
		this._notch_meter_stencil_a = m;
	}

	private function prepare_notch_meter_b():Void
	{
		if (this._color_notch == null)
			return;

		var o:MovieClip = this.content.createEmptyMovieClip("", this.content.getNextHighestDepth());

//		o.blendMode = "invert";

		var m:MovieClip = this.content.createEmptyMovieClip("", this.content.getNextHighestDepth());

		m.lineStyle();
		m.beginFill(0x000000, 100);
		this._shape_b.traceShape(m, new Point(0.0, 0.0));
		m.endFill();

		m.lineStyle();
		m.beginFill(0x000000, 100);
		this._shape_b.traceNotch(m, new Point(0.0, 0.0), 4.0, 1.0);
		m.endFill();

		o.setMask(m);

		this._notch_meter_b = o;
		this._notch_meter_stencil_b = m;
	}

	private function prepare_pulse():Void
	{
		var o:Array = (this._shaft != null)
			? [this._shaft, this._meter_a, this._meter_b]
			: [this._meter_a, this._meter_b];

		this._tween_pulse = TweenMax.fromTo(o, 0.3, {
			colorTransform: {
				brightness: 1.0
			}
		}, {
			colorTransform: {
				brightness: 1.5
			},
			ease: Sine.easeInOut,
			repeat: -1,
			yoyo: true,
			paused: true
		});
	}

	private function refresh_notch():Void
	{
		this.refresh_notch_shaft();
		this.refresh_notch_meter();
	}

	private function refresh_notch_shaft():Void
	{
		if (this._notch_shaft == null)
			return;

		var o:MovieClip = this._notch_shaft;

		o.clear();

		if (this._value_notch == null)
			return;

		o.lineStyle();
		o.beginFill(this._color_notch.color, this._color_notch.alpha * 0.5);
		for (var i:Number = 0; i < this._value_notch.length; ++i)
		{
			if (this._value_notch[i] <= 0)
				continue;

			if (this._value_notch[i] >= this._maximum)
				continue;

			this._shape_a.traceNotch(o, new Point(0.0, 0.0), 4.0, this._value_notch[i] / this._maximum);
			this._shape_b.traceNotch(o, new Point(0.0, 0.0), 4.0, this._value_notch[i] / this._maximum);
		}
		o.endFill();
	}

	private function refresh_notch_meter():Void
	{
		this.refresh_notch_meter_a();
		this.refresh_notch_meter_b();
	}

	private function refresh_notch_meter_a():Void
	{
		if (this._notch_meter_a == null)
			return;

		var o:MovieClip = this._notch_meter_a;

		o.clear();

		if (this._value_notch == null)
			return;

		o.lineStyle();
		o.beginFill(this._color_notch.color, this._color_notch.alpha);
		for (var i:Number = 0; i < this._value_notch.length; ++i)
		{
			if (this._value_notch[i] <= 0)
				continue;

			if (this._value_notch[i] >= this._maximum)
				continue;

			this._shape_a.traceNotch(o, new Point(0.0, 0.0), 4.0, this._value_notch[i] / this._maximum);
		}
		o.endFill();
	}

	private function refresh_notch_meter_b():Void
	{
		if (this._notch_meter_b == null)
			return;

		var o:MovieClip = this._notch_meter_b;

		o.clear();

		if (this._value_notch == null)
			return;

		o.lineStyle();
		o.beginFill(this._color_notch.color, this._color_notch.alpha);
		for (var i:Number = 0; i < this._value_notch.length; ++i)
		{
			if (this._value_notch[i] <= 0)
				continue;

			if (this._value_notch[i] >= this._maximum)
				continue;

			this._shape_b.traceNotch(o, new Point(0.0, 0.0), 4.0, this._value_notch[i] / this._maximum);
		}
		o.endFill();
	}

	private function refresh_meter():Void
	{
		if (this._meter_stencil_a == null)
			return;

		if (this._meter_stencil_b == null)
			return;

		var normalizeMeter:Number = this.normalizeMeter(this._value_meter);

		this._meter_stencil_a._rotation = -Rad.getDeg(this._shape_a.getDelta(1.0 - normalizeMeter));
		this._meter_stencil_b._rotation = -Rad.getDeg(this._shape_b.getDelta(1.0 - normalizeMeter));

		if (this._notch_meter_stencil_a == null)
			return;

		if (this._notch_meter_stencil_b == null)
			return;

		var normalizeNotch:Number = this.normalizeNotch(this._value_meter);

		this._notch_meter_stencil_a._rotation = -Rad.getDeg(this._shape_a.getDelta(1.0 - normalizeNotch));
		this._notch_meter_stencil_b._rotation = -Rad.getDeg(this._shape_b.getDelta(1.0 - normalizeNotch));
	}

	private function normalizeMeter(value:Number):Number
	{
		return Math.min(Math.max(value / this._maximum, 0.0), 1.0);
	}

	private function normalizeNotch(value:Number):Number
	{
		for (var i:Number = 0; i < this._value_notch.length; ++i)
		{
			if (value >= this._value_notch[i])
				return Math.min(Math.max(this._value_notch[i] / this._maximum, 0.0), 1.0);
		}

		return 0.0;
	}

	public function discard():Void
	{
		this._tween_pulse.kill();

		super.discard();
	}

	public function pulseBegin():Void
	{
		if (this._tween_pulse == null)
			return;

		if (this._tween_pulse.isActive())
			return;

		this._tween_pulse.play(0.0);
	}

	public function pulseEnd():Void
	{
		if (this._tween_pulse == null)
			return;

		if (!this._tween_pulse.isActive())
			return;

		this._tween_pulse.restart();
		this._tween_pulse.kill();
	}
}
