import caurina.transitions.Tweener;
import caurina.transitions.properties.ColorShortcuts;

class descendent.hud.reticle.TweenerSetup
{
	private function TweenerSetup()
	{
	}

	public static function run():Void
	{
		ColorShortcuts.init();

		Tweener.registerSpecialProperty("setMeter", TweenerSetup.getMeter, TweenerSetup.setMeter);
		Tweener.registerSpecialProperty("setAlpha", TweenerSetup.getAlpha, TweenerSetup.setAlpha);
		Tweener.registerSpecialProperty("setPending", TweenerSetup.getPending, TweenerSetup.setPending);
		Tweener.registerSpecialProperty("setGaugeAlpha", TweenerSetup.getGaugeAlpha, TweenerSetup.setGaugeAlpha);
	}

	private static function getMeter(o:Object):Number
	{
		return o.getMeter();
	}

	private static function setMeter(o:Object, value:Number):Void
	{
		o.setMeter(value);
	}

	private static function getAlpha(o:Object):Number
	{
		return o.getAlpha();
	}

	private static function setAlpha(o:Object, value:Number):Void
	{
		o.setAlpha(value);
	}

	private static function getPending(o:Object):Number
	{
		return o.getPending();
	}

	private static function setPending(o:Object, value:Number):Void
	{
		o.setPending(value);
	}

	private static function getGaugeAlpha(o:Object):Number
	{
		return o.getGaugeAlpha();
	}

	private static function setGaugeAlpha(o:Object, value:Number):Void
	{
		o.setGaugeAlpha(value);
	}
}
