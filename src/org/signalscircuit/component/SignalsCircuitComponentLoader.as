package org.signalscircuit.component
{
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import flash.utils.setTimeout;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.net.URLRequest;
	import flash.utils.describeType;
	import org.signalscircuit.SignalsCircuit;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import org.osflash.signals.Signal;
	import flash.display.Loader;

	/**
	 * @author Omar Gonzalez
	 */
	public class SignalsCircuitComponentLoader extends Loader
	{
		private var _uri:String;
		private var _success:Signal;
		private var _failure:Signal;
		private var _activeLoaders:Array;
		private var _isFlex:Boolean;
		
		public function SignalsCircuitComponentLoader( activeLoaders:Array, uri:String, success:Signal=null, failure:Signal=null, isFlex:Boolean=false )
		{
			_init(activeLoaders, uri, success, failure, isFlex);
		}

		private function _init( activeLoaders:Array, uri:String, success:Signal, failure:Signal, isFlex:Boolean ):void
		{
			_uri			= uri;
			_success		= success;
			_failure		= failure;
			_activeLoaders	= activeLoaders;
			_isFlex			= isFlex;
			
			contentLoaderInfo.addEventListener(Event.COMPLETE, _handleComponentLoadComplete, false, 0, true);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _handleComponentLoadError, false, 0, true);
			contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleComponentLoadError, false, 0, true);
			
			const loaderContext:LoaderContext = new LoaderContext(false, new ApplicationDomain());
			load(new URLRequest(_uri), loaderContext);
		}

		private function _handleComponentLoadError(event:Event):void
		{
			if (_failure)
			{
				_failure.dispatch(event);
			}
			
			_selfDestruct();
		}
		
		private function _handleFlashComponent():void
		{
			const validComponent:Boolean = SignalsCircuit.getInstance().validateComponent(this);

			if (!validComponent)
			{
				// Create an error event and route it through the error handler for IOErrorEvent and SecurityErrorEvent so the same failure Signal can handle if one is assigned.
				const errorEvent:SignalsCircuitComponentLoaderErrorEvent = new SignalsCircuitComponentLoaderErrorEvent(SignalsCircuitComponentLoaderErrorEvent.COMPONENT_INVALID);
					  errorEvent.errorMessage = _getComponentInvalidErrorMessage();
				_handleComponentLoadError(errorEvent);
				return;
			}
			else
			{
				// Loaded component is valid, register and success Signal dispatch if needed 
				SignalsCircuit.getInstance().registerComponent(_uri, this);
				if (_success)
					_success.dispatch(this);
			}
			
			_selfDestruct();
		}

		private function _handleComponentLoadComplete(event:Event):void
		{
			if (_isFlex)
			{
				_handleFlexComponent();
			}
			else
			{
				_handleFlashComponent();
			}	
		}

		private function _handleFlexComponent():void
		{
			if (!content['application'])
			{
				setTimeout(_handleFlexComponent, 250);
				return;
			}
			
			const validComponent:Boolean = SignalsCircuit.getInstance().validateFlexComponent(this);

			if (!validComponent)
			{
				// Create an error event and route it through the error handler for IOErrorEvent and SecurityErrorEvent so the same failure Signal can handle if one is assigned.
				const errorEvent:SignalsCircuitComponentLoaderErrorEvent = new SignalsCircuitComponentLoaderErrorEvent(SignalsCircuitComponentLoaderErrorEvent.COMPONENT_INVALID);
					  errorEvent.errorMessage = _getComponentInvalidErrorMessage();
				_handleComponentLoadError(errorEvent);
				return;
			}
			else
			{
				// Destroy the uic that was used to init this comp.
				var uic:UIComponent = parent as UIComponent;
				if (uic)
				{
					if (uic.parent)
					{
						if (uic.parent is IVisualElementContainer)
						{
							uic.parent['removeElement'](uic);
						}
						else
						{
							uic.parent.removeChild(uic);
						}
					}
					
					if (uic.contains(this))
						uic.removeChild(this);
				}
				
				// Loaded component is valid, register and success Signal dispatch if needed 
				SignalsCircuit.getInstance().registerFlexComponent(_uri, this);
				
				if (_success)
				{
					_success.dispatch(this);
				}
			}
			
			_selfDestruct();
		}
		/**
		* Returns a detailed message of why the loaded component is not valid.
		*/
		private function _getComponentInvalidErrorMessage():String
		{
			const classInfo:XML		= describeType(this);
			var message:String		= "The SWF's main class ([className]) loaded into the content property does not implement the ISignalsCircuitComponent interface.";
			const className:String	= classInfo.@name.toString();
			
			return message.replace("[className]", className);
		}
		/**
		* Destroys itself and its references when it is done working.
		*/
		private function _selfDestruct():void
		{
			const loaderIndex:Number = _activeLoaders.lastIndexOf(this);
			if (loaderIndex > -1)
			{
				_activeLoaders.splice(loaderIndex, 1);
			}
			
			contentLoaderInfo.removeEventListener(Event.COMPLETE, _handleComponentLoadComplete);
			contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleComponentLoadError);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _handleComponentLoadError);
			
			_uri = null;
			_failure = null;
			_success = null;
			_activeLoaders = null;
		}
	}
}
