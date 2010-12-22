package org.signalscircuit.component
{
	import flash.events.Event;

	/**
	 * @author Omar Gonzalez
	 */
	public class SignalsCircuitComponentLoaderErrorEvent extends Event
	{
		/**
		* Event dispatched if the component loaded by SignalsCircuit.getInstance.loadComponent() does not
		* implement the ISignalsCircuitComponent interface.
		*/
		static public const COMPONENT_INVALID:String = "signalscircuit_componentLoaderErrorEvent";
		
		/**
		* An error message for COMPONENT_INVALID containing details about the invalid component.
		*/
		public var errorMessage:String;
		
		public function SignalsCircuitComponentLoaderErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
