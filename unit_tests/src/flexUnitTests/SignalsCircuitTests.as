package flexUnitTests
{
	import flexunit.framework.Assert;
	
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.Signal;
	import org.signalscircuit.SignalsCircuit;
	
	public class SignalsCircuitTests
	{
		private var _signalsCircuit:SignalsCircuit;
		
		
		static public const TEST_SIGNAL_EXECUTION:Signal = new Signal();
		
		[Before]
		public function setUp():void
		{
			if (!_signalsCircuit)
				_signalsCircuit = SignalsCircuit.getInstance();
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test(order="1")]
		public function testGetInstance():void
		{
			var sc:SignalsCircuit = SignalsCircuit.getInstance();
			Assert.assertTrue("SignalsCircuit is not being returned.", sc is SignalsCircuit);
		}
		
		[Test(order="2")]
		public function testRegisterHasSignalCommandAndRemove():void
		{
			Assert.assertFalse("hasSignalCommand should return false at start.", _signalsCircuit.hasSignalCommand(TestSignals.TEST_SIGNAL));
			
			_signalsCircuit.registerSignal(TestSignals.TEST_SIGNAL, TestSimpleSignalCommand);
			
			Assert.assertTrue("registerSignal did not register the Signal object.", _signalsCircuit.hasSignalCommand(TestSignals.TEST_SIGNAL));
			
			_signalsCircuit.removeCommand(TestSignals.TEST_SIGNAL);
			
			Assert.assertFalse("hasSignalsCircuit failed after removing a registered Signal.", _signalsCircuit.hasSignalCommand(TestSignals.TEST_SIGNAL));
		}
		
		[Test(order="3", async, timeout="5000")]
		public function testExecuteSimpleSignalCommand():void
		{
			_signalsCircuit.registerSignal(TestSignals.TEST_SIGNAL, TestSimpleSignalCommand);
			
			TEST_SIGNAL_EXECUTION.add(_signalExecuted);
			
			TestSignals.TEST_SIGNAL.dispatch();
		}
		
		private function _signalExecuted():void
		{
			TEST_SIGNAL_EXECUTION.remove(_signalExecuted);
			_signalsCircuit.removeCommand(TestSignals.TEST_SIGNAL);
			Assert.assertTrue(true);
		}
		
		[Test(order="4", async, timeout="5000")]
		public function testExecuteMacroSignalCommand():void
		{
			_signalsCircuit.registerSignal(TestSignals.TEST_SIGNAL, TestMacroSignalCommand);
			
			TEST_SIGNAL_EXECUTION.add(_signalExecuted);
			
			TestSignals.TEST_SIGNAL.dispatch();
		}
	}
}