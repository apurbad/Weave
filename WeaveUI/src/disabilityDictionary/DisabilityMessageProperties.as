package disabilityDictionary
{
	import flash.utils.Dictionary;
	
	public class DisabilityMessageProperties
	{
		private static const messageCategoryMap:Dictionary = new Dictionary();
		
		init();
		
		private static function init():void
		{
			//defining the dictionary
			messageCategoryMap[INCREASING_TREND_ID] = INCREASING_TREND; // eg : IT = "increasing trend"
			messageCategoryMap[DECREASING_TREND_ID] = DECREASING_TREND;
			messageCategoryMap[STABLE_TREND_ID] = STABLE_TREND;
			messageCategoryMap[PERIODICITY_ID] = PERIODICITY;
			messageCategoryMap[UNDEFINED_TREND_ID] = UNDEFINED_TREND;
			
		}
		
		public static function getMessageCategoryMap():Dictionary
		{
			return messageCategoryMap;
			
		}
		
		
		public static const INCREASING_TREND_ID : String = "IT";
		public static const DECREASING_TREND_ID : String = "DT";
		public static const STABLE_TREND_ID : String = "ST";
		public static const UNDEFINED_TREND_ID : String = "UT";
		public static const PERIODICITY_ID:String = "PD";
		
		
		private static const INCREASING_TREND:String = "This line chart has an increasing trend";
		private static const PERIODICITY:String = "This line chart has high periodicity";
		private static const DECREASING_TREND:String = "This line chart has a decreasing trend";
		private static const STABLE_TREND:String = "This line chart has a stable trend";
		private static const UNDEFINED_TREND:String = "This line chart has an undefined trend";
		
		
	}
}