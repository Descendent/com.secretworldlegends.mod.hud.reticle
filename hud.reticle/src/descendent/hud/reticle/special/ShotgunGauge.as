import com.GameInterface.SpellBase;
import com.GameInterface.Game.BuffData;
import com.GameInterface.Game.Character;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import descendent.hud.reticle.Color;
import descendent.hud.reticle.DefaultArcBarMeter;
import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IGauge;
import descendent.hud.reticle.IMeter;

class descendent.hud.reticle.special.ShotgunGauge extends Gauge
{
	private static var TAG_SHELL:Number = 9253306;

	private static var TAG_DEPLETEDURANIUM:Number = 9253310;

	private static var TAG_DRAGONSBREATH:Number = 9253311;

	private static var TAG_ARMORPIERCING:Number = 9253312;

	private static var TAG_ANIMAINFUSED:Number = 9253313;

//	private static var ABILITY_ODDSANDEVENS:Number = 9255598;

	private static var ABILITY_ENRICH:Number = 9255616;

	private static var SHELL_MAX:Number = 6;

	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _equip:Number;

	private var _character:Character;

	private var _meter_a:IMeter;

	private var _meter_b:IMeter;

	private var _meter_c:IMeter;

	private var _meter_d:IMeter;

	private var _meter_x:IMeter;

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

		this.refresh_meter();
		this.refresh_color();
		this.refresh_pulse();

		this._character.SignalInvisibleBuffAdded.Connect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Connect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Connect(this.character_onTag, this);
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
		var notch:/*Number*/Array = [2, 4, 6];

		this._meter_a = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x9B52CE, 25), new Color(0x9B52CE, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_a.setNotch(notch);
		this._meter_a.prepare(this.content);

		this.refresh_maximum();
	}

	private function prepare_meter_b():Void
	{
		var notch:/*Number*/Array = [2, 4];

		this._meter_b = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0xFD853D, 25), new Color(0xFD853D, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_b.setNotch(notch);
		this._meter_b.prepare(this.content);
	}

	private function prepare_meter_c():Void
	{
		var notch:/*Number*/Array = [2, 4];

		this._meter_c = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x009CC9, 25), new Color(0x009CC9, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_c.setNotch(notch);
		this._meter_c.prepare(this.content);
	}

	private function prepare_meter_d():Void
	{
		var notch:/*Number*/Array = [2, 4];

		this._meter_d = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x0CB700, 25), new Color(0x0CB700, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_d.setNotch(notch);
		this._meter_d.prepare(this.content);
	}

	private function prepare_meter_x():Void
	{
		var notch:/*Number*/Array = [2, 4];

		this._meter_x = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0xD7D7D7, 25), new Color(0xD7D7D7, 100), new Color(0xFFFFFF, 100), ShotgunGauge.SHELL_MAX, false);
		this._meter_x.setNotch(notch);
		this._meter_x.prepare(this.content);
	}

	private function refresh_meter():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[ShotgunGauge.TAG_SHELL];

		var value:Number = (tag != null)
			? tag.m_Count
			: 0;

		if (value == this._meter_a.getMeter())
			return;

		TweenMax.to(this, 0.3, {
			setMeter: value,
			ease: Linear.easeNone,
			onComplete: this.meter_onMeter,
			onCompleteParams: [value],
			onCompleteScope: this
		});
	}

	private function getMeter():Number
	{
		return this._meter_a.getMeter();
	}

	private function setMeter(value:Number):Void
	{
		this._meter_a.setMeter(value);
		this._meter_b.setMeter(value);
		this._meter_c.setMeter(value);
		this._meter_d.setMeter(value);
		this._meter_x.setMeter(value);
	}

	private function refresh_color():Void
	{
		this._meter_a.dismiss();
		this._meter_b.dismiss();
		this._meter_c.dismiss();
		this._meter_d.dismiss();
		this._meter_x.dismiss();

		if (this._character.m_InvisibleBuffList[ShotgunGauge.TAG_DEPLETEDURANIUM] != null)
			this._meter_a.present();
		else if (this._character.m_InvisibleBuffList[ShotgunGauge.TAG_DRAGONSBREATH] != null)
			this._meter_b.present();
		else if (this._character.m_InvisibleBuffList[ShotgunGauge.TAG_ARMORPIERCING] != null)
			this._meter_c.present();
		else if (this._character.m_InvisibleBuffList[ShotgunGauge.TAG_ANIMAINFUSED] != null)
			this._meter_d.present();
		else
			this._meter_x.present();
	}

	private function refresh_maximum():Void
	{
		if (this._meter_a == null)
			return;

		this._meter_a.setMaximum(SpellBase.IsPassiveEquipped(ShotgunGauge.ABILITY_ENRICH)
			? ShotgunGauge.SHELL_MAX + 2
			: ShotgunGauge.SHELL_MAX);
	}

	private function refresh_pulse():Void
	{
		if (this.pulse())
		{
			this._meter_a.pulseBegin();
			this._meter_b.pulseBegin();
			this._meter_c.pulseBegin();
			this._meter_d.pulseBegin();
			this._meter_x.pulseBegin();
		}
		else
		{
			this._meter_a.pulseEnd();
			this._meter_b.pulseEnd();
			this._meter_c.pulseEnd();
			this._meter_d.pulseEnd();
			this._meter_x.pulseEnd();
		}
	}

	private function pulse():Boolean
	{
		var value:Number = this._meter_a.getMeter();

		if (value == 0)
			return true;

		return false;
	}

//	private function pulse_oddsAndEvens():Boolean
//	{
//		if (!SpellBase.IsPassiveEquipped(ShotgunGauge.ABILITY_ODDSANDEVENS))
//			return false;
//
//		var value:Number = this._meter_a.getMeter();
//
//		if (value % 2 != 0)
//			return false;
//
//		return true;
//	}

	public function discard():Void
	{
		this._character.SignalInvisibleBuffAdded.Disconnect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Disconnect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Disconnect(this.character_onTag, this);
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

	private function discard_meter_c():Void
	{
		if (this._meter_c == null)
			return;

		this._meter_c.discard();
		this._meter_c = null;
	}

	private function discard_meter_d():Void
	{
		if (this._meter_d == null)
			return;

		this._meter_d.discard();
		this._meter_d = null;
	}

	private function discard_meter_x():Void
	{
		if (this._meter_x == null)
			return;

		this._meter_x.discard();
		this._meter_x = null;
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
	}

	private function loadout_onPlant(which:Number, name:String, icon:String, item:Number, palette:Number):Void
	{
		this.refresh_maximum();
	}

	private function loadout_onPluck(which:Number):Void
	{
		this.refresh_maximum();
	}

	private function meter_onMeter(value:Number):Void
	{
		this.refresh_pulse();
	}
}
