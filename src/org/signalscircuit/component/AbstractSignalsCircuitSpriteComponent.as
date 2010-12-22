package org.signalscircuit.component
{
	import org.signalscircuit.SignalsCircuit;
	import flash.display.Sprite;

	/**
	 * The AbstractSignalsCircuitSpriteComponent is used to create Sprite based ISignalsCircuitComponent SWFs
	 * to be loaded into a SignalsCircuit application shell. This class is used for AS3  based components made in 
	 * FlashBuilder or Flash CS5.
	 * 
	 * @author Omar Gonzalez
	 */
	public class AbstractSignalsCircuitSpriteComponent extends Sprite implements ISignalsCircuitComponent
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
