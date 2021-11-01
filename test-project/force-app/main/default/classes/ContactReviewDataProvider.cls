public class ContactReviewDataProvider extends DataProvider implements ContactReview.IDataProvider { 
    
    public List<ContactReview.AccountPm> getAccountsWithContactsByAccountId(List<String> accountIds){
        List<Account> results = [
            SELECT
                Name,
                (
                    SELECT 	
                    	Id, 
                    	Name,
                    	FirstName,
                    	LastName,
                    	Phone,
                    	MobilePhone,
                    	MailingStreet,
                    	MailingCity,
                    	MailingState,
						MailingPostalCode,
                    	Core_FirstName__c,
                    	Core_LastName__c
                    FROM 	
                    	Contacts 
                )
            FROM
            	Account
            WHERE 
            	Id in : accountIds
        ];
        return ConvertToPms(results);
    }
    
    public List<ContactReview.ContactReviewPm> getContactReviewDetails(){
        List<Contact_Review__c> results = [
            SELECT 
                Id,
                AccountId__c,
                Birthdate__c,
                Core_FirstName__c,
                Core_LastName__c,
                First_Name__c,
                Last_Name__c,
                Import_Source__c,
                Key__c,
                Mailing_City__c,
                Mailing_Postal_Code__c,
                Mailing_State__c,
                Mailing_Street__c,
                Phone__c,
                Home_Phone__c,
                Processed_Flag__c
            FROM 
                Contact_Review__c
            WHERE
                Processed_Flag__c != true
            LIMIT
            	100
            ];
        return ConvertToPms(results);
    }    
    
    public void save(ContactReview.ContactPm pm){
        Contact c = new Contact();
        c.Id = pm.Id;
        c.RecordTypeId = Utility.recordTypeObject('Contact', 'Synchronized Contact').Id;
        c.FirstName = pm.FirstName;
        c.LastName = pm.LastName;
        c.AccountId = pm.AccountId;  
        c.Phone = pm.Phone;
        c.MobilePhone = pm.MobilePhone;
        c.MailingStreet = pm.MailingStreet;
        c.MailingCity = pm.MailingCity;
        c.MailingState = pm.MailingState;
        c.MailingPostalCode = pm.MailingPostalCode;
        c.Core_FirstName__c = pm.Core_First_Name_c;
        c.Core_LastName__c = pm.Core_Last_Name_c;
        c.Key__c = pm.Key_c;
        c.ImportSource__c = pm.Import_Source_c;
        
        if(string.isEmpty(pm.Id)){                      
            insert c;
        }else{                       
            update c;
        }            
    }
    
    public void updateProcessedFlag(String contactReviewId){
        Contact_Review__c cr = new Contact_Review__c(Id=contactReviewId, Processed_Flag__c=true);
        update cr;
    }
    
    private List<ContactReview.AccountPm> ConvertToPms(List<Account> accounts){
        List<ContactReview.AccountPm> pms = new List<ContactReview.AccountPm>();
        for(Account a : accounts){
            ContactReview.AccountPm pm = new ContactReview.AccountPm();
            pm.Id = a.Id;
            pm.Name = a.Name;
            pm.Contacts = ConvertToPms(a.Contacts);
            pms.add(pm);
        }
        return pms;
    }
    
    private List<ContactReview.ContactPm> ConvertToPms(List<Contact> contacts){
        List<ContactReview.ContactPm> pms = new List<ContactReview.ContactPm>();
        for(Contact c : contacts){
            ContactReview.ContactPm pm = new ContactReview.ContactPm();
            pm.Id = c.Id;
            pm.FirstName = c.FirstName;
            pm.LastName = c.LastName;
            pm.Phone = c.Phone;
            pm.MobilePhone = c.MobilePhone;
            pm.MailingStreet = c.MailingStreet;
            pm.MailingCity = c.MailingCity;
            pm.MailingState = c.MailingState;
            pm.MailingPostalCode = c.MailingPostalCode;
            pm.Core_First_Name_c = c.Core_FirstName__c;
            pm.Core_Last_Name_c = c.Core_LastName__c;
            pms.add(pm);
        }
        return pms;
    }
    
    private List<ContactReview.ContactReviewPm> ConvertToPms(List<Contact_Review__c> contactReviews){
        List<ContactReview.ContactReviewPm> pms = new List<ContactReview.ContactReviewPm>();
        for(Contact_Review__c cr : contactReviews){
            ContactReview.ContactReviewPm pm = new ContactReview.ContactReviewPm();
            pm.Id = cr.Id;
            pm.First_Name_c = cr.First_Name__c;
            pm.Last_Name_c = cr.Last_Name__c;
            pm.AccountId_c = cr.AccountId__c;
            pm.Phone_c = cr.Phone__c;
            pm.Mobile_Phone_c = cr.Home_Phone__c;
            pm.Mailing_Street_c = cr.Mailing_Street__c;
            pm.Mailing_City_c = cr.Mailing_City__c;
            pm.Mailing_State_c = cr.Mailing_State__c;
            pm.Mailing_Postal_Code_c = cr.Mailing_Postal_Code__c;
            pm.Core_First_Name_c = cr.Core_FirstName__c;
            pm.Core_Last_Name_c = cr.Core_LastName__c;
            pm.Import_Source_c = cr.Import_Source__c;
            pm.Key_c = cr.Key__c;
            pms.add(pm);
        }
        return pms;
    }
}