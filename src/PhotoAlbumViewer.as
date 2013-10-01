package  
{
	import com.gestureworks.cml.components.AlbumViewer;
	import com.gestureworks.cml.element.Graphic;
	import com.gestureworks.cml.element.TouchContainer;
	import com.gestureworks.cml.element.Video;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.events.GWGestureEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Jenny
	 */
	public class PhotoAlbumViewer extends AlbumViewer
	{		
		
		private var players:Array;
		private var timer:Timer;
		private var _resetTime:Number = 0;
		private var _videoScrollAction:String = "pause";
		private var _playOnComplete:Boolean = false;
		
		public function PhotoAlbumViewer() 
		{
			super();
			addEventListener(GWGestureEvent.MANIPULATE, updateAngle);
		}
		
		override public function init():void 
		{
			super.init();
			addEventListener(TouchEvent.TOUCH_BEGIN, resetTimer);
			front.addEventListener(TouchEvent.TOUCH_BEGIN, resetTimer);
			back.addEventListener(TouchEvent.TOUCH_BEGIN, resetTimer);
			
			var f:Function = videoScrollAction == "stop" ? stop : pause;
			front.addEventListener(StateEvent.CHANGE, f);			
			players = front.childList.getCSSClass("player").getValueArray();

			if (playOnComplete)
				front.addEventListener(StateEvent.CHANGE, play);
			else{
				for each(var player:TouchContainer in players)
					player.addEventListener(GWGestureEvent.TAP, play);			
			}

			for each(var video:Video in front.searchChildren(Video, Array))
				video.addEventListener(StateEvent.CHANGE, resetVideo);
				
			if (resetTime)
			{
				timer = new Timer(resetTime * 1000);	
				timer.start();
				timer.addEventListener(TimerEvent.TIMER, timeExpired);			
			}			
		}
		
		override public function displayComplete():void 
		{
			super.displayComplete();
			init();						
		}
		
		public function get resetTime():Number { return _resetTime; }
		public function set resetTime(t:Number):void
		{
			_resetTime = t;
		}
		
		public function get videoScrollAction():String { return _videoScrollAction; }
		public function set videoScrollAction(a:String):void
		{
			_videoScrollAction = a;
		}
		
		public function get playOnComplete():Boolean { return _playOnComplete; }
		public function set playOnComplete(p:Boolean):void
		{
			_playOnComplete = p;
		}
		
		/**
		 * Play the tapped Video
		 * @param	e
		 */
		private function play(e:*):void
		{
			if (playOnComplete && e.property == "complete")
			{
				var video:* = e.value.getChildAt(0);
				if (video is Video)
				{
					var g:Graphic = e.value.getChildAt(1);
					g.visible = false;
					video.resume();
				}
			}
			else if (e.type == "tap")
			{
				video = e.target.searchChildren(Video);
				g = e.target.searchChildren(Graphic);
				g.visible = false;
				video.resume();
			}
		}
		
		/**
		 * Pause all Video objects on Album state change
		 * @param	e
		 */
		private function pause(e:StateEvent = null):void
		{
			var video:Video;
			var g:Graphic;
			for each(var player:TouchContainer in players)
			{
				video = player.searchChildren(Video);
				g = player.searchChildren(Graphic);
				g.visible = true;
				video.pause();
			}
		}		
		
		/**
		 * Stop all Video objects on Album state change
		 * @param	e
		 */
		private function stop(e:StateEvent = null):void
		{
			var video:Video;
			var g:Graphic;
			for each(var player:TouchContainer in players)
			{
				video = player.searchChildren(Video);
				g = player.searchChildren(Graphic);
				g.visible = true;
				video.stop();
			}
		}				
		
		/**
		 * Resets Video state when video finishes
		 * @param	e
		 */
		private function resetVideo(e:StateEvent):void
		{
			if (e.property == "isPlaying" && !e.value)
			{
				var g:Graphic = e.target.parent.searchChildren(Graphic);
				g.visible = true;
			}
		}
		
		/**
		 * Reset albums to initial frame
		 * @param	e
		 */
		private function timeExpired(e:TimerEvent):void
		{
			front.belt.x = 0;
			back.belt.x = 0;
			var f:Function = videoScrollAction == "stop" ? stop : pause;
			f.call();
			
			if (front)
				front.visible = true;
				
			if (back)
				back.visible = false;			
		}
		
		/**
		 * Reset the activity timer
		 * @param	e
		 */
		private function resetTimer(e:* = null):void
		{
			timer.reset();
			timer.start();
		}
		
	   /**
		* Updates the angle of the album element
		*/
		private function updateAngle(e:GWGestureEvent):void
		{
			if (album) album.dragAngle = rotation;
			if (linkAlbums && back) back.dragAngle = rotation;							
		}		
				
	}

}