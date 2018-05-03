import com.GameInterface.SpellBase;
import com.GameInterface.Game.BuffData;
import com.GameInterface.Game.Character;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import descendent.hud.reticle.Color;
import descendent.hud.reticle.DefaultArcBarMeter;
import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IMeter;

class descendent.hud.reticle.special.ElementalismGauge extends Gauge
{
	private static var TAG_HEAT:Number = 9258485;

	private static var TAG_OVERHEAT:Number = 9260877;

	private static var TAG_MAXWELLSDEMON:Number = 9261432;

	private static var ABILITY_MAXWELLSDEMON:Number = 9261431;

	private static var HEAT_MAX:Number = 100;

	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _equip:Number;

	private var _character:Character;

	private var _meter_a:IMeter;

	private var _meter_b:IMeter;

	public function ElementalismGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number,
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
		this.refresh_notch();
		this.refresh_pulse();

		this._character.SignalInvisibleBuffAdded.Connect(this.character_onTagBegin, this);
		this._character.SignalInvisibleBuffUpdated.Connect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Connect(this.character_onTagEnd, this);
		this._character.SignalBuffAdded.Connect(this.character_onTagBegin, this);
		SpellBase.SignalPassiveAdded.Connect(this.loadout_onPlant, this);
		SpellBase.SignalPassiveRemoved.Connect(this.loadout_onPluck, this);
	}

	private function prepare_meter():Void
	{
		this.prepare_meter_a();
		this.prepare_meter_b();
	}

	private function prepare_meter_a():Void
	{
		var notch:/*Number*/Array = [
			25, 50, 75,
			ElementalismGauge.HEAT_MAX - 21,
			ElementalismGauge.HEAT_MAX - 14,
			ElementalismGauge.HEAT_MAX - 6];

		this._meter_a = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0xF4802B, 33), new Color(0xF4802B, 100), new Color(0xFFFFFF, 100), ElementalismGauge.HEAT_MAX, false);
		this._meter_a.setNotch(notch);
		this._meter_a.prepare(this.content);
	}

	private function prepare_meter_b():Void
	{
		var notch:/*Number*/Array = [
			25, 50, 75,
			ElementalismGauge.HEAT_MAX - 21,
			ElementalismGauge.HEAT_MAX - 14,
			ElementalismGauge.HEAT_MAX - 6];

		this._meter_b = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x000000, 50), new Color(0xFFFFFF, 100), ElementalismGauge.HEAT_MAX, false);
		this._meter_b.setNotch(notch);
		this._meter_b.prepare(this.content);
	}

	private function refresh_meter():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[ElementalismGauge.TAG_HEAT];

		var value:Number = (tag != null)
			? tag.m_Count
			: 0;

		if (value == this._meter_a.getMeter())
			return;

		TweenMax.to(this._meter_a, 0.3, {
			setMeter: value,
			ease: Linear.easeNone
		});
	}

	private function refresh_notch():Void
	{
		if (SpellBase.IsPassiveEquipped(ElementalismGauge.ABILITY_MAXWELLSDEMON))
			this._meter_b.present();
		else
			this._meter_b.dismiss();
	}

	private function refresh_pulse():Void
	{
		if (this.pulse())
			this._meter_a.pulseBegin();
		else
			this._meter_a.pulseEnd();
	}

	private function pulse():Boolean
	{
		if (this._character.m_InvisibleBuffList[ElementalismGauge.TAG_OVERHEAT] != null)
			return true;

		return false;
	}

	public function discard():Void
	{
		this._character.SignalInvisibleBuffAdded.Disconnect(this.character_onTagBegin, this);
		this._character.SignalInvisibleBuffUpdated.Disconnect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Disconnect(this.character_onTagEnd, this);
		this._character.SignalBuffAdded.Disconnect(this.character_onTagBegin, this);
		SpellBase.SignalPassiveAdded.Disconnect(this.loadout_onPlant, this);
		SpellBase.SignalPassiveRemoved.Disconnect(this.loadout_onPluck, this);

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

	private function character_onTagBegin(which:Number):Void
	{
		if (which == ElementalismGauge.TAG_HEAT)
			this.refresh_meter();
		else if (which == ElementalismGauge.TAG_OVERHEAT)
			this.refresh_pulse();
		else if (which == ElementalismGauge.TAG_MAXWELLSDEMON)
			this._meter_b.setMeter(this._meter_a.getMeter());
	}

	private function character_onTag(which:Number):Void
	{
		if (which == ElementalismGauge.TAG_HEAT)
			this.refresh_meter();
		else if (which == ElementalismGauge.TAG_OVERHEAT)
			this.refresh_pulse();
	}

	private function character_onTagEnd(which:Number):Void
	{
		if (which == ElementalismGauge.TAG_HEAT)
			this.refresh_meter();
		else if (which == ElementalismGauge.TAG_OVERHEAT)
			this.refresh_pulse();
		else if (which == ElementalismGauge.TAG_MAXWELLSDEMON)
			this._meter_b.setMeter(0);
	}

	private function loadout_onPlant(which:Number, name:String, icon:String, item:Number, palette:Number):Void
	{
		this.refresh_notch();
	}

	private function loadout_onPluck(which:Number):Void
	{
		this.refresh_notch();
	}
}
