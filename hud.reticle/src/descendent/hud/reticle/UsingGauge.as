import mx.utils.Delegate;

import com.GameInterface.Game.Character;
import com.Utils.Colors;
import com.Utils.ID32;

import descendent.hud.reticle.Color;
import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IMeter;
import descendent.hud.reticle.ReflectArcBarMeter;

class descendent.hud.reticle.UsingGauge extends Gauge
{
	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _meter_a:IMeter;

	private var _meter_a_conditional:IMeter;

	private var _meter_b:IMeter;

	private var _meter_b_conditional:IMeter;

	private var _subject:Character;

	private var _timer:Number;

	private var _refresh_meter:Function;

	private var _using:Boolean;

	private var _using_direction:Number;

	private var _using_uninterruptible:Boolean;

	public function UsingGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number)
	{
		super();

		this._r = r;
		this._angle_a = angle_a;
		this._angle_b = angle_b;
		this._thickness = thickness;

		this._refresh_meter = Delegate.create(this, this.refresh_meter);
	}

	public function setSubject(value:Character):Void
	{
		if (value == null)
		{
			if (this._subject == null)
				return;
		}
		else
		{
			var which:ID32 = value.GetID();

			if ((this._subject != null)
				&& (which.Equal(this._subject.GetID())))
			{
				return;
			}

			if (which.IsNull())
				value = null;
		}

		this.discard_subject();
		this.prepare_subject(value);

		this.refresh_color();
	}

	public function prepare(o:MovieClip):Void
	{
		super.prepare(o);

		this.prepare_meter();

		this.refresh_color();
	}

	private function prepare_meter():Void
	{
		this.prepare_meter_a();
		this.prepare_meter_a_conditional();
		this.prepare_meter_b();
		this.prepare_meter_b_conditional();
	}

	private function prepare_meter_a():Void
	{
		this._meter_a = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
//			new Color(0xFFCC33, 33), new Color(0xFFCC33, 100), new Color(0xFFFFFF, 100), 1.0, true);
			new Color(0xFFFF00, 33), new Color(0xFFFF00, 100), new Color(0xFFFFFF, 100), 1.0, true);
		this._meter_a.prepare(this.content);
	}

	private function prepare_meter_a_conditional():Void
	{
		this._meter_a_conditional = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
//			new Color(0x230174, 33), new Color(0x230174, 100), new Color(0xFFFFFF, 100), 1.0, true);
//			new Color(0x5311E8, 33), new Color(0x5311E8, 100), new Color(0xFFFFFF, 100), 1.0, true);
//			new Color(0x8E48F7, 33), new Color(0x8E48F7, 100), new Color(0xFFFFFF, 100), 1.0, true);
			new Color(Colors.e_ColorAnimaCritical, 33), new Color(Colors.e_ColorAnimaCritical, 100), new Color(0xFFFFFF, 100), 1.0, true);
		this._meter_a_conditional.prepare(this.content);
	}

	private function prepare_meter_b():Void
	{
		this._meter_b = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
//			new Color(0xFFCC33, 33), new Color(0xFFCC33, 100), new Color(0xFFFFFF, 100), 1.0, false);
			new Color(0xFFFF00, 33), new Color(0xFFFF00, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_b.prepare(this.content);
	}

	private function prepare_meter_b_conditional():Void
	{
		this._meter_b_conditional = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
//			new Color(0x230174, 33), new Color(0x230174, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			new Color(0x5311E8, 33), new Color(0x5311E8, 100), new Color(0xFFFFFF, 100), 1.0, false);
//			new Color(0x8E48F7, 33), new Color(0x8E48F7, 100), new Color(0xFFFFFF, 100), 1.0, false);
			new Color(Colors.e_ColorAnimaCritical, 33), new Color(Colors.e_ColorAnimaCritical, 100), new Color(0xFFFFFF, 100), 1.0, false);
		this._meter_b_conditional.prepare(this.content);
	}

	private function prepare_subject(subject:Character):Void
	{
		if (subject == null)
			return;

		if (subject.GetID().GetType() != _global.Enums.TypeID.e_Type_GC_Character)
			return;

		this._subject = subject;

		this._subject.SignalCommandStarted.Connect(this.subject_onUsingBegin, this);
        this._subject.SignalCommandAborted.Connect(this.subject_onUsingEnd, this);
        this._subject.SignalCommandEnded.Connect(this.subject_onUsingEnd, this);
		this._subject.SignalStatChanged.Connect(this.subject_onValue, this);

		this._subject.ConnectToCommandQueue();
	}

	private function timerBegin():Void
	{
		clearInterval(this._timer);
		this._timer = setInterval(this._refresh_meter, 33);

		this.refresh_color();
		this.refresh_meter();

		this.rouse();
	}

	private function timerEnd():Void
	{
		clearInterval(this._timer);
		this._timer = null;

		this.refresh_color();

		this.sleep();
	}

	private function refresh_meter():Void
	{
		var value:Number = this._subject.GetCommandProgress();

		if (value == this.getMeter())
			return;

		this.setMeter(value);
	}

	private function getMeter():Number
	{
		return this._meter_a.getMeter();
	}

	private function setMeter(value:Number):Void
	{
		this._meter_a.setMeter(value);
		this._meter_a_conditional.setMeter(value);
		this._meter_b.setMeter(1.0 - value);
		this._meter_b_conditional.setMeter(1.0 - value);
	}

	private function refresh_color():Void
	{
		this._meter_a.dismiss();
		this._meter_a_conditional.dismiss();
		this._meter_b.dismiss();
		this._meter_b_conditional.dismiss();

		if (!this._using)
			return;

		var meter_x:IMeter;
		var meter_x_conditional:IMeter;
		if (this._using_direction == _global.Enums.CommandProgressbarType.e_CommandProgressbar_Empty)
		{
			meter_x = this._meter_b;
			meter_x_conditional = this._meter_b_conditional;
		}
		else
		{
			meter_x = this._meter_a;
			meter_x_conditional = this._meter_a_conditional;
		}

		if (this._using_uninterruptible)
			meter_x_conditional.present();
		else if (this._subject.GetStat(_global.Enums.Stat.e_Uninterruptable, 2) > 0)
			meter_x_conditional.present();
		else
			meter_x.present();
	}

	public function discard():Void
	{
		clearInterval(this._timer);

		this.discard_subject();
		this.discard_meter();

		super.discard();
	}

	private function discard_meter():Void
	{
		this.discard_meter_a();
		this.discard_meter_a_conditional();
		this.discard_meter_b();
		this.discard_meter_b_conditional();

		this.sleep();
	}

	private function discard_meter_a():Void
	{
		if (this._meter_a == null)
			return;

		this._meter_a.discard();
		this._meter_a = null;
	}

	private function discard_meter_a_conditional():Void
	{
		if (this._meter_a_conditional == null)
			return;

		this._meter_a_conditional.discard();
		this._meter_a_conditional = null;
	}

	private function discard_meter_b():Void
	{
		if (this._meter_b == null)
			return;

		this._meter_b.discard();
		this._meter_b = null;
	}

	private function discard_meter_b_conditional():Void
	{
		if (this._meter_b_conditional == null)
			return;

		this._meter_b_conditional.discard();
		this._meter_b_conditional = null;
	}

	private function discard_subject():Void
	{
		if (this._subject == null)
			return;

		this._subject.SignalCommandStarted.Disconnect(this.subject_onUsingBegin, this);
        this._subject.SignalCommandAborted.Disconnect(this.subject_onUsingEnd, this);
        this._subject.SignalCommandEnded.Disconnect(this.subject_onUsingEnd, this);
		this._subject.SignalStatChanged.Disconnect(this.subject_onValue, this);

		this._subject = null;

		this.subject_onUsingEnd();
	}

	private function subject_onUsingBegin(label:String, direction:Number, uninterruptible:Boolean):Void
	{
		this._using = true;
		this._using_direction = direction;
		this._using_uninterruptible = uninterruptible;

		this.timerBegin();
	}

	private function subject_onUsingEnd():Void
	{
		this._using = false;
		this._using_direction = _global.Enums.CommandProgressbarType.e_CommandProgressbar_Fill;
		this._using_uninterruptible = false;

		this.timerEnd();
	}

	private function subject_onValue(which:Number):Void
	{
		if (!this._using)
			return;

		if (which != _global.Enums.Stat.e_Uninterruptable)
			return;

		this.refresh_color();
	}
}
