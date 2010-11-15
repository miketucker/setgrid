package com.mt.assets {
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import com.mt.model.AbstractModel;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author mikebook
	 */
	public class SoundAsset extends EventDispatcher {
		public var volume:Number;
		public var type:String;
		public var id:String;
		private var _data:LoadingItem;
		public static const TYPE_LOOP:String = "loop";
		public static const TYPE_EFFECT:String = "effect";
		
		public function SoundAsset(){
			
		}
		
		public function get loaded():Boolean{
			return data.isLoaded;
		}
		
		public function get data() : LoadingItem {
			
			return _data;
		}
		
		public function set data(data : LoadingItem) : void {
			_data = data;
			AbstractModel.asset.get(_data.id).addEventListener(Event.COMPLETE, eventComplete);
			_data.addEventListener(LoadingItem.STATUS_FINISHED, eventComplete);
		}
		
		private function eventComplete(event : Event) : void {
			AbstractModel.debug.log('sound load '+_data.id);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
