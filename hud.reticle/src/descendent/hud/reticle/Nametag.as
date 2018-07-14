import flash.filters.BlurFilter;

import com.GameInterface.DistributedValue;
import com.GameInterface.Game.Character;
import com.GameInterface.Game.Dynel;
import com.GameInterface.Lore;
import com.GameInterface.Nametags;
import com.Utils.Colors;
import com.Utils.ID32;
import com.Utils.LDBFormat;

import descendent.hud.reticle.Deg;
import descendent.hud.reticle.Gauge;

class descendent.hud.reticle.Nametag extends Gauge
{
	private var _label:TextField;

	private var _label_backing:TextField;

	private var _title:TextField;

	private var _title_backing:TextField;

	private var _cabal:TextField;

	private var _cabal_backing:TextField;

	private var _level:TextField;

	private var _level_backing:TextField;

	private var _dynel:Dynel;

	private var _character:Character;

	public function Nametag()
	{
		super();
	}

	public function setSubject(value:Dynel):Void
	{
		if (value == null)
		{
			if (this._dynel == null)
				return;
		}
		else
		{
			var which:ID32 = value.GetID();

			if ((this._dynel != null)
				&& (which.Equal(this._dynel.GetID())))
			{
				return;
			}

			if (which.IsNull())
				value = null;
		}

		this.discard_dynel();
		this.prepare_dynel(value);
	}

	public function prepare(o:MovieClip):Void
	{
		super.prepare(o);

		this.prepare_label();
		this.prepare_title();
		this.prepare_cabal();
		this.prepare_level();
	}

	private function prepare_label():Void
	{
		var style:TextFormat = new TextFormat();
		style.font = "_StandardFont";
		style.bold = true;
		style.size = 16.0;
		style.align = "center";

		var a:TextField = this.content.createTextField("", this.content.getNextHighestDepth(),
			0.0, 0.0, 0.0, 0.0);
		a.setNewTextFormat(style);
		a.textColor = 0x000000;
		a.autoSize = "center";
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
		o._y = 0.0 - (o._height / 2.0);
		o.text = "";

		var d:Number = 2.0 * Math.sin(Deg.getRad(45.0));
		a._x = o._x + d;
		a._y = o._y + d;
		a.filters = [new BlurFilter(2.0, 2.0, 3)];

		this._label = o;
		this._label_backing = a;
	}

	private function prepare_title():Void
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
		a.autoSize = "center";
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
		o._y = -16.0 - (o._height / 2.0);
		o.text = "";

		var d:Number = 2.0 * Math.sin(Deg.getRad(45.0));
		a._x = o._x + d;
		a._y = o._y + d;
		a.filters = [new BlurFilter(2.0, 2.0, 3)];

