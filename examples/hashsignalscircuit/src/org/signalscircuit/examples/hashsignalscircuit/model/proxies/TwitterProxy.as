package org.signalscircuit.examples.hashsignalscircuit.model.proxies
{
	import org.signalscircuit.examples.hashsignalscircuit.signals.TwitterSignals;
	import ab.fl.utils.json.JSON;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoader;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * @author Omar Gonzalez
	 */
	public class TwitterProxy extends Proxy
	{
		static public const NAME:String = "TwitterProxy";
		/**
		 * URLLoader used to load the JSON.
		 */
		private var _jsonLoader:URLLoader;
		/**
		 * JSON object used to parse the JSON string, from JSONTools.
		 */
		private var _json:JSON;
		
		public function TwitterProxy()
		{
			super(NAME, null);
		}
		/**
		 * Loads a JSON search of the specified hash tag.
		 */
		public function loadHashTag(hashTag:String):void
		{
			//http://search.twitter.com/search.json?q=SignalsCircuit
			_jsonLoader = new URLLoader();
			_jsonLoader.addEventListener(Event.COMPLETE, _handleJsonComplete, false, 0, true);
			
			var twitterSearch:String = "http://search.twitter.com/search.json?q="+hashTag;
			_jsonLoader.load(new URLRequest(twitterSearch));
		}
		/**
		 * Handles the complete event on the URLLoader and parses
		 * the JSON and dispatches the Signal for it
		 */
		private function _handleJsonComplete(event:Event):void
		{
			_json = new JSON(_jsonLoader.data);
			TwitterSignals.HASH_TAG_LOADED.dispatch(_json);
		}
		
	}
}
