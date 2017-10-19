import flash.geom.Point;

import com.GameInterface.DistributedValue;
import com.GameInterface.Game.Character;

import com.greensock.TweenMax;

import descendent.hud.reticle.Deg;
import descendent.hud.reticle.PowerGauge;
import descendent.hud.reticle.Shape;
import descendent.hud.reticle.SpecialGauge;

class descendent.hud.reticle.Hud extends Shape
{
	private static var GUIMODEFLAGS_MOUSEMODEOVERLAY:Number = 1 << 10;

	private static var STATE_SLEEP:Number = 0x0;

	private static var STATE_ROUSE:Number = 0x1;

	private static var STATE_AWAKE:Number = 0x2;

	private var _power_1:PowerGauge;

	private var _power_2:PowerGauge;

	private var _special_1:SpecialGauge;

	private var _special_2:SpecialGauge;

	private var _character:Character;

	private var _awakeness:Number;

	private var _state:Number;

	private var _opt_guimode:DistributedValue;

	private var _mousemode:Boolean;

	public function Hud()
	{
		super();

		this._character = Character.GetClientCharacter();
		this._awakeness = 0;
//		this._state = Hud.STATE_SLEEP;
	}

	public function prepare(o:MovieClip):Void
	{
		super.prepare(o);

		this.prepare_power();
		this.prepare_special();

		this._character.SignalToggleCombat.Connect(this.character_onAggro, this);
		this._character.SignalCharacterDied.Connect(this.character_onDeath, this);

		this._opt_guimode = DistributedValue.Create("guimode");
		this._opt_guimode.SignalChanged.Connect(this.refresh_awake, this);

		this.refresh_awake();
	}

	private function prepare_power():Void
	{
		this.prepare_power_1();
		this.prepare_power_2();
	}

	private function prepare_power_1():Void
	{
		this._power_1 = new PowerGauge(96.0, Deg.getRad(142.5), Deg.getRad(217.5), 6.0,
			_global.Enums.ItemEquipLocation.e_Wear_First_WeaponSlot);
		this._power_1.prepare(this.content);

		this._power_1.onRouse.Connect(this.gauge_onRouse, this);
		this._power_1.onSleep.Connect(this.gauge_onSleep, this);
	}

	private function prepare_power_2():Void
	{
		this._power_2 = new PowerGauge(96.0, Deg.getRad(37.5), Deg.getRad(-37.5), 6.0,
			_global.Enums.ItemEquipLocation.e_Wear_Second_WeaponSlot);
		this._power_2.prepare(this.content);

		this._power_2.onRouse.Connect(this.gauge_onRouse, this);
		this._power_2.onSleep.Connect(this.gauge_onSleep, this);
	}

	private function prepare_special():Void
	{
		this.prepare_special_1();
		this.prepare_special_2();
	}

	private function prepare_special_1():Void
	{
		this._special_1 = new SpecialGauge(106.0, Deg.getRad(142.5), Deg.getRad(217.5), 12.0,
			_global.Enums.ItemEquipLocation.e_Wear_First_WeaponSlot);
		this._special_1.prepare(this.content);

		this._special_1.onRouse.Connect(this.gauge_onRouse, this);
		this._special_1.onSleep.Connect(this.gauge_onSleep, this);
	}

	private function prepare_special_2():Void
	{
		this._special_2 = new SpecialGauge(106.0, Deg.getRad(37.5), Deg.getRad(-37.5), 12.0,
			_global.Enums.ItemEquipLocation.e_Wear_Second_WeaponSlot);
		this._special_2.prepare(this.content);

		this._special_2.onRouse.Connect(this.gauge_onRouse, this);
		this._special_2.onSleep.Connect(this.gauge_onSleep, this);
	}

	public function discard():Void
	{
		this._opt_guimode.SignalChanged.Disconnect(this.refresh_awake, this);
		this._opt_guimode = null;

		this._character.SignalToggleCombat.Disconnect(this.character_onAggro, this);
		this._character.SignalCharacterDied.Disconnect(this.character_onDeath, this);

		this.discard_special();
		this.discard_power();

		super.discard();
	}

	private function discard_power():Void
	{
		this.discard_power_1();
		this.discard_power_2();
	}

