package com.mt.view.elements {
	import com.greensock.TweenLite;
	import com.mt.model.AbstractModel;

	import flash.display.Sprite;
	import flash.display.Stage;

	/**
	 * @author mikebook
	 */
	public class AbstractSprite extends Sprite {


		private var _fadeSpeed:Number = 0;
		
		public function AbstractSprite() {
		}
		
		public function show(time:Number=-1,callback:Function=null):void{
			visible = true;			
			if(time==-1) time = _fadeSpeed;
			if(callback==null) callback = function():void{};
			TweenLite.to(this,time,{alpha:1,onComplete:function():void{
				callback();
			}});
		}
		//

		public function hide(time:Number=-1,callback:Function=null):void{
			if(time==-1) time = _fadeSpeed;
			if(callback==null) callback = function():void{};
			TweenLite.to(this,time,{alpha:0,onComplete:function():void{
				visible = false;
				callback();
			}});
		}
		
		
		override public function get stage():Stage{
			return AbstractModel.stage;
		}
		
		public function log(value:String):void{
			AbstractModel.debug.log(value);
		}
		
		public function info(value:String):void{
			AbstractModel.debug.info(value);
		}		
	}
}
