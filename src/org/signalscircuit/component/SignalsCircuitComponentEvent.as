package org.signalscircuit.component
{
	import flash.events.Event;

	/**
	 * @author Omar Gonzalez
	 */
	public class SignalsCircuitComponentEvent extends Event
	{
		/**
		* Event dispatched via sharedEvents object to communicate up to the loading application.
		*/
		static public const COMPONENT_TO_APPLICATION:String = "signalscircuit_componentToApplicationEvent";
		
		/**
		* An AMF encoded Array with the signal arguments.
		*/
		public var arguments:String;
		/**
		* The string name of the Signal to dispatch in the application.
		*/
		public var signalName:String;
		
		public function SignalsCircuitComponentEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
