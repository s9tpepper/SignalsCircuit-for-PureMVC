package org.signalscircuit.examples.hashsignalscircuit.view.tweet
{
	import ab.fl.utils.json.JSONError;
	import mx.events.FlexEvent;
	import spark.components.HGroup;
	import spark.layouts.VerticalLayout;
	import spark.components.Label;
	import mx.controls.Image;
	import flash.events.Event;
	import org.osflash.signals.natives.NativeSignal;
	import spark.components.supportClasses.ItemRenderer;

	/**
	 * @author Omar Gonzalez
	 */
	public class TweetRenderer extends ItemRenderer
	{
		private var _complete:NativeSignal;
		private var _avatar:Image;
		private var _tweetFrom:Label;
		private var _tweet:Label;
		private var _tweetTime:Label;
		private var _displayReady:Boolean;
		private var _dataChanged:NativeSignal;
		
		
		public function TweetRenderer()
		{
			super();

			_complete = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			_complete.addOnce(_init);
		}

		private function _init(event:Event):void
		{
			_complete.remove(_init);
			_complete = null;
			
			_setUpDisplay();

			_dataChanged = new NativeSignal(this, FlexEvent.DATA_CHANGE, FlexEvent);
			_dataChanged.add(_updateDisplayAfterDataChanged);
		}

		private function _updateDisplayAfterDataChanged(event:FlexEvent):void
		{
			if (_displayReady)
			{
				try
				{
					_avatar.source = data.profile_image_url.valueOf();
					_tweetFrom.text = "@" + data.from_user.valueOf();
					_tweet.text = data.text.valueOf();
					_tweetTime.text = data.created_at.valueOf();
				}
				catch (e:JSONError)
				{
					trace("JSON property error: " + e.message);
				}
			}
		}

		private function _setUpDisplay():void
		{
			layout = new VerticalLayout();
			percentWidth = 100;
			VerticalLayout(layout).paddingTop = 10;
			VerticalLayout(layout).paddingRight = 10;
			VerticalLayout(layout).paddingBottom = 10;
			VerticalLayout(layout).paddingLeft = 10;
			
			var hgroup:HGroup = new HGroup();
				hgroup.percentWidth = 100;
			addElement(hgroup);
			
			_avatar = new Image();
			_avatar.width = 50;
			_avatar.height = 50;
			hgroup.addElement(_avatar);
			
			_tweetFrom = new Label();
			_tweetFrom.setStyle("fontSize", 16);
			_tweetFrom.maxDisplayedLines = 1;
			_tweetFrom.percentWidth = 100;
			hgroup.addElement(_tweetFrom);
			
			_tweet = new Label();
			_tweet.setStyle("fontSize", 24);
			_tweet.percentWidth = 100;
			addElement(_tweet);
			
			_tweetTime = new Label();
			_tweetTime.setStyle("fontSize", 10);
			_tweetTime.percentWidth = 100;
			addElement(_tweetTime);
			
			_displayReady = true;
		}
	}
}
