package
org.signalscircuit.examples.hashsignalscircuit.view{
	import mx.events.FlexEvent;
	import spark.components.List;
	import spark.components.Application;
	import org.signalscircuit.examples.hashsignalscircuit.HashSignalsCircuitFacade;
	import org.osflash.signals.natives.NativeSignal;
	import org.signalscircuit.examples.hashsignalscircuit.signals.HashSignalsCircuitSignals;

	/**
	 * @author Omar Gonzalez
	 */
	public class HashSignalsCircuitView extends Application
	{
		private var _tweetList:List;
		
		public function HashSignalsCircuitView()
		{
			super();

			usePreloader = false;

			HashSignalsCircuitSignals.APP_ADDED_TO_STAGE = new NativeSignal(this, FlexEvent.APPLICATION_COMPLETE, FlexEvent);
			HashSignalsCircuitSignals.APP_ADDED_TO_STAGE.addOnce(_startApplication);
		}
		
		/**
		 * Handles the Event.ADDED_TO_STAGE of the main
		 * game class and starts up the game core.
		 * 
		 * @param event Event dispatched by Gigapede when its added to stage.
		 */
		private function _startApplication(event:FlexEvent):void
		{
			HashSignalsCircuitFacade.getInstance().startUp(this);
		}
		/**
		 * Returns the list component.
		 */
		public function get tweetList():List
		{
			return _tweetList;
		}
		/**
		 * Used by the mediator when it creates the view.
		 */
		public function set tweetList(tweetList:List):void
		{
			_tweetList = tweetList;
		}
	}
}
