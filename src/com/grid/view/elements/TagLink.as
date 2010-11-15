package com.grid.view.elements {
	import com.grid.model.Model;
	import com.grid.view.Bar;

	import flash.display.Sprite;

	/**
	 * @author mikebook
	 */
	public class TagLink extends Sprite {
		private var text : Label;
		private var textCount : Label;
		private static const PAD : Number = 1;
		private var _count : int = 0;
		private var _total : int;
		private var active : Boolean;

		public function TagLink(str : String,total : int) {
			_total = total;
			name = str;
			/*
			addChild(bg = new Shape());
			bg.graphics.beginFill(0xFFFFFF,1);
			bg.graphics.drawRect(0, 2,  Model.BAR_WIDTH - Bar.MARGIN_LEFT*2, 10);
			 */
			addChild( text = new Label( str , Model.TEXT_COLOR ) );
			//addChild( textCount = new Label( "0-0" , Model.TEXT_COLOR , TextFormatAlign.RIGHT , false ) );
			//textCount.x = Model.BAR_WIDTH - Bar.MARGIN_LEFT;
			if(textCount) textCount.width = Model.BAR_WIDTH - Bar.MARGIN_LEFT * 2;
			text.x = PAD;
			buttonMode = true;
			mouseChildren = false;
			count = 0;

			deselect( );
			
			unhighlight( );
		}

		public function highlight() : void {
			alpha = 1;
		}

		public function dim() : void {
			alpha = Model.LINK_ALPHA_DIM;
		}

		public function unhighlight() : void {
			alpha = Model.LINK_ALPHA_UNHIGHLIGHT;
		}

		public function deselect() : void {
			if(textCount) textCount.visible = false;
			active = false;
		}

		public function mouseOver() : void {
			highlight( );
			if(textCount) textCount.visible = true;
		}

		public function mouseOut() : void {
			unhighlight( );
			if(textCount) textCount.visible = false;
		}

		public function select() : void {
			if(active) count = count + 1;
			if(count >= _total) count = 0;
			if(textCount) textCount.visible = true;			
			active = true;
			highlight( );
			if(name == Model.image.TAG_ALL) Model.app.wall.selectByTag( "" , count );
			else Model.app.wall.selectByTag( name , count );
		}

		public function get count() : int {
			return _count;
		}

		public function set count(i : int) : void {
			_count = i;
			var str : String = int( i + 1 ).toString( ) + ' - ' + _total.toString( );
			if(textCount) textCount.text = str;
		}
	}
}
