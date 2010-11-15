package com.grid.view {
	import com.greensock.TweenLite;
	import com.mt.view.elements.AbstractView;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	/**
	 * @author mikebook
	 */
	public class Intro extends AbstractView {
		
		//[Embed(source="/intro.png")]
		private var img : Class;
		private var b : Bitmap;
		private var ds : DropShadowFilter;

		public function Intro() {
			addChild(b = new img());
			b.x = -.5 * b.width;
			b.y = -.5 * b.height;
			ds = new DropShadowFilter(0,0,0,.5,20,20,.3);
			filters = [ds];
			resize();
			stage.addEventListener(MouseEvent.CLICK, eClick );
			buttonMode = true;
		}
		
		private function eClick(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.CLICK, eClick );
			TweenLite.to(this,1,{alpha:0,onComplete:function():void{
				dispose();
			}} );
		}
		
		private function dispose() : void {
			parent.removeChild(this);
		}

		override public function resize():void{
			x = stage.stageWidth * .5;
			y = stage.stageHeight * .5;
		}
	}
}
