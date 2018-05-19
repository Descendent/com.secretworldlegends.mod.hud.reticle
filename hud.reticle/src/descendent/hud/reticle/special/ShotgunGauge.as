import com.GameInterface.SpellBase;
import com.GameInterface.Game.BuffData;
import com.GameInterface.Game.Character;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import descendent.hud.reticle.Color;
import descendent.hud.reticle.DefaultArcBarMeter;
import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IMeter;

class descendent.hud.reticle.special.ShotgunGauge extends Gauge
{
	private static var TAG_SHELL:Number = 9253306;

	private static var TAG_DEPLETEDURANIUM:Number = 9253310;

	private static var TAG_DRAGONSBREATH:Number = 9253311;

	private static var TAG_ARMORPIERCING:Number = 9253312;

	private static var TAG_ANIMAINFUSED:Number = 9253313;

	private static var TAG_ENRICH:Number = 9255619;

	private static var ABILITY_ODDSANDEVENS:Number = 9255598;

	private static var ABILITY_ENRICH:Number = 9255616;

	private static var SHELL_MAX:Number = 6;

	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _equip:Number;

	private var _character:Character;

	private var _meter_a_shaft:IMeter;

	private var _meter_a_value:IMeter;

	private var _meter_a_odd:IMeter;

	private var _meter_b_shaft:IMeter;

	private var _meter_b_value:IMeter;

	private var _meter_b_odd:IMeter;

	private var _meter_c_shaft:IMeter;

	private var _meter_c_value:IMeter;

	private var _meter_c_odd:IMeter;

	private var _meter_d_shaft:IMeter;

	private var _meter_d_value:IMeter;

	private var _meter_d_odd:IMeter;

	private var _meter_x_shaft:IMeter;

	private var _meter_x_value:IMeter;

	private var _meter_x_odd:IMeter;

	private var _notch_a:IMeter;

	private var _notch_x:IMeter;

	public function ShotgunGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number,
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
		this.prepare_notch();

		this.refresh_meter();
		this.refresh_maximum();
		this.refresh_color();
		this.refresh_pulse();

