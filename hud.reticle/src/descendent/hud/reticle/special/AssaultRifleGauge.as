import mx.utils.Delegate;

import com.GameInterface.Inventory;
import com.GameInterface.InventoryItem;
import com.GameInterface.SpellBase;
import com.GameInterface.UtilsBase;
import com.GameInterface.Game.BuffData;
import com.GameInterface.Game.Character;
import com.Utils.ID32;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import descendent.hud.reticle.Color;
import descendent.hud.reticle.DefaultArcBarMeter;
import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IMeter;

class descendent.hud.reticle.special.AssaultRifleGauge extends Gauge
{
	private static var TAG_FUSE:Number = 9255809;

	private static var TAG_COOKED:Number = 9255818;

	private static var ABILITY_EXPLOSIVESEXPERT:Number = 9257773;

	private static var THING_KSR43:Number = 7523968;

	private static var FUSE_MAX:Number = 6000;

	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _equip:Number;

	private var _character:Character;

	private var _inventory:Inventory;

	private var _meter:IMeter;

	private var _timer:Number;

	private var _refresh_meter:Function;

	public function AssaultRifleGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number,
		equip:Number)
	{
		super();

		this._r = r;
		this._angle_a = angle_a;
		this._angle_b = angle_b;
		this._thickness = thickness;
		this._equip = equip;

		this._refresh_meter = Delegate.create(this, this.refresh_meter);
	}

	public function prepare(o:MovieClip):Void
	{
		super.prepare(o);

		this._character = Character.GetClientCharacter();
		this._inventory = new Inventory(new ID32(_global.Enums.InvType.e_Type_GC_WeaponContainer, this._character.GetID().GetInstance()));

		this.prepare_meter();

		this.refresh_meter();
		this.refresh_timer();
		this.refresh_pulse();

		this._character.SignalInvisibleBuffAdded.Connect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Connect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Connect(this.character_onTag, this);
		SpellBase.SignalPassiveAdded.Connect(this.loadout_onPlant, this);
		SpellBase.SignalPassiveRemoved.Connect(this.loadout_onPluck, this);
		this._inventory.SignalItemLoaded.Connect(this.inventory_onPlant, this);
		this._inventory.SignalItemAdded.Connect(this.inventory_onPlant, this);
		this._inventory.SignalItemChanged.Connect(this.inventory_onTransform, this);
		this._inventory.SignalItemRemoved.Connect(this.inventory_onPluck, this);
	}

	private function prepare_meter():Void
	{
		this._meter = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x10B9D6, 33), new Color(0x10B9D6, 100), new Color(0xFFFFFF, 100), AssaultRifleGauge.FUSE_MAX, false);
		this._meter.prepare(this.content);

		this.refresh_maximum();
	}

	private function refresh_timer():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[AssaultRifleGauge.TAG_FUSE];

		if (tag != null)
			this.timerBegin();
		else
			this.timerEnd();
	}

	private function timerBegin():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[AssaultRifleGauge.TAG_FUSE];

		var value:Number = (tag != null)
			? tag.m_TotalTime - (UtilsBase.GetNormalTime() * 1000)
			: 0;

		TweenMax.fromTo(this._meter, 0.3, {
			setMeter: 0
		}, {
			setMeter: value - 300,
			ease: Linear.easeNone,
			onComplete: this.timerBegin_process,
			onCompleteParams: null,
			onCompleteScope: this
		});
	}

	private function timerBegin_process():Void
	{
		clearInterval(this._timer);
		this._timer = setInterval(this._refresh_meter, 100);

		this.refresh_meter();
	}

	private function timerEnd():Void
	{
		clearInterval(this._timer);
		this._timer = null;

		this.refresh_meter();
	}

	private function refresh_meter():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[AssaultRifleGauge.TAG_FUSE];

		var value:Number = (tag != null)
			? tag.m_TotalTime - (UtilsBase.GetNormalTime() * 1000)
			: 0;

		if (value == this._meter.getMeter())
			return;

		TweenMax.fromTo(this._meter, value / 1000, {
			setMeter: value
		}, {
			setMeter: 0,
			ease: Linear.easeNone
		});
	}

	private function refresh_maximum():Void
	{
		var explosivesExpert:Boolean = SpellBase.IsPassiveEquipped(AssaultRifleGauge.ABILITY_EXPLOSIVESEXPERT);
		var ksr43:Boolean = this.equip_ksr43();

		var maximum:Number = AssaultRifleGauge.FUSE_MAX;
		if (ksr43)
			maximum -= 3000;
		if (explosivesExpert)
			maximum += 3000;

		var notch:/*Number*/Array;
		if (ksr43)
			notch = null;
		else
			notch = [maximum - 3000];

		this._meter.setNotch(null);
		this._meter.setMaximum(maximum);
		this._meter.setNotch(notch);
	}

	private function equip_ksr43():Boolean
	{
		var thing:InventoryItem = this._inventory.GetItemAt(this._equip);

		if (thing == null)
			return false;

		if (thing.m_Icon.GetInstance() != AssaultRifleGauge.THING_KSR43)
			return false;

		return true;
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
		if (this._character.m_InvisibleBuffList[AssaultRifleGauge.TAG_COOKED] != null)
			return true;

		return false;
	}

	public function discard():Void
	{
		this._character.SignalInvisibleBuffAdded.Disconnect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Disconnect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Disconnect(this.character_onTag, this);
		SpellBase.SignalPassiveAdded.Disconnect(this.loadout_onPlant, this);
		SpellBase.SignalPassiveRemoved.Disconnect(this.loadout_onPluck, this);
		this._inventory.SignalItemLoaded.Disconnect(this.inventory_onPlant, this);
		this._inventory.SignalItemAdded.Disconnect(this.inventory_onPlant, this);
		this._inventory.SignalItemChanged.Disconnect(this.inventory_onTransform, this);
		this._inventory.SignalItemRemoved.Disconnect(this.inventory_onPluck, this);

		clearInterval(this._timer);

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

	private function character_onTag(which:Number):Void
	{
		if (which == AssaultRifleGauge.TAG_FUSE)
			this.refresh_timer();
		else if (which == AssaultRifleGauge.TAG_COOKED)
			this.refresh_pulse();
	}

	private function loadout_onPlant(which:Number, name:String, icon:String, item:Number, palette:Number):Void
	{
		this.refresh_maximum();
	}

	private function loadout_onPluck(which:Number):Void
	{
		this.refresh_maximum();
	}

	private function inventory_onPlant(inventory:ID32, which:Number):Void
	{
		if (which != this._equip)
			return;

		this.refresh_maximum();
	}

	private function inventory_onTransform(inventory:ID32, which:Number):Void
	{
		if (which != this._equip)
			return;

		this.refresh_maximum();
	}

	private function inventory_onPluck(inventory:ID32, which:Number, replant:Boolean):Void
	{
		if (which != this._equip)
			return;

		this.refresh_maximum();
	}
}
