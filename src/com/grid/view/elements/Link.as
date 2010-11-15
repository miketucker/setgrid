package com.grid.view.elements {
	import com.grid.model.Model;

	import flash.events.MouseEvent;

	/**
	 * @author mikebook
	 */
	public class Link extends Label {
		public function Link(str : String) {
			super( str ,Model.TEXT_COLOR );
			unhighlight( );
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_OVER,eOver );
			addEventListener(MouseEvent.MOUSE_OUT,eOut );
		}
		
		private function eOut(event : MouseEvent) : void {
			unhighlight();
		}

		private function eOver(event : MouseEvent) : void {
			highlight();
		}

		public function unhighlight() : void {
			alpha = Model.LINK_ALPHA_UNHIGHLIGHT;
		}
		
		public function dim() : void {
			alpha = Model.LINK_ALPHA_DIM;
		}		
		
		public function highlight() : void {
			alpha = 1;
		}
	}
}
