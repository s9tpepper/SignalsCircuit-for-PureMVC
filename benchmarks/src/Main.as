package {
	import com.gskinner.performance.PerformanceTest;
	import com.gskinner.performance.TextLog;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author Ross
	 */
	public class Main extends Sprite {
		private var _outFld:TextField;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			initTest();
		}
		
		private function initTest():void {
			PerformanceTest.getInstance().delay = 0;
			
			_outFld = this.addChild(new TextField()) as TextField;
			_outFld.autoSize = TextFieldAutoSize.LEFT;
			_outFld.text = "Running tests on "+Capabilities.version+" "+(Capabilities.isDebugger ? "DEBUG" : "RELEASE")+"...\n";
			
			new TextLog().out = out;
			//new XMLLog().out = out;
			
			PerformanceTest.queue(new SignalsVsEventsTestSuite());
			PerformanceTest.queue(new SignalsVsEventsTestSuite(1));
			PerformanceTest.queue(new SignalsVsEventsTestSuite(2));
			PerformanceTest.queue(new SignalsVsEventsTestSuite(3));
			PerformanceTest.queue(new SignalsVsEventsTestSuite(4));
			PerformanceTest.queue(new SignalsVsEventsTestSuite(5));
		}
		
		
		protected function out(str:*):void {
			_outFld.appendText(String(str) + "\n");
			_outFld.scrollV = _outFld.maxScrollV;
		}
		
	}
	
}