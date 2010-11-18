package com.grid.view.elements {
	import com.grid.model.Model;

	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author mikebook
	 */
	public class Label extends Sprite {
		private var t : TextField;
		private var tf : TextFormat;
		private var _autoSize : Boolean;
		private var _align : String;
		private var _background : Boolean;
		private var _bgColor : uint = 0x000000;

		public function Label(str:String,color:uint=0x777777,align:String="left",autoSize:Boolean=true) {
			addChild(t = new TextField());
			tf = new TextFormat( );
			name = str;
			tf.font = Model.fontName;
			tf.align = align;
			_align = align;
			tf.color = color;
			tf.size = Model.fontSize;
			tf.letterSpacing = .5;
			t.defaultTextFormat = tf;
			t.antiAliasType = AntiAliasType.ADVANCED;
			t.embedFonts = true;
			t.text = str.toUpperCase();
			t.selectable = false;
			_autoSize = autoSize;
			if(_autoSize) t.autoSize = align;
			mouseChildren = false;
		}
		
		public function set background(val:Boolean):void{
			_background = val;
			drawBG();
		}
		
		private function drawBG():void{
			graphics.clear();
			if(!_background) return;
			graphics.beginFill(_bgColor,1);
			graphics.drawRect(0, 0, t.width, t.height);			
		}		
		
		public function set size(val:int):void{
			tf.size = val;
			t.defaultTextFormat = tf;
			t.text = t.text;
			drawBG();
		}
		
		
		override public function set width(value:Number):void{
			t.width = value;
		}
		
		override public function get width():Number{
			return t.width;
		}
		
		public function set align(val:String):void{
			tf.align = val;
			t.defaultTextFormat = tf;
			t.text = t.text;
			if(_autoSize) t.autoSize = _align;
			drawBG();
		}
		
		public function get textFormat():TextFormat{
			return tf;
		}
		
		public function get textField():TextField{
			return t;
		}
		
		public function get text():String{
			return t.text;
		}
		
		public function set text(str:String):void{
			t.text = str;
			if(_autoSize) t.autoSize = _align;
			drawBG();
		}

		public function get bgColor() : uint {
			return _bgColor;
		}

		public function set bgColor(val : uint) : void {
			_bgColor = val;
			drawBG();
		}
	}
}
