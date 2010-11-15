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

		public function Label(str:String,color:uint=0x999999,align:String="left",autoSize:Boolean=true) {
			addChild(t = new TextField());
			tf = new TextFormat( );
			name = str;
			tf.font = Model.FONT_NAME;
			tf.align = align;
			_align = align;
			tf.color = color;
			tf.size = 9;
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
		}
		
		public function get textFormat():TextFormat{
			return tf;
		}
		
		public function get text():String{
			return t.text;
		}
		
		public function set text(str:String):void{
			t.text = str;
			if(_autoSize) t.autoSize = _align;
			//t.autoSize = TextFieldAutoSize.LEFT;
		}
	}
}
