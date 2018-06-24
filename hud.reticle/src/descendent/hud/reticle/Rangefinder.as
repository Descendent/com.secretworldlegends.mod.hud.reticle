import flash.filters.BlurFilter;

import mx.utils.Delegate;

import com.GameInterface.Game.Dynel;
import com.Utils.Format;
import com.Utils.ID32;

import descendent.hud.reticle.Deg;
import descendent.hud.reticle.Gauge;

class descendent.hud.reticle.Rangefinder extends Gauge
{
	private var _label:TextField;

	private var _label_backing:TextField;

	private var _dynel:Dynel;

	private var _timer:Number;

	private var _refresh_label:Function;

	public function Rangefinder()
	{
		super();

		this._refresh_label = Delegate.create(this, this.refresh_label);
	}

	public function setSubject(value:Dynel):Void
	{
		if (value == this._dynel)
			return;

		this.discard_dynel();
		this.prepare_dynel(value);
	}

	public function prepare(o:MovieClip):Void
	{
		super.prepare(o);

		this.prepare_label();
	}

	private function prepare_label():Void
	{
		var style:TextFormat = new TextFormat();
		style.font = "_StandardFont";
		style.bold = true;
		style.size = 10.0;
		style.align = "right";

		var a:TextField = this.content.createTextField("", this.content.getNextHighestDepth(),
			0.0, 0.0, 0.0, 0.0);
		a.setNewTextFormat(style);
		a.textColor = 0x000000;
		a.autoSize = "right";
		a.embedFonts = true;
		a.mouseWheelEnabled = false;
		a.selectable = false;

		var o:TextField = this.content.createTextField("", this.content.getNextHighestDepth(),
			0.0, 0.0, 0.0, 0.0);
		o.setNewTextFormat(style);
		o.textColor = 0xFFFFFF;
		o.autoSize = "right";
		o.embedFonts = true;
		o.mouseWheelEnabled = false;
		o.selectable = false;

		o.text = " ";
		o._y = 0.0 - (o._height / 2.0);
		o.text = "";

		var d:Number = 2.0 * Math.sin(Deg.getRad(45.0));
		a._x = o._x + d;
		a._y = o._y + d;
		a.filters = [new BlurFilter(2.0, 2.0, 3)];

		this._label = o;
		this._label_backing = a;
	}

	private function prepare_dynel(dynel:Dynel):Void
	{
		if (dynel == null)
			return;

		this._dynel = dynel;

		var which:ID32 = dynel.GetID();

		if ((which.GetType() != _global.Enums.TypeID.e_Type_GC_Character)
			&& (which.GetType() != _global.Enums.TypeID.e_Type_GC_Destructible))
		{
			return;
		}

		this.timerBegin();
	}

	private function timerBegin():Void
	{
		clearInterval(this._timer);
		this._timer = setInterval(this._refresh_label, 100);

		this.refresh_label();
	}

	private function timerEnd():Void
	{
		clearInterval(this._timer);
		this._timer = null;

		this.refresh_label();
	}

	private function refresh_label():Void
	{
		this._label._visible = false;
		this._label.text = "";

		this._label_backing._visible = false;
		this._label_backing.text = "";

		if (this._dynel == null)
			return;

		var value:String = Format.Printf("%.1f", Math.round(this._dynel.GetDistanceToPlayer() * 10.0) / 10.0) + " m";

		this._label.text = value;
		this._label._visible = true;

		this._label_backing.text = value;
		this._label_backing._visible = true;
	}

	public function discard():Void
	{
		clearInterval(this._timer);

		this.discard_dynel();

		super.discard();
	}

	private function discard_dynel():Void
	{
		if (this._dynel == null)
			return;

		this._dynel = null;

		this.timerEnd();
	}
}
