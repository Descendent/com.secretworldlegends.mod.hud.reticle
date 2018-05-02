import com.GameInterface.Game.Character;
import com.GameInterface.Inventory;
import com.GameInterface.InventoryItem;
import com.Utils.Colors;
import com.Utils.ID32;
import com.Utils.Signal;

import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IGauge;
import descendent.hud.reticle.special.AssaultRifleGauge;
import descendent.hud.reticle.special.BladeGauge;
import descendent.hud.reticle.special.BloodGauge;
import descendent.hud.reticle.special.ChaosGauge;
import descendent.hud.reticle.special.DualPistolsGauge;
import descendent.hud.reticle.special.ElementalismGauge;
import descendent.hud.reticle.special.FistGauge;
import descendent.hud.reticle.special.HammerGauge;
import descendent.hud.reticle.special.ShotgunGauge;

class descendent.hud.reticle.SpecialGauge extends Gauge
{
	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _equip:Number;

	private var _character:ID32;

	private var _inventory:Inventory;

	private var _gauge:IGauge;

	public function SpecialGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number,
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

		this._character = Character.GetClientCharID();
		this._inventory = new Inventory(new ID32(_global.Enums.InvType.e_Type_GC_WeaponContainer, this._character.GetInstance()));

		this.prepare_gauge();

		this._inventory.SignalItemLoaded.Connect(this.inventory_onPlant, this);
		this._inventory.SignalItemAdded.Connect(this.inventory_onPlant, this);
		this._inventory.SignalItemChanged.Connect(this.inventory_onTransform, this);
		this._inventory.SignalItemRemoved.Connect(this.inventory_onPluck, this);
	}

	private function prepare_gauge():Void
	{
		var thing:InventoryItem = this._inventory.GetItemAt(this._equip);

		if (thing == null)
			return;

		if ((thing.m_Type & _global.Enums.WeaponTypeFlag.e_WeaponType_AssaultRifle) != 0)
		{
			this.present_gauge_process(new AssaultRifleGauge(
				this._r, this._angle_a, this._angle_b, this._thickness, this._equip));
		}
		else if ((thing.m_Type & _global.Enums.WeaponTypeFlag.e_WeaponType_Sword) != 0)
		{
			this.present_gauge_process(new BladeGauge(
				this._r, this._angle_a, this._angle_b, this._thickness, this._equip));
		}
		else if ((thing.m_Type & _global.Enums.WeaponTypeFlag.e_WeaponType_Death) != 0)
		{
			this.present_gauge_process(new BloodGauge(
				this._r, this._angle_a, this._angle_b, this._thickness, this._equip));
		}
		else if ((thing.m_Type & _global.Enums.WeaponTypeFlag.e_WeaponType_Jinx) != 0)
		{
			this.present_gauge_process(new ChaosGauge(
				this._r, this._angle_a, this._angle_b, this._thickness, this._equip));
		}
		else if ((thing.m_Type & _global.Enums.WeaponTypeFlag.e_WeaponType_Handgun) != 0)
		{
			this.present_gauge_process(new DualPistolsGauge(
				this._r, this._angle_a, this._angle_b, this._thickness, this._equip));
		}
		else if ((thing.m_Type & _global.Enums.WeaponTypeFlag.e_WeaponType_Fire) != 0)
		{
			this.present_gauge_process(new ElementalismGauge(
				this._r, this._angle_a, this._angle_b, this._thickness, this._equip));
		}
		else if ((thing.m_Type & _global.Enums.WeaponTypeFlag.e_WeaponType_Fist) != 0)
		{
			this.present_gauge_process(new FistGauge(
				this._r, this._angle_a, this._angle_b, this._thickness, this._equip));
		}
		else if ((thing.m_Type & _global.Enums.WeaponTypeFlag.e_WeaponType_Club) != 0)
		{
			this.present_gauge_process(new HammerGauge(
				this._r, this._angle_a, this._angle_b, this._thickness, this._equip));
		}
		else if ((thing.m_Type & _global.Enums.WeaponTypeFlag.e_WeaponType_Shotgun) != 0)
		{
			this.present_gauge_process(new ShotgunGauge(
				this._r, this._angle_a, this._angle_b, this._thickness, this._equip));
		}
	}

	private function present_gauge_process(gauge:IGauge)
	{
		this._gauge = gauge;
		this._gauge.onRouse.Connect(this.rouse, this);
		this._gauge.onSleep.Connect(this.sleep, this);
		this._gauge.prepare(this.content);
	}

	public function discard():Void
	{
		this._inventory.SignalItemLoaded.Disconnect(this.inventory_onPlant, this);
		this._inventory.SignalItemAdded.Disconnect(this.inventory_onPlant, this);
		this._inventory.SignalItemChanged.Disconnect(this.inventory_onTransform, this);
		this._inventory.SignalItemRemoved.Disconnect(this.inventory_onPluck, this);

		this.discard_gauge();

		super.discard();
	}

	private function discard_gauge():Void
	{
		if (this._gauge == null)
			return;

		this._gauge.discard();
		this._gauge.onRouse.Disconnect(this.rouse, this);
		this._gauge.onSleep.Disconnect(this.sleep, this);
		this._gauge = null;

		this.sleep();
	}

	private function inventory_onPlant(inventory:ID32, which:Number):Void
	{
		if (which != this._equip)
			return;

		this.discard_gauge();
		this.prepare_gauge();
	}

	private function inventory_onTransform(inventory:ID32, which:Number):Void
	{
		if (which != this._equip)
			return;

		this.discard_gauge();
		this.prepare_gauge();
	}

	private function inventory_onPluck(inventory:ID32, which:Number, replant:Boolean):Void
	{
		if (which != this._equip)
			return;

		this.discard_gauge();
	}
}
