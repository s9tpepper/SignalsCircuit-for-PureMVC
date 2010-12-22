package org.signalscircuit.component
{
	/**
	 * @author Omar Gonzalez
	 */
	public interface ISignalsCircuitComponent
	{
		/**
		* Dispatches a Signal in a application that has registered the signalName with the SignalsCircuit <code>registerComponentSignalNameToReceive()</code> 
		* method.  This method is used by SignalsCircuit to send a message to the parent application that loaded it if a component has registered
		* a Signal using the SignalsCircuit <code>registerComponentToApplicationSignal()</code> method.
		*/
		function dispatchSignalToApplication(signalName:String, ... rest):void;
		/**
		* This method is used by SignalsCircuit when a Signal is dispatched that has been registered with SignalsCircuit using its <code>registerApplicationToComponentSignal()</code>
		* method to trigger dispatching a Signal by its registered name in all loaded components.
		* 
		* @param signalName The name of the Signal that the application is sending out.
		* @param rest An array of arguments to dispatch with the Signal if the component has a Signal for that name registered, encoded as an AMF base64 encoded String.
		*/
		function receiveSignalFromApplication(signalName:String, arguments:String):void;
	}
}
