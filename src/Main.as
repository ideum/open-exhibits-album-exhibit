//////////////////////////////////////////////////////////////////////////////
// This example demonstrates the CML AlbumViewer tag.
/////////////////////////////////////////////////////////////////////////////

package 
{
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.element.Album;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.utils.FrameRate;
	import flash.events.Event;
	import flash.utils.Timer;
	import PhotoAlbumViewer; PhotoAlbumViewer;

	[SWF(width = "1920", height = "1080", backgroundColor = "0x000000", frameRate = "60")]

	public class Main extends GestureWorks
	{		
		public function Main():void 
		{
			super();
			cml = "PhotoAlbumViewer.cml";
			gml = "photoAlbum_gestures.gml";
			// add this event listener so we know when the CML parsing is complete
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);
			fullscreen = true;
		}
	
		override protected function gestureworksInit():void
 		{
			trace("gestureWorksInit()");
		}
		
		private function cmlInit(event:Event):void
		{
			trace("cmlInit()");
			//addChild(new FrameRate());
		}
		
	}
}