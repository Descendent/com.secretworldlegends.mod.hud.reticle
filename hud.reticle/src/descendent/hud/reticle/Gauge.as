import com.Utils.Signal;

import descendent.hud.reticle.IGauge;
import descendent.hud.reticle.Shape;

class descendent.hud.reticle.Gauge extends Shape implements IGauge
{
	private var _awake:Boolean;

	private var _onRouse:Signal;

	private var _onSleep:Signal;

	public function Gauge()
	{
		super();

		this._awake = false;

		this._onRouse = new Signal();
		this._onSleep = new Signal();
	}

	public function get onRouse():Signal
	{
		return this._onRouse;
	}

	public function get onSleep():Signal
	{
		return this._onSleep;
	}

	private function sleep():Void
	{
		if (!this._awake)
			return;

		this._awake = false;

		this._onSleep.Emit();
	}

	private function rouse():Void
	{
		if (this._awake)
			return;

		this._awake = true;

		this._onRouse.Emit();
	}
}
