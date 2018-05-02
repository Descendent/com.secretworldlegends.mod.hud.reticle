import flash.geom.Point;

import descendent.hud.reticle.IShape;

class descendent.hud.reticle.Shape implements IShape
{
	private var _content:MovieClip;

	private var _translation:Point;

	private var _orientation:Number;

	private var _scale:Point;

	private var _alpha:Number;

	private var _dismiss:Boolean;

	private function Shape()
	{
		this._translation = new Point(0.0, 0.0);
		this._orientation = 0.0;
		this._scale = new Point(100, 100);
		this._alpha = 100;
		this._dismiss = false;
	}

	private function get content():MovieClip
	{
		return this._content;
	}

	public function getTranslation():Point
	{
		return this._translation;
	}

	public function setTranslation(value:Point):Void
	{
		this._translation = value;

		if (this._content == null)
			return;

		this._content._x = this._translation.x;
		this._content._y = this._translation.y;
	}

	public function getOrientation():Number
	{
		return this._orientation;
	}

	public function setOrientation(value:Number):Void
	{
		this._orientation = value;

		if (this._content == null)
			return;

		this._content._rotation = this._orientation;
	}

	public function getScale():Point
	{
		return this._scale;
	}

	public function setScale(value:Point):Void
	{
		this._scale = value;

		if (this._content == null)
			return;

		this._content._xscale = this._scale.x;
		this._content._yscale = this._scale.y;
	}

	public function getAlpha():Number
	{
		return this._alpha;
	}

	public function setAlpha(value:Number):Void
	{
		this._alpha = value;

		if (this._content == null)
			return;

		this._content._alpha = value;
	}

	public function prepare(o:MovieClip):Void
	{
		this._content = o.createEmptyMovieClip("", o.getNextHighestDepth());

		this.setTranslation(this.getTranslation());
		this.setOrientation(this.getOrientation());
		this.setScale(this.getScale());
		this.setAlpha(this.getAlpha());

		if (this._dismiss)
			this.dismiss();
		else
			this.present();
	}

	public function discard():Void
	{
		this._content.removeMovieClip();
	}

	public function present():Void
	{
		this._dismiss = false;

		if (this._content == null)
			return;

		this._content._visible = !this._dismiss;
	}

	public function dismiss():Void
	{
		this._dismiss = true;

		if (this._content == null)
			return;

		this._content._visible = !this._dismiss;
	}
}
