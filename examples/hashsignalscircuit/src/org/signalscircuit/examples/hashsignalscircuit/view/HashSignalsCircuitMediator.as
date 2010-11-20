package org.signalscircuit.examples.hashsignalscircuit.view
{
	import spark.components.List;
	import org.signalscircuit.examples.hashsignalscircuit.view.tweet.TweetRenderer;
	import mx.core.ClassFactory;
	import ab.fl.utils.json.JSONList;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * @author Omar Gonzalez
	 */
	public class HashSignalsCircuitMediator extends Mediator
	{
		static public const NAME:String = "HashSignalsCircuitMediator";
		
		public function HashSignalsCircuitMediator(viewComponent:HashSignalsCircuitView)
		{
			super(NAME, viewComponent);
		}
		/**
		 * Populates the list component with the loaded JSON
		 * object from Twitter using JSONTools' JSONList class.
		 */
		public function setDisplay(results:Array):void
		{
			var jsonList:JSONList = new JSONList(results);
			hashSignalsCircuit.tweetList.dataProvider = jsonList;
		}
		/**
		 * Getter for the referenced view component.
		 */
		protected function get hashSignalsCircuit():HashSignalsCircuitView
		{
			return getViewComponent() as HashSignalsCircuitView;
		}
		/**
		 * Using onRegister() override to start the UI components.
		 */
		override public function onRegister():void
		{
			_initializeDisplay();
		}
		/**
		 * Sets up the display components when the mediator is registered
		 */
		private function _initializeDisplay():void
		{
			hashSignalsCircuit.tweetList = new List();
			hashSignalsCircuit.tweetList.percentWidth = 100;
			hashSignalsCircuit.tweetList.percentHeight = 100;
			hashSignalsCircuit.tweetList.itemRenderer = new ClassFactory(TweetRenderer);
			hashSignalsCircuit.addElement(hashSignalsCircuit.tweetList);
		}
	}
}
