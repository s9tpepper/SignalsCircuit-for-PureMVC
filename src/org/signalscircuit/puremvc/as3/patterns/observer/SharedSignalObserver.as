package org.signalscircuit.puremvc.as3.patterns.observer
{
	import org.osflash.signals.Signal;
	import org.signalscircuit.SignalsCircuit;

	/**
	 * @author Omar Gonzalez
	 */
	public class SharedSignalObserver extends SignalObserver
	{
		/**
		* @private
		*/
		private var _name:String;
		
		/**
		* @Constructor
		* 
		* @param signalName The signalName for the Signal object, used to map Signals between an application and a ISignalsCircuitComponent.
		* @param signal The Signal that is being observed for dispatches.
		* @param signalsCircuit The SignalsCircuit instance reference.
		*/
		public function SharedSignalObserver(signalName:String, signal:Signal, signalsCircuit:SignalsCircuit)
		{
			_name = signalName;
			
			super(signal, signalsCircuit);
		}
		/**
		* Override to change the method invoked on SignalsCircuit to <code>dispatchSignalToComponents()</code>, which will
		* use the loaded components <code>receiveSignalFromApplication()</code> to broadcast the signal by its signalName to all components.
		* The args Array that becomes AMF encoded, so any custom VO/DTO type objects must have a [RemoteClass(alias='someArbitraryUniqueString')] 
		* metadata tag.  DisplayObjects will can not be encoded and sent directly to the components.  Both the
		* application and the components must use registerClassAlias() to register any VO/DTOs they might expect in a Signal
		* before actually receiving it to ensure that the object is decoded properly.
		* 
		* @param args The Array of arguments that were dispatched with the Signal object.
		* @param signal The Signal that was dispatched.
		*/
		override protected function signalObservers(signal:Signal, args:Array):void
		{
			_signalsCircuit.dispatchSignalToComponents(_name, args);
		}
	}
}
