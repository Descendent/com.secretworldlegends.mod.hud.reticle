import flash.geom.Point;
import flash.geom.Rectangle;

import mx.utils.Delegate;

import com.GameInterface.DistributedValue;
import com.Utils.Archive;

import descendent.hud.reticle.Hud;

class descendent.hud.reticle.App
{
	private var _content:MovieClip;

	private var _archive:Archive;

	private var _hud:Hud;

	private var _setting_GUIResolutionScale:DistributedValue;

	public function App(content:MovieClip)
	{
		this._content = content;
		this._content._visible = false;

		this._content.onLoad = Delegate.create(this, this.content_onPrepare);
		this._content.OnUnload = Delegate.create(this, this.content_onDiscard);
		this._content.OnModuleActivated = Delegate.create(this, this.content_onPresent);
		this._content.OnModuleDeactivated = Delegate.create(this, this.content_onDismiss);

		this._setting_GUIResolutionScale = DistributedValue.Create("GUIResolutionScale");
	}

	private function prepare():Void
	{
		var stage:Rectangle = Stage["visibleRect"];

		this._hud = new Hud();
		this._hud.setTranslation(new Point(stage.width * 0.5, stage.height * 0.5));
		this._hud.prepare(this._content);

		this.rescale();
		this._setting_GUIResolutionScale.SignalChanged.Connect(this.rescale, this);
	}

	private function discard():Void
	{
		this._setting_GUIResolutionScale.SignalChanged.Disconnect(this.rescale, this);

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
		this._hud.setScale(this._setting_GUIResolutionScale.GetValue());
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
