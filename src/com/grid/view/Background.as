package com.grid.view {
	import com.grid.model.Model;
	import com.mt.view.elements.AbstractView;

	/**
	 * @author mikebook
	 */
	public class Background extends AbstractView {
		public function Background() {
			super( );
			graphics.beginFill( Model.backgroundColor , 1 );
			graphics.drawRect( 0 , 0 , 500 , 500 );
			resize( );
		}

		override public function resize() : void {
			width = stage.stageWidth;
			height = stage.stageHeight;
		}
	}
}
