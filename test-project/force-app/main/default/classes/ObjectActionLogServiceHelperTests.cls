@IsTest
public class ObjectActionLogServiceHelperTests {
    private static final Mock.ofISystem mockSystem;
    private static final ObjectActionLogServiceHelper sut;

    static{
        mockSystem = new Mock.ofISystem();
        sut = new ObjectActionLogServiceHelper(mockSystem);
    }

    @isTest
    static void it_should_add_a_log_and_return_smLogs(){
        ObjectActionLogService.SaveSm sm = new ObjectActionLogService.SaveSm();
        sm.ObjectName = 'test name';
        //act
        sut.addLog(sm);
        List<ObjectActionLogService.SaveSm> results = sut.getLogs();
        //assert
        System.assertEquals(1, results.size());
        System.assertEquals('test name', results[0].ObjectName);
    }

    @isTest
    static void it_should_clear_smLogs(){
        ObjectActionLogService.SaveSm sm = new ObjectActionLogService.SaveSm();
        sm.ObjectName = 'test name';
        //act
        sut.addLog(sm);
        sut.clearLogs();
        List<ObjectActionLogService.SaveSm> results = sut.getLogs();
        //assert
        System.assertEquals(0, results.size());
    }

    @isTest
    static void it_should_build_a_sm_given_these_strings(){
        String objectName = 'test name';
        String objectRecordId = '1234';
        String action = 'test action';
        String actionType = 'test action type';
        dateTime now = dateTime.newInstance(2000,9,1);
        mockSystem.setup('now').returns(now); 
        //act
        ObjectActionLogService.SaveSm results = sut.buildSm(objectName, objectRecordId, actionType, action);
        //assert
        System.assertEquals('test name', results.ObjectName);
        System.assertEquals('1234', results.ObjectRecordId);
        System.assertEquals('test action type', results.ActionType);
        System.assertEquals('test action', results.Action);
        System.assertEquals(now, results.CreatedDate);
    }

    @isTest
    static void it_should_build_a_oaLog_given_an_smLog_with_a_createdDate(){
        dateTime now = dateTime.newInstance(2000,9,1);
        
        ObjectActionLogService.SaveSm sm = new ObjectActionLogService.SaveSm();
        sm.ObjectName = 'test name';
        sm.ObjectRecordId = '1234';
        sm.ActionType = 'test action type';
        sm.Action = 'test action';
        sm.CreatedDate = now;

        List<ObjectActionLogService.SaveSm> smLogs = new List<ObjectActionLogService.SaveSm>{sm};

        mockSystem.setup('now').returns(now);
        //act
        List<Object_Action_Log__c> results = sut.buildOALogs(smLogs);
        //assert
        System.assertEquals(1, results.size());
        System.assertEquals('test name', results[0].Object_API_Name__c);
        System.assertEquals('1234', results[0].Object_Id__c);
        System.assertEquals('test action type', results[0].Action_Type__c);
        System.assertEquals('test action', results[0].Action__c);
        System.assertEquals(now, results[0].Action_Date_Time__c);
    }

    @isTest
    static void it_should_build_a_oaLog_given_an_smLog_without_a_createdDate(){
        dateTime now = dateTime.newInstance(2000,9,1);
        
        ObjectActionLogService.SaveSm sm = new ObjectActionLogService.SaveSm();
        sm.ObjectName = 'test name';
        sm.ObjectRecordId = '1234';
        sm.ActionType = 'test action type';
        sm.Action = 'test action';
        sm.CreatedDate = null;

        List<ObjectActionLogService.SaveSm> smLogs = new List<ObjectActionLogService.SaveSm>{sm};

        mockSystem.setup('now').returns(now);
        //act
        List<Object_Action_Log__c> results = sut.buildOALogs(smLogs);
        //assert
        System.assertEquals(1, results.size());
        System.assertEquals('test name', results[0].Object_API_Name__c);
        System.assertEquals('1234', results[0].Object_Id__c);
        System.assertEquals('test action type', results[0].Action_Type__c);
        System.assertEquals('test action', results[0].Action__c);
        System.assertEquals(now, results[0].Action_Date_Time__c);
    }

    @isTest
    static void it_should_build_a_dm_given_this_oaLog(){
        dateTime now = dateTime.newInstanceGmt(2000,9,1);
        String localizedNow = now.format();
        User testUser = ObjectFactory.getUser();
        Object_Action_Log__c oaLog = new Object_Action_Log__c();
        oaLog.Action__c = 'test action';
        oaLog.Object_API_Name__c = 'test api name';
        oaLog.Object_Id__c = '1234';
        oaLog.Cycle_Time_In_Business_Days__c = 1;
        oaLog.Action_Date_Time__c = now;
        oaLog.CreatedBy = testUser;
        oaLog.CreatedDate = now;

        mockSystem.setup('now').returns(now);
        //act
        ObjectActionLogService.Data results = sut.convertToDm(oaLog);
        //assert
        System.assertEquals(oaLog.Action__c, results.Action);
        System.assertEquals(oaLog.Object_API_Name__c, results.ObjectName);
        System.assertEquals(oaLog.Object_Id__c, results.ObjectRecordId);
        System.assertEquals(oaLog.Cycle_Time_In_Business_Days__c, results.TimeInStageBusinessDays);
        System.assertEquals(oaLog.CreatedDate, results.CreatedDate);
        System.assertEquals(localizedNow, results.LocalizedCreatedDate);
        System.assertEquals(testUser.Name, results.CreatedBy.Name);
        System.assertEquals(testUser.Id, results.CreatedBy.id);
        
    }
}