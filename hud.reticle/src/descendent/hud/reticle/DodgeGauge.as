import mx.utils.Delegate;

import com.GameInterface.Game.Character;
import com.GameInterface.Game.CharacterBase;
import com.GameInterface.Game.BuffData;
import com.GameInterface.ProjectUtils;
import com.GameInterface.UtilsBase;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import descendent.hud.reticle.Color;
import descendent.hud.reticle.Gauge;
import descendent.hud.reticle.IMeter;
import descendent.hud.reticle.ReflectArcBarMeter;

class descendent.hud.reticle.DodgeGauge extends Gauge
{
	private static var TAG_DODGE:Number = ProjectUtils.GetUint32TweakValue("DashCooldownSpellID");

	private var _r:Number;

	private var _angle_a:Number;

	private var _angle_b:Number;

	private var _thickness:Number;

	private var _character:Character;

	private var _meter:IMeter;

	private var _timer:Number;

	private var _refresh_meter:Function;

	public function DodgeGauge(r:Number, angle_a:Number, angle_b:Number, thickness:Number)
	{
		super();

		this._r = r;
		this._angle_a = angle_a;
		this._angle_b = angle_b;
		this._thickness = thickness;

		this._refresh_meter = Delegate.create(this, this.refresh_meter);
	}

	public function prepare(o:MovieClip):Void
	{
		super.prepare(o);

		this._character = Character.GetClientCharacter();

		this.prepare_meter();

		this.refresh_timer();

		CharacterBase.SignalClientCharacterAlive.Connect(this.character_onEnter, this);

		this._character.SignalInvisibleBuffAdded.Connect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Connect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Connect(this.character_onTag, this);
	}

	private function prepare_meter():Void
	{
		this._meter = new ReflectArcBarMeter(this._r, this._angle_a, this._angle_b, this._thickness,
//			new Color(0x37FFFF, 33), new Color(0x37FFFF, 100), new Color(0xFFFFFF, 100), 1.0, true);
			new Color(0x00FFF6, 33), new Color(0x00FFF6, 100), new Color(0xFFFFFF, 100), 1.0, true);
		this._meter.prepare(this.content);
	}

	private function refresh_timer():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[DodgeGauge.TAG_DODGE];

		if (tag != null)
			this.timerBegin();
		else
			this.timerEnd();
	}

	private function timerBegin():Void
	{
		clearInterval(this._timer);
		this._timer = setInterval(this._refresh_meter, 300);

		this.refresh_meter();
		this._meter.present();

		this.rouse();
	}

	private function timerEnd():Void
	{
		clearInterval(this._timer);
		this._timer = null;

		this.refresh_meter();
		this._meter.dismiss();

		this.sleep();
	}

	private function refresh_meter():Void
	{
		var tag:BuffData = this._character.m_InvisibleBuffList[DodgeGauge.TAG_DODGE];

		var t:Number = UtilsBase.GetNormalTime() * 1000;
		var value:Number = (tag != null)
			? 1.0 - ((tag.m_TotalTime - t) / tag.m_RemainingTime)
			: 1.0;

		if (value == this._meter.getMeter())
			return;

		TweenMax.fromTo(this._meter, (tag.m_TotalTime - t) / 1000, {
			setMeter: value
		}, {
			setMeter: 1.0,
			ease: Linear.easeNone
		});
	}

	public function discard():Void
	{
		this._character.SignalInvisibleBuffAdded.Disconnect(this.character_onTag, this);
		this._character.SignalInvisibleBuffUpdated.Disconnect(this.character_onTag, this);
		this._character.SignalBuffRemoved.Disconnect(this.character_onTag, this);

		CharacterBase.SignalClientCharacterAlive.Disconnect(this.character_onEnter, this);

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

		this.sleep();
	}

	private function character_onEnter():Void
	{
		this.refresh_timer();
	}

	private function character_onTag(which:Number):Void
	{
		if (which != DodgeGauge.TAG_DODGE)
			return;

		this.refresh_timer();
	}
}
