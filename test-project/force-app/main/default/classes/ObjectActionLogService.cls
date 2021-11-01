public class ObjectActionLogService implements IObjectActionLogService{
	
	public interface IObjectActionLogService {
		List<Data> get(ObjectAndTypeRequest request);
		Map<string, List<Data>> get(List<ObjectRequest> requests, String actionType);
		void log(String objectName, String objectRecordId, String actionType, String action);
		void recordCachedLogs();
		List<Object_Action_Log__c> getCachedLogs();
	}

	private final ObjectActionLogSvcDataProvider.IDataProvider m_dataProvider;
	private final Utility.IUtility m_util;
	private final CachedMap.ICachedMap m_cache;
	private final ObjectActionLogServiceHelper.IObjectActionLogServiceHelper m_helper;

	public ObjectActionLogService(ObjectActionLogSvcDataProvider.IDataProvider dataProvider, Utility.IUtility util, CachedMap.ICachedMap cache, ObjectActionLogServiceHelper.IObjectActionLogServiceHelper helper) {
		m_dataProvider = dataProvider;
		m_util = util;
		m_cache = cache;
		m_helper = helper;
	}

	public void log(String objectName, String objectRecordId, String actionType, String action){
		String key = createKey(objectName, objectRecordId, actionType, action);
		
		if(!m_cache.containsKey(key)){
			SaveSm sm = m_helper.buildSm(objectName, objectRecordId, actionType, action);
			m_cache.put(key, sm);
			m_helper.addLog(sm);
		}
	}

	public void recordCachedLogs(){
		List<SaveSm> smLogs = m_helper.getLogs();
		List<Object_Action_Log__c> oaLogs = m_helper.buildOALogs(smLogs);
		m_dataProvider.save(oaLogs);
		m_helper.clearLogs();
	}

	public List<Object_Action_Log__c> getCachedLogs(){
		List<SaveSm> smLogs = m_helper.getLogs();
		List<Object_Action_Log__c> sos = m_helper.buildOALogs(smLogs);
		m_helper.clearLogs();
		return sos;
	}

    public List<Data> get(ObjectAndTypeRequest request){
        List<Data> dmLogs = new List<Data>();
        String objectId = m_util.convertid15ToId18(request.ObjectRecordId);
        List<Object_Action_Log__c> pms = m_dataProvider.get(objectId, request.ActionType);
        if(pms == null || pms.size() == 0){return dmLogs;}

        for(Object_Action_Log__c pm : pms){
        	Data dm = m_helper.convertToDm(pm);
			dmLogs.add(dm);
        }

        return dmLogs;
    }

	public Map<string, List<Data>> get(List<ObjectRequest> requests, String actionType){
		Map<string, List<Data>> dmLogMap = new  Map<string, List<Data>>();
		List<String> objectIds = new List<String>();
		for(ObjectRequest r : requests){
			objectIds.add(m_util.convertid15ToId18(r.ObjectRecordId));
		}
		List<Object_Action_Log__c> pms = m_dataProvider.get(objectIds, actionType);
		for(Object_Action_Log__c pm : pms){
        	if(!dmLogMap.containsKey(pm.Object_Id__c)){
				dmLogMap.put(pm.Object_Id__c, new List<Data>());
			}
			Data dm = m_helper.convertToDm(pm);
			dmLogMap.get(pm.Object_Id__c).add(dm);
        }
		return dmLogMap;
	}	

	private String createKey(String objectName, String objectRecordId, String actionType, String action){
		return String.format('{0}-{1}-{2}-{3}', new List<String>{objectName, objectRecordId, actionType, action});
	}

	public class Data {
		public String ObjectName{get;set;}
		public String ObjectRecordId {get;set;}
		public String Action{get;set;}
        public Decimal TimeInStageBusinessDays{get;set;}
        public String  TimeInStageBusinessDaysHours{get;set;}
		public DateTime CreatedDate {get;set;}
		public String LocalizedCreatedDate {get;set;}
		public DmUser CreatedBy {get;set;}
	}

	public class ObjectRequest {
		public String ObjectRecordId {get;set;}
	}

	public class ObjectAndTypeRequest {
		public String ObjectRecordId {get;set;}
		public String ActionType {get;set;}
	}

	public class SaveSm {
		public String ObjectName {get;set;}
		public String ObjectRecordId {get;set;}
		public String ActionType {get;set;}
		public String Action {get;set;}
		public DateTime CreatedDate{get;set;} 
	}

	public static IObjectActionLogService bootstrap() {
		ObjectActionLogSvcDataProvider.IDataProvider dataProvider = new ObjectActionLogSvcDataProvider();
		Utility.IUtility util = new Utility();
		CachedMap.ICachedMap cache = CachedMap.getInstance();
		ISystem sys = new SystemWrapper();
		ObjectActionLogServiceHelper.IObjectActionLogServiceHelper helper = new ObjectActionLogServiceHelper(sys);
		return new ObjectActionLogService(dataProvider, util, cache, helper);
	}   
}