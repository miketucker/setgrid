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
		private static const HEIGHT : int = 20;
		private static const WIDTH : int = 600;

		public function Notes() {
			Model.notes = this;
			
			addChild(container = new Sprite());
			container.graphics.lineStyle(1);
			container.graphics.beginFill(0xFFFFFF);
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
			obj.color="#000000";
			obj.fontFamily="Monaco";
			obj.fontSize="9px";
			obj.leading="2px";
			
			style.setStyle("p", obj);			
			
			obj = new Object();
			obj.color="#0000FF";
			obj.fontFamily="Monaco";
			obj.fontSize="9px";
			obj.leading="2px";
			//obj.textDecoration = "underline";

			style.setStyle("a", obj);			
			t.cacheAsBitmap = true;
			t.styleSheet = style;
			t.antiAliasType = AntiAliasType.ADVANCED;
			t.embedFonts = true;
			t.text = "blah blah blah";
			t.selectable = false;
			t.multiline = true;
			t.wordWrap = true;
			t.width = width - PAD * 2;
			t.height = height - PAD * 2;
			
			t.x = t.y = PAD;
			t.autoSize = TextFieldAutoSize.LEFT;
			resize();
			close(0);
			visible = false;
		}
		
		override public function resize():void{
			x = stage.stageWidth - WIDTH + 1;
			y = stage.stageHeight - HEIGHT + 1;
			y -= Model.navBar.height;
		}

		public function set text(str:String):void{
			if(str){
				t.htmlText = "<p>"+str+ "</p>";
				open();
			} else {
				t.htmlText = "";
				close();
			}
		}
		
		private function close(time:Number=1) : void {
			TweenLite.to(container,time,{y:HEIGHT});
		}
		
		private function open() : void {
			opened = true;
			TweenLite.to(container,1,{y:0});
		}
	}
}
