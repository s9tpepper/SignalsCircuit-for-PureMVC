package org.signalscircuit.component
{
	import org.signalscircuit.SignalsCircuit;
	import mx.core.Application;

	/**
	 * The AbstractSignalsCircuitMXComponent is used to create MX mx:Application based ISignalsCircuitComponent SWFs
	 * to be loaded into a SignalsCircuit application shell. This class is used for Flex 3 MX based components made in 
	 * FlashBuilder.
	 * 
	 * @author Omar Gonzalez
	 */
	public class AbstractSignalsCircuitMXComponent extends Application implements ISignalsCircuitComponent
	{
		/**
		* @inheritDoc
		*/
		public function dispatchSignalToApplication(signalName:String, ...rest):void
		{
			SignalsCircuit.getInstance().dispatchSignalToApplication(signalName, rest, loaderInfo.sharedEvents);
		}
		/**
		* @inheritDoc
		*/
		public function receiveSignalFromApplication(signalName:String, arguments:String):void
		{
			SignalsCircuit.getInstance().receiveSignalFromApplication(signalName, arguments);
		}
	}
}
