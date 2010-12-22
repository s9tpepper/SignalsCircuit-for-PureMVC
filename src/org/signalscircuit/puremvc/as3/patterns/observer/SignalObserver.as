package org.signalscircuit.puremvc.as3.patterns.observer
{
	import org.osflash.signals.Signal;
	import org.signalscircuit.SignalsCircuit;

	/**
	 * @author Omar Gonzalez
	 */
	public class SignalObserver
	{
		protected var _signalsCircuit:SignalsCircuit;
		protected var _signal:Signal;
		
		/**
		 * @Constructor
		 * 
		 * @param signal Signal object to watch for signals.
		 * @param notifyMethod Function callback to notify/invoke.
		 * @param notifyContext Object on which the function callback exists.
		 */
		public function SignalObserver(signal:Signal, signalsCircuit:SignalsCircuit)
		{
			_signalsCircuit = signalsCircuit;
			
			_initSignal(signal);
		}
		/**
		 * Initializes the Signal object.
		 * 
		 * @param signal Signal object to watch for dispatched signals.
		 */
		private function _initSignal(signal:Signal):void
		{
			_signal = signal;
			_signal.add(_signalWatcher);
		}
		/**
		 * The method that watches for dispatches from the signal, notifies
		 * the observers.  Had to refactor to take multiple optional variables
		 * to be able to have a single callback that should support the majority
		 * of Signal object usage.
		 * 
		 */
		private function _signalWatcher(a:*=null, b:*=null, c:*=null, d:*=null, e:*=null, f:*=null, g:*=null, h:*=null, i:*=null, j:*=null, k:*=null, l:*=null, m:*=null, n:*=null, o:*=null):void
		{
			signalObservers(_signal, arguments);
		}
		/**
		 * Sends the signal to all observers of this Signal object dispatches.
		 */
		protected function signalObservers(signal:Signal, args:Array):void
		{
			_signalsCircuit.executeSignalCommand(signal, args);
		}
		/**
		 * Compare an object to the notification context. 
		 * 
		 * @param object the object to compare
		 * @return boolean indicating if the object and the notification context are the same
		 */
		 public function compareNotifyContext( object:Object ):Boolean
		 {
		 	return object === _signalsCircuit;
		}
		/**
		 * Destroys the SignalObserver object.
		 */
		public function destroy():void
		{
			if (_signal)
			{
				_signal.remove(_signalWatcher);
			}

			_signalsCircuit = null;
			_signal = null;
		}
		/**
		 * Returns the Signal object associated with this SignalObserver instance.
		 */
		public function get signal():Signal
		{
			return _signal;
		}
	}
}
