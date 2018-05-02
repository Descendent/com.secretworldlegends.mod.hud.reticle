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

class descendent.hud.reticle.special.DualPistolsGauge extends Gauge
{
	private static var TAG_CHAMBER_1:Number = 9262328;

	private static var TAG_CHAMBER_2:Number = 9262330;

	private static var TAG_MATCH:Number = 9266708;

//	private static var TAG_FULLHOUSE:Number = 9265024;

	private static var TAG_FULLHOUSE_STACKEDDECK:Number = 9267064;

//	private static var ABILITY_STACKEDDECK:Number = 9265315;

//	private static var ABILITY_FULLHOUSE:Number = 9265025;

	private static var THING_SIXSHOOTERS:Number = 6813528;

	private static var MATCH_MAX:Number = 3000;

	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _equip:Number;

	private var _character:Character;

	private var _inventory:Inventory;

	private var _meter_1_a:IMeter;

	private var _meter_1_b:IMeter;

	private var _meter_1_c:IMeter;

	private var _meter_2_a:IMeter;

	private var _meter_2_b:IMeter;

	private var _meter_2_c:IMeter;

	private var _meter_x_a:IMeter;

	private var _meter_x_b:IMeter;

	private var _meter_x_b_conditional:IMeter;

	private var _meter_x_c:IMeter;

	private var _timer:Number;

	private var _refresh_meter:Function;

	public function DualPistolsGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number,
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
		this.refresh_color();
		this.refresh_timer();
		this.refresh_pulse();

