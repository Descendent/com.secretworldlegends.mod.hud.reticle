import com.GameInterface.SpellBase;
import com.GameInterface.Game.BuffData;
import com.GameInterface.Game.Character;
import com.GameInterface.Game.Shortcut;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import descendent.hud.reticle.Color;
import descendent.hud.reticle.DefaultArcBarMeter;
import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IGauge;
import descendent.hud.reticle.IMeter;

class descendent.hud.reticle.special.ChaosGauge extends Gauge
{
	private static var TAG_PARADOX:Number = 9267821;

	private static var ABILITY_DUALITY:Number = 9269294;

	private static var ABILITY_TUMULTUOUSWHISPER:Number = 7094285;

	private static var PARADOX_MAX:Number = 8;

	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _equip:Number;

	private var _character:Character;

	private var _meter:IMeter;

	private var _suspend:Boolean;

	public function ChaosGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number,
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
		this.refresh_pulse();

		this._character.SignalInvisibleBuffAdded.Connect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Connect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Connect(this.character_onTag, this);
		Shortcut.SignalShortcutAdded.Connect(this.loadout_onPlant, this);
		Shortcut.SignalShortcutRemoved.Connect(this.loadout_onPluck, this);
		SpellBase.SignalPassiveAdded.Connect(this.loadout_onPlant, this);
		SpellBase.SignalPassiveRemoved.Connect(this.loadout_onPluck, this);
	}

	private function prepare_meter():Void
	{
		this._meter = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0xCD91ED, 25), new Color(0xCD91ED, 100), new Color(0xFFFFFF, 100), ChaosGauge.PARADOX_MAX, false);
		this._meter.prepare(this.content);
	}

	private function refresh_meter():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[ChaosGauge.TAG_PARADOX];

		var value:Number = (tag != null)
			? tag.m_Count
			: 0;

		if (value == this._meter.getMeter())
			return;

		if (value == ChaosGauge.PARADOX_MAX)
			this.suspend();

		TweenMax.to(this._meter, 0.3, {
			setMeter: value,
			ease: Linear.easeNone,
			onComplete: this.meter_onMeter,
			onCompleteParams: [value],
			onCompleteScope: this
		});
	}

	private function refresh_pulse():Void
	{
		if (this.pulse())
			this._meter.pulseBegin();
		else
			this._meter.pulseEnd();
	}

	private function pulse():Boolean
	{
		if (this.pulse_duality())
			return true;

		return false;
	}

	private function pulse_duality():Boolean
	{
		if (!SpellBase.IsPassiveEquipped(ChaosGauge.ABILITY_DUALITY))
			return false;

		if (!Shortcut.IsSpellEquipped(ChaosGauge.ABILITY_TUMULTUOUSWHISPER))
			return false;

		var value:Number = this._meter.getMeter();

		if (value >= ChaosGauge.PARADOX_MAX)
			return false;

		if (value <= ChaosGauge.PARADOX_MAX - 3)
			return false;

		return true;
	}

	public function discard():Void
	{
		this._character.SignalInvisibleBuffAdded.Disconnect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Disconnect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Disconnect(this.character_onTag, this);
		Shortcut.SignalShortcutAdded.Disconnect(this.loadout_onPlant, this);
		Shortcut.SignalShortcutRemoved.Disconnect(this.loadout_onPluck, this);
		SpellBase.SignalPassiveAdded.Disconnect(this.loadout_onPlant, this);
		SpellBase.SignalPassiveRemoved.Disconnect(this.loadout_onPluck, this);

		TweenMax.killTweensOf(this.restore);

		this.discard_meter();

		super.discard();
	}

	private function discard_meter():Void
	{
		if (this._meter == null)
			return;

		TweenMax.killTweensOf(this._meter);

		this._meter.discard();
		this._meter = null;
	}

	private function suspend():Void
	{
		if (this._suspend)
			return;

		this._suspend = true;

		TweenMax.delayedCall(0.8, this.restore, null, this, false);
	}

	private function restore():Void
	{
		if (!this._suspend)
			return;

		this._suspend = false;

		this.refresh_meter();
	}

	private function character_onTag(which:Number):Void
	{
		if (which != ChaosGauge.TAG_PARADOX)
			return;

		if (this._suspend)
			return;

		this.refresh_meter();
	}

	private function loadout_onPlant(which:Number, name:String, icon:String, item:Number, palette:Number):Void
	{
		this.refresh_pulse();
	}

	private function loadout_onPluck(which:Number):Void
	{
		this.refresh_pulse();
	}

	private function meter_onMeter(value:Number):Void
	{
		this.refresh_pulse();
	}
}
