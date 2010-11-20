package org.signalscircuit.examples.hashsignalscircuit.signals
{
	import org.signalscircuit.examples.hashsignalscircuit.view.HashSignalsCircuitView;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.signals.Signal;
	/**
	 * @author Omar Gonzalez
	 */
	public class HashSignalsCircuitSignals
	{
		/**
		 * Signal dispatched when the main game class is added
		 * to the stage.
		 */
		static public var APP_ADDED_TO_STAGE:NativeSignal;
		/**
		 * Signal dispatched to start the application.
		 */
		static public const START_APPLICATION:Signal = new Signal(HashSignalsCircuitView);
		
		
	}
}
