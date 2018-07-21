import com.GameInterface.Game.Character;
import com.Utils.Colors;
import com.Utils.ID32;

import caurina.transitions.Tweener;

import descendent.hud.reticle.Color;
import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IMeter;
import descendent.hud.reticle.ReflectArcBarMeter;

class descendent.hud.reticle.VitalGauge extends Gauge
{
	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _meter_current:IMeter;

	private var _meter_current_a:IMeter;

	private var _meter_current_b:IMeter;

	private var _meter_barrier:IMeter;

	private var _meter_pending:IMeter;

	private var _shaft:IMeter;

	private var _shaft_a:IMeter;

	private var _shaft_b:IMeter;

	private var _shaft_our:IMeter;

	private var _notch:IMeter;

	private var _notch_a:IMeter;

	private var _notch_b:IMeter;

	private var _notch_our:IMeter;

	private var _subject:Character;

	private var _value_maximum:Number;

	private var _value_current:Number;

	private var _value_barrier:Number;

	private var _value_pending:Number;

	public function VitalGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number)
	{
		super();

		this._r = r;
		this._angle_a = angle_a;
		this._angle_b = angle_b;
		this._thickness = thickness;
	}

	public function setSubject(value:Character):Void
	{
		this.discard_subject();
		this.prepare_subject(value);
	}

	public function prepare(o:MovieClip):Void
	{
		super.prepare(o);

		this.prepare_shaft();
		this.prepare_meter();
		this.prepare_notch();

		this._meter_current_a.dismiss();
		this._meter_current_b.dismiss();
		this._meter_barrier.dismiss();
		this._meter_pending.dismiss();
		this._shaft_a.dismiss();
		this._shaft_b.dismiss();
		this._shaft_our.dismiss();
		this._notch_a.dismiss();
		this._notch_b.dismiss();
		this._notch_our.dismiss();
	}

	private function prepare_shaft():Void
	{
		this.prepare_shaft_a();
		this.prepare_shaft_b();
		this.prepare_shaft_our();
	}

	private function prepare_shaft_a():Void
	{
		var notch:/*Number*/Array = [0.25, 0.5, 0.75];

		this._shaft_a = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x20FF8A, 33), new Color(0x20FF8A, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			new Color(0x88FCCC, 33), new Color(0x88FCCC, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._shaft_a.setNotch(notch);
		this._shaft_a.prepare(this.content);
	}

	private function prepare_shaft_b():Void
	{
		var notch:/*Number*/Array = [0.25, 0.5, 0.75];

		this._shaft_b = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0xFF4646, 33), new Color(0xFF4646, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			new Color(0xFFB1B1, 33), new Color(0xFFB1B1, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._shaft_b.setNotch(notch);
		this._shaft_b.prepare(this.content);
	}

	private function prepare_shaft_our():Void
	{
		this._shaft_our = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			new Color(0x20FF8A, 33), new Color(0x20FF8A, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			new Color(0x88FCCC, 33), new Color(0x88FCCC, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._shaft_our.prepare(this.content);
	}

	private function prepare_meter():Void
	{
		this.prepare_meter_barrier();
		this.prepare_meter_pending();
		this.prepare_meter_current();
	}

	private function prepare_meter_current():Void
	{
		this.prepare_meter_current_a();
		this.prepare_meter_current_b();
	}

	private function prepare_meter_current_a():Void
	{
		this._meter_current_a = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x20FF8A, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			null, new Color(0x88FCCC, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_current_a.prepare(this.content);
	}

	private function prepare_meter_current_b():Void
	{
		this._meter_current_b = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0xFF4646, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			null, new Color(0xFFB1B1, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_current_b.prepare(this.content);
	}

	private function prepare_meter_barrier():Void
	{
		this._meter_barrier = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0xFFED70, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			null, new Color(0xFFF585, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			null, new Color(0xFFFFFF, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_barrier.prepare(this.content);
	}

	private function prepare_meter_pending():Void
	{
		this._meter_pending = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(Colors.e_ColorHealthCritical, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_pending.prepare(this.content);
	}

	private function prepare_notch():Void
	{
		this.prepare_notch_a();
		this.prepare_notch_b();
		this.prepare_notch_our();
	}

	private function prepare_notch_a():Void
	{
		var notch:/*Number*/Array = [0.25, 0.5, 0.75];

		this._notch_a = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x000000, 0), new Color(0xFFFFFF, 100), 1.0, false);
		this._notch_a.setNotch(notch);
		this._notch_a.prepare(this.content);
	}

	private function prepare_notch_b():Void
	{
		var notch:/*Number*/Array = [0.25, 0.5, 0.75];

		this._notch_b = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x000000, 0), new Color(0xFFFFFF, 100), 1.0, false);
		this._notch_b.setNotch(notch);
		this._notch_b.prepare(this.content);
	}

	private function prepare_notch_our():Void
	{
		this._notch_our = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
			null, new Color(0x000000, 0), new Color(0xFFFFFF, 100), 1.0, false);
		this._notch_our.prepare(this.content);
	}

	private function prepare_subject(subject:Character):Void
	{
		if (subject == null)
			return;

		var which:ID32 = subject.GetID();

		if ((which.GetType() != _global.Enums.TypeID.e_Type_GC_Character)
			&& (which.GetType() != _global.Enums.TypeID.e_Type_GC_Destructible))
		{
			return;
		}

		this._subject = subject;

		if (subject.IsEnemy())
		{
			this._meter_current = this._meter_current_b;
			this._shaft = this._shaft_b;
			this._notch = this._notch_b;
		}
		else if (subject.IsClientChar())
		{
			this._meter_current = this._meter_current_a;
			this._shaft = this._shaft_our;
			this._notch = this._notch_our;
		}
		else
		{
			this._meter_current = this._meter_current_a;
			this._shaft = this._shaft_a;
			this._notch = this._notch_a;
		}

		this._value_maximum = this._subject.GetStat(_global.Enums.Stat.e_Life, 2);
		this._value_current = this._subject.GetStat(_global.Enums.Stat.e_Health, 2);
		this._value_barrier = this._subject.GetStat(_global.Enums.Stat.e_BarrierHealthPool, 2);
		this._value_pending = this._value_current;

		if (this._value_maximum == 0)
			return;

		this._meter_current.present();
		this._shaft.present();
		this._notch.present();

		this.refresh_meter();

		this._subject.SignalStatChanged.Connect(this.subject_onValue, this);
	}

	private function refresh_maximum():Void
	{
		var value:Number = this._subject.GetStat(_global.Enums.Stat.e_Life, 2);

		this.setMaximum(value);
	}

	private function getMaximum():Number
	{
		return this._value_maximum;
	}

	private function setMaximum(value:Number):Void
	{
		this._value_maximum = value;

		this.refresh_meter();
	}

	private function refresh_current():Void
	{
		var value:Number = this._subject.GetStat(_global.Enums.Stat.e_Health, 2);

		this.setCurrent(value);

		var timer:Number = (value >= this._value_pending)
			? 0.0
			: 0.3;

		Tweener.addTween(this, {
			setPending: value,
			time: timer,
			transition: "linear"
		});
	}

	private function getCurrent():Number
	{
		return this._value_current;
	}

	private function setCurrent(value:Number):Void
	{
		this._value_current = value;

		this.refresh_meter();
	}

	private function getPending():Number
	{
		return this._value_pending;
	}

	private function setPending(value:Number):Void
	{
		this._value_pending = value;

		this.refresh_meter();
	}

	private function refresh_barrier():Void
	{
		var value:Number = this._subject.GetStat(_global.Enums.Stat.e_BarrierHealthPool, 2);

		this.setBarrier(value);
	}

	private function getBarrier():Number
	{
		return this._value_barrier;
	}

	private function setBarrier(value:Number):Void
	{
		this._value_barrier = value;

		this.refresh_meter();
	}

	private function refresh_meter():Void
	{
		if (this._value_barrier == 0)
			this._meter_barrier.dismiss();
		else
			this._meter_barrier.present();

		if (this._value_pending <= this._value_current)
			this._meter_pending.dismiss();
		else
			this._meter_pending.present();

        var combine:Number = Math.max(this._value_current, this._value_pending) + this._value_barrier;
        var maximum:Number = Math.max(combine, this._value_maximum);

        this._meter_current.setMeter(this._value_current / maximum);
        this._meter_barrier.setMeter(combine / maximum);
        this._meter_pending.setMeter(this._value_pending / maximum);
        this._notch.setMeter(combine / maximum);

		this.refresh_awake();
	}

	private function refresh_awake():Void
	{
		if (this._subject.IsDead())
			this.sleep();
		else if (this._subject.IsGhosting())
			this.sleep();
		else if (this._value_current >= this._value_maximum)
			this.sleep();
		else
			this.rouse();
	}

	private function refresh_subject():Void
	{
		var subject:Character = this._subject;

		this.discard_subject();
		this.prepare_subject(subject);
	}

	public function discard():Void
	{
		Tweener.removeTweens(this);

		this.discard_subject();
		this.discard_notch();
		this.discard_meter();
		this.discard_shaft();

		super.discard();
	}

	private function discard_shaft():Void
	{
		this.discard_shaft_a();
		this.discard_shaft_b();
		this.discard_shaft_our();
	}

	private function discard_shaft_a():Void
	{
		if (this._shaft_a == null)
			return;

		this._shaft_a.discard();
		this._shaft_a = null;
	}

	private function discard_shaft_b():Void
	{
		if (this._shaft_b == null)
			return;

		this._shaft_b.discard();
		this._shaft_b = null;
	}

	private function discard_shaft_our():Void
	{
		if (this._shaft_our == null)
			return;

		this._shaft_our.discard();
		this._shaft_our = null;
	}

	private function discard_meter():Void
	{
		this.discard_meter_current();
		this.discard_meter_barrier();
		this.discard_meter_pending();

		this.sleep();
	}

	private function discard_meter_current():Void
	{
		this.discard_meter_current_a();
		this.discard_meter_current_b();
	}

	private function discard_meter_current_a():Void
	{
		if (this._meter_current_a == null)
			return;

		this._meter_current_a.discard();
		this._meter_current_a = null;
	}

	private function discard_meter_current_b():Void
	{
		if (this._meter_current_b == null)
			return;

		this._meter_current_b.discard();
		this._meter_current_b = null;
	}

	private function discard_meter_barrier():Void
	{
		if (this._meter_barrier == null)
			return;

		this._meter_barrier.discard();
		this._meter_barrier = null;
	}

	private function discard_meter_pending():Void
	{
		if (this._meter_pending == null)
			return;

		this._meter_pending.discard();
		this._meter_pending = null;
	}

	private function discard_notch():Void
	{
		this.discard_notch_a();
		this.discard_notch_b();
		this.discard_notch_our();
	}

	private function discard_notch_a():Void
	{
		if (this._notch_a == null)
			return;

		this._notch_a.discard();
		this._notch_a = null;
	}

	private function discard_notch_b():Void
	{
		if (this._notch_b == null)
			return;

		this._notch_b.discard();
		this._notch_b = null;
	}

	private function discard_notch_our():Void
	{
		if (this._notch_our == null)
			return;

		this._notch_our.discard();
		this._notch_our = null;
	}

	private function discard_subject():Void
	{
		if (this._subject == null)
			return;

		this._subject.SignalStatChanged.Disconnect(this.subject_onValue, this);

		this._subject = null;

		Tweener.removeTweens(this, "setPending");

		this._meter_current_a.dismiss();
		this._meter_current_b.dismiss();
		this._meter_barrier.dismiss();
		this._meter_pending.dismiss();
		this._shaft_a.dismiss();
		this._shaft_b.dismiss();
		this._shaft_our.dismiss();
		this._notch_a.dismiss();
		this._notch_b.dismiss();
		this._notch_our.dismiss();

		this._value_maximum = 0;
		this._value_current = 0;
		this._value_barrier = 0;
		this._value_pending = 0;

		this.sleep();
	}

	private function subject_onValue(which:Number):Void
	{
		if (which == _global.Enums.Stat.e_Life)
			this.refresh_maximum();
		else if (which == _global.Enums.Stat.e_Health)
			this.refresh_current();
		else if (which == _global.Enums.Stat.e_BarrierHealthPool)
			this.refresh_barrier();
		else if (which == _global.Enums.Stat.e_PlayerFaction)
			this.refresh_subject();
		else if (which == _global.Enums.Stat.e_Side)
			this.refresh_subject();
		else if (which == _global.Enums.Stat.e_CarsGroup)
			this.refresh_subject();
	}
}
