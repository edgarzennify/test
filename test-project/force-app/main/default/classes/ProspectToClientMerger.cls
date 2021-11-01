public class ProspectToClientMerger implements ProspectToClient.IProspectToClientMerger {
	private ProspectToClient.IProspectToClientDataProvider m_dataProvider;
	
	public ProspectToClientMerger(ProspectToClient.IProspectToClientDataProvider dataProvider){
		m_dataProvider = dataProvider;
	}
	
    public Account mergeProspectAndClient(Account prospect, Account client){
    	if(copySelectedFieldsToProspect(prospect, client) != null){
    	   m_dataProvider.mergeEntities(prospect, client);    	
    	   return prospect;
    	}
    	return null;
    }
    
    private Account copySelectedFieldsToProspect(Account prospect, Account client){      
        if(prospect == null || client == null){
        	return null;
        }
        
        Id prospectRecordTypeId = Utility.recordTypeObject('Account','Prospect').Id;
        Id clientRecordTypeId = Utility.recordTypeObject('Account','Client').Id;
        
        if(prospect.RecordTypeId == prospectRecordTypeId){
            prospect.RecordTypeId = clientRecordTypeId;
            prospect.TIN_SSN__c = client.TIN_SSN__c;
            prospect.EB_Customer_Number__c = client.EB_Customer_Number__c;
            prospect.EB_Client_Name__c = client.EB_Client_Name__c;
            prospect.BillingStreet = client.BillingStreet;
            prospect.BillingState = client.BillingState;
            prospect.BillingPostalCode = client.BillingPostalCode;
            prospect.BillingCountry = client.BillingCountry;
            prospect.BillingCity = client.BillingCity;
            prospect.Phone = client.Phone;
            prospect.SSNTIN_Encrypted__c = client.SSNTIN_Encrypted__c;
            prospect.Import_Source__c = 'Prospect Promoted To Client';
            //update prospect;
        }
        
        return prospect;
    }
}