class descendent.hud.reticle.Color
{
	private var _color:Number;

	private var _alpha:Number;

	public function Color(color:Number, alpha:Number)
	{
		this._color = color;
		this._alpha = alpha;
	}

	public function get color():Number
	{
		return this._color;
	}

	public function set color(value:Number):Void
	{
		this._color = value;
	}

	public function get alpha():Number
	{
		return this._alpha;
	}

	public function set alpha(value:Number):Void
	{
		this._alpha = value;
	}
}