	private function discard_power_1():Void
	{
		this._power_1.onRouse.Disconnect(this.gauge_onRouse, this);
		this._power_1.onSleep.Disconnect(this.gauge_onSleep, this);

		TweenMax.killTweensOf(this._power_1);

		this._power_1.discard();
		this._power_1 = null;
	}

	private function discard_power_2():Void
	{
		this._power_2.onRouse.Disconnect(this.gauge_onRouse, this);
		this._power_2.onSleep.Disconnect(this.gauge_onSleep, this);

		TweenMax.killTweensOf(this._power_2);

		this._power_2.discard();
		this._power_2 = null;
	}

	private function discard_special():Void
	{
		this.discard_special_1();
		this.discard_special_2();
	}

	private function discard_special_1():Void
	{
		this._special_1.onRouse.Disconnect(this.gauge_onRouse, this);
		this._special_1.onSleep.Disconnect(this.gauge_onSleep, this);

		TweenMax.killTweensOf(this._special_1);

		this._special_1.discard();
		this._special_1 = null;
	}

	private function discard_special_2():Void
	{
		this._special_2.onRouse.Disconnect(this.gauge_onRouse, this);
		this._special_2.onSleep.Disconnect(this.gauge_onSleep, this);

		TweenMax.killTweensOf(this._special_2);

		this._special_2.discard();
		this._special_2 = null;
	}

	private function refresh_awake():Void
	{
		var mousemode:Boolean = Boolean(this._opt_guimode.GetValue() & Hud.GUIMODEFLAGS_MOUSEMODEOVERLAY);

		if (this._character.IsDead())
			this.sleep();
		else if (this._character.IsGhosting())
			this.sleep();
		else if (this._character.IsInCombat())
			this.awake();
		else if (this._character.IsThreatened())
			this.rouse();
		else if (this._awakeness != 0)
			this.rouse();
		else if (mousemode)
			this.rouse();
		else if ((!mousemode) && (this._mousemode))
			this.sleep(true);
		else
			this.sleep();

		this._mousemode = mousemode;
	}

	private function awake():Void
	{
		if (this._state == Hud.STATE_AWAKE)
			return;

		this._state = Hud.STATE_AWAKE;

		TweenMax.to([this._power_1, this._power_2, this._special_1, this._special_2], 0.0, {
			setAlpha: 100,
			overwrite: "allOnStart",
			onStart: this.gauge_present,
			onStartScope: this
		});
	}

	private function rouse():Void
	{
		if (this._state == Hud.STATE_ROUSE)
			return;

		this._state = Hud.STATE_ROUSE;

		TweenMax.to([this._power_1, this._power_2, this._special_1, this._special_2], 0.0, {
			setAlpha: 50,
			overwrite: "allOnStart",
			onStart: this.gauge_present,
			onStartScope: this
		});
	}

	private function sleep(instant:Boolean):Void
	{
		if (this._state == Hud.STATE_SLEEP)
			return;

		this._state = Hud.STATE_SLEEP;

		var timer:Number;
		var delay:Number;
		if (instant)
		{
			timer = 0.0;
			delay = 0.0;
		}
		else
		{
			timer = 1.0;
			delay = 0.3;
		}

		TweenMax.to([this._power_1, this._power_2, this._special_1, this._special_2], timer, {
			setAlpha: 0,
			delay: delay,
			overwrite: "allOnStart",
			onComplete: this.gauge_dismiss,
			onCompleteScope: this
		});
	}

	private function gauge_present():Void
	{
		this._power_1.present();
		this._power_2.present();
		this._special_1.present();
		this._special_2.present();
	}

	private function gauge_dismiss():Void
	{
		this._power_1.dismiss();
		this._power_2.dismiss();
		this._special_1.dismiss();
		this._special_2.dismiss();
	}

	private function character_onAggro(aggro:Boolean):Void
	{
		this.refresh_awake();
	}

	private function character_onDeath():Void
	{
		this.refresh_awake();
	}

	private function gauge_onRouse():Void
	{
		++this._awakeness;

		this.refresh_awake();
	}

	private function gauge_onSleep():Void
	{
		--this._awakeness;

		this.refresh_awake();
	}
}
