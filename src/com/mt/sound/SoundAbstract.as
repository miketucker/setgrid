package com.mt.sound {
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import com.greensock.TweenLite;
	import com.mt.assets.SoundAsset;
	import com.mt.model.AbstractModel;

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * @author mikebook
	 */
	public class SoundAbstract {
		
		protected var channel:SoundChannel;
		protected var transform:SoundTransform;
		protected var sound:Sound;		
		protected var loops:int = 0;
		protected var fadeTime:Number = 10;
		protected var volume:Number;
		protected var asset:SoundAsset;
		protected var _id:String;
		private var _fade:Boolean = false;
		protected var _mute:Boolean;
		private var loadingItem : LoadingItem;

		public function SoundAbstract(value:String):void{
			transform = new SoundTransform();
			loadingItem = AbstractModel.asset.get(value);
			fadeTime = AbstractModel.sound.soundFadeTime;
			_id = value;
			volume = asset.volume;
		}
		
		public function play(fade:Boolean=false):void{
			_fade = fade;
			if(asset.loaded) 
				sound = Sound(asset.data.content);
			else{
				asset.addEventListener(Event.COMPLETE, eventLoaded);
				return;
			}
				
			
			if(sound){
			
				if(fade){
					transform.volume = 0;
					channel = sound.play(0,loops,transform);				
					TweenLite.to(transform, fadeTime, {onUpdate:updateChannel,volume:volume});
				} else {
					transform.volume = volume;
					channel = sound.play(0,loops,transform);
				}
			} else {
				trace('sound not loaded or found');
			}
		}
		
		private function eventLoaded(event : Event) : void {
			AbstractModel.debug.log('sound loaded '+this+' '+AbstractModel.sound.currentLoop);
			if(this == AbstractModel.sound.currentLoop) play(_fade);
		}

		public function stop(fade:Boolean=false):void{
			if(!channel) return;
			
			if(fade){
				TweenLite.to(transform, fadeTime, {volume:0, onUpdate:updateChannel, onComplete:function():void{
					channel.stop();
				}});
			} else {
				channel.stop();
			}
		}
		
		public function set mute(value:Boolean):void{
			_mute = value;
			transform.volume = (value) ? 0 : volume;
			updateChannel(true);
		}
		

		protected function updateChannel(force:Boolean=false):void{
			if(channel && (!_mute || force))
 			channel.soundTransform = transform;
		}
		
		public function get id() : String {
			return _id;
		}		
	}
}
