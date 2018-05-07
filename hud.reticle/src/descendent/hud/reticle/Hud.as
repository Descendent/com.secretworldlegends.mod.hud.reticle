import flash.geom.Point;

import com.Utils.GlobalSignal;
import com.Utils.ID32;

import com.GameInterface.DistributedValue;
import com.GameInterface.Game.Character;
import com.GameInterface.Game.CharacterBase;
import com.GameInterface.Game.Dynel;

import com.greensock.TweenMax;

import descendent.hud.reticle.Callout;
import descendent.hud.reticle.Deg;
import descendent.hud.reticle.DodgeGauge;
import descendent.hud.reticle.Nametag;
import descendent.hud.reticle.PowerGauge;
import descendent.hud.reticle.Rangefinder;
import descendent.hud.reticle.Shape;
import descendent.hud.reticle.SpecialGauge;
import descendent.hud.reticle.UsingGauge;
import descendent.hud.reticle.VitalGauge;

class descendent.hud.reticle.Hud extends Shape
{
	private static var GUIMODEFLAGS_MOUSEMODEOVERLAY:Number = 1 << 10;

	private static var NPCFLAGS_HIDENAMETAG:Number = 1 << 2;

	private static var STATE_SLEEP:Number = 0x0;

	private static var STATE_ROUSE:Number = 0x1;

	private static var STATE_AWAKE:Number = 0x2;

	private var _power_1:PowerGauge;

	private var _power_2:PowerGauge;

	private var _special_1:SpecialGauge;

	private var _special_2:SpecialGauge;

	private var _our_vital:VitalGauge;

	private var _our_using:UsingGauge;

	private var _dodge:DodgeGauge;

	private var _their_vital:VitalGauge;

	private var _their_using:UsingGauge;

	private var _nametag:Nametag;

	private var _callout:Callout;

	private var _rangefinder:Rangefinder;

	private var _character:Character;

	private var _awakeness:Number;

	private var _state:Number;

	private var _their_vital_awakeness:Number;

	private var _opt_guimode:DistributedValue;

	private var _mousemode:Boolean;

	private var _reticle_hover:ID32;

	private var _reticle_focus:ID32;

	public function Hud()
	{
		super();

		this._awakeness = 0;
//		this._state = Hud.STATE_SLEEP;
		this._their_vital_awakeness = 0;

		this._reticle_hover = new ID32();
		this._reticle_focus = new ID32();
	}

	public function prepare(o:MovieClip):Void
	{
		super.prepare(o);

		this._character = Character.GetClientCharacter();

		this.prepare_power();
		this.prepare_special();
		this.prepare_our();
		this.prepare_dodge();
		this.prepare_their();
		this.prepare_nametag();
		this.prepare_callout();
		this.prepare_rangefinder();

		CharacterBase.SignalClientCharacterAlive.Connect(this.character_onEnter, this);

		GlobalSignal.SignalCrosshairTargetUpdated.Connect(this.character_onReticleHover, this);

		this._character.SignalOffensiveTargetChanged.Connect(this.character_onReticleFocus, this);
		this._character.SignalToggleCombat.Connect(this.character_onAggro, this);
		this._character.SignalCharacterDied.Connect(this.character_onDeath, this);

		this._opt_guimode = DistributedValue.Create("guimode");
		this._opt_guimode.SignalChanged.Connect(this.refresh_awake, this);

		this.refresh_awake();
		this.refresh_their_vital_awake();

		this._our_vital.setSubject(this._character);
		this._our_using.setSubject(this._character);
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
		this._power_1.onRouse.Connect(this.gauge_onRouse, this);
		this._power_1.onSleep.Connect(this.gauge_onSleep, this);
		this._power_1.prepare(this.content);
	}

	private function prepare_power_2():Void
	{
		this._power_2 = new PowerGauge(96.0, Deg.getRad(37.5), Deg.getRad(-37.5), 6.0,
			_global.Enums.ItemEquipLocation.e_Wear_Second_WeaponSlot);
		this._power_2.onRouse.Connect(this.gauge_onRouse, this);
		this._power_2.onSleep.Connect(this.gauge_onSleep, this);
		this._power_2.prepare(this.content);
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
		this._special_1.onRouse.Connect(this.gauge_onRouse, this);
		this._special_1.onSleep.Connect(this.gauge_onSleep, this);
		this._special_1.prepare(this.content);
	}

	private function prepare_special_2():Void
	{
		this._special_2 = new SpecialGauge(106.0, Deg.getRad(37.5), Deg.getRad(-37.5), 12.0,
			_global.Enums.ItemEquipLocation.e_Wear_Second_WeaponSlot);
		this._special_2.onRouse.Connect(this.gauge_onRouse, this);
		this._special_2.onSleep.Connect(this.gauge_onSleep, this);
		this._special_2.prepare(this.content);
	}

	private function prepare_our():Void
	{
		this.prepare_our_vital();
		this.prepare_our_using();
	}

