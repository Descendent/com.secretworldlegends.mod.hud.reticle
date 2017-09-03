import descendent.hud.reticle.App;

class descendent.hud.reticle.Bootstrap
{
	private static var _app:App;

	public static function main(content:MovieClip):Void
	{
		Bootstrap._app = new App(content);
	}

	private function Bootstrap()
	{
	}
}
