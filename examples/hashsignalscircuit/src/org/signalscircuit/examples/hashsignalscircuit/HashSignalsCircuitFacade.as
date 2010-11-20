package org.signalscircuit.examples.hashsignalscircuit
{
	import org.puremvc.as3.patterns.facade.Facade;
	import org.signalscircuit.SignalsCircuit;
	import org.signalscircuit.examples.hashsignalscircuit.controller.commands.startup.StartApplicationCommand;
	import org.signalscircuit.examples.hashsignalscircuit.controller.commands.twitter.HashTagLoadedCommand;
	import org.signalscircuit.examples.hashsignalscircuit.signals.HashSignalsCircuitSignals;
	import org.signalscircuit.examples.hashsignalscircuit.signals.TwitterSignals;
	import org.signalscircuit.examples.hashsignalscircuit.view.HashSignalsCircuitView;

	/**
	 * @author Omar Gonzalez
	 */
	public class HashSignalsCircuitFacade extends Facade
	{
		/**
		 * Reference to the SignalsCircuit instance for the app
		 * used to register Signal objects to ISignalCommand objects.
		 */
		private var _signalsCircuit:SignalsCircuit;
		/**
		 * Instance getter for the HashSignalsCircuitFacade class.
		 */
		static public function getInstance():HashSignalsCircuitFacade
		{
			if (!instance)
				instance = new HashSignalsCircuitFacade();
				
			return instance as HashSignalsCircuitFacade;
		}
		/**
		 * Override initializeController().  Instead of starting up the
		 * PureMVC Controller the SignalsCircuit is started up. Optionally,
		 * you can use both, if you want/need them.
		 */
		override protected function initializeController():void
		{
			_signalsCircuit = SignalsCircuit.getInstance();
			_signalsCircuit.registerSignal(HashSignalsCircuitSignals.START_APPLICATION, StartApplicationCommand);
			_signalsCircuit.registerSignal(TwitterSignals.HASH_TAG_LOADED, HashTagLoadedCommand);
		}
		/**
		 * Starts up the application using the Signal for start up.
		 */
		public function startUp(hashSignalsCircuit:HashSignalsCircuitView):void
		{
			HashSignalsCircuitSignals.START_APPLICATION.dispatch(hashSignalsCircuit);
		}
	}
}
