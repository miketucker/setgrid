package com.mt.model {
	import com.mt.sound.SoundEffect;
	import com.mt.sound.SoundLoop;

	/**
	 * @author mikebook
	 */
	public class SoundModel extends AbstractModel {
		private var _currentLoop:SoundLoop;
		private var _masterVolume:Number = 1;
		private var _mute : Boolean;

		public var soundFadeTime:Number = 5;

		public function SoundModel() {
			name = 'SoundModel';
		}
		
		public function playEffect(value:String):void{
			if(_mute) return;
			AbstractModel.debug.log(name+' playEffect '+value);
			var s:SoundEffect = new SoundEffect(value);
			s.play(false);
		}
		
		public function playLoop(value:String):void
		{
			if(currentLoop && value == currentLoop.id) return;
			var s:SoundLoop = new SoundLoop(value);
			
			AbstractModel.debug.log(name+' playLoop '+value);
			
			if(_currentLoop) _currentLoop.stop(true);
			if(_mute) s.mute = _mute;
			s.play(true);
			_currentLoop = s;
		}
		
		public function get masterVolume() : Number {
			return _masterVolume;
		}
		
		public function get mute() : Boolean {
			return _mute;
		}
		
		public function set mute(value : Boolean) : void {
			AbstractModel.debug.log(name+' mute '+value);
			_mute = value;
			
			if(currentLoop) currentLoop.mute = value;
		}
		
		public function get currentLoop() : SoundLoop {
			return _currentLoop;
		}
	}
}
