public with sharing class ModificationRequestTriggerHandler extends TriggerHandler {	
	private final ModReqTriggerHandlerDataProv.IModReqTriggerHandlerDataProv m_dataProvider;
	private final ParentRelationshipSvc.IParentRelationshipSvc m_parentRelSvc;
	private List<Account> m_AccountsToUpdateRM = new List<Account>();

	public ModificationRequestTriggerHandler(){
		m_dataProvider = new ModReqTriggerHandlerDataProv();
		m_parentRelSvc = new ParentRelationshipSvc();
	}

    public ModificationRequestTriggerHandler(ModReqTriggerHandlerDataProv.IModReqTriggerHandlerDataProv dataProvider, ParentRelationshipSvc.IParentRelationshipSvc parentRelSvc) {
		m_dataProvider = dataProvider;
		m_parentRelSvc = parentRelSvc;
    }

    public override void bulkBeforeUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
		for(SObject oldSo : oldSos){
			checkForApprovedRMChange((Modification_Request__c)newSosMap.get(oldSo.Id));
		}
	}
	
	public override void finalize(){	
		saveRMChanges();
	}
  
    private void checkForApprovedRMChange(Modification_Request__c modRequest){
		if(modRequest.Approval_Status__c == 'Approved' && String.IsNotBlank(modRequest.New_RM__c)){/*modRequest.New_RM__c != null){*/
			Account topLevelParent = m_parentRelSvc.getTopLevelParent(modRequest.Account__c);
			modRequest.Processing_Status__c = 'Processed';
			m_AccountsToUpdateRM.add(new Account(Id=topLevelParent.Id, OwnerId=modRequest.New_RM__c));
		}
		
    }

    private void saveRMChanges(){
  		if(m_AccountsToUpdateRM.size() > 0){
  			m_dataProvider.saveAccounts(m_AccountsToUpdateRM);
  		}
    }

}