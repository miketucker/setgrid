package com.mt.model {
	import com.mt.view.DebugView;
	import com.mt.view.MainView;

	import flash.display.Stage;

	/**
	 * @author mikepro
	 */
	public class ViewModel extends AbstractModel {
				
		public var stage:Stage;		
		private var _main:MainView;	
		public var debug:DebugView;
			
		public function ViewModel() {
			name = 'ViewModel';
			super();
		}
		
		public function get main() : MainView {
			return _main;
		}
		
		public function set main(main : MainView) : void {
			_main = main;
			
		}
		
	}
}
