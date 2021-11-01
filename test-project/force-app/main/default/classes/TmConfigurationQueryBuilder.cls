public class TmConfigurationQueryBuilder implements TmConfiguration.IQueryBuilder{
    public List<String> addRequiredRequestFields(List<String> fields) {
        List<String> required = new List<String>();
        required.add('Id'); 
        required.add('Name');
        required.add('RecordType.Id');
        required.add('RecordType.Name');
        required.add('RecordTypeId');
        required.add('Stage__c');
        required.add('Stage__r.Name');
        required.add('TM_Service_Request_Packet__c');
        required.add('TM_Service_Request_Packet__r.Name');
        required.add('TM_Service_Request_Packet__r.Id'); 
        required.add('TM_Service_Request_Packet__r.Entity__r.Id');
        required.add('TM_Service_Request_Packet__r.Entity__r.Name');
        required.add('TM_Service_Request_Packet__r.Opportunity__c');

        return mergeFields(fields, required);
    }
    public List<String> addRequiredContactFields(List<String> fields) {
        List<String> required = new List<String>();
        required.add('Id');
		required.add('AccountId');
		required.add('FirstName');
		required.add('LastName');
		required.add('Name');
        return mergeFields(fields, required);
    }
    public List<String> addRequiredAccountFields(List<String> fields) {
        List<String> required = new List<String>();
        required.add('EB_Account_Id__r.Id');
        required.add('EB_Account_Id__r.Name');
        required.add('EB_Account_Id__r.Account_Number__c');
        required.add('EB_Account_Id__r.Application__c');
        required.add('EB_Account_Id__r.Account_Line_1__c');
        required.add('EB_Account_Id__r.Account_Name__c');
        required.add('EB_Account_Id__r.ApplicationDescription__c'); 
        required.add('EB_Account_Id__r.Fee_Master_Account__c'); 
        List<String> objAppendedFields = new List<String>();
        if(fields != null) {
            for(String f : fields) {
                objAppendedFields.add(String.format('{0}.{1}', new List<String> {'EB_Account_Id__r', f}));
            }
        }

        List<string> merged = mergeFields(objAppendedFields, required);
        Set<String> secondPass = new Set<String>();
        List<String> finalize = new List<String>();
        if(merged != null) {
            for(String s : merged) {
                String sobj = s.replace('EB_Account__c', 'EB_Account_Id__r');
            	secondPass.add(sobj);
            }
        }
        finalize.addAll(secondPass);
        return finalize;
    }
    public List<String> addRequiredContactRequestFields(List<String> fields) {
        List<String> required = new List<String>();
        required.add('Contact__r.Id');
		required.add('Contact__r.FirstName');
		required.add('Contact__r.LastName');
		required.add('Contact__r.Name');
		required.add('TM_Service_Request__c');

        return mergeFields(fields, required);
    }
    public List<String> addRequiredAccountRequestFields(List<String> fields) {
        List<String> required = new List<String>();
        required.add('EB_Account__r.Id');
        required.add('EB_Account__r.Name');
        required.add('EB_Account__r.Account_Number__c');
        required.add('EB_Account__r.Application__c'); 
        required.add('Prospective_Account__c'); 
        required.add('TM_Service_Request__c');
        required.add('Account_Number_Title__c');
        required.add('EB_Account__r.Account_Line_1__c');
        required.add('EB_Account__r.Account_Name__c');
        required.add('EB_Account__r.ApplicationDescription__c'); 
        required.add('EB_Account__r.Fee_Master_Account__c'); 
        return mergeFields(fields, required);
    }
    public List<String> addRequiredContactAccountFields(List<String> fields) {
        List<String> required = new List<String>();
        required.add('Id');
		required.add('Name');
        required.add('Account__c');
        required.add('Contact__c');
        required.add('Account_Key__c');
        required.add('Contact_Key__c');
        required.add('TM_Service_Request_Account__c');
        required.add('TM_Service_Request_Contact__c');
        required.add('TM_Service_Request_Contact__r.TM_Service_Request__c');
        required.add('TM_Service_Request_Account__r.TM_Service_Request__c');
        required.add('TM_Service_Request_Account__r.Prospective_Account__c');
        required.add('TM_Service_Request_Account__r.Eb_Account__r.Id');
        required.add('TM_Service_Request_Account__r.Eb_Account__r.Name');
        required.add('TM_Service_Request_Account__r.Eb_Account__r.Account_Line_1__c');
        required.add('TM_Service_Request_Account__r.Eb_Account__r.Account_Name__c');
        required.add('TM_Service_Request_Account__r.Eb_Account__r.ApplicationDescription__c'); 
        required.add('TM_Service_Request_Account__r.Eb_Account__r.Fee_Master_Account__c');
        required.add('TM_Service_Request_Contact__r.Contact__r.Id');
        required.add('TM_Service_Request_Contact__r.Contact__r.Name');
        required.add('TM_Service_Request_Contact__r.Contact__r.AccountId');
        return mergeFields(fields, required);
    }
    
    private List<String> mergeFields(List<string> existing, List<string> newFields) {
        Set<String> existingSet = new Set<String>();
        List<String> merged = new List<String>();
        if(existing != null){existingSet.addAll(existing);}
        if(newFields != null){existingSet.addAll(newFields);}
        merged.addAll(existingSet);
        return merged;
    }
}