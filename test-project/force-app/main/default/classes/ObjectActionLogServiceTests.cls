@IsTest
private class ObjectActionLogServiceTests {
	private static final ObjectActionLogServiceTests.ofIDataProvider mockDataProvider;
	private static final Mock.ofIUtility mockUtility;
	private static final Mock.ofICachedMap mockCache;
	private static final ObjectActionLogServiceTests.ofIObjectActionLogServiceHelper mockHelper;
	private static final ObjectActionLogService sut;

	static {		
		mockDataProvider= new ObjectActionLogServiceTests.ofIDataProvider();
		mockUtility = new Mock.ofIUtility();
		mockCache = new Mock.ofICachedMap();
		mockhelper = new ObjectActionLogServiceTests.ofIObjectActionLogServiceHelper();
		sut = new ObjectActionLogService(mockDataProvider, mockUtility, mockCache, mockhelper);
	}

	@IsTest 
	static void it_should_return_a_list_of_dmLogs_when_given_a_single_request() {
		
		ObjectActionLogService.ObjectAndTypeRequest request= new ObjectActionLogService.ObjectAndTypeRequest();
		request.ObjectRecordId = 'sdfwerwet';
		request.ActionType = 'asdf';
		string objectId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Object_Action_Log__c objActionLog = new Object_Action_Log__c();
		objActionLog.Action__c = 'test';
		objActionLog.Object_API_Name__c = 'sdfwert';
		objActionLog.Object_Id__c = 'wetwerdsdf';
		objActionLog.Action_Date_Time__c = System.now();
		objActionLog.CreatedBy = new User();

		List<Object_Action_Log__c> objectActionLogs = new List<Object_Action_Log__c>{objActionLog};

		ObjectActionLogService.Data dm = new ObjectActionLogService.Data();
		dm.Action = 'test';

		mockUtility.setup('convertid15ToId18', new List<Object>{request.ObjectRecordId}).returns(objectId);
		mockDataProvider.setup('get', new List<Object>{objectId, request.ActionType}).returns(objectActionLogs);
		mockHelper.setup('convertToDm', new List<Object>{objActionLog}).returns(dm);

		List<ObjectActionLogService.Data> results = sut.get(request);
	
		System.assertEquals(1, results.size());
		System.assertEquals('test', results[0].Action);
	}

	@IsTest 
	static void it_should_return_a_list_of_dmlogs_when_given_a_list_of_requests() {
		String actionType = 'qwerty';
		ObjectActionLogService.ObjectRequest request= new ObjectActionLogService.ObjectRequest();
		request.ObjectRecordId = 'sdfwerwet';
		string objectId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Object_Action_Log__c objActionLog = new Object_Action_Log__c();
		objActionLog.Action__c = 'test';
		objActionLog.Object_API_Name__c = 'sdfwert';
		objActionLog.Object_Id__c = 'wetwerdsdf';
		objActionLog.Action_Date_Time__c = System.now();
		objActionLog.CreatedBy = new User();

		List<Object_Action_Log__c> objectActionLogs = new List<Object_Action_Log__c>{objActionLog};

		ObjectActionLogService.Data dm = new ObjectActionLogService.Data();
		dm.Action = 'test';

		mockUtility.setup('convertid15ToId18', new List<Object>{request.ObjectRecordId}).returns(objectId);
		mockDataProvider.setup('get', new List<Object>{new List<string>{objectId}, actionType}).returns(objectActionLogs);
		mockHelper.setup('convertToDm', new List<Object>{objActionLog}).returns(dm);

		Map<string, List<ObjectActionLogService.Data>> result = sut.get(new List<ObjectActionLogService.ObjectRequest>{request}, actionType);
	
		System.assertEquals(1, result.keySet().size());
		System.assertEquals('test', result.get(objActionLog.Object_Id__c)[0].Action);
	}

	@IsTest
	static void it_should_add_each_sm_to_the_log_once(){
		String key01 = '1-1-1-1';
		String key02 = '2-2-2-2';

		ObjectActionLogService.SaveSm sm01 = new ObjectActionLogService.SaveSm();
		sm01.ObjectName = 'test name 1';
		ObjectActionLogService.SaveSm sm02 = new ObjectActionLogService.SaveSm();
		sm02.ObjectName = 'test name 2';

		mockCache.setup('containsKey', new List<Object>{key01}).returns(false);
		mockHelper.setup('buildSm', new List<Object>{'1','1','1','1'}).returns(sm01);
		mockCache.setup('containsKey', new List<Object>{key02}).returns(false);
		mockHelper.setup('buildSm', new List<Object>{'2','2','2','2'}).returns(sm02);
		//act
		sut.log('1','1','1','1');
		sut.log('2','2','2','2');
		//assert
		mockHelper.verify('addLog', new List<Object>{sm01}, Times.Once);
		mockHelper.verify('addLog', new List<Object>{sm02}, Times.Once);
	}

	@IsTest
	static void it_should_get_the_smLogs_from_the_helper_when_recording_logs(){
		//act
		sut.recordCachedLogs();
		//assert
		mockHelper.verify('getLogs', Times.Once);
	}

	@IsTest
	static void it_should_get_the_oaLogs_from_the_helper_when_recording_logs(){
		ObjectActionLogService.SaveSm smLog1 = new ObjectActionLogService.SaveSm();
		ObjectActionLogService.SaveSm smLog2 = new ObjectActionLogService.SaveSm();
		List<ObjectActionLogService.SaveSm> smLogs = new List<ObjectActionLogService.SaveSm>{smLog1,smLog2};

		mockHelper.setup('getLogs').returns(smLogs);
		//act
		sut.recordCachedLogs();
		//assert
		mockHelper.verify('buildOALogs', new List<Object>{smLogs}, Times.Once);
	}

	@IsTest
	static void it_should_save_the_oaLogs_once(){
		ObjectActionLogService.SaveSm smLog1 = new ObjectActionLogService.SaveSm();
		ObjectActionLogService.SaveSm smLog2 = new ObjectActionLogService.SaveSm();
		List<ObjectActionLogService.SaveSm> smLogs = new List<ObjectActionLogService.SaveSm>{smLog1,smLog2};

		Object_Action_Log__c oaLog1 = new Object_Action_Log__c();
		Object_Action_Log__c oaLog2 = new Object_Action_Log__c();
		List<Object_Action_Log__c> oaLogs = new List<Object_Action_Log__c>{oaLog1,oaLog2};

		mockHelper.setup('getLogs').returns(smLogs);
		mockHelper.setup('buildOALogs', new List<Object>{smLogs}).returns(oaLogs);
		//act
		sut.recordCachedLogs();
		//assert
		mockDataProvider.verify('save', new List<Object>{oaLogs}, Times.Once);
	}

	@IsTest
	static void it_should_clear_the_smLogs_once(){
		ObjectActionLogService.SaveSm smLog1 = new ObjectActionLogService.SaveSm();
		List<ObjectActionLogService.SaveSm> smLogs = new List<ObjectActionLogService.SaveSm>{smLog1};

		Object_Action_Log__c oaLog1 = new Object_Action_Log__c();
		List<Object_Action_Log__c> oaLogs = new List<Object_Action_Log__c>{oaLog1};

		mockHelper.setup('getLogs').returns(smLogs);
		mockHelper.setup('buildOALogs', new List<Object>{smLogs}).returns(oaLogs);
		//act
		sut.recordCachedLogs();
		//assert
		mockHelper.verify('clearLogs', Times.Once);
	}

	@IsTest
	static void it_should_return_a_list_of_OALogs_when_getCachedLogs_is_called(){
		ObjectActionLogService.SaveSm smLog1 = new ObjectActionLogService.SaveSm();
		List<ObjectActionLogService.SaveSm> smLogs = new List<ObjectActionLogService.SaveSm>{smLog1};

		Object_Action_Log__c oaLog1 = new Object_Action_Log__c();
		List<Object_Action_Log__c> oaLogs = new List<Object_Action_Log__c>{oaLog1};

		mockHelper.setup('getLogs').returns(smLogs);
		mockHelper.setup('buildOALogs', new List<Object>{smLogs}).returns(oaLogs);
		//act
		List<Object_Action_Log__c> results = sut.getCachedLogs();
		//assert
		System.assertEquals(1, results.size());
		System.assertEquals(oaLog1, results[0]);
	}

	@IsTest
	static void it_should_call_clearLogs_on_the_helper_once_when_getCachedLogs_is_called(){
		ObjectActionLogService.SaveSm smLog1 = new ObjectActionLogService.SaveSm();
		List<ObjectActionLogService.SaveSm> smLogs = new List<ObjectActionLogService.SaveSm>{smLog1};

		Object_Action_Log__c oaLog1 = new Object_Action_Log__c();
		List<Object_Action_Log__c> oaLogs = new List<Object_Action_Log__c>{oaLog1};

		mockHelper.setup('getLogs').returns(smLogs);
		mockHelper.setup('buildOALogs', new List<Object>{smLogs}).returns(oaLogs);
		//act
		sut.getCachedLogs();
		//assert
		mockHelper.verify('clearLogs', Times.Once);
	}
//////////////////////////////////////
	public class ofIDataProvider extends Mock.ofIDataProvider implements ObjectActionLogSvcDataProvider.IDataProvider{
        public List<Object_Action_Log__c> get(String recordId, String actionType){
            return (List<Object_Action_Log__c>)handleMethodInvocation('get', new List<Object>{recordId, actionType});
        }
		public List<Object_Action_Log__c> get(List<String> recordIds, String actionType){
            return (List<Object_Action_Log__c>)handleMethodInvocation('get', new List<Object>{recordIds, actionType});
        }
    }

	public class ofIObjectActionLogServiceHelper extends ApexMoq implements ObjectActionLogServiceHelper.IObjectActionLogServiceHelper{
		public void addLog(ObjectActionLogService.SaveSm sm){
			handleMethodInvocation('addLog', new List<Object>{sm});
		}
		public List<ObjectActionLogService.SaveSm> getLogs(){
			return (List<ObjectActionLogService.SaveSm>)handleMethodInvocation('getLogs');
		}
		public void clearLogs(){
			handleMethodInvocation('clearLogs');
		}
		public ObjectActionLogService.SaveSm buildSm(String objectName, String objectRecordId, String actionType, String action){
			return (ObjectActionLogService.SaveSm)handleMethodInvocation('buildSm', new List<Object>{objectName, objectRecordId, actionType, action});
		}
		public List<Object_Action_Log__c> buildOALogs(List<ObjectActionLogService.SaveSm> smLogs){
			return (List<Object_Action_Log__c>)handleMethodInvocation('buildOALogs', new List<Object>{smLogs});
		}
		public ObjectActionLogService.Data convertToDm(Object_Action_Log__c pm){
			return (ObjectActionLogService.Data)handleMethodInvocation('convertToDm', new List<Object>{pm});
		}
	}
}