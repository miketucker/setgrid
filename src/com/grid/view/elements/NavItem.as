package 
com.grid.view.elements {
	import com.asual.swfaddress.SWFAddress;
	import com.grid.view.Image;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author mikebook
	 */
	public class NavItem extends Sprite {
		private var label : Label;
		private var img:Image;
		
		
		public function NavItem(image:Image,tag:String) {
			img = image;
			addChild(label = new Link(tag));
			buttonMode = true;
			addEventListener(MouseEvent.CLICK,eClick );
		}
		
		private function eClick(event : MouseEvent) : void {
			if(img && img.vo && img.vo.id) SWFAddress.setValue( img.vo.id.toString( ) );
		}
	}
}
