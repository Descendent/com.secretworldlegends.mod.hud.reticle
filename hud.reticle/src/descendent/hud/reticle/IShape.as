import flash.geom.Point;

interface descendent.hud.reticle.IShape
{
	function getTranslation():Point;
	function setTranslation(value:Point):Void;

	function getOrientation():Number;
	function setOrientation(value:Number):Void;

	function getScale():Point;
	function setScale(value:Point):Void;

	function getAlpha():Number;
	function setAlpha(value:Number):Void;

	function prepare(o:MovieClip):Void;

	function discard():Void;

	function present():Void;

	function dismiss():Void;
}
