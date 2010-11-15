package com.grid.view {
	import com.grid.view.elements.Label;
	import com.grid.vo.ImageVO;

	import flash.display.Sprite;

	/**
	 * @author mikebook
	 */
	public class Hover extends Sprite {
		private var label : Label;

		public function Hover() {
			addChild(label = new Label('',0x333333));
			mouseEnabled = false;
		}
		
		public function set text(val:String):void{
			label.text = val;
			visible = true;
			graphics.clear();
			graphics.beginFill(0xFFFFFF,1);
			graphics.drawRect(0, 0, label.width, label.height);
		}
		
		public function set vo(val:ImageVO):void{
			
			text = val.tagsAsString.toUpperCase();
		}
		
		public function hide():void{
			visible = false;
		}
		
	}
}
