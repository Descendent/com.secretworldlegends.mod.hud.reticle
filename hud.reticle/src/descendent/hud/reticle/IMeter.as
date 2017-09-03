import descendent.hud.reticle.IShape;

interface descendent.hud.reticle.IMeter extends IShape
{
	function getMaximum():Number;
	function setMaximum(value:Number):Void;

	function getMeter():Number;
	function setMeter(value:Number):Void;

	function getNotch():/*Number*/Array;
	function setNotch(value:/*Number*/Array):Void;

	function pulseBegin():Void;

	function pulseEnd():Void;
}
