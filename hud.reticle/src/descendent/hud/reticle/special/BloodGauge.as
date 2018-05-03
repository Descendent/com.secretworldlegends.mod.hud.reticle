import com.GameInterface.Game.BuffData;
import com.GameInterface.Game.Character;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import descendent.hud.reticle.Color;
import descendent.hud.reticle.DefaultArcBarMeter;
import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IMeter;

class descendent.hud.reticle.special.BloodGauge extends Gauge
{
	private static var TAG_MARTYRDOM:Number = 9257968;

	private static var TAG_CORRUPTION:Number = 9257969;

	private static var CORRUPTION_MARTYRDOM_MAX:Number = 100;

	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _equip:Number;

	private var _character:Character;

	private var _meter_a:IMeter;

	private var _meter_b:IMeter;

	public function BloodGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number,
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

		this.refresh_meter();

		this._character.SignalInvisibleBuffAdded.Connect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Connect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Connect(this.character_onTag, this);
	}

	private function prepare_meter():Void
	{
		this.prepare_meter_a();
		this.prepare_meter_b();
	}

	private function prepare_meter_a():Void
	{
		var notch:/*Number*/Array = [10, 60, 90];

		this._meter_a = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x4FF47A, 33), new Color(0x4FF47A, 100), new Color(0xFFFFFF, 100), BloodGauge.CORRUPTION_MARTYRDOM_MAX, false);
		this._meter_a.setNotch(notch);
		this._meter_a.prepare(this.content);
	}

	private function prepare_meter_b():Void
	{
		var notch:/*Number*/Array = [10, 60, 90];

		this._meter_b = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x6600CC, 33), new Color(0x6600CC, 100), new Color(0xFFFFFF, 100), BloodGauge.CORRUPTION_MARTYRDOM_MAX, false);
		this._meter_b.setNotch(notch);
		this._meter_b.prepare(this.content);
	}

	private function refresh_meter():Void
	{
		var value:Number = this.count(this._character.m_InvisibleBuffList[BloodGauge.TAG_MARTYRDOM])
			- this.count(this._character.m_InvisibleBuffList[BloodGauge.TAG_CORRUPTION]);

		if (value == this._meter_a.getMeter())
			return;

		TweenMax.to(this, 0.3, {
			setMeter: value,
			ease: Linear.easeNone
		});
	}

	private function count(tag:BuffData):Number
	{
		return (tag != null)
			? tag.m_Count
			: 0;
	}

	private function getMeter():Number
	{
		return this._meter_a.getMeter();
	}

	private function setMeter(value:Number):Void
	{
		if (value <= 0)
		{
			this._meter_a.dismiss();
			this._meter_b.present();
		}
		else
		{
			this._meter_a.present();
			this._meter_b.dismiss();
		}

		this._meter_a.setMeter(value);
		this._meter_b.setMeter(-value);
	}

	public function discard():Void
	{
		this._character.SignalInvisibleBuffAdded.Disconnect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Disconnect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Disconnect(this.character_onTag, this);

		TweenMax.killTweensOf(this);

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

		this._meter_a.discard();
		this._meter_a = null;
	}

	private function discard_meter_b():Void
	{
		if (this._meter_b == null)
			return;

		this._meter_b.discard();
		this._meter_b = null;
	}

	private function character_onTag(which:Number):Void
	{
		if (which == BloodGauge.TAG_MARTYRDOM)
			this.refresh_meter();
		else if (which == BloodGauge.TAG_CORRUPTION)
			this.refresh_meter();
	}
}
