package flexUnitTests
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.async.Async;
	import org.osflash.signals.Signal;
	import org.signalscircuit.SignalsCircuit;
	import org.signalscircuit.shared.SharedSignal;
	
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
		/**
		 * Tests the SignalsCircuit.getInstance() method to make sure its returning the right object.
		 */
		public function testGetInstance():void
		{
			var sc:SignalsCircuit = SignalsCircuit.getInstance();
			Assert.assertTrue("SignalsCircuit is not being returned.", sc is SignalsCircuit);
		}
		
		
		
		[Test(order="2")]
		/**
		 * Tests the SignalsCircuit <code>hasSignalCommand()</code> method and the <code>registerSignal()</code>
		 * method.
		 */
		public function testRegisterHasSignalCommandAndRemove():void
		{
			Assert.assertFalse("hasSignalCommand should return false at start.", _signalsCircuit.hasSignalCommand(TestSignals.TEST_SIGNAL));
			
			_signalsCircuit.registerSignal(TestSignals.TEST_SIGNAL, TestSimpleSignalCommand);
			
			Assert.assertTrue("registerSignal did not register the Signal object.", _signalsCircuit.hasSignalCommand(TestSignals.TEST_SIGNAL));
			
			_signalsCircuit.removeCommand(TestSignals.TEST_SIGNAL);
			
			Assert.assertFalse("hasSignalsCircuit failed after removing a registered Signal.", _signalsCircuit.hasSignalCommand(TestSignals.TEST_SIGNAL));
		}
		
		
		
		[Test(order="3", async, timeout="5000")]
		/**
		 * Tests executing a SimpleSignalCommand subclass.
		 */
		public function testExecuteSimpleSignalCommand():void
		{
			_signalsCircuit.registerSignal(TestSignals.TEST_SIGNAL, TestSimpleSignalCommand);
			
			TEST_SIGNAL_EXECUTION.add(_signalExecuted);
			
			TestSignals.TEST_SIGNAL.dispatch();
		}
		/**
		 * @private
		 */
		private function _signalExecuted():void
		{
			TEST_SIGNAL_EXECUTION.remove(_signalExecuted);
			_signalsCircuit.removeCommand(TestSignals.TEST_SIGNAL);
			Assert.assertTrue(true);
		}
		
		
		
		
		[Test(order="4", async, timeout="5000")]
		/**
		 * Test executing a MacroSignalCommand subclass.
		 */
		public function testExecuteMacroSignalCommand():void
		{
			_signalsCircuit.registerSignal(TestSignals.TEST_SIGNAL, TestMacroSignalCommand);
			
			TEST_SIGNAL_EXECUTION.add(_signalExecuted);
			
			TestSignals.TEST_SIGNAL.dispatch();
		}
		
		
		
		
		// Vars used for testValidateComponent()
		[Embed(source="/TestComponent.swf", mimeType="application/octet-stream")]
		// Embed of a TestComponent application.
		private var _TEST_COMPONENT:Class;
		[Embed(source="/InvalidComponent.swf", mimeType="application/octet-stream")]
		// Embed of a SWF that does not implement ISignalsCircuitComponent to test the validation function
		private var _INVALID_TEST_COMPONENT:Class;
		// Loader used to load the test component
		private var _testComponentLoader:Loader;
		// Loader used to load the invalid component
		private var _invalidTestComponentLoader:Loader;
		[Test(order="5", async, timeout="5000")]
		/**
		 * Tests the SignalsCircuit <code>validateComponent()</code> method.
		 */
		public function testValidateComponent():void
		{
			const invalidComponent:ByteArray = new _INVALID_TEST_COMPONENT() as ByteArray;
			const loaderContext:LoaderContext = new LoaderContext(false, new ApplicationDomain());

			_invalidTestComponentLoader = new Loader();
			Async.handleEvent(this, _invalidTestComponentLoader.contentLoaderInfo, Event.COMPLETE, _handleInvalidBytesLoaded, 5000);
			_invalidTestComponentLoader.loadBytes(invalidComponent, loaderContext);
			
		}
		/**
		 * @private
		 */
		private function _handleInvalidBytesLoaded(event:Event, passThrough:Object=null):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			Assert.assertFalse("Validation is not working properly.", _signalsCircuit.validateComponent(loaderInfo.loader));
		}
		
		
		
		
		[Test(order="6", async, timeout="5000")]
		/**
		 * Tests the SignalsCircuit <code>validateComponent()</code> method and the <code>registerComponent()</code> method.
		 */
		public function testValidateAndRegisterComponent():void
		{
			const component:ByteArray = new _TEST_COMPONENT() as ByteArray;
			const loaderContext:LoaderContext = new LoaderContext(false, new ApplicationDomain());
			
			_testComponentLoader = new Loader();
			Async.handleEvent(this, _testComponentLoader.contentLoaderInfo, Event.COMPLETE, _handleTestComponentLoaderComplete, 5000); 
			_testComponentLoader.loadBytes(component, loaderContext);
		}
		/**
		 * @private
		 */
		private function _handleTestComponentLoaderComplete(event:Event, passThrough:Object=null):void
		{
			Assert.assertTrue("Loaded SWF is not valid, could not find ISignalsCircuitComponent interface.", _signalsCircuit.validateComponent(_testComponentLoader));
			try
			{
				_signalsCircuit.registerComponent("/path/to/Component.swf", _testComponentLoader);
				Assert.assertTrue(true);
			}
			catch (e:Error)
			{
				Assert.fail(e.message);
			}
		}
		
		
		
		
		[Test(order="7")]
		/**
		 * Tests the SignalsCircuit <code>hasComponent()</code> method.
		 */
		public function testHasComponent():void
		{
			Assert.assertFalse("Did not return false when entering a bad key to hasComponent method.", _signalsCircuit.hasComponent("/a/key/that/doesnt/exist"));
			Assert.assertTrue("Could not find component from registration in testValidateAndRegisterComponent().", _signalsCircuit.hasComponent("/path/to/Component.swf"));
		}
		
		
		
		
		[Test(order="8")]
		/**
		 * Tests the SignalsCircuit <code>removeComponent()</code> method.
		 */
		public function testRemoveComponent():void
		{
			Assert.assertTrue("Could not find component from registration in testValidateAndRegisterComponent().", _signalsCircuit.hasComponent("/path/to/Component.swf"));

			_signalsCircuit.removeComponent("/path/to/Component.swf");

			Assert.assertFalse("Did not return false when entering the key that was removed.", _signalsCircuit.hasComponent("/path/to/Component.swf"));
		}
		
		
		// Signal used to test if success Signals are dispatched
		private var _componentLoadSuccess:Signal = new Signal(Loader);
		// Signal used to test if failure Signals are dispatched
		private var _componentLoadFailed:Signal = new Signal(Event);
		// Event dispatcher used to finish the test.
		private var _testLoadComponentEventDispatcher:EventDispatcher;
		[Test(order="9", async, timeout="5000")]
		/**
		 * Tests the SignalsCircuit <code>loadComponent()</code> method.
		 */
		public function testLoadComponent():void
		{
			Assert.assertFalse("Did not return false when entering the key for the TestComponent.swf.", _signalsCircuit.hasComponent("TestComponent.swf"));
			
			_testLoadComponentEventDispatcher = new EventDispatcher();
			Async.handleEvent(this, _testLoadComponentEventDispatcher, "testComponentLoaded", _testComponentLoadedCallback, 5000);
			
			_componentLoadSuccess.addOnce(_componentLoadHandler);
			_componentLoadFailed.addOnce(_componentLoadHandler);
			
			_signalsCircuit.loadComponent("TestComponent.swf", _componentLoadSuccess, _componentLoadFailed);
		}
		/**
		 * @private
		 */
		private function _componentLoadHandler(loader:Loader):void
		{
			var event:Event = new Event("testComponentLoaded");
			_testLoadComponentEventDispatcher.dispatchEvent(event);
		}
		/**
		 * @private
		 */
		private function _testComponentLoadedCallback(event:Event, passThrough:Object=null):void
		{
			Assert.assertTrue("TestComponent.swf key was not found as registered.", _signalsCircuit.hasComponent("TestComponent.swf"));
		}
		
		
		
		
		// Signal used to dispatch a Signal from application to component
		private var _testSignalToComponent:SharedSignal = new SharedSignal("appToCompSignal", String);
		// Signal used to listen for a Signal dispatched by a component
		private var _compToAppSignal:SharedSignal = new SharedSignal("compToAppSignal", String);
		// Event dispatcher used to finish the async flex unit test.
		private var _receivedSignalResponse:EventDispatcher;
		[Test(order="10", async, timeout="5000")]
		/**
		 * Tests the SignalsCircuit <code>registerApplicationToComponentSignal()</code> and the 
		 * <code>registerComponentSignalNameToReceive()</code> method.  Makes sure that communication
		 * is going both ways from application to component and vice versa.
		 */
		public function testSignalCommunicationBothWays():void
		{
			_signalsCircuit.registerApplicationToComponentSignal(_testSignalToComponent.name, _testSignalToComponent);
			_signalsCircuit.registerComponentSignalNameToReceive(_compToAppSignal.name, _compToAppSignal);
			_compToAppSignal.add(_handleSignalFromComponent);
			
			_receivedSignalResponse = new EventDispatcher();
			Async.handleEvent(this, _receivedSignalResponse, "responseReceived", _handleSignalResponseReceived, 5000);
			
			_testSignalToComponent.dispatch("Hello from FlexUnit");
		}
		/**
		 * @private
		 */
		private function _handleSignalResponseReceived(event:Event, passThrough:Object=null):void
		{
			Assert.assertTrue(true);
		}
		/**
		 * @private
		 */
		private function _handleSignalFromComponent(message:String):void
		{
			_receivedSignalResponse.dispatchEvent(new Event("responseReceived"));
		}
	}
}











