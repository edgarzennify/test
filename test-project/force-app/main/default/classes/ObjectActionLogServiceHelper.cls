public class ObjectActionLogServiceHelper implements IObjectActionLogServiceHelper{

    public interface IObjectActionLogServiceHelper {
        void addLog(ObjectActionLogService.SaveSm sm);
        List<ObjectActionLogService.SaveSm> getLogs();
        void clearLogs();
        ObjectActionLogService.SaveSm buildSm(String objectName, String objectRecordId, String actionType, String action);
        List<Object_Action_Log__c> buildOALogs(List<ObjectActionLogService.SaveSm> smLogs);
        ObjectActionLogService.Data convertToDm(Object_Action_Log__c pm);
    }

    private final ISystem m_System;

    public ObjectActionLogServiceHelper(ISystem sys){
        m_System = sys;
    }

    private List<ObjectActionLogService.SaveSm> smLogs {
		get{
			if(smLogs == null){
				smLogs = new List<ObjectActionLogService.SaveSm>();
			}
			return smLogs;
		}
		set{
			smLogs = value;
		}
	}

    public void addLog(ObjectActionLogService.SaveSm sm){
        smLogs.add(sm);
    }

    public List<ObjectActionLogService.SaveSm> getLogs(){
        return smLogs;
    }

    public void clearLogs(){
        smLogs.clear();
    }

    public ObjectActionLogService.SaveSm buildSm(String objectName, String objectRecordId, String actionType, String action){
        ObjectActionLogService.SaveSm sm = new ObjectActionLogService.SaveSm();
        sm.ObjectName = objectName;
        sm.ObjectRecordId = objectRecordId;
        sm.ActionType = actionType;
        sm.Action = action;
        sm.CreatedDate = m_System.now();
        return sm;
    }

    public List<Object_Action_Log__c> buildOALogs(List<ObjectActionLogService.SaveSm> smLogs){
        List<Object_Action_Log__c> oaLogs = new List<Object_Action_Log__c>();

        for (ObjectActionLogService.SaveSm sm : smLogs){
            oaLogs.add(buildOALog(sm));
        }

        return oaLogs;
    }

    public ObjectActionLogService.Data convertToDm(Object_Action_Log__c pm){
        ObjectActionLogService.Data dmLog = new ObjectActionLogService.Data();
    	dmLog.Action = pm.Action__c;
    	dmLog.ObjectName = pm.Object_API_Name__c;
    	dmLog.ObjectRecordId = pm.Object_Id__c;
        dmLog.TimeInStageBusinessDays = pm.Cycle_Time_In_Business_Days__c;
        dmLog.TimeInStageBusinessDaysHours = pm.Cycle_Time_In_Business_Days_Hours__c;
        dmLog.CreatedDate = pm.Action_Date_Time__c;
        dmlog.LocalizedCreatedDate = pm.Action_Date_Time__c.format();
    	dmLog.CreatedBy = new dmUser();
    	dmLog.CreatedBy.id = pm.createdBy.id;
    	dmLog.CreatedBy.name = pm.createdBy.name;

    	return dmLog;
    }

    private Object_Action_Log__c buildOALog(ObjectActionLogService.SaveSm sm){
        Object_Action_Log__c oaLog = new Object_Action_Log__c();
        Utility.debug_Log('sm is: ', sm);
        oaLog.Object_API_Name__c = sm.ObjectName;
    	oaLog.Object_Id__c = sm.ObjectRecordId;
    	oaLog.Action_Type__c = sm.ActionType;
    	oaLog.Action__c = sm.Action;
    	oaLog.Action_Date_Time__c = sm.CreatedDate;
        if(oaLog.Action_Date_Time__c == null){
    		oaLog.Action_Date_Time__c = m_System.now();
    	}

    	return oaLog;
    }
}