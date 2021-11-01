public class TmArchivingMapperHelper implements TmArchiving.IMapperHelper {

    private final TmArchiving.IConfiguration m_config;
    private final TmConfiguration.IRepository m_configRepository;

    public TmArchivingMapperHelper(TmConfiguration.IRepository configRepository, TmArchiving.IConfiguration config){
        m_configRepository = configRepository;
        m_config = config;
    }

    public RecordType getRecordType(List<RecordType> pms, String currentRecordType) {
        for (RecordType rT: pms) {
            if (rT.Name == currentRecordType) {
                return rT;
            }
        }
        return null;
    }

    public Treasury_Management__c buildTMObject(TmArchiving.MapperRequestContainer container, String recordName) {
        Treasury_Management__c obj = new Treasury_Management__c();
        obj.Start_Date__c = System.Today();
        TM_Service_request__c requestPm = container.Pm == null || container.Pm.requestPm == null? null:container.Pm.requestPm;
        obj.TM_Service_Request__c = requestPm == null ? null:requestPm.id;
        obj.Account__c = container.Pm.entityPm.Id;
        obj.Pricing_Packages__c = getOnlineBankingBundle(requestPm);
        setupPrimaryContact(obj, container.Pm);
        setupSecondaryContact(obj, container.Pm);
        RecordType recType = getRecordType(container.RecordTypes, recordName);
        if (recType == null) {return obj;}
        obj.RecordTypeId = recType.Id;
        obj.Product_PL__c = recType.Name;
        
        return obj;
    }

    private string getOnlineBankingBundle(TM_Service_request__c requestPm) {
        return requestPm == null? '' : requestPm.TM_Service_Request_Packet__r.Bundle_Type__c;
    }

    public boolean compare(string item, string compareTo) {
        if(string.isBlank(item)) return false;
        return item.tolowerCase() == compareTo.toLowerCase();
    }

    public Id getFeeAccount(List<Tm_Service_Request_Account__c> relatedAccounts) {
        if(relatedAccounts == null || relatedAccounts.size() == 0){return null;}
        Eb_Account__c feeAccount = new Eb_Account__c();
        Eb_Account__c productFeeAccount = new Eb_Account__c();
        for(Tm_Service_Request_Account__c a: relatedAccounts) {
            if(a.EB_Account__r != null && a.EB_Account__r.Fee_Master_Account__c != null && a.EB_Account__r.Fee_Master_Account__c == true){          
                feeAccount = a.EB_Account__r;
            }
            if(a.Product_Fee_Account__c == true){
                productFeeAccount = a.EB_Account__r;
            }
        }
        return String.isBlank(productFeeAccount.Id)? feeAccount.Id: productFeeAccount.Id;
    }

    public Eb_Account__c getMasterAccount(List<Tm_Service_Request_Account__c> relatedAccounts){
        if(relatedAccounts == null || relatedAccounts.size() == 0){return null;}
        Eb_Account__c masterAccount = new Eb_Account__c();
        Eb_Account__c feeAccount = new Eb_Account__c();
        for(Tm_Service_Request_Account__c a : relatedAccounts){
            if(a.EB_Account__r != null && a.Master_Account__c == true){
                masterAccount = a.Eb_Account__r;
            }
            if(a.Product_Fee_Account__c == true){
                feeAccount = a.EB_Account__r;
            }
        }
        if(String.IsNotBlank(masterAccount.Id)){
            return masterAccount;
        }
        if(String.isNotBlank(feeAccount.Id)){
            return feeAccount;
        }
        return null;
    }

    public Tm_Service_Request_Account__c getSweepAccount(List<Tm_Service_Request_Account__c> relatedAccounts) {
        for(Tm_Service_Request_Account__c a: relatedAccounts) {
            if(a.Sweep_Investment_Account_Number__c != null && a.Sweep_Investment_Account_Number__c == true){          
                return a;
            }
        }
        return null;
    }

    public Contact getPrimaryContact(List<Tm_Service_Request_Contact__c> contacts) {
        if(contacts == null || contacts.size() == 0){return null;}
        Contact primaryContact = null;
        Contact productContact = null;
        for(Tm_Service_Request_Contact__c c : contacts) {
            if(c.Contact__r != null && c.Contact__r.Primary_TM_Contact__c == true){
                primaryContact = c.Contact__r;
            }
            if(c.Primary_Product_Contact__c == true){
                productContact = c.Contact__r;
            }
        }
        return productContact == null? primaryContact : productContact;
    }

    public Contact getSecondaryContact(List<Tm_Service_Request_Contact__c> contacts) {
        if(contacts == null || contacts.size() == 0){return null;}
        Contact secondaryContact = null;
        Contact productContact = null;
        for(Tm_Service_Request_Contact__c c : contacts) {
            if(c.Contact__r != null && c.Contact__r.Secondary_TM_Contact__c == true){
                secondaryContact = c.Contact__r;
            }
            if(c.Secondary_Product_Contact__c == true){
                productContact = c.Contact__r;
            }
        }
        return productContact == null? secondaryContact : productContact;
    }

    public Eb_Account__c getLoanAccount(TmBoarding.RequestPm r){
        for(Tm_Service_Request_Account__c ra: r.serviceAccountPms) {
            if(ra.EB_Account__r.Application__c ==11 || ra.EB_Account__r.Application__c == 13 || ra.EB_Account__r.Application__c == 15){
                return ra.Eb_Account__r;
            }
        }
        return null;
    }

    public Decimal getDailyLimit(TmBoarding.RequestPm r) {
        Tm_Service_Request_Account__c accountRel = new Tm_Service_Request_Account__c();
        Decimal total = 0.0;
        for(Tm_Service_Request_Account__c ra: r.serviceAccountPms) {
            if(ra.Daily_Dollar_Limit__c != null) {total += ra.Daily_Dollar_Limit__c;}
        }
        return total;
    }


    public Boolean getObjectValue_bool(TM_Service_Request_Contact__c c, String fieldName) {
        try {
            return Boolean.valueOf(c.get(fieldName));
        }catch(Exception ex) {
            return false;
        }
    }

    public String getObjectValue_string(TM_Service_Request_Contact__c c, String fieldName) {
        try {
            return String.valueOf(c.get(fieldName));
        }catch(Exception ex) {
            return null;
        }
    }

    public Decimal annualFee(Decimal monthlyFee) {
        if(monthlyFee == null){monthlyFee = 0;}
        return monthlyFee * 12;
    }

    public string concatenate(string text, integer size){
		if(String.isBlank(text) || size == 0) return text;
        Integer textLength = text.length();
        if(textLength <= size) return text;
		return text.substring(0,size);
	}

    private Contact getPrimaryContact(List<Contact> contacts){
         if(contacts == null || contacts.size() == 0){return null;}
         for(Contact c : contacts){
            if(c!= null && c.Primary_TM_Contact__c == true){
                return c;
            }
         }
         return null;
    }

    private Contact getSecondaryContact(List<Contact> contacts){
         if(contacts == null || contacts.size() == 0){return null;}
         for(Contact c : contacts){
            if(c!= null && c.Secondary_TM_Contact__c == true){
                return c;
            }
         }
         return null;
    }

    private Tm_service_Request__c getOnlineBankingProduct(TmArchiving.MapperRequestContainer container){

		for(Tm_service_Request__c req : container.Pm.packetRequestsPm){ 
			if(req.RecordTypeId != null && req.RecordType.Name.toLowerCase() == m_config.RECORDTYPE_ONLINE_BANKING().toLowerCase()){
				return req;
			}
		}
        return null;
    }

    private void setupPrimaryContact(Treasury_Management__c obj, TmBoarding.RequestPm pm) {
        Contact primaryContact = getPrimaryContact(pm.serviceContactPms);
        if(primaryContact == null){ primaryContact = getPrimaryContact(pm.ContactPms); }
        if(primaryContact != null){ obj.Contact__c = primaryContact.Id;}
    }

    private void setupSecondaryContact(Treasury_Management__c obj, TmBoarding.RequestPm pm) {
        Contact secondaryContact = getSecondaryContact(pm.serviceContactPms);
        if(secondaryContact != null){ obj.Secondary_Contact__c = secondaryContact.Id;}
    }
}