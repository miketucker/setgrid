package com.mt.model {
	import com.mt.AbstractMainApp;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author mikepro
	 */
	public class AbstractModel extends EventDispatcher {
		
		protected static var _view:ViewModel;
		protected static var _asset:AssetModel;
		protected static var _debug:DebugModel;
		protected static var _sound:SoundModel;
		protected static var _app:AbstractMainApp;
		protected static var _stage:Stage;
		protected static var _dispatcher:EventDispatcher;
		protected static var _config : ConfigModel;
		protected var name: String;

		public function AbstractModel() {
			super();
			name = 'Model';
		}
		
		static public function get view() : ViewModel {
			if(!_view) _view = new ViewModel();
			return _view;
		}
		
		static public function get asset() : AssetModel {
			if(!_asset) _asset = new AssetModel();
			return _asset;
		}

		static public function get config() : ConfigModel {
			if(!_config) _config = new ConfigModel();
			return _config;
		}
		
		static public function get debug() : DebugModel {
			if(!_debug) _debug = new DebugModel();
			return _debug;
		}
		
		static public function get sound() : SoundModel {
			if(!_sound) _sound = new SoundModel();
			return _sound;
		}
		
		static public function get app() : AbstractMainApp {
			return _app;
		}
		
		static public function set app(value : AbstractMainApp) : void {
			_app = value;
			_stage = value.stage;
			_stage.addEventListener(Event.RESIZE, eventResize);
		}
		
		private static function eventResize(event : Event) : void {
			AbstractModel.debug.info('resize '+stage.stageWidth + ' '+stage.stageHeight);
			dispatcher.dispatchEvent(new Event(Event.RESIZE));
		}
		
		public static function addEventListener(type:String,listener:Function):void{
			dispatcher.addEventListener(type,listener);
		}
		
		static public function get stage() : Stage {
			return _stage;
		}
		
		private static function get dispatcher():EventDispatcher{
			if(!_dispatcher) _dispatcher = new EventDispatcher();
			return _dispatcher;
		}
		
	}
}
