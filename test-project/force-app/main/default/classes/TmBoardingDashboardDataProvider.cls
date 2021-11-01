public class TmBoardingDashboardDataProvider implements TmBoardingDashboard.IDataProvider {

	public List<Tm_Service_Request__c> getRequestWithActivePackets() {
		DateTime dt = System.today().addDays(-365);
		return [
			SELECT
				Id
				,Name
				,Assigned_To__c
				,RecordTypeId
				,RecordType.Name
				,Stage_Name__c
				,Stage__c
				,Stage__r.Name
				,Entity__c
				,Notes__c
				,CreatedById
				,CreatedDate
				,LastModifiedById
				,TM_Service_Request_Packet__c
				,TM_Service_Request_Packet__r.Name
				,TM_Service_Request_Packet__r.Is_Rushed__c
				,TM_Service_Request_Packet__r.Stage__c
				,TM_Service_Request_Packet__r.Last_Stage_Change_Date__c
				,TM_Service_Request_Packet__r.Entity__c
				,TM_Service_Request_Packet__r.Entity__r.Name
				,TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r.User__c
				,TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r.User__r.Name
				,TM_Service_Request_Packet__r.CreatedById
				,TM_Service_Request_Packet__r.CreatedDate
				,TM_Service_Request_Packet__r.LastModifiedById
				,TM_Service_Request_Packet__r.Entity__r.Owner.Id
				,TM_Service_Request_Packet__r.Entity__r.Owner.FirstName		
				,TM_Service_Request_Packet__r.Entity__r.Owner.LastName					
			FROM
				TM_Service_Request__c
			WHERE 
			    TM_Service_Request_Packet__r.Stage__c <> null
				AND TM_Service_Request_Packet__r.Stage__c <> 'Complete'
				AND Stage__r.Name <> 'Complete'
				AND CreatedDate >=: dt
		];
	}

	public List<Tm_Service_Request__c> getRequestWithAllPackets() {
		DateTime dt = System.today().addDays(-365);
		return [
			SELECT
				Id
				,Name
				,Assigned_To__c
				,RecordTypeId
				,RecordType.Name
				,Stage_Name__c
				,Stage__c
				,Stage__r.Name
				,Entity__c
				,Notes__c
				,CreatedById
				,CreatedDate
				,LastModifiedById
				,TM_Service_Request_Packet__c
				,TM_Service_Request_Packet__r.Name
				,TM_Service_Request_Packet__r.Is_Rushed__c
				,TM_Service_Request_Packet__r.Stage__c
				,TM_Service_Request_Packet__r.Last_Stage_Change_Date__c
				,TM_Service_Request_Packet__r.Entity__c
				,TM_Service_Request_Packet__r.Entity__r.Name
				,TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r.User__c
				,TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r.User__r.Name
				,TM_Service_Request_Packet__r.CreatedById
				,TM_Service_Request_Packet__r.CreatedDate
				,TM_Service_Request_Packet__r.LastModifiedById
				,TM_Service_Request_Packet__r.Entity__r.Owner.Id
				,TM_Service_Request_Packet__r.Entity__r.Owner.FirstName		
				,TM_Service_Request_Packet__r.Entity__r.Owner.LastName					
			FROM
				TM_Service_Request__c
			WHERE
				CreatedDate >=: dt
		];
	}

	public List<Tm_Service_Request__c> getRequestWithActivePackets(List<Id> packetIds) {

		return [
			SELECT
				Id
				,Name
				,Assigned_To__c
				,RecordTypeId
				,RecordType.Name
				,Stage_Name__c
				,Stage__c
				,Stage__r.Name
				,Entity__c
				,Notes__c
				,CreatedById
				,CreatedDate
				,LastModifiedById
				,TM_Service_Request_Packet__c
				,TM_Service_Request_Packet__r.Name
				,TM_Service_Request_PAcket__r.Is_Rushed__c
				,TM_Service_Request_Packet__r.Stage__c
				,TM_Service_Request_Packet__r.Last_Stage_Change_Date__c
				,TM_Service_Request_Packet__r.Entity__c
				,TM_Service_Request_Packet__r.Entity__r.Name
				,TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r.User__c
				,TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r.User__r.Name
				,TM_Service_Request_Packet__r.CreatedById
				,TM_Service_Request_Packet__r.CreatedDate
				,TM_Service_Request_Packet__r.LastModifiedById
				,TM_Service_Request_Packet__r.Entity__r.Owner.Id
				,TM_Service_Request_Packet__r.Entity__r.Owner.FirstName		
				,TM_Service_Request_Packet__r.Entity__r.Owner.LastName					
			FROM
				TM_Service_Request__c
			WHERE 
				TM_Service_Request_Packet__c in: packetIds
		];
	}

	public List<EB_Team_Member__c> getTeamMembers() {
		Set<Id> teamSet = new Set<Id>();
		for(Account e : [SELECT Team_Treasury_Management_Representative__c FROM Account WHERE Team_Treasury_Management_Representative__c <> null]){
			teamSet.add(e.Team_Treasury_Management_Representative__c);
		}

		return [
			SELECT
				Id
				,Name
				,Officer_Code__c
				,User__c
				,User__r.Name
			FROM
				EB_Team_Member__c
			WHERE
				Id in: teamSet
				AND Active_Employee__c =: true
				AND User__c <> null
		];
	}

	public List<Tm_Service_Request__c> getRequestWithActivePacketsBySearch(String search) {

		return [
			SELECT
				Id
				,Name
				,Assigned_To__c
				,RecordTypeId
				,RecordType.Name
				,Stage_Name__c
				,Stage__c
				,Stage__r.Name
				,Entity__c
				,Notes__c
				,CreatedBy.Name
				,CreatedById
				,CreatedDate
				,LastModifiedById
				,TM_Service_Request_Packet__c
				,TM_Service_Request_Packet__r.Name
				,TM_Service_Request_Packet__r.Is_Rushed__c
				,TM_Service_Request_Packet__r.Stage__c
				,TM_Service_Request_Packet__r.Last_Stage_Change_Date__c
				,TM_Service_Request_Packet__r.Entity__c
				,TM_Service_Request_Packet__r.Entity__r.Name
				,TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r.User__c
				,TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r.User__r.Name
				,TM_Service_Request_Packet__r.CreatedById
				,TM_Service_Request_Packet__r.CreatedBy.Name
				,TM_Service_Request_Packet__r.CreatedDate
				,TM_Service_Request_Packet__r.LastModifiedById
				,TM_Service_Request_Packet__r.Entity__r.Owner.Id
				,TM_Service_Request_Packet__r.Entity__r.Owner.FirstName		
				,TM_Service_Request_Packet__r.Entity__r.Owner.LastName					
			FROM
				TM_Service_Request__c
			WHERE 
				(
					TM_Service_Request_Packet__r.Name like: search
                    OR TM_Service_Request_Packet__r.Entity__r.Name like: search
                    OR TM_Service_Request_Packet__r.Stage__c like: search
                    OR TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r.User__r.Name like: search
                    OR TM_Service_Request_Packet__r.CreatedBy.Name like: search
                    OR RecordType.Name like: search
                    OR Stage__r.Name like: search
                    OR Name like: search
                    OR CreatedBy.Name like: search
				)
		];
	}
    
    public List<TM_Maintenance__c> getAllTmMaintenances() {
        return [
            SELECT 
            	Id
            	,Name
            	,Contact__r.Account.Id
            	,Contact__r.Account.Entity_Name__c
            	,Status__c
            	,Type__c
            	,Contact__c
            	,Contact__r.Name
            	,TmPortal_First_Name__c
            	,TmPortal_LastName__c
            	,User_Changes_Count__c
            	,Entitlement_Changes_Count__c
	            ,CreatedDate
            FROM 
				TM_Maintenance__c
        ];
    }
    
    public List<TM_Maintenance__c> getSearchedTmMaintenances(string search) {
		String likeSearch = '%' + search + '%';
        return [
            SELECT 
            	Id
            	,Name
            	,Contact__r.Account.Id
            	,Contact__r.Account.Entity_Name__c
            	,Status__c
            	,Type__c
            	,Contact__c
            	,Contact__r.Name
            	,TmPortal_First_Name__c
            	,TmPortal_LastName__c
            	,User_Changes_Count__c
            	,Entitlement_Changes_Count__c
            	,CreatedDate
				,Tm_Portal_Company_Name__c
            FROM 
				TM_Maintenance__c
            WHERE 
				(Contact__r.Name like: likeSearch
                   OR Contact__r.Account.Entity_Name__c like: likeSearch
                   OR Contact__r.Name like: likeSearch
                   OR Tm_Portal_Company_Name__c like: likeSearch)
        ];
    }

	public List<PM_Entity_Action_c> getSearchedEntityActions(string search){
		String likeSearch = '%' + search + '%';
		List<PM_Entity_Action_c> pmActions = new List<PM_Entity_Action_c>();
		List<Entity_Action__c> pms = [
			SELECT
				 Id
				,Name
				,Assigned_To__c
				,CreatedDate	
				,CreatedById
				,CreatedBy.Name
				,Date_of_Last_Stage_Change__c
				,RecordTypeId
				,RecordType.Name
				,EB_Account__c
				,EB_Account__r.Name
				,Account_Officer__c
				,Account_Officer__r.Name
				,Attention_To_Address__c
				,Charge_Status__c
				,Date__c
				,Entity__c
				,Entity__r.Name
				,Esignature_Status__c
				,Lead_Account_Number__c
				,Online_Banking_ID_s__c
				,Other_Analysis_Request__c
				,Paper_Address_Or_E_Statement_Users__c
				,Statement_Type__c
				,Subsidiary_Account_s__c
				,Status__c
				,Unit__c
				,Unit__r.Name
				,Waive_Expiration_Date__c
			FROM
				Entity_Action__c
			WHERE
				(Entity__r.Name like: likeSearch
				OR EB_Account__r.Name like: likeSearch
				OR Name like: likeSearch)
		];

		if(pms == null || pms.size() == 0) return pmActions;
		for(Entity_Action__c pm: pms){
			pmActions.add(buildEntityActionPm(pm));
		}
		return pmActions;
	}

	public List<PM_Entity_Action_c> getEntityActions(){
		List<PM_Entity_Action_c> pmActions = new List<PM_Entity_Action_c>();
		List<Entity_Action__c> pms = [
			SELECT
				 Id
				,Name
				,Assigned_To__c
				,CreatedDate	
				,CreatedById
				,CreatedBy.Name
				,Date_of_Last_Stage_Change__c
				,RecordTypeId
				,RecordType.Name
				,EB_Account__c
				,EB_Account__r.Name
				,Account_Officer__c
				,Account_Officer__r.Name
				,Attention_To_Address__c
				,Charge_Status__c
				,Date__c
				,Entity__c
				,Entity__r.Name
				,Esignature_Status__c
				,Lead_Account_Number__c
				,Online_Banking_ID_s__c
				,Other_Analysis_Request__c
				,Paper_Address_Or_E_Statement_Users__c
				,Statement_Type__c
				,Subsidiary_Account_s__c
				,Status__c
				,Unit__c
				,Unit__r.Name
				,Waive_Expiration_Date__c
			FROM
				Entity_Action__c
		];
		if(pms == null || pms.size() == 0) return pmActions;
		for(Entity_Action__c pm: pms){
			pmActions.add(buildEntityActionPm(pm));
		}
		return pmActions;
	}

	public Map<string, PM_Object_Action_Log_c> getStageLogsForTMRequests(){
        DateTime dt = System.today().addDays(-365);
		Map<string, PM_Object_Action_Log_c> pmLogs = new Map<string, PM_Object_Action_Log_c>();
		List<Object_Action_Log__c> pms = [
			SELECT 
				Id
				,Action_Date_Time__c
				,Object_Id__c  
			FROM 
				Object_Action_Log__c 
			WHERE 
                Object_API_Name__c = 'TM_Service_Request__c'
				AND Action_Type__c = 'Stage Logging' 
				AND Action__c = 'Ops Product Setup'
                AND CreatedDate >=: dt
			ORDER BY
				Action_Date_Time__c DESC
		];
		if(pms == null || pms.size() == 0) return pmLogs;
		for(Object_Action_Log__c pm : pms){
			if(!pmLogs.containsKey(pm.Object_Id__c)){
				PM_Object_Action_Log_c pmLog = new PM_Object_Action_Log_c();
				pmLog.Object_Id_c = pm.Object_Id__c;
				pmLog.Action_Date_Time_c = pm.Action_Date_Time__c;
				pmLogs.put(pm.Object_Id__c, pmLog);
			}
		}
		return pmLogs;
	}

	private PM_Entity_Action_c buildEntityActionPm(Entity_Action__c pm){
		PM_Entity_Action_c actionPm = new PM_Entity_Action_c();
		actionPm.id = pm.Id;
		actionPm.name = pm.Name;
		actionPm.CreatedDate = pm.CreatedDate;
		actionPm.RecordType = new PM_RecordType();
		actionPm.RecordType.id = pm.RecordTypeId;
		actionPm.RecordType.name = pm.RecordType.Name;
		actionPm.Account_Number_r = new PM_EB_Account_c();
		actionPm.Account_Number_r.id = pm.EB_Account__c;
		actionPm.Account_Number_r.name = pm.EB_Account__r.Name;
		actionPm.Account_Officer_r = new PM_User();
		actionPm.Account_Officer_r.id = pm.Account_Officer__c;
		actionPm.Account_Officer_r.name = pm.Account_Officer__r.Name;
		actionPm.Attention_To_Address_c  = pm.Attention_To_Address__c;
		actionPm.Charge_Status_c = pm.Charge_Status__c;
		actionPm.Date_c = pm.Date__c;
		actionPm.Entity_r = new PM_Account();
		actionPm.Entity_r.id = pm.Entity__c;
		actionPm.Entity_r.name = pm.Entity__r.name;
		actionPm.Esignature_Status_c = pm.Esignature_Status__c;
		actionPm.Lead_Account_Number_c = pm.Lead_Account_Number__c;
		actionPm.Online_Banking_ID_s_c = pm.Online_Banking_ID_s__c;
		actionPm.Other_Analysis_Request_c = pm.Other_Analysis_Request__c;
		actionPm.Paper_Address_Or_E_Statement_Users_c = pm.Paper_Address_Or_E_Statement_Users__c;
		actionPm.Statement_Type_c = pm.Statement_Type__c;
		actionPm.Subsidiary_Account_s_c = pm.Subsidiary_Account_s__c;
		actionPm.status_c = pm.status__c;
		actionPm.Unit_r = new PM_EB_Unit_c();
		actionPm.Unit_r.id = pm.Unit__c;
		actionPm.Unit_r.name = pm.Unit__r.Name;
		actionPm.Waive_Expiration_Date_c = pm.Waive_Expiration_Date__c;
		actionPm.CreatedBy = new PM_User();
		actionPm.CreatedBy.Id = pm.createdById;
		actionPm.CreatedBy.Name = pm.CreatedBy.Name;
		actionPm.Assigned_To_c = pm.Assigned_To__c;
		
		actionPm.Date_of_Last_Stage_Change_c = pm.Date_of_Last_Stage_Change__c;

		return actionPm;
	}

}