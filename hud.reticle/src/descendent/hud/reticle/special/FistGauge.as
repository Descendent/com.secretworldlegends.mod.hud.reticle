import com.GameInterface.Inventory;
import com.GameInterface.InventoryItem;
import com.GameInterface.Game.BuffData;
import com.GameInterface.Game.Character;
import com.Utils.ID32;

import caurina.transitions.Tweener;

import descendent.hud.reticle.Color;
import descendent.hud.reticle.DefaultArcBarMeter;
import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IMeter;

class descendent.hud.reticle.special.FistGauge extends Gauge
{
	private static var TAG_FURY:Number = 9267149;

	private static var TAG_FRENZIEDWRATH:Number = 9267174;

	private static var TAG_INVIGORATINGWRATH:Number = 9267176;

	private static var THING_INVIGORATINGRAZORS:Number = 7378802;

	private static var FURY_MAX:Number = 100;

	private static var FURY_CONSUME:Number = 20;

	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _equip:Number;

	private var _character:Character;

	private var _inventory:Inventory;

	private var _meter:IMeter;

	private var _consume:Number;

	public function FistGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number,
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
		this._inventory = new Inventory(new ID32(_global.Enums.InvType.e_Type_GC_WeaponContainer, this._character.GetID().GetInstance()));

		this.prepare_meter();

		this.refresh_meter();
		this.refresh_pulse();
		this.refresh_consume();

		this._character.SignalInvisibleBuffAdded.Connect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Connect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Connect(this.character_onTag, this);
		this._inventory.SignalItemLoaded.Connect(this.inventory_onPlant, this);
		this._inventory.SignalItemAdded.Connect(this.inventory_onPlant, this);
		this._inventory.SignalItemChanged.Connect(this.inventory_onTransform, this);
		this._inventory.SignalItemRemoved.Connect(this.inventory_onPluck, this);
	}

	private function prepare_meter():Void
	{
		var notch:/*Number*/Array = [60];

		this._meter = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0xEC474B, 33), new Color(0xEC474B, 100), new Color(0xFFFFFF, 100), FistGauge.FURY_MAX, false);
		this._meter.setNotch(notch);
		this._meter.prepare(this.content);
	}

	private function refresh_meter():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[FistGauge.TAG_FURY];

		var value:Number = (tag != null)
			? tag.m_Count
			: 0;

		if (value == this._meter.getMeter())
			return;

		if (this.wrath())
			this.refresh_meter_decrease(value);
		else
			this.refresh_meter_increase(value);
	}

	private function refresh_meter_decrease(value:Number):Void
	{
		this._meter.setMeter(value);
		Tweener.addTween(this._meter, {
			setMeter: 0,
			time: value / this._consume,
			transition: "linear"
		});
	}

	private function refresh_meter_increase(value:Number):Void
	{
		Tweener.addTween(this._meter, {
			setMeter: value,
			time: 0.3,
			transition: "linear",
			onComplete: this.meter_onMeter,
			onCompleteParams: [value],
			onCompleteScope: this
		});
	}

	private function refresh_consume():Void
	{
		this._consume = (this.equip_invigoratingRazors())
			? FistGauge.FURY_CONSUME / 1.1
			: FistGauge.FURY_CONSUME;
	}

	private function equip_invigoratingRazors():Boolean
	{
		var thing:InventoryItem = this._inventory.GetItemAt(this._equip);

		if (thing == null)
			return false;

		if (thing.m_Icon.GetInstance() != FistGauge.THING_INVIGORATINGRAZORS)
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
		if (this.wrath())
			return false;

		var value:Number = this._meter.getMeter();

		if (value >= 60)
			return true;

		return false;
	}

	private function wrath():Boolean
	{
		if (this._character.m_InvisibleBuffList[FistGauge.TAG_FRENZIEDWRATH] != null)
			return true;

		if (this._character.m_InvisibleBuffList[FistGauge.TAG_INVIGORATINGWRATH] != null)
			return true;

		return false;
	}

	public function discard():Void
	{
		this._character.SignalInvisibleBuffAdded.Disconnect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Disconnect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Disconnect(this.character_onTag, this);
		this._inventory.SignalItemLoaded.Disconnect(this.inventory_onPlant, this);
		this._inventory.SignalItemAdded.Disconnect(this.inventory_onPlant, this);
		this._inventory.SignalItemChanged.Disconnect(this.inventory_onTransform, this);
		this._inventory.SignalItemRemoved.Disconnect(this.inventory_onPluck, this);

		this.discard_meter();

		super.discard();
	}

	private function discard_meter():Void
	{
		if (this._meter == null)
			return;

		Tweener.removeTweens(this._meter);

		this._meter.discard();
		this._meter = null;
	}

	private function character_onTag(which:Number):Void
	{
		if (which == FistGauge.TAG_FURY)
		{
			this.refresh_meter();
		}
		else if (which == FistGauge.TAG_FRENZIEDWRATH)
		{
			this.refresh_meter();
			this.refresh_pulse();
		}
		else if (which == FistGauge.TAG_INVIGORATINGWRATH)
		{
			this.refresh_meter();
			this.refresh_pulse();
		}
	}

	private function inventory_onPlant(inventory:ID32, which:Number):Void
	{
		if (which != this._equip)
			return;

		this.refresh_consume();
	}

	private function inventory_onTransform(inventory:ID32, which:Number):Void
	{
		if (which != this._equip)
			return;

		this.refresh_consume();
	}

	private function inventory_onPluck(inventory:ID32, which:Number, replant:Boolean):Void
	{
		if (which != this._equip)
			return;

		this.refresh_consume();
	}

	private function meter_onMeter(value:Number):Void
	{
		this.refresh_pulse();
	}
}
