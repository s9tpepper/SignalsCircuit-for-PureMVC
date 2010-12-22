package org.signalscircuit.shared
{
	import org.osflash.signals.Signal;

	/**
	 * @author Omar Gonzalez
	 */
	public class SharedSignal extends Signal
	{
		private var _name:String;
		
		public function SharedSignal(sharedSignalName:String, ...rest)
		{
			_name = sharedSignalName;
			
			super(rest);
		}

		public function get name():String
		{
			return _name;
		}
	}
}