		this._character.SignalInvisibleBuffAdded.Connect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Connect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Connect(this.character_onTag, this);
		this._character.SignalBuffAdded.Connect(this.character_onTag, this);
		this._inventory.SignalItemLoaded.Connect(this.inventory_onPlant, this);
		this._inventory.SignalItemAdded.Connect(this.inventory_onPlant, this);
		this._inventory.SignalItemChanged.Connect(this.inventory_onTransform, this);
		this._inventory.SignalItemRemoved.Connect(this.inventory_onPluck, this);
	}

	private function prepare_meter():Void
	{
		this.prepare_meter_1();
		this.prepare_meter_2();
		this.prepare_meter_x();
	}

	private function prepare_meter_1():Void
	{
		this.prepare_meter_1_a();
		this.prepare_meter_1_b();
		this.prepare_meter_1_c();
	}

	private function prepare_meter_1_a():Void
	{
		var thickness:Number = this._thickness / 2.0;
		var r:Number = (this._equip == _global.Enums.ItemEquipLocation.e_Wear_First_WeaponSlot)
			? this._r + thickness
			: this._r;

		this._meter_1_a = new DefaultArcBarMeter(r, this._angle_a, this._angle_b, thickness,
//			new Color(0xA3A3A3, 25), new Color(0xA3A3A3, 100), new Color(0xFFFFFF, 100), 1.0, false);
			new Color(0xD7D7D7, 25), new Color(0xD7D7D7, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_1_a.prepare(this.content);
	}

	private function prepare_meter_1_b():Void
	{
		var thickness:Number = this._thickness / 2.0;
		var r:Number = (this._equip == _global.Enums.ItemEquipLocation.e_Wear_First_WeaponSlot)
			? this._r + thickness
			: this._r;

		this._meter_1_b = new DefaultArcBarMeter(r, this._angle_a, this._angle_b, thickness,
			new Color(0x4895FF, 25), new Color(0x4895FF, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			new Color(0x1EA1FF, 25), new Color(0x1EA1FF, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_1_b.prepare(this.content);
	}

	private function prepare_meter_1_c():Void
	{
		var thickness:Number = this._thickness / 2.0;
		var r:Number = (this._equip == _global.Enums.ItemEquipLocation.e_Wear_First_WeaponSlot)
			? this._r + thickness
			: this._r;

		this._meter_1_c = new DefaultArcBarMeter(r, this._angle_a, this._angle_b, thickness,
			new Color(0xFF2E2E, 25), new Color(0xFF2E2E, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			new Color(0xFF3C3C, 25), new Color(0xFF3C3C, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_1_c.prepare(this.content);
	}

	private function prepare_meter_2():Void
	{
		this.prepare_meter_2_a();
		this.prepare_meter_2_b();
		this.prepare_meter_2_c();
	}

	private function prepare_meter_2_a():Void
	{
		var thickness:Number = this._thickness / 2.0;
		var r:Number = (this._equip == _global.Enums.ItemEquipLocation.e_Wear_Second_WeaponSlot)
			? this._r + thickness
			: this._r;

		this._meter_2_a = new DefaultArcBarMeter(r, this._angle_a, this._angle_b, thickness,
//			new Color(0xA3A3A3, 25), new Color(0xA3A3A3, 100), new Color(0xFFFFFF, 100), 1.0, false);
			new Color(0xD7D7D7, 25), new Color(0xD7D7D7, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_2_a.prepare(this.content);
	}

	private function prepare_meter_2_b():Void
	{
		var thickness:Number = this._thickness / 2.0;
		var r:Number = (this._equip == _global.Enums.ItemEquipLocation.e_Wear_Second_WeaponSlot)
			? this._r + thickness
			: this._r;

		this._meter_2_b = new DefaultArcBarMeter(r, this._angle_a, this._angle_b, thickness,
			new Color(0x4895FF, 25), new Color(0x4895FF, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			new Color(0x1EA1FF, 25), new Color(0x1EA1FF, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_2_b.prepare(this.content);
	}

	private function prepare_meter_2_c():Void
	{
		var thickness:Number = this._thickness / 2.0;
		var r:Number = (this._equip == _global.Enums.ItemEquipLocation.e_Wear_Second_WeaponSlot)
			? this._r + thickness
			: this._r;

		this._meter_2_c = new DefaultArcBarMeter(r, this._angle_a, this._angle_b, thickness,
			new Color(0xFF2E2E, 25), new Color(0xFF2E2E, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			new Color(0xFF3C3C, 25), new Color(0xFF3C3C, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_2_c.prepare(this.content);
	}

	private function prepare_meter_x():Void
	{
		this.prepare_meter_x_a();
		this.prepare_meter_x_b();
		this.prepare_meter_x_b_conditional();
		this.prepare_meter_x_c();

		this.dismiss_meter_x();
		this.refresh_maximum();
	}

	private function prepare_meter_x_a():Void
	{
		var notch:/*Number*/Array = [1000, 2500];

		this._meter_x_a = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
//			new Color(0xA3A3A3, 25), new Color(0xA3A3A3, 100), new Color(0xFFFFFF, 100), DualPistolsGauge.MATCH_MAX, false);
			new Color(0xD7D7D7, 25), new Color(0xD7D7D7, 100), new Color(0xFFFFFF, 100), DualPistolsGauge.MATCH_MAX, false);
		this._meter_x_a.setNotch(notch);
		this._meter_x_a.prepare(this.content);
	}

	private function prepare_meter_x_b():Void
	{
		var notch:/*Number*/Array = [1000, 2500];

		this._meter_x_b = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x4895FF, 25), new Color(0x4895FF, 100), new Color(0xFFFFFF, 100), DualPistolsGauge.MATCH_MAX, false);
//			new Color(0x1EA1FF, 25), new Color(0x1EA1FF, 100), new Color(0xFFFFFF, 100), DualPistolsGauge.MATCH_MAX, false);
		this._meter_x_b.setNotch(notch);
		this._meter_x_b.prepare(this.content);
	}

	private function prepare_meter_x_b_conditional():Void
	{
		var notch:/*Number*/Array = [1000, 2500];

		this._meter_x_b_conditional = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x4895FF, 25), new Color(0x4895FF, 100), new Color(0xFFFFFF, 100), DualPistolsGauge.MATCH_MAX + 2000, false);
//			new Color(0x1EA1FF, 25), new Color(0x1EA1FF, 100), new Color(0xFFFFFF, 100), DualPistolsGauge.MATCH_MAX + 2000, false);
		this._meter_x_b_conditional.setNotch(notch);
		this._meter_x_b_conditional.prepare(this.content);
	}

	private function prepare_meter_x_c():Void
	{
		var notch:/*Number*/Array = [1000, 2500];

		this._meter_x_c = new DefaultArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0xFF2E2E, 25), new Color(0xFF2E2E, 100), new Color(0xFFFFFF, 100), DualPistolsGauge.MATCH_MAX, false);
//			new Color(0xFF3C3C, 25), new Color(0xFF3C3C, 100), new Color(0xFFFFFF, 100), DualPistolsGauge.MATCH_MAX, false);
		this._meter_x_c.setNotch(notch);
		this._meter_x_c.prepare(this.content);
	}

	private function refresh_timer():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[DualPistolsGauge.TAG_MATCH];

		if (tag != null)
			this.timerBegin();
		else
			this.timerEnd();
	}

	private function timerBegin():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[DualPistolsGauge.TAG_MATCH];

		var value:Number = (tag != null)
			? tag.m_TotalTime - (UtilsBase.GetNormalTime() * 1000)
			: 0;

		this.dismiss_meter_1();
		this.dismiss_meter_2();
		this.dismiss_meter_x();

		var meter:IMeter = this.meter_x();

		meter.present();

		TweenMax.fromTo(meter, 0.3, {
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
		this.refresh_color(true);
	}

	private function refresh_meter():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[DualPistolsGauge.TAG_MATCH];

		var value:Number = (tag != null)
			? tag.m_TotalTime - (UtilsBase.GetNormalTime() * 1000)
			: 0;

		var meter:IMeter = this.meter_x();

		if (value == meter.getMeter())
			return;

		TweenMax.fromTo(meter, value / 1000, {
			setMeter: value
		}, {
			setMeter: 0,
			ease: Linear.easeNone
		});
	}

	private function meter_x():IMeter
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[DualPistolsGauge.TAG_CHAMBER_1];

		var value:Number = (tag != null)
			? tag.m_Count
			: 0;

		var meter:IMeter;
		if (value >= 6)
		{
			meter = this._meter_x_c;
		}
		else if (value >= 4)
		{
			meter = (this.tag_fullHouse_stackedDeck())
				? this._meter_x_b_conditional
				: this._meter_x_b;
		}
		else
		{
			meter = this._meter_x_a;
		}

		return meter;
	}

	private function tag_fullHouse_stackedDeck():Boolean
	{
//		if (!SpellBase.IsPassiveEquipped(DualPistolsGauge.ABILITY_STACKEDDECK))
//			return false;

		if (this._character.m_BuffList[DualPistolsGauge.TAG_FULLHOUSE_STACKEDDECK] == null)
			return false;

		return true;
	}

	private function refresh_color(still:Boolean):Void
	{
		this.refresh_color_1(still);
		this.refresh_color_2(still);
	}

	private function refresh_color_1(still:Boolean):Void
	{
		if (this._character.m_InvisibleBuffList[DualPistolsGauge.TAG_MATCH] != null)
			return;

		var tag:BuffData = this._character.m_InvisibleBuffList[DualPistolsGauge.TAG_CHAMBER_1];

		var value:Number = (tag != null)
			? tag.m_Count
			: 0;

		this.dismiss_meter_x();
		this.dismiss_meter_1();

		var meter:IMeter;
		if (value >= 6)
			meter = this._meter_1_c;
		else if (value >= 4)
			meter = this._meter_1_b;
		else
			meter = this._meter_1_a;

		meter.present();

		if (still)
			this.refresh_color_1_still(meter);
		else
			this.refresh_color_1_tween(meter);
	}

	private function refresh_color_1_still(meter:IMeter):Void
	{
		meter.setMeter(0.0);
	}

	private function refresh_color_1_tween(meter:IMeter):Void
	{
		TweenMax.fromTo(meter, 0.3, {
			setMeter: 0.0
		}, {
			setMeter: 1.0,
			ease: Linear.easeNone
		});
	}

	private function refresh_color_2(still:Boolean):Void
	{
		if (this._character.m_InvisibleBuffList[DualPistolsGauge.TAG_MATCH] != null)
			return;

		var tag:BuffData = this._character.m_InvisibleBuffList[DualPistolsGauge.TAG_CHAMBER_2];

		var value:Number = (tag != null)
			? tag.m_Count
			: 0;

		this.dismiss_meter_x();
		this.dismiss_meter_2();

		var meter:IMeter;
		if (value >= 6)
			meter = this._meter_2_c;
		else if (value >= 4)
			meter = this._meter_2_b;
		else
			meter = this._meter_2_a;

		meter.present();

		if (still)
			this.refresh_color_2_still(meter);
		else
			this.refresh_color_2_tween(meter);
	}

	private function refresh_color_2_still(meter:IMeter):Void
	{
		meter.setMeter(0.0);
	}

	private function refresh_color_2_tween(meter:IMeter):Void
	{
		TweenMax.fromTo(meter, 0.3, {
			setMeter: 0.0
		}, {
			setMeter: 1.0,
			ease: Linear.easeNone
		});

		// Support for Six Line used during match
		TweenMax.to([this._meter_1_a, this._meter_1_b, this._meter_1_c], 0.3, {
			setMeter: 1.0,
			ease: Linear.easeNone,
			overwrite: "none"
		});
	}

	private function refresh_maximum():Void
	{
		var maximum:Number = (this.equip_sixShooters())
			? DualPistolsGauge.MATCH_MAX + 500
			: DualPistolsGauge.MATCH_MAX;

		this._meter_x_a.setMaximum(maximum);
		this._meter_x_b.setMaximum(maximum);
		this._meter_x_b_conditional.setMaximum(maximum + 2000);
		this._meter_x_c.setMaximum(maximum);
	}

	private function equip_sixShooters():Boolean
	{
		var thing:InventoryItem = this._inventory.GetItemAt(this._equip);

		if (thing == null)
			return false;

		if (thing.m_Icon.GetInstance() != DualPistolsGauge.THING_SIXSHOOTERS)
			return false;

		return true;
	}

	private function refresh_pulse():Void
	{
		if (this.pulse())
		{
			this._meter_x_a.pulseBegin();
			this._meter_x_b.pulseBegin();
			this._meter_x_b_conditional.pulseBegin();
			this._meter_x_c.pulseBegin();
		}
		else
		{
			this._meter_x_a.pulseEnd();
			this._meter_x_b.pulseEnd();
			this._meter_x_b_conditional.pulseEnd();
			this._meter_x_c.pulseEnd();
		}
	}

	private function pulse():Boolean
	{
		if (this._character.m_InvisibleBuffList[DualPistolsGauge.TAG_MATCH] != null)
			return true;

		return false;
	}

	private function dismiss_meter_1():Void
	{
		this._meter_1_a.dismiss();
		this._meter_1_b.dismiss();
		this._meter_1_c.dismiss();
	}

	private function dismiss_meter_2():Void
	{
		this._meter_2_a.dismiss();
		this._meter_2_b.dismiss();
		this._meter_2_c.dismiss();
	}

	private function dismiss_meter_x():Void
	{
		this._meter_x_a.dismiss();
		this._meter_x_b.dismiss();
		this._meter_x_b_conditional.dismiss();
		this._meter_x_c.dismiss();
	}

	public function discard():Void
	{
		this._character.SignalInvisibleBuffAdded.Disconnect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Disconnect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Disconnect(this.character_onTag, this);
		this._character.SignalBuffAdded.Disconnect(this.character_onTag, this);
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
		this.discard_meter_1();
		this.discard_meter_2();
	}

	private function discard_meter_1():Void
	{
		this.discard_meter_1_a();
		this.discard_meter_1_b();
		this.discard_meter_1_c();
	}

	private function discard_meter_1_a():Void
	{
		if (this._meter_1_a == null)
			return;

		TweenMax.killTweensOf(this._meter_1_a);

		this._meter_1_a.discard();
		this._meter_1_a = null;
	}

	private function discard_meter_1_b():Void
	{
		if (this._meter_1_b == null)
			return;

		TweenMax.killTweensOf(this._meter_1_b);

		this._meter_1_b.discard();
		this._meter_1_b = null;
	}

	private function discard_meter_1_c():Void
	{
		if (this._meter_1_c == null)
			return;

		TweenMax.killTweensOf(this._meter_1_c);

		this._meter_1_c.discard();
		this._meter_1_c = null;
	}

	private function discard_meter_2():Void
	{
		this.discard_meter_2_a();
		this.discard_meter_2_b();
		this.discard_meter_2_c();
	}

	private function discard_meter_2_a():Void
	{
		if (this._meter_2_a == null)
			return;

		TweenMax.killTweensOf(this._meter_2_a);

		this._meter_2_a.discard();
		this._meter_2_a = null;
	}

	private function discard_meter_2_b():Void
	{
		if (this._meter_2_b == null)
			return;

		TweenMax.killTweensOf(this._meter_2_b);

		this._meter_2_b.discard();
		this._meter_2_b = null;
	}

	private function discard_meter_2_c():Void
	{
		if (this._meter_2_c == null)
			return;

		TweenMax.killTweensOf(this._meter_2_c);

		this._meter_2_c.discard();
		this._meter_2_c = null;
	}

	private function discard_meter_x():Void
	{
		this.discard_meter_x_a();
		this.discard_meter_x_b();
		this.discard_meter_x_b_conditional();
		this.discard_meter_x_c();
	}

	private function discard_meter_x_a():Void
	{
		if (this._meter_x_a == null)
			return;

		TweenMax.killTweensOf(this._meter_x_a);

		this._meter_x_a.discard();
		this._meter_x_a = null;
	}

	private function discard_meter_x_b():Void
	{
		if (this._meter_x_b == null)
			return;

		TweenMax.killTweensOf(this._meter_x_b);

		this._meter_x_b.discard();
		this._meter_x_b = null;
	}

	private function discard_meter_x_b_conditional():Void
	{
		if (this._meter_x_b_conditional == null)
			return;

		TweenMax.killTweensOf(this._meter_x_b_conditional);

		this._meter_x_b_conditional.discard();
		this._meter_x_b_conditional = null;
	}

	private function discard_meter_x_c():Void
	{
		if (this._meter_x_c == null)
			return;

		TweenMax.killTweensOf(this._meter_x_c);

		this._meter_x_c.discard();
		this._meter_x_c = null;
	}

	private function character_onTag(which:Number):Void
	{
		if (which == DualPistolsGauge.TAG_MATCH)
		{
			this.refresh_timer();
			this.refresh_pulse();
		}
		else if (which == DualPistolsGauge.TAG_CHAMBER_1)
		{
			this.refresh_color_1();
		}
		else if (which == DualPistolsGauge.TAG_CHAMBER_2)
		{
			this.refresh_color_2();
		}
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