	private function prepare_our_vital():Void
	{
		this._our_vital = new VitalGauge(106.0, Deg.getRad(52.5), Deg.getRad(127.5), 12.0);
		this._our_vital.onRouse.Connect(this.gauge_onRouse, this);
		this._our_vital.onSleep.Connect(this.gauge_onSleep, this);
		this._our_vital.prepare(this.content);
	}

	private function prepare_our_using():Void
	{
		this._our_using = new UsingGauge(96.0, Deg.getRad(52.5), Deg.getRad(127.5), 6.0);
		this._our_using.prepare(this.content);
	}

	private function prepare_dodge():Void
	{
		this._dodge = new DodgeGauge(122.0, Deg.getRad(52.5), Deg.getRad(127.5), 6.0);
		this._dodge.onRouse.Connect(this.gauge_onRouse, this);
		this._dodge.onSleep.Connect(this.gauge_onSleep, this);
		this._dodge.prepare(this.content);
	}

	private function prepare_their():Void
	{
		this.prepare_their_vital();
		this.prepare_their_using();
	}

	private function prepare_their_vital():Void
	{
		this._their_vital = new VitalGauge(106.0, Deg.getRad(232.5), Deg.getRad(307.5), 12.0);
		this._their_vital.onRouse.Connect(this.their_vital_onRouse, this);
		this._their_vital.onSleep.Connect(this.their_vital_onSleep, this);
		this._their_vital.prepare(this.content);
	}

	private function prepare_their_using():Void
	{
		this._their_using = new UsingGauge(96.0, Deg.getRad(232.5), Deg.getRad(307.5), 6.0);
		this._their_using.prepare(this.content);
	}

	private function prepare_nametag():Void
	{
		this._nametag = new Nametag();
		this._nametag.setTranslation(new Point(0.0, -154.0));
		this._nametag.prepare(this.content);
	}

	private function prepare_callout():Void
	{
		this._callout = new Callout(152.0);
		this._callout.setTranslation(new Point(0.0, -48.0));
		this._callout.prepare(this.content);
	}

	private function prepare_rangefinder():Void
	{
		this._rangefinder = new Rangefinder();
		this._rangefinder.setTranslation(new Point(-24.0, 0.0));
		this._rangefinder.prepare(this.content);
	}

	public function discard():Void
	{
		this._opt_guimode.SignalChanged.Disconnect(this.refresh_awake, this);
		this._opt_guimode = null;

		this._character.SignalOffensiveTargetChanged.Disconnect(this.character_onReticleFocus, this);
		this._character.SignalToggleCombat.Disconnect(this.character_onAggro, this);
		this._character.SignalCharacterDied.Disconnect(this.character_onDeath, this);

		GlobalSignal.SignalCrosshairTargetUpdated.Disconnect(this.character_onReticleHover, this);

		CharacterBase.SignalClientCharacterAlive.Disconnect(this.character_onEnter, this);

		TweenMax.killTweensOf(this);

		this.discard_rangefinder();
		this.discard_callout();
		this.discard_nametag();
		this.discard_their();
		this.discard_dodge();
		this.discard_our();
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
		TweenMax.killTweensOf(this._power_1);

		this._power_1.discard();
		this._power_1.onRouse.Disconnect(this.gauge_onRouse, this);
		this._power_1.onSleep.Disconnect(this.gauge_onSleep, this);
		this._power_1 = null;
	}

	private function discard_power_2():Void
	{
		TweenMax.killTweensOf(this._power_2);

		this._power_2.discard();
		this._power_2.onRouse.Disconnect(this.gauge_onRouse, this);
		this._power_2.onSleep.Disconnect(this.gauge_onSleep, this);
		this._power_2 = null;
	}

	private function discard_special():Void
	{
		this.discard_special_1();
		this.discard_special_2();
	}

	private function discard_special_1():Void
	{
		TweenMax.killTweensOf(this._special_1);

		this._special_1.discard();
		this._special_1.onRouse.Disconnect(this.gauge_onRouse, this);
		this._special_1.onSleep.Disconnect(this.gauge_onSleep, this);
		this._special_1 = null;
	}

	private function discard_special_2():Void
	{
		TweenMax.killTweensOf(this._special_2);

		this._special_2.discard();
		this._special_2.onRouse.Disconnect(this.gauge_onRouse, this);
		this._special_2.onSleep.Disconnect(this.gauge_onSleep, this);
		this._special_2 = null;
	}

	private function discard_our():Void
	{
		this.discard_our_vital();
		this.discard_our_using();
	}

	private function discard_our_vital():Void
	{
		this._our_vital.discard();
		this._our_vital.onRouse.Disconnect(this.gauge_onRouse, this);
		this._our_vital.onSleep.Disconnect(this.gauge_onSleep, this);
		this._our_vital = null;
	}

	private function discard_our_using():Void
	{
		this._our_using.discard();
		this._our_using = null;
	}

