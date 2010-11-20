package org.signalscircuit.examples.hashsignalscircuit.signals
{
	import ab.fl.utils.json.JSON;
	import org.osflash.signals.Signal;
	/**
	 * @author Omar Gonzalez
	 */
	public class TwitterSignals
	{
		/**
		 * Signal dispatched by TwitterProxy when it has loaded the
		 * JSON object for a hash tag search.
		 */
		static public const HASH_TAG_LOADED:Signal = new Signal(JSON);
	}
}
