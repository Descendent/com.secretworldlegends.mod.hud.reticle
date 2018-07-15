import flash.filters.BlurFilter;

import com.GameInterface.Game.Character;
import com.Utils.ID32;

import descendent.hud.reticle.Deg;
import descendent.hud.reticle.Gauge;

class descendent.hud.reticle.Callout extends Gauge
{
	private var _w:Number;

	private var _label:TextField;

	private var _label_backing:TextField;

	private var _subject:Character;

	public function Callout(w:Number)
	{
		super();

		this._w = w;
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
		style.size = 12.0;
		style.align = "center";

		var a:TextField = this.content.createTextField("", this.content.getNextHighestDepth(),
			0.0, 0.0, 0.0, 0.0);
		a.setNewTextFormat(style);
		a.textColor = 0x000000;
		a.autoSize = "none";
		a.embedFonts = true;
		a.mouseWheelEnabled = false;
		a.selectable = false;

		var o:TextField = this.content.createTextField("", this.content.getNextHighestDepth(),
			0.0, 0.0, 0.0, 0.0);
		o.setNewTextFormat(style);
		o.textColor = 0xFFFFFF;
		o.autoSize = "center";
		o.embedFonts = true;
		o.mouseWheelEnabled = false;
		o.selectable = false;

		o.text = " ";
		var h:Number = o._height;
		o.text = "";

		o.autoSize = "none";
		o._width = this._w;
		o._height = h;
		o._x = 0.0 - (o._width / 2.0);
		o._y = 0.0 - (o._height / 2.0);

		a._width = o._width;
		a._height = o._height;

		var d:Number = 2.0 * Math.sin(Deg.getRad(45.0));
		a._x = o._x + d;
		a._y = o._y + d;
		a.filters = [new BlurFilter(2.0, 2.0, 3)];

		this._label = o;
		this._label_backing = a;
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

		this._subject.ConnectToCommandQueue();
	}

	private function labelBegin(label:String):Void
	{
		var value:String = label;
		this._label.text = value;

		while ((this._label.textWidth > this._label._width)
			&& (value.length != 0))
		{
			value = value.substring(0, value.length - 1);
			this._label.text = value + "...";
		}

		this._label._visible = true;

		this._label_backing.text = this._label.text;
		this._label_backing._visible = true;
	}

	private function labelEnd():Void
	{
		this._label._visible = false;
		this._label.text = "";

		this._label_backing._visible = false;
		this._label_backing.text = "";
	}

	public function discard():Void
	{
		this.discard_subject();

		super.discard();
	}

	private function discard_subject():Void
	{
		if (this._subject == null)
			return;

		this._subject.SignalCommandStarted.Disconnect(this.subject_onUsingBegin, this);
        this._subject.SignalCommandAborted.Disconnect(this.subject_onUsingEnd, this);
        this._subject.SignalCommandEnded.Disconnect(this.subject_onUsingEnd, this);

		this._subject = null;

		this.subject_onUsingEnd();
	}

	private function subject_onUsingBegin(label:String, direction:Number, uninterruptible:Boolean):Void
	{
		this.labelBegin(label);
	}

	private function subject_onUsingEnd():Void
	{
		this.labelEnd();
	}
}
