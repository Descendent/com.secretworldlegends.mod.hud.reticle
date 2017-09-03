import com.Utils.Signal;

import descendent.hud.reticle.IShape;

interface descendent.hud.reticle.IGauge extends IShape
{
	function get onRouse():Signal;

	function get onSleep():Signal;
}
