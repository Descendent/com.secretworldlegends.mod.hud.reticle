import flash.geom.Point;
import flash.geom.Rectangle;

import mx.utils.Delegate;

import com.GameInterface.DistributedValue;
import com.Utils.Archive;
import GUIFramework.SFClipLoader;

import com.greensock.plugins.ColorTransformPlugin;
import com.greensock.plugins.TweenPlugin;

import descendent.hud.reticle.Hud;

class descendent.hud.reticle.App
{
	private static var OPT_NAMESPACE:String = "descendent_hud_reticle_";

	private static var SCALE_H:Number = 1080.0;

	private var _content:MovieClip;

	private var _hud:Hud;

	private var _opt_scale:DistributedValue;

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

		this._opt_scale = DistributedValue.Create(App.OPT_NAMESPACE + "scale");
		this._opt_scale.SignalChanged.Connect(this.rescale, this);

		SFClipLoader.SignalDisplayResolutionChanged.Connect(this.rescale, this);

		this.rescale();
	}

	private function discard():Void
	{
		SFClipLoader.SignalDisplayResolutionChanged.Disconnect(this.rescale, this);

		this._opt_scale.SignalChanged.Disconnect(this.rescale, this);
		this._opt_scale = null;

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

		var k:Number = (display.height / App.SCALE_H) * (this._opt_scale.GetValue() / 100.0) * 100;
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
		this._opt_scale.SetValue(archive.FindEntry("scale", 100));

		this.present();
	}

	private function content_onDismiss():Archive
	{
		this.dismiss();

		var archive:Archive = new Archive();
		archive.AddEntry("scale", this._opt_scale.GetValue());

		return archive;
	}
}
