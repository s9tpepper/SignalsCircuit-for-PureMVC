package org.signalscircuit.puremvc.as3.patterns.observer
{
	import flash.events.IEventDispatcher;
	import org.osflash.signals.Signal;
	import org.signalscircuit.SignalsCircuit;

	/**
	 * This class is used when a component registers a Signal to be funneled
	 * through to its loading application.  Whenever registered
	 * Signals are dispatched this observer passes the signal through to the app.
	 *
	 * @author Omar Gonzalez
	 */
	public class ComponentSharedSignalObserver extends SignalObserver
	{
		/**
		* @private
		*/
		private var _signalName:String;
		/**
		* @private
		*/
		private var _sharedEvents:IEventDispatcher;
				/**
		* @Constructor
		* 
		* @param sharedEvents The sharedEvents dispatcher for the component's main class used to broadcast signals up to the loading application.
		* @param signal The Signal that is being observed for dispatches.
		* @param signalName The signalName for the Signal object, used to map Signals between an application and a ISignalsCircuitComponent.
		* @param signalsCircuit The SignalsCircuit instance reference.
		*/
		public function ComponentSharedSignalObserver(signalName:String, signal:Signal, sharedEvents:IEventDispatcher, signalsCircuit:SignalsCircuit)
		{
			_signalName = signalName;
			_sharedEvents = sharedEvents;
			
			super(signal, signalsCircuit);
		}
		/**
		* Override to change the method invoked on SignalsCircuit to <code>dispatchSignalToApplication()</code>, which will
		* use the sharedEvents EventDispatcher object to broadcast the signal by its signalName to the application.
		* The args Array gets AMF encoded, so any custom VO/DTO type objects must have a [RemoteClass(alias='someArbitraryUniqueString')] 
		* metadata tag.  DisplayObjects will can not be encoded and sent directly to the parent application.  Both the
		* application and the components must use registerClassAlias() to register any VO/DTOs they might expect in a Signal
		* before actually receiving it to ensure that the object is decoded properly.
		* 
		* @param args The Array of arguments that were dispatched with the Signal object.
		* @param signal The Signal that was dispatched.
		*/
		override protected function signalObservers(signal:Signal, args:Array):void
		{
			_signalsCircuit.dispatchSignalToApplication(_signalName, args, _sharedEvents);
		}
	}
}
