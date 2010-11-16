package com.grid.view {
	import com.greensock.TweenLite;
	import com.grid.model.Model;
	import com.mt.view.elements.AbstractView;

	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author mikebook
	 */
	public class Notes extends AbstractView {
		private var t : TextField;
		private var tf : TextFormat;
		private var style : StyleSheet;
		private static const PAD : int = 10;
		private var opened : Boolean;
		
		private var container : Sprite;
		private static const HEIGHT : int = 200;
		private static const WIDTH : int = 350;

		public function Notes() {
			Model.notes = this;
			
			addChild(container = new Sprite());
			//container.graphics.lineStyle(1);
			container.graphics.lineStyle(1,0x333333);
			container.graphics.beginFill(0x000000);
			container.graphics.drawRect(0, 0, WIDTH, HEIGHT);
			container.addChild(t = new TextField());
			
			tf = new TextFormat( );
			tf.font = Model.fontName;
			tf.align = TextFormatAlign.LEFT;
			tf.color = 0x000000;
			tf.size = Model.fontSize;
			tf.letterSpacing = .5;
			style = new StyleSheet();
			
			var obj:Object;
			obj = new Object();
			obj.color="#FFFFFF";
			obj.fontFamily= Model.fontName;
			obj.fontSize= "10px";
			obj.leading="2px";
			
			style.setStyle("p", obj);			
			
			obj = new Object();
			obj.color="#CCCCCC";
			obj.fontFamily= Model.fontName;
			obj.fontSize= "10px";
			obj.leading="2px";

			style.setStyle("a", obj);			
			t.cacheAsBitmap = true;
			t.styleSheet = style;
			t.antiAliasType = AntiAliasType.ADVANCED;
			t.embedFonts = true;
			t.selectable = false;
			t.multiline = true;
			t.wordWrap = true;
			t.width = width - PAD * 2;
			t.height = height - PAD * 2;
			
			t.x = t.y = PAD;
			t.autoSize = TextFieldAutoSize.LEFT;
			resize();
			//close(0);
			visible = false;
		}
		
		override public function resize():void{

		}

		public function set text(str:String):void{
			if(str){
				t.htmlText = "<p>"+str+ "</p>";
			} else {
				t.htmlText = "";
			}
		}
		
		public function close(time:Number=1) : void {
			if(!opened) return;
			visible = false;
			opened = false;
			//TweenLite.to(container,time,{y:-HEIGHT});
		}
		
		public function toggle():void{
			if(opened) close();
			else open();
		}
		
		public function open() : void {
			if(opened) return;
			visible = true;
			opened = true;
			//TweenLite.to(container,1,{y:0});
		}
	}
}
