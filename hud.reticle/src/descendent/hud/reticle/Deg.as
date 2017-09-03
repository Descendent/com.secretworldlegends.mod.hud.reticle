class descendent.hud.reticle.Deg
{
	private static var DEG_RAD:Number = (1.0 / 360.0) * (2.0 * Math.PI);

	private function Deg()
	{
	}

	public static function getRad(deg:Number):Number
	{
		return deg * Deg.DEG_RAD;
	}
}
