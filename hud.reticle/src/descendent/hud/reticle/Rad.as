class descendent.hud.reticle.Rad
{
	private static var RAD_DEG:Number = (1.0 / (2.0 * Math.PI)) * 360.0;

	private function Rad()
	{
	}

	public static function getDeg(rad:Number):Number
	{
		return rad * Rad.RAD_DEG;
	}
}