		this._title = o;
		this._title_backing = a;
	}

	private function prepare_cabal():Void
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
		a.autoSize = "center";
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
		o._y = 16.0 - (o._height / 2.0);
		o.text = "";

		var d:Number = 2.0 * Math.sin(Deg.getRad(45.0));
		a._x = o._x + d;
		a._y = o._y + d;
		a.filters = [new BlurFilter(2.0, 2.0, 3)];

		this._cabal = o;
		this._cabal_backing = a;
	}

	private function prepare_level():Void
	{
		var style:TextFormat = new TextFormat();
		style.font = "_StandardFont";
		style.bold = true;
		style.size = 12.0;
		style.align = "left";

		var a:TextField = this.content.createTextField("", this.content.getNextHighestDepth(),
			0.0, 0.0, 0.0, 0.0);
		a.setNewTextFormat(style);
		a.textColor = 0x000000;
		a.autoSize = "left";
		a.embedFonts = true;
		a.mouseWheelEnabled = false;
		a.selectable = false;

		var o:TextField = this.content.createTextField("", this.content.getNextHighestDepth(),
			0.0, 0.0, 0.0, 0.0);
		o.setNewTextFormat(style);
		o.textColor = 0xFFFFFF;
		o.autoSize = "left";
		o.embedFonts = true;
		o.mouseWheelEnabled = false;
		o.selectable = false;

		o.text = " ";
		o._y = this._label._y;
		o.text = "";

		var d:Number = 2.0 * Math.sin(Deg.getRad(45.0));
		a._x = o._x + d;
		a._y = o._y + d;
		a.filters = [new BlurFilter(2.0, 2.0, 3)];

		this._level = o;
		this._level_backing = a;
	}

	private function prepare_dynel(dynel:Dynel):Void
	{
		if (dynel == null)
			return;

		var which:ID32 = dynel.GetID();

		if ((which.GetType() != _global.Enums.TypeID.e_Type_GC_Character)
			&& (which.GetType() != _global.Enums.TypeID.e_Type_GC_Destructible))
		{
			return;
		}

		this._dynel = dynel;
		this._character = Character.GetCharacter(dynel.GetID());

		this.refresh_label();
		this.refresh_color();
		this.refresh_title();
		this.refresh_cabal();
		this.refresh_level();

		this._dynel.SignalStatChanged.Connect(this.dynel_onValue, this);
	}

	private function refresh_label():Void
	{
		this._label._visible = false;
		this._label.text = "";

		this._label_backing._visible = false;
		this._label_backing.text = "";

		if (this._dynel == null)
			return;

		var which:ID32 = this._dynel.GetID();
		var label:String = LDBFormat.Translate(this._dynel.GetName());

		var value:String;
		if ((which.IsPlayer())
			&& (DistributedValue.GetDValue("ShowNametagFullName", 0)))
		{
			value = this._character.GetFirstName() + " \"" + label + "\" " + this._character.GetLastName();
		}
		else if ((which.IsNpc())
			&& (this._dynel.IsDead()))
		{
			value = LDBFormat.Printf(LDBFormat.LDBGetText("Gamecode", "CorpseOfMonsterName"), label);
		}
		else
		{
			value = label;
		}

		this._label.text = value;
		this._label._visible = true;

		this._label_backing.text = value;
		this._label_backing._visible = true;
	}

	private function refresh_color():Void
	{
		if (this._dynel == null)
			return;

		var color:Number = Colors.GetNametagColor(this._dynel.GetNametagCategory(), Nametags.GetAggroStanding(this._dynel.GetID()));

		this._label.textColor = color;
	}

	private function refresh_title():Void
	{
		this._title._visible = false;
		this._title.text = "";

		this._title_backing._visible = false;
		this._title_backing.text = "";

		if (this._dynel == null)
			return;

		if (!DistributedValue.GetDValue("ShowNametagTitle", false))
			return;

		var title:Number = this._character.GetStat(_global.Enums.Stat.e_SelectedTag);

		if (title == 0)
			return;

		var value:String = Lore.GetTagName(title);

		this._title.text = value;
		this._title._visible = true;

		this._title_backing.text = value;
		this._title_backing._visible = true;
	}

	private function refresh_cabal():Void
	{
		this._cabal._visible = false;
		this._cabal.text = "";

		this._cabal_backing._visible = false;
		this._cabal_backing.text = "";

		if (this._dynel == null)
			return;

		if (!DistributedValue.GetDValue("ShowNametagGuild", false))
			return;

		var cabal:String = this._character.GetGuildName();

		if (cabal == null)
			return;

		if (cabal == "")
			return;

		var value:String = "<" + cabal + ">";

		this._cabal.text = value;
		this._cabal._visible = true;

		this._cabal_backing.text = value;
		this._cabal_backing._visible = true;
	}

	private function refresh_level():Void
	{
		this._level._visible = false;
		this._level.text = "";

		this._level_backing._visible = false;
		this._level_backing.text = "";

		if (this._dynel == null)
			return;

		var level:String = this._dynel.GetStat(_global.Enums.Stat.e_Level);

		if (level == 0)
			return;

		var value:String;
		if (this._character.IsBoss())
			value = level + "*";
		else
			value = level;

		var color:Number;
		if (this._dynel.IsEnemy())
		{
			var delta:Number = this._dynel.GetStat(_global.Enums.Stat.e_Level, 2) - Character.GetClientCharacter().GetStat(_global.Enums.Stat.e_Level, 2);

			if (delta <= -10)
				color = 0xB88ECD;
			else if (delta <= -2)
				color = 0x06F6FF;
			else if (delta <= 0)
				color = 0xFFFFFF;
			else if (delta <= 2)
				color = 0xFFF666;
			else
				color = 0xFF0000;
		}
		else
		{
			color = 0xFFFFFF;
		}

		this._level.textColor = color;
		this._level.text = value;
		this._level._x = this._label._x + this._label._width;
		this._level._visible = true;

		this._level_backing.text = value;
		this._level_backing._x = this._level._x + 1.0;
		this._level_backing._visible = true;
	}

	private function refresh_dynel():Void
	{
		var dynel:Dynel = this._dynel;

		this.discard_dynel();
		this.prepare_dynel(dynel);
	}

	public function discard():Void
	{
		this.discard_dynel();

		super.discard();
	}

	private function discard_dynel():Void
	{
		if (this._dynel == null)
			return;

		this._dynel.SignalStatChanged.Disconnect(this.dynel_onValue, this);

		this._dynel = null;
		this._character = null;

		this.refresh_label();
		this.refresh_title();
		this.refresh_cabal();
		this.refresh_level();
	}

	private function dynel_onValue(which:Number):Void
	{
		if (which == _global.Enums.Stat.e_GmLevel)
			this.refresh_dynel();
		else if (which == _global.Enums.Stat.e_PlayerFaction)
			this.refresh_dynel();
		else if (which == _global.Enums.Stat.e_Side)
			this.refresh_dynel();
		else if (which == _global.Enums.Stat.e_CarsGroup)
			this.refresh_dynel();
		else if (which == _global.Enums.Stat.e_RankTag)
			this.refresh_dynel();
		else if (which == _global.Enums.Stat.e_VeteranMonths)
			this.refresh_dynel();
	}
}
