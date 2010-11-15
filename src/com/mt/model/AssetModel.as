package com.mt.model {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import flash.events.Event;

	/**
	 * @author mikepro
	 */
	public class AssetModel extends AbstractModel {

		private var _loader:BulkLoader;

		public function AssetModel() {
			name = 'AssetModel';
			_loader = new BulkLoader('loader',BulkLoader.DEFAULT_NUM_CONNECTIONS );
			_loader.addEventListener(Event.COMPLETE, eventLoaded);
			super();
		}
		
		public function get(value:String):LoadingItem{
			return _loader.get(value);
		}
		
		public function load(value:String,id:String=null,priority:int=3):LoadingItem{
			
			var ar:Array = value.split('/');
			if(!id) id = ar[ar.length-1];

			var li:LoadingItem = _loader.add(config.root + value,{id:id,priority:priority});
			AbstractModel.debug.log(name+'load '+id+' : '+value);
			if(!_loader.isRunning) _loader.start();
			return li;
		}
		
		private function eventLoaded(event : Event) : void {
			AbstractModel.debug.log(name+event);
		}
	}
}
