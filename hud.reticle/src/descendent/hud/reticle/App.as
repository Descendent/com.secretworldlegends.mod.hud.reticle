import flash.geom.Point;
import flash.geom.Rectangle;

import mx.utils.Delegate;

import com.Utils.Archive;
import GUIFramework.SFClipLoader;

import com.greensock.plugins.ColorTransformPlugin;
import com.greensock.plugins.TweenPlugin;

import descendent.hud.reticle.Hud;

class descendent.hud.reticle.App
{
	private var _content:MovieClip;

	private var _archive:Archive;

	private var _hud:Hud;

	public function App(content:MovieClip)
	{
		this._content = content;
		this._content._visible = false;

		TweenPlugin.activate([ColorTransformPlugin]);

		this._content.onLoad = Delegate.create(this, this.content_onPrepare);
		this._content.OnUnload = Delegate.create(this, this.content_onDiscard);
		this._content.OnModuleActivated = Delegate.create(this, this.content_onPresent);
		this._content.OnModuleDeactivated = Delegate.create(this, this.content_onDismiss);
	}

	private function prepare():Void
	{
		this._hud = new Hud();
		this._hud.prepare(this._content);

		this.rescale();
		SFClipLoader.SignalDisplayResolutionChanged.Connect(this.rescale, this);
	}

	private function discard():Void
	{
		SFClipLoader.SignalDisplayResolutionChanged.Disconnect(this.rescale, this);

		this._hud.discard();
		this._hud = null;
	}

	private function present():Void
	{
		this._content._visible = true;
	}

	private function dismiss():Void
	{
		this._content._visible = false;
	}

	private function rescale():Void
	{
		var display:Rectangle = Stage["visibleRect"];

		this._hud.setTranslation(new Point(display.width * 0.5, display.height * 0.5));

		var k:Number = (display.height / 1080.0) * 100;
		this._hud.setScale(new Point(k, k));
	}

	private function content_onPrepare():Void
	{
		this.prepare();
	}

	private function content_onDiscard():Void
	{
		this.discard();
	}

	private function content_onPresent(archive:Archive):Void
	{
		this._archive = archive;

		this.present();
	}

	private function content_onDismiss():Archive
	{
		this.dismiss();

		return this._archive;
	}
}
