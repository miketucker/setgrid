package com.mt.view {
	import com.mt.model.AbstractModel;
	import com.mt.view.elements.AbstractView;

	import flash.events.Event;

	/**
	 * @author mikepro
	 */
	public class MainView extends AbstractView {
		public function MainView() {
			AbstractModel.view.main = this;
		}
		
		override public function resize() : void {
			dispatchEvent(new Event(Event.RESIZE));
		}
	}
}
