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
			stage.addEventListener(Event.ADDED_TO_STAGE, eResize );
			resize();
		}
		
		
		private function eResize(event : Event) : void {
			resize( );
		}
		
		public function resize() : void {
			// OVERRIDE IN EXTENDED CLASSES
		}
		
		override public function remove():void{
			stage.removeEventListener(Event.RESIZE, eResize );
			stage.removeEventListener(Event.ADDED_TO_STAGE, eResize );
			super.remove();
		}
		
		
		public function center(target:Sprite=null):void{
			if(!target) target = this;
			target.x = stage.stageWidth  * .5;
			target.y = stage.stageHeight * .5;
		}
	}
}
