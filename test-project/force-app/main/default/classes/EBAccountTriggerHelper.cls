public class EBAccountTriggerHelper {
	
	public void preventEBAccountDeletion(LIST<EB_Account__c> ebaccounts){
		DisableAccountDelete__c da = DisableAccountDelete__c.getOrgDefaults();
		for (EB_Account__c eb : ebaccounts){
			if(eb.RecordTypeId != m_OREORecordTypeId && da.Disabled__c == false){
				eb.addError('Error: Delete is disabled for Accounts.  Please call your System Administrator for assistance.');
			}
		}
	}
	
	public void initializeOREOAccounts(List<EB_Account__c> newList){
		for(EB_Account__c eb : newList){
			if(m_OREORecordTypeId != null && eb.RecordTypeId == m_OREORecordTypeId){
				String newOreoName = generateNewOREOName;
				//Needed for user interface friendly name.
				eb.Name = newOreoName;
				//Needed for Imagenow documents and barcode generator.
				eb.Key__c = newOreoName;
				eb.Account_Line_1__c = eb.OREO_Short_Name__c;
				eb.Application__c = 91;         
			}
		}
    }
	
	public void ensureOREOAccountsLine1IsCorrect(List<EB_Account__c> newList){
		for(EB_Account__c eb : newList){
			if(m_OREORecordTypeId != null && eb.RecordTypeId == m_OREORecordTypeId){
				if(eb.Account_Line_1__c != eb.OREO_Short_Name__c){
					eb.Account_Line_1__c = eb.OREO_Short_Name__c;
				}      
			}
		}
	}
	
	public void updateAccountOfficerEmail(List<EB_Account__c> updatingAccounts){
		for(EB_Account__c updating : updatingAccounts){
			EB_Team_Member__c officer = m_associates.get(updating.EB_Team_Member__c);
			if(officer != null && officer.User__r != null && updating.Account_Officer_Email__c != officer.User__r.Email){
                updating.Account_Officer_Email__c = officer.User__r.Email;
			}
		}
	}
	
	private Id m_OREORecordTypeId{
        get{
            return Utility.recordTypeObject('EB_Account__c', 'OREO').Id;
        }
    }
    
    private String generateNewOREOName{
        get{
            OREONameGenerator__c OREONameObj = new OREONameGenerator__c();
            insert OREONameObj;
            //Funky step...required to confirm the name is in.
            OREONameObj = [SELECT Id, Name FROM OREONameGenerator__c WHERE Id =: OREONameObj.Id];
            
            return OREONameObj.Name;
        }
    }
    
    private static Map<Id, EB_Team_Member__c>m_associates{
    	get{
    		if(m_associates == null){
                m_associates = new Map<Id, EB_Team_Member__c>([SELECT Id, Name, User__c, User__r.Id, User__r.Email FROM EB_Team_Member__c]);
    		}
    		return m_associates;
    	}
    	set;
    }
}