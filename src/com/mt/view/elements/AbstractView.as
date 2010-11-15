package com.mt.view.elements {
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author mikebook
	 */
	public class AbstractView extends AbstractSprite {
		public function AbstractView() {
			super( );
			stage.addEventListener(Event.RESIZE, eResize );
		}
		
		
		private function eResize(event : Event) : void {
			resize( );
		}
		
		public function resize() : void {
			
		}
		
		
		public function center(target:Sprite=null):void{
			if(!target) target = this;
			target.x = stage.stageWidth  * .5;
			target.y = stage.stageHeight * .5;
		}
	}
}
