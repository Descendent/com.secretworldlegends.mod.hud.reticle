import flash.filters.DropShadowFilter;

import com.GameInterface.Game.Character;

import descendent.hud.reticle.Gauge;

class descendent.hud.reticle.Callout extends Gauge
{
	private var _w:Number;

	private var _label:TextField;

	private var _label_backing:TextField;

	private var _character:Character;

	public function Callout(w:Number)
	{
		super();

		this._w = w;
	}

	public function setSubject(value:Character):Void
	{
		if (value == this._character)
			return;

		this.discard_character();
		this.prepare_character(value);
	}

	public function prepare(o:MovieClip):Void
	{
		super.prepare(o);

		this.prepare_label();
	}

	private function prepare_label():Void
	{
		var style:TextFormat = new TextFormat();
		style.font = "res.Renner-Medium.ttf";
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
		a._x = o._x + 1.0;
		a._y = o._y + 1.0;

//		var f:Array = o.filters;
//		f.push(new DropShadowFilter(3.0, 45.0, 0x000000, 1.0, 3.0, 3.0, 1.0, 1, false, false, false));
//		o.filters = f;

		this._label = o;
		this._label_backing = a;
	}

	private function prepare_character(character:Character):Void
	{
		this._character = character;

		if (character == null)
			return;

		if (character.GetID().GetType() != _global.Enums.TypeID.e_Type_GC_Character)
		{
			this._character = null;

			return;
		}

		this._character.SignalCommandStarted.Connect(this.character_onUsingBegin, this);
        this._character.SignalCommandAborted.Connect(this.character_onUsingEnd, this);
        this._character.SignalCommandEnded.Connect(this.character_onUsingEnd, this);

		this._character.ConnectToCommandQueue();
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
		super.discard();

		this.discard_character();
	}

	private function discard_character():Void
	{
		if (this._character == null)
			return;

		this._character.SignalCommandStarted.Disconnect(this.character_onUsingBegin, this);
        this._character.SignalCommandAborted.Disconnect(this.character_onUsingEnd, this);
        this._character.SignalCommandEnded.Disconnect(this.character_onUsingEnd, this);

		this._character = null;

		this.character_onUsingEnd();
	}

	private function character_onUsingBegin(label:String, direction:Number, uninterruptible:Boolean):Void
	{
		this.labelBegin(label);
	}

	private function character_onUsingEnd():Void
	{
		this.labelEnd();
	}
}
