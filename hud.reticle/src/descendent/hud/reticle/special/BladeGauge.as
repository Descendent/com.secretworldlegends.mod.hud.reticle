import com.GameInterface.Game.BuffData;
import com.GameInterface.Game.Character;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import descendent.hud.reticle.Color;
import descendent.hud.reticle.DefaultArcBarMeter;
import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IGauge;
import descendent.hud.reticle.IMeter;

class descendent.hud.reticle.special.BladeGauge extends Gauge
{
	private static var TAG_CHI:Number = 9253321;

	private static var TAG_SPIRITBLADE:Number = 7631134;

	private static var TAG_CHIOVERFLOW:Number = 9255856;

	private static var CHI_MAX:Number = 5;

	private static var SPIRITBLADE_MAX:Number = 10;

	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _equip:Number;

	private var _character:Character;

	private var _meter_a:IMeter;

	private var _meter_b:IMeter;

	private var _bloom:IMeter;

	public function BladeGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number,
		equip:Number)
	{
		super();

		this._r = r;
		this._angle_a = angle_a;
		this._angle_b = angle_b;
		this._thickness = thickness;
		this._equip = equip;
	}

	public function prepare(o:MovieClip):Void
	{
		super.prepare(o);

		this._character = Character.GetClientCharacter();

		this.prepare_meter();
		this.prepare_bloom();

		this.refresh_meter();
		this.refresh_pulse();

		this._character.SignalInvisibleBuffAdded.Connect(this.character_onTagBegin, this);
		this._character.SignalInvisibleBuffUpdated.Connect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Connect(this.character_onTagEnd, this);
		this._character.SignalBuffAdded.Connect(this.character_onTagBegin, this);
	}

	private function prepare_meter():Void
	{
		this.prepare_meter_a();
		this.prepare_meter_b();
	}

	private function prepare_meter_a():Void
	{
		var t:Number = 2.0 / (this._r + (this._thickness * 0.5));
		var angle_m:Number = this._angle_a + ((this._angle_b - this._angle_a) / 3.0);
		var angle_b:Number = (this._angle_b >= this._angle_a)
			? angle_m - t
			: angle_m + t;

		this._meter_a = new DefaultArcBarMeter(this._r, this._angle_a, angle_b, this._thickness,
			new Color(0x30AADF, 25), new Color(0x30AADF, 100), new Color(0xFFFFFF, 100), BladeGauge.CHI_MAX, false);
		this._meter_a.prepare(this.content);
	}

	private function prepare_meter_b():Void
	{
		var notch:/*Number*/Array = [1, 3];

		var t:Number = 2.0 / (this._r + (this._thickness * 0.5));
		var angle_m:Number = this._angle_a + ((this._angle_b - this._angle_a) / 3.0);
		var angle_a:Number = (this._angle_b >= this._angle_a)
			? angle_m + t
			: angle_m - t;

		this._meter_b = new DefaultArcBarMeter(this._r, angle_a, this._angle_b, this._thickness,
			new Color(0x30AADF, 25), new Color(0x30AADF, 100), new Color(0xFFFFFF, 100), BladeGauge.SPIRITBLADE_MAX, false);
		this._meter_b.setNotch(notch);
		this._meter_b.prepare(this.content);
	}

	private function prepare_bloom():Void
	{
		var t:Number = 2.0 / (this._r + (this._thickness * 0.5));
		var angle_m:Number = this._angle_a + ((this._angle_b - this._angle_a) / 3.0);
		var angle_a:Number = (this._angle_b >= this._angle_a)
			? angle_m + t
			: angle_m - t;

		this._bloom = new DefaultArcBarMeter(this._r, angle_a, this._angle_b, this._thickness,
			null, new Color(0x22FF00, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._bloom.setMeter(1.0);
		this._bloom.prepare(this.content);

		this._bloom.dismiss();
	}

	private function refresh_meter():Void
	{
		this.refresh_meter_a();
		this.refresh_meter_b();
	}

	private function refresh_meter_a():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[BladeGauge.TAG_CHI];

		var value:Number = (tag != null)
			? tag.m_Count
			: 0;

		if (value == this._meter_a.getMeter())
			return;

		TweenMax.to(this._meter_a, 0.3, {
			setMeter: value,
			ease: Linear.easeNone,
			onComplete: this.meter_a_onMeter,
			onCompleteParams: [value],
			onCompleteScope: this
		});
	}

	private function refresh_meter_b():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[BladeGauge.TAG_SPIRITBLADE];

		var value:Number = (tag != null)
			? tag.m_Count
			: 0;

		if (value == this._meter_b.getMeter())
			return;

		TweenMax.to(this._meter_b, 0.3, {
			setMeter: value,
			ease: Linear.easeNone,
			onComplete: this.meter_b_onMeter,
			onCompleteParams: [value],
			onCompleteScope: this
		});
	}

	private function refresh_pulse():Void
	{
		this.refresh_pulse_a();
		this.refresh_pulse_b();
	}

	private function refresh_pulse_a():Void
	{
		if (this.pulse_a())
			this._meter_a.pulseBegin();
		else
			this._meter_a.pulseEnd();
	}

	private function pulse_a():Boolean
	{
		var value:Number = this._meter_a.getMeter();

		if (value >= BladeGauge.CHI_MAX)
			return true;

		return false;
	}

	private function refresh_pulse_b():Void
	{
		if (this.pulse_b())
			this._meter_b.pulseBegin();
		else
			this._meter_b.pulseEnd();
	}

	private function pulse_b():Boolean
	{
		var value:Number = this._meter_b.getMeter();

		if (value == 1)
			return true;

		return false;
	}

	public function discard():Void
	{
		this._character.SignalInvisibleBuffAdded.Disconnect(this.character_onTagBegin, this);
		this._character.SignalInvisibleBuffUpdated.Disconnect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Disconnect(this.character_onTagEnd, this);
		this._character.SignalBuffAdded.Disconnect(this.character_onTagBegin, this);

		this.discard_bloom();
		this.discard_meter();

		super.discard();
	}

	private function discard_meter():Void
	{
		this.discard_meter_a();
		this.discard_meter_b();
	}

	private function discard_meter_a():Void
	{
		if (this._meter_a == null)
			return;

		TweenMax.killTweensOf(this._meter_a);

		this._meter_a.discard();
		this._meter_a = null;
	}

	private function discard_meter_b():Void
	{
		if (this._meter_b == null)
			return;

		TweenMax.killTweensOf(this._meter_b);

		this._meter_b.discard();
		this._meter_b = null;
	}

	private function discard_bloom():Void
	{
		if (this._bloom == null)
			return;

		TweenMax.killTweensOf(this._bloom);

		this._bloom.discard();
		this._bloom = null;
	}

	private function bloom():Void
	{
		TweenMax.fromTo(this._bloom, 1.5, {
			setAlpha: 100
		}, {
			setAlpha: 0,
			onStart: this._bloom.present,
			onStartScope: this._bloom,
			onComplete: this._bloom.dismiss,
			onCompleteScope: this._bloom
		});
	}

	private function character_onTagBegin(which:Number):Void
	{
		if (which == BladeGauge.TAG_CHI)
			this.refresh_meter_a();
		else if (which == BladeGauge.TAG_SPIRITBLADE)
			this.refresh_meter_b();
		else if (which == BladeGauge.TAG_CHIOVERFLOW)
			this.bloom();
	}

	private function character_onTag(which:Number):Void
	{
		if (which == BladeGauge.TAG_CHI)
			this.refresh_meter_a();
		else if (which == BladeGauge.TAG_SPIRITBLADE)
			this.refresh_meter_b();
	}

	private function character_onTagEnd(which:Number):Void
	{
		if (which == BladeGauge.TAG_CHI)
			this.refresh_meter_a();
		else if (which == BladeGauge.TAG_SPIRITBLADE)
			this.refresh_meter_b();
	}

	private function meter_a_onMeter(value:Number):Void
	{
		this.refresh_pulse_a();
	}

	private function meter_b_onMeter(value:Number):Void
	{
		this.refresh_pulse_b();
	}
}