		this._character.SignalInvisibleBuffAdded.Connect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Connect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Connect(this.character_onTag, this);
		this._character.SignalBuffAdded.Connect(this.character_onTag, this);
		this._character.SignalBuffUpdated.Connect(this.character_onTag, this);
		SpellBase.SignalPassiveAdded.Connect(this.loadout_onPlant, this);
		SpellBase.SignalPassiveRemoved.Connect(this.loadout_onPluck, this);
	}

	private function prepare_meter():Void
	{
		this.prepare_meter_a();
		this.prepare_meter_b();
		this.prepare_meter_c();
		this.prepare_meter_d();
		this.prepare_meter_x();
	}

	private function prepare_meter_a():Void
	{
		this.prepare_meter_a_shaft();
		this.prepare_meter_a_value();
		this.prepare_meter_a_odd();
	}

	private function prepare_meter_a_shaft():Void
	{
		var notch:/*Number*/Array = [2, 4, 6];

		this._meter_a_shaft = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x9B52CE, 33), new Color(0x9B52CE, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_a_shaft.setNotch(notch);
		this._meter_a_shaft.prepare(this.content);
	}

	private function prepare_meter_a_value():Void
	{
		this._meter_a_value = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x9B52CE, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_a_value.prepare(this.content);
	}

	private function prepare_meter_a_odd():Void
	{
		this._meter_a_odd = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x9B52CE, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_a_odd.prepare(this.content);
	}

	private function prepare_meter_b():Void
	{
		this.prepare_meter_b_shaft();
		this.prepare_meter_b_value();
		this.prepare_meter_b_odd();
	}

	private function prepare_meter_b_shaft():Void
	{
		var notch:/*Number*/Array = [2, 4];

		this._meter_b_shaft = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0xFD853D, 33), new Color(0xFD853D, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_b_shaft.setNotch(notch);
		this._meter_b_shaft.prepare(this.content);
	}

	private function prepare_meter_b_value():Void
	{
		this._meter_b_value = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0xFD853D, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_b_value.prepare(this.content);
	}

	private function prepare_meter_b_odd():Void
	{
		this._meter_b_odd = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0xFD853D, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_b_odd.prepare(this.content);
	}

	private function prepare_meter_c():Void
	{
		this.prepare_meter_c_shaft();
		this.prepare_meter_c_value();
		this.prepare_meter_c_odd();
	}

	private function prepare_meter_c_shaft():Void
	{
		var notch:/*Number*/Array = [2, 4];

		this._meter_c_shaft = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x009CC9, 33), new Color(0x009CC9, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_c_shaft.setNotch(notch);
		this._meter_c_shaft.prepare(this.content);
	}

	private function prepare_meter_c_value():Void
	{
		this._meter_c_value = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x009CC9, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_c_value.prepare(this.content);
	}

	private function prepare_meter_c_odd():Void
	{
		this._meter_c_odd = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x009CC9, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_c_odd.prepare(this.content);
	}

	private function prepare_meter_d():Void
	{
		this.prepare_meter_d_shaft();
		this.prepare_meter_d_value();
		this.prepare_meter_d_odd();
	}

	private function prepare_meter_d_shaft():Void
	{
		var notch:/*Number*/Array = [2, 4];

		this._meter_d_shaft = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x0CB700, 33), new Color(0x0CB700, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_d_shaft.setNotch(notch);
		this._meter_d_shaft.prepare(this.content);
	}

	private function prepare_meter_d_value():Void
	{
		this._meter_d_value = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x0CB700, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_d_value.prepare(this.content);
	}

	private function prepare_meter_d_odd():Void
	{
		this._meter_d_odd = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x0CB700, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_d_odd.prepare(this.content);
	}

	private function prepare_meter_x():Void
	{
		this.prepare_meter_x_shaft();
		this.prepare_meter_x_value();
		this.prepare_meter_x_odd();
	}

	private function prepare_meter_x_shaft():Void
	{
		var notch:/*Number*/Array = [2, 4];

		this._meter_x_shaft = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0xD7D7D7, 33), new Color(0xD7D7D7, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_x_shaft.setNotch(notch);
		this._meter_x_shaft.prepare(this.content);
	}

	private function prepare_meter_x_value():Void
	{
		this._meter_x_value = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0xD7D7D7, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_x_value.prepare(this.content);
	}

	private function prepare_meter_x_odd():Void
	{
		this._meter_x_odd = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0xD7D7D7, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_x_odd.prepare(this.content);
	}

	private function prepare_notch():Void
	{
		this.prepare_notch_a();
		this.prepare_notch_x();
	}

	private function prepare_notch_a():Void
	{
		var notch:/*Number*/Array = [2, 4, 6];

		this._notch_a = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x000000, 0), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._notch_a.setNotch(notch);
		this._notch_a.prepare(this.content);
	}

	private function prepare_notch_x():Void
	{
		var notch:/*Number*/Array = [2, 4];

		this._notch_x = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x000000, 0), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._notch_x.setNotch(notch);
		this._notch_x.prepare(this.content);
	}

	private function refresh_meter():Void
	{
		var value:Number = this.count(this._character.m_InvisibleBuffList[ShotgunGauge.TAG_SHELL])
			+ this.count(this._character.m_BuffList[ShotgunGauge.TAG_ENRICH]);

		if (value == this._meter_x_value.getMeter())
			return;

		TweenMax.to(this, 0.3, {
			setMeter: value,
			ease: Linear.easeNone,
			onComplete: this.meter_onMeter,
			onCompleteParams: [value],
			onCompleteScope: this
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
		return this._meter_x_value.getMeter();
	}

	private function setMeter(value:Number):Void
	{
		var i:Number = Math.floor(value);
		var odd:Number = i - (1 - (i % 2));

		this._meter_a_value.setMeter(value);
		this._meter_a_odd.setMeter(odd);

		this._meter_b_value.setMeter(value);
		this._meter_b_odd.setMeter(odd);

		this._meter_c_value.setMeter(value);
		this._meter_c_odd.setMeter(odd);

		this._meter_d_value.setMeter(value);
		this._meter_d_odd.setMeter(odd);

		this._meter_x_value.setMeter(value);
		this._meter_x_odd.setMeter(odd);

		this._notch_a.setMeter(value);
		this._notch_x.setMeter(value);
	}

	private function refresh_color():Void
	{
		this._meter_a_shaft.dismiss();
		this._meter_a_value.dismiss();
		this._meter_a_value.pulseEnd();
		this._meter_a_odd.dismiss();

		this._meter_b_shaft.dismiss();
		this._meter_b_value.dismiss();
		this._meter_b_value.pulseEnd();
		this._meter_b_odd.dismiss();

		this._meter_c_shaft.dismiss();
		this._meter_c_value.dismiss();
		this._meter_c_value.pulseEnd();
		this._meter_c_odd.dismiss();

		this._meter_d_shaft.dismiss();
		this._meter_d_value.dismiss();
		this._meter_d_value.pulseEnd();
		this._meter_d_odd.dismiss();

		this._meter_x_shaft.dismiss();
		this._meter_x_value.dismiss();
		this._meter_x_value.pulseEnd();
		this._meter_x_odd.dismiss();

		this._notch_a.dismiss();
		this._notch_x.dismiss();

		var shaft:IMeter;
		var value:IMeter;
		var odd:IMeter;
		var notch:IMeter;
		if (this._character.m_InvisibleBuffList[ShotgunGauge.TAG_DEPLETEDURANIUM] != null)
		{
			shaft = this._meter_a_shaft;
			value = this._meter_a_value;
			odd = this._meter_a_odd;
			notch = this._notch_a;
		}
		else if (this._character.m_InvisibleBuffList[ShotgunGauge.TAG_DRAGONSBREATH] != null)
		{
			shaft = this._meter_b_shaft;
			value = this._meter_b_value;
			odd = this._meter_b_odd;
			notch = this._notch_x;
		}
		else if (this._character.m_InvisibleBuffList[ShotgunGauge.TAG_ARMORPIERCING] != null)
		{
			shaft = this._meter_c_shaft;
			value = this._meter_c_value;
			odd = this._meter_c_odd;
			notch = this._notch_x;
		}
		else if (this._character.m_InvisibleBuffList[ShotgunGauge.TAG_ANIMAINFUSED] != null)
		{
			shaft = this._meter_d_shaft;
			value = this._meter_d_value;
			odd = this._meter_d_odd;
			notch = this._notch_x;
		}
		else
		{
			shaft = this._meter_x_shaft;
			value = this._meter_x_value;
			odd = this._meter_x_odd;
			notch = this._notch_x;
		}

		shaft.present();
		value.present();
		notch.present();

		if (!SpellBase.IsPassiveEquipped(ShotgunGauge.ABILITY_ODDSANDEVENS))
			return;

		value.pulseBegin();
		odd.present();
	}

	private function refresh_maximum():Void
	{
		if (this._meter_a_value == null)
			return;

		var maximum:Number = (SpellBase.IsPassiveEquipped(ShotgunGauge.ABILITY_ENRICH))
			? ShotgunGauge.SHELL_MAX + 2
			: ShotgunGauge.SHELL_MAX;

		this._meter_a_shaft.setMaximum(maximum);
		this._meter_a_value.setMaximum(maximum);
		this._meter_a_odd.setMaximum(maximum);
		this._notch_a.setMaximum(maximum);
	}

	private function refresh_pulse():Void
	{
		if (this.pulse())
		{
			this._meter_a_shaft.pulseBegin();
			this._meter_b_shaft.pulseBegin();
			this._meter_c_shaft.pulseBegin();
			this._meter_d_shaft.pulseBegin();
			this._meter_x_shaft.pulseBegin();
		}
		else
		{
			this._meter_a_shaft.pulseEnd();
			this._meter_b_shaft.pulseEnd();
			this._meter_c_shaft.pulseEnd();
			this._meter_d_shaft.pulseEnd();
			this._meter_x_shaft.pulseEnd();
		}
	}

	private function pulse():Boolean
	{
		var value:Number = this._meter_x_value.getMeter();

		if (value == 0)
			return true;

		return false;
	}

	public function discard():Void
	{
		this._character.SignalInvisibleBuffAdded.Disconnect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Disconnect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Disconnect(this.character_onTag, this);
		this._character.SignalBuffAdded.Disconnect(this.character_onTag, this);
		this._character.SignalBuffUpdated.Disconnect(this.character_onTag, this);
		SpellBase.SignalPassiveAdded.Disconnect(this.loadout_onPlant, this);
		SpellBase.SignalPassiveRemoved.Disconnect(this.loadout_onPluck, this);

		TweenMax.killTweensOf(this);

		this.discard_meter();

		super.discard();
	}

	private function discard_meter():Void
	{
		this.discard_meter_a();
		this.discard_meter_b();
		this.discard_meter_c();
		this.discard_meter_d();
		this.discard_meter_x();
	}

	private function discard_meter_a():Void
	{
		this.discard_meter_a_shaft();
		this.discard_meter_a_value();
		this.discard_meter_a_odd();
	}

	private function discard_meter_a_shaft():Void
	{
		if (this._meter_a_shaft == null)
			return;

		this._meter_a_shaft.discard();
		this._meter_a_shaft = null;
	}

	private function discard_meter_a_value():Void
	{
		if (this._meter_a_value == null)
			return;

		this._meter_a_value.discard();
		this._meter_a_value = null;
	}

	private function discard_meter_a_odd():Void
	{
		if (this._meter_a_odd == null)
			return;

		this._meter_a_odd.discard();
		this._meter_a_odd = null;
	}

	private function discard_meter_b():Void
	{
		this.discard_meter_b_shaft();
		this.discard_meter_b_value();
		this.discard_meter_b_odd();
	}

	private function discard_meter_b_shaft():Void
	{
		if (this._meter_b_shaft == null)
			return;

		this._meter_b_shaft.discard();
		this._meter_b_shaft = null;
	}

	private function discard_meter_b_value():Void
	{
		if (this._meter_b_value == null)
			return;

		this._meter_b_value.discard();
		this._meter_b_value = null;
	}

	private function discard_meter_b_odd():Void
	{
		if (this._meter_b_odd == null)
			return;

		this._meter_b_odd.discard();
		this._meter_b_odd = null;
	}

	private function discard_meter_c():Void
	{
		this.discard_meter_c_shaft();
		this.discard_meter_c_value();
		this.discard_meter_c_odd();
	}

	private function discard_meter_c_shaft():Void
	{
		if (this._meter_c_shaft == null)
			return;

		this._meter_c_shaft.discard();
		this._meter_c_shaft = null;
	}

	private function discard_meter_c_value():Void
	{
		if (this._meter_c_value == null)
			return;

		this._meter_c_value.discard();
		this._meter_c_value = null;
	}

	private function discard_meter_c_odd():Void
	{
		if (this._meter_c_odd == null)
			return;

		this._meter_c_odd.discard();
		this._meter_c_odd = null;
	}

	private function discard_meter_d():Void
	{
		this.discard_meter_d_shaft();
		this.discard_meter_d_value();
		this.discard_meter_d_odd();
	}

	private function discard_meter_d_shaft():Void
	{
		if (this._meter_d_shaft == null)
			return;

		this._meter_d_shaft.discard();
		this._meter_d_shaft = null;
	}

	private function discard_meter_d_value():Void
	{
		if (this._meter_d_value == null)
			return;

		this._meter_d_value.discard();
		this._meter_d_value = null;
	}

	private function discard_meter_d_odd():Void
	{
		if (this._meter_d_odd == null)
			return;

		this._meter_d_odd.discard();
		this._meter_d_odd = null;
	}

	private function discard_meter_x():Void
	{
		this.discard_meter_x_shaft();
		this.discard_meter_x_value();
		this.discard_meter_x_odd();
	}

	private function discard_meter_x_shaft():Void
	{
		if (this._meter_x_shaft == null)
			return;

		this._meter_x_shaft.discard();
		this._meter_x_shaft = null;
	}

	private function discard_meter_x_value():Void
	{
		if (this._meter_x_value == null)
			return;

		this._meter_x_value.discard();
		this._meter_x_value = null;
	}

	private function discard_meter_x_odd():Void
	{
		if (this._meter_x_odd == null)
			return;

		this._meter_x_odd.discard();
		this._meter_x_odd = null;
	}

	private function discard_notch_a():Void
	{
		if (this._notch_a == null)
			return;

		this._notch_a.discard();
		this._notch_a = null;
	}

	private function discard_notch_x():Void
	{
		if (this._notch_x == null)
			return;

		this._notch_x.discard();
		this._notch_x = null;
	}

	private function character_onTag(which:Number):Void
	{
		if (which == ShotgunGauge.TAG_SHELL)
			this.refresh_meter();
		else if (which == ShotgunGauge.TAG_DEPLETEDURANIUM)
			this.refresh_color();
		else if (which == ShotgunGauge.TAG_DRAGONSBREATH)
			this.refresh_color();
		else if (which == ShotgunGauge.TAG_ARMORPIERCING)
			this.refresh_color();
		else if (which == ShotgunGauge.TAG_ANIMAINFUSED)
			this.refresh_color();
		else if (which == ShotgunGauge.TAG_ENRICH)
			this.refresh_meter();
	}

	private function loadout_onPlant(which:Number, name:String, icon:String, item:Number, palette:Number):Void
	{
		this.refresh_maximum();
		this.refresh_color();
	}

	private function loadout_onPluck(which:Number):Void
	{
		this.refresh_maximum();
		this.refresh_color();
	}

	private function meter_onMeter(value:Number):Void
	{
		this.refresh_pulse();
	}
}