	private function discard_dodge():Void
	{
		this._dodge.discard();
		this._dodge.onRouse.Disconnect(this.gauge_onRouse, this);
		this._dodge.onSleep.Disconnect(this.gauge_onSleep, this);
		this._dodge = null;
	}

	private function discard_their():Void
	{
		this.discard_their_vital();
		this.discard_their_using();
	}

	private function discard_their_vital():Void
	{
		this._their_vital.discard();
		this._their_vital.onRouse.Disconnect(this.their_vital_onRouse, this);
		this._their_vital.onSleep.Disconnect(this.their_vital_onSleep, this);
		this._their_vital = null;
	}

	private function discard_their_using():Void
	{
		this._their_using.discard();
		this._their_using = null;
	}

	private function discard_nametag():Void
	{
		this._nametag.discard();
		this._nametag = null;
	}

	private function discard_callout():Void
	{
		this._callout.discard();
		this._callout = null;
	}

	private function discard_rangefinder():Void
	{
		this._rangefinder.discard();
		this._rangefinder = null;
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

		TweenMax.to(this, 0.0, {
			setGaugeAlpha: 100,
			overwrite: "allOnStart",
			onStart: this.gauge_present,
			onStartScope: this
		});

		this._our_using.setAlpha(100);
		this._their_vital.setAlpha(100);
		this._their_using.setAlpha(100);
		this._callout.setAlpha(100);
	}

	private function rouse():Void
	{
		if (this._state == Hud.STATE_ROUSE)
			return;

		this._state = Hud.STATE_ROUSE;

		TweenMax.to(this, 0.0, {
			setGaugeAlpha: 50,
			overwrite: "allOnStart",
			onStart: this.gauge_present,
			onStartScope: this
		});

		this._our_using.setAlpha(50);
		this._their_vital.setAlpha(50);
		this._their_using.setAlpha(50);
		this._callout.setAlpha(50);
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

		TweenMax.to(this, timer, {
			setGaugeAlpha: 0,
			delay: delay,
			overwrite: "allOnStart",
			onComplete: this.gauge_dismiss,
			onCompleteScope: this
		});

		this._our_using.setAlpha(50);
		this._their_vital.setAlpha(50);
		this._their_using.setAlpha(50);
		this._callout.setAlpha(50);
	}

	private function getGaugeAlpha():Number
	{
		return this._our_vital.getAlpha();
	}

	private function setGaugeAlpha(value:Number):Void
	{
		this._power_1.setAlpha(value);
		this._power_2.setAlpha(value);
		this._special_1.setAlpha(value);
		this._special_2.setAlpha(value);
		this._our_vital.setAlpha(value);
		this._dodge.setAlpha(value);
	}

	private function gauge_present():Void
	{
		this._power_1.present();
		this._power_2.present();
		this._special_1.present();
		this._special_2.present();
		this._our_vital.present();
		this._dodge.present();
	}

	private function gauge_dismiss():Void
	{
		this._power_1.dismiss();
		this._power_2.dismiss();
		this._special_1.dismiss();
		this._special_2.dismiss();
		this._our_vital.dismiss();
		this._dodge.dismiss();
	}

	private function refresh_their_vital_awake():Void
	{
		if (this._character.IsInCombat())
			this._their_vital.present();
		else if (this._character.IsThreatened())
			this._their_vital.present();
		else if (this._their_vital_awakeness != 0)
			this._their_vital.present();
		else
			this._their_vital.dismiss();
	}

	private function refresh_reticle():Void
	{
		var which:ID32 = (!this._reticle_focus.IsNull())
			? this._reticle_focus
			: this._reticle_hover;

		var dynel:Dynel = Dynel.GetDynel(which);
		var character:Character = Character.GetCharacter(which);

		if ((character.GetStat(_global.Enums.Stat.e_NPCFlags, 2) & Hud.NPCFLAGS_HIDENAMETAG) != 0)
		{
			dynel = null;
			character = null;
		}

		this._their_vital.setSubject(dynel);
		this._their_using.setSubject(character);
		this._nametag.setSubject(dynel);
		this._callout.setSubject(character);
		this._rangefinder.setSubject(dynel);
	}

	private function character_onEnter():Void
	{
		this._our_using.setSubject(null);
		this._our_using.setSubject(this._character);
	}

	private function character_onReticleHover(which:ID32):Void
	{
		this._reticle_hover = which;

		this.refresh_reticle();
	}

	private function character_onReticleFocus(which:ID32):Void
	{
		this._reticle_focus = which;

		this.refresh_reticle();
	}

	private function character_onAggro(aggro:Boolean):Void
	{
		this.refresh_awake();
		this.refresh_their_vital_awake();
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

	private function their_vital_onRouse():Void
	{
		++this._their_vital_awakeness;

		this.refresh_their_vital_awake();
	}

	private function their_vital_onSleep():Void
	{
		--this._their_vital_awakeness;

		this.refresh_their_vital_awake();
	}
}
