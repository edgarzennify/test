public class AgreementStatusManager implements Agreements.IAgreementStatusManager{  
	
    private IUserInfoService m_userInfoService;
    private Agreements.IAgreementEntityManager m_agreementEntityManager;
    private Agreements.IAgreementStatusManagerDataProvider m_dataProvider;
    private Map<Id, List<EB_Loan_Application__c>> m_agreementLoanApps = null;
    
    public AgreementStatusManager(IUserInfoService userInfoSvc, Agreements.IAgreementEntityManager entityManager, Agreements.IAgreementStatusManagerDataProvider dataProvider){
    	m_userInfoService = userInfoSvc;
        m_agreementEntityManager = entityManager;
        m_dataProvider = dataProvider;
    }
        
    private static RecordType activeRecordType{
        get{
            return utility.RecordTypeObject('Agreement__c', 'Active');
        }
    }
    
    private static RecordType archiveRecordType{
        get{
            return utility.RecordTypeObject('Agreement__c', 'Archive');
        }
    }
    
    private static RecordType pendingRecordType{
        get{
            return utility.RecordTypeObject('Agreement__c', 'Pending');
        }
    }
    
    private void SetRecordTypeAdminBackdoor(Id agmtId, RecordType newRecordType){
        Agreement__c agmt = new Agreement__c(Id=agmtId);
        agmt.RecordTypeId = newRecordType.Id;
        m_dataProvider.saveAgreement(agmt);
    }
    
    public Boolean isAgreementEditable(Agreement__c agreement, Id userId){
    	Boolean isAgreementInBackOfficeModification = isBackOfficeModification(agreement);
        Boolean isAgreementPending = isAgreementPending(agreement);
        Boolean hasRelatedLoanApps = hasRelatedLoanApps(agreement);
        Boolean isAgreementStageNew = isAgreementStageNew(agreement);
        Boolean areAnyAppsBeyondNew = areAnyAppsBeyondNew(agreement);
        Boolean isAgreementInUnderwriting = isAgreementInUnderwriting(agreement);
        Boolean userHasCreditAnalystPermission = m_userInfoService.hasPermissionSet(userId,'Role - Credit Analyst');
        Boolean userHasBackOfficeModificationPermission = m_userInfoService.hasPermissionSet(userId,'Function - Lending Agreement System - Back Office Modification');
        Boolean userIsSystemAdmin = m_userInfoService.isSystemAdministrator(userId);
        Boolean areAnyAppsInUnderwriting = areAnyAppsInUnderwriting(agreement);
        Boolean areAnyAppsBeyondUnderwriting = areAnyAppsBeyondUnderwriting(agreement);

        return (
                  (!hasRelatedLoanApps && isAgreementPending && isAgreementStageNew) 
                ||(!hasRelatedLoanApps && isAgreementPending && isAgreementInUnderwriting && (userHasCreditAnalystPermission || userIsSystemAdmin))
                ||(!hasRelatedLoanApps && isAgreementPending && isAgreementInBackOfficeModification && (userHasBackOfficeModificationPermission || userIsSystemAdmin))
                ||(hasRelatedLoanApps && isAgreementPending && !areAnyAppsBeyondNew)
                ||(hasRelatedLoanApps && isAgreementPending && areAnyAppsInUnderwriting && !areAnyAppsBeyondUnderwriting && (userHasCreditAnalystPermission || userIsSystemAdmin))
                
            	? true : false);
    }

    private boolean hasRelatedLoanApps(Agreement__c agmt){
      return (getLoanApplications(agmt).Size()> 0) ? true : false;
    }

    private Boolean isAgreementPending(Agreement__c agmt){
        return(agmt.RecordTypeId == Utility.recordTypeObject('Agreement__c','Pending').Id) ? true : false;
    }

    private boolean isAgreementStageNew(Agreement__c agmt){
        return(agmt.Stage__r.Name == 'New')? true : false; 
    }

    private boolean isBackOfficeModification(Agreement__c agmt){
        return (agmt.Stage__r.Name == 'Back Office Modification') ? true : false;
    }

    private Boolean isAgreementActive(Agreement__c agmt){
        return (agmt.RecordTypeDescription__c == 'Active')? true:false;
    }

    private Boolean isAgreementArchive(Agreement__c agmt){
        return(agmt.RecordTypeDescription__c == 'Archive') ? true : false;
    }

    private boolean isAgreementInUnderwriting(Agreement__c agmt){
      return (agmt.Stage__r.loan_app_stage_action_controller__r.Name == 'Underwriting') ? true : false;
    }  

    private boolean areAnyAppsInUnderwriting(Agreement__c agmt){
        Boolean returnResult = false;
        for(EB_Loan_Application__c app: getLoanApplications(agmt)){
            if(app.Application_Stage__r.loan_app_stage_action_controller__r.Name == 'Underwriting') 
                returnResult = true;      
        }
        return returnResult;
    }

    private boolean areAnyAppsBeyondUnderwriting(Agreement__c agmt){
        Boolean returnResult = false;
        for(EB_Loan_Application__c app: getLoanApplications(agmt)){
            if(app.Application_Stage__r.loan_app_stage_action_controller__r.Name != 'New' && app.Application_Stage__r.loan_app_stage_action_controller__r.Name != 'Underwriting')
                returnResult = true;      
        }
        return returnResult;
    }

    private Boolean areAnyAppsBeyondNew(Agreement__c agmt){
        Boolean returnResult = false;
        for(EB_Loan_Application__c app: getLoanApplications(agmt)){
            if(app.Application_Stage__r.Name != 'New') returnResult = true;      
        }
        return returnResult;
    }

    private List<EB_Loan_Application__c> getLoanApplications(Agreement__c agmt){
        if(m_agreementLoanApps == null){
            m_agreementLoanApps = new Map<Id, List<EB_Loan_Application__c>>();
        }
        if(m_agreementLoanApps.get(agmt.Id) == null){
            m_agreementLoanApps.put(agmt.Id, fetchLoanApplications(agmt));
        }
        return m_agreementLoanApps.get(agmt.Id);
    }
    
    private List<EB_Loan_Application__c> fetchLoanApplications(Agreement__c agmt){
    	List<EB_Loan_Application__c> agmtApps = new List<EB_Loan_Application__c>();
        List<Agreement_Loan_Application_Relationship__c> agmtAppRels = m_dataProvider.getAgreementLoanAppRelationshipsByAgreementId(agmt.Id);
        
        if(agmtAppRels != null){
            for(Agreement_Loan_Application_Relationship__c rel : agmtAppRels){
                agmtApps.add(rel.Loan_Application__r);
            }
        }
        
        return agmtApps;
    } 
    
    public void enterBackOfficeModification(Agreement__c agreement){
    	agreement.Back_Office_Start_Stage__c = agreement.Stage__c;
    	agreement.Back_Office_Start_Path__c = agreement.Actual_Approval_Process__c;    	
    	agreement.Back_Office_Start_Approver_One__c = agreement.Approver_One__c;
    	agreement.Back_Office_Start_Approver_Two__c = agreement.Approver_Two__c;
    	agreement.Back_Office_Start_Approver_Three__c = agreement.Approver_Three__c;
    	resetApprovalFields(agreement);
    }

    public void exitBackOfficeModification(Agreement__c agreement){
        agreement.Stage__c = agreement.Back_Office_Start_Stage__c;
        agreement.Actual_Approval_Process__c = agreement.Back_Office_Start_Path__c;
        agreement.Approver_One__c = agreement.Back_Office_Start_Approver_One__c;
        agreement.Approver_Two__c = agreement.Back_Office_Start_Approver_Two__c;
        agreement.Approver_Three__c = agreement.Back_Office_Start_Approver_Three__c;
        resetBackOfficeStartFields(agreement);
    }
    
    private void resetApprovalFields(Agreement__c agreement){
        agreement.Actual_Approval_Process__c = '';
        agreement.Approver_One__c = null;
        agreement.Approver_Two__c = null;
        agreement.Approver_Three__c = null;
    }
    
    private void resetBackOfficeStartFields(Agreement__c agreement){
    	agreement.Back_Office_Start_Stage__c = null;
        agreement.Back_Office_Start_Path__c = '';
        agreement.Back_Office_Start_Approver_One__c = null;
        agreement.Back_Office_Start_Approver_Two__c = null;
        agreement.Back_Office_Start_Approver_Three__c = null;
    }

    public void MakeActiveAdminBackdoor(Id agmtId){		
        SetRecordTypeAdminBackdoor(agmtId, activeRecordType);     
    }
    
    public void MakeArchiveAdminBackdoor(Id agmtId){
		SetRecordTypeAdminBackdoor(agmtId, archiveRecordType);
    }
    
    public void MakePendingAdminBackdoor(Id agmtId){
		SetRecordTypeAdminBackdoor(agmtId, pendingRecordType);
    }
    
    public void MakeNewAdminBackdoor(Id agmtId){
		EB_Loan_App_Stage__c newStage = m_dataProvider.getLoanAppStageByName('New');
		Agreement__c agmt = m_dataProvider.getAgreementById(agmtId);
		agmt.Stage__c = newStage.Id;
		m_dataProvider.saveAgreement(agmt);
    }
    
    public void attachLoanAppAgreementsToAccount(Id appId, Id acctId){
        List<Agreement_EB_Account_Relationship__c> newRels = new List<Agreement_EB_Account_Relationship__c>();

        List<Agreement_Loan_Application_Relationship__c> appRels = m_dataProvider.getAgreementLoanApplicationRelationshipsByAppId(appId);
        List<Agreement_EB_Account_Relationship__c> existingRels = m_dataProvider.getAgreementAccountRelationshipsByAccountId(acctId);
        
        Map<Id,Id> agmtsAlreadyAttached = new Map<Id,Id>();
        for(Agreement_EB_Account_Relationship__c existing : existingRels){
            agmtsAlreadyAttached.put(existing.Agreement__c, existing.Agreement__c);
        }
        
        for(Agreement_Loan_Application_Relationship__c appAgmt : appRels){
            if(!agmtsAlreadyAttached.containsKey(appAgmt.Agreement__c)){
                Agreement_EB_Account_Relationship__c newAcctAgmt = new Agreement_EB_Account_Relationship__c();
                newAcctAgmt.Agreement__c = appAgmt.Agreement__c;
                newAcctAgmt.Loan_Account__c = acctId;
                newRels.add(newAcctAgmt);
            }
        }

        if(newRels.size() > 0){
            m_dataProvider.saveAccountRelationships(newRels);
        }
    }
    
    public void MakeActive(Id agmtId){
        Agreement__c newAgmt;
        Agreement__c oldAgmt;
        Id agmtSourceId;
		if(agmtId != null){
        	newAgmt = m_dataProvider.getAgreementById(agmtId);
        }
        if(newAgmt.Source_Agreement__c != null){
        	agmtSourceId = newAgmt.Source_Agreement__c;
        }
        if(agmtSourceId != null){
        	oldAgmt = m_dataProvider.getAgreementById(agmtSourceId);
        }
        ProcessRecordTypeChange(newAgmt,oldAgmt);        
    }
    
    public void MakeArchive(Id agmtId){
    	Agreement__c agreement;
    	if(agmtId != null){
            agreement = m_dataProvider.getAgreementById(agmtId);
        }
        agreement.RecordTypeId = archiveRecordType.Id;
        m_dataProvider.saveAgreement(agreement);
        
        m_agreementEntityManager.copyActiveFinancialReportingRequirementsToArchive(agreement.Id);
    }  

    public Boolean hasLoanApps(Agreement__c agreement){
    	return hasRelatedLoanApps(agreement);
    }
      
    private void ProcessRecordTypeChange(Agreement__c newAgmt, Agreement__c oldAgmt){        
        if(newAgmt.Id != null){
            if(oldAgmt != null){
	        	if(oldAgmt.Id != null){
	          		//Has Source Agreement
	        		if(oldAgmt.RecordTypeId == activeRecordType.Id){
	        			makeArchiveWithReplacement(oldAgmt, newAgmt.Id);
	        		}	    
	        	}
            }
	       
	        if(newAgmt.RecordTypeId == pendingRecordType.Id){
	        	newAgmt.RecordTypeId = activeRecordType.Id;	        	
	        	m_dataProvider.saveAgreement(newAgmt);
	        	m_agreementEntityManager.copyPendingFinancialReportingRequirementsToActive(newAgmt.Id);
                
	        }
        }
    }
    
    private void makeArchiveWithReplacement(Agreement__c agreement, Id replacedById){
        agreement.RecordTypeId = archiveRecordType.Id;
        agreement.Replaced_By_Agreement__c = replacedById;
        m_dataProvider.saveAgreement(agreement);
        
        m_agreementEntityManager.copyActiveFinancialReportingRequirementsToArchive(agreement.Id);
    }
    
    public RecordType getRecordType(Agreement__c agreement){
        return Utility.recordTypeObject('Agreement__c',agreement.RecordTypeId);
    }
    
}