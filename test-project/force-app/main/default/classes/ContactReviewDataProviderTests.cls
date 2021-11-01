@IsTest
private class ContactReviewDataProviderTests {
	private final static ContactReviewDataProvider sut;
    static{
        sut = new ContactReviewDataProvider();
    }
    
    private static testmethod void it_should_get_contacts_for_entity(){
        Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
        EB_Team_Member__c teamMember = objectFactory.getTeamMember('Team Member');
        Account entity = ObjectFactory.getEntity('Entity1',ClientRecordTypeId,teamMember);
        
        Contact contact1 = new Contact();
            contact1.FirstName='Contact1';
        	contact1.AccountId=entity.Id;
        	contact1.Key__c = entity.EB_Customer_Number__c + '-C';
        	contact1.Firstname='Contacti'; 
            contact1.LastName='Contactos'; 
            contact1.Core_FirstName__c='';
            contact1.Core_LastName__c=''; 
            contact1.Phone='';
            contact1.MailingStreet='';
            contact1.MailingCity='';
            contact1.MailingState='';
            contact1.MailingPostalCode ='';
        
        insert contact1;
        List<Id> entityIdList = new List<Id>();
        entityIdList.add(entity.Id);
        List<ContactReview.AccountPm> results = sut.getAccountsWithContactsByAccountId(entityIdList);
        System.assertEquals(1, results.size());
        
        Object fieldObject;
        fieldObject = results[0].Name;
    }
    
    private static testmethod void it_should_get_contact_reviews(){
        Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
        EB_Team_Member__c teamMember = objectFactory.getTeamMember('Team Member');
        Account entity = ObjectFactory.getEntity('Entity1',ClientRecordTypeId,teamMember);
        Date bDate = Date.newInstance(2000, 7, 8);
        List<Contact_Review__c> reviews = new List<Contact_Review__c>();
        Contact_Review__c contactRev1 = new Contact_Review__c();
                        contactRev1.AccountId__c=entity.Id;
                        contactRev1.Key__c = entity.EB_Customer_Number__c + '-C';
                        contactRev1.Birthdate__c = bDate;
                        contactRev1.Core_FirstName__c = 'Custname';
                        contactRev1.Core_LastName__c = 'Custlast';
                        contactRev1.First_Name__c = 'Firstname';
                        contactRev1.Last_Name__c = 'lastname';
                        contactRev1.Import_Source__c = '';
                        contactRev1.Mailing_City__c='';
                        contactRev1.Mailing_Postal_Code__c='';
                        contactRev1.Mailing_State__c='';
                        contactRev1.Mailing_Street__c='';
        
        reviews.add(contactRev1);
        insert reviews;
        
        List<ContactReview.ContactReviewPm> results = sut.getContactReviewDetails();
        System.assertEquals(1, results.size());
        
        Object fieldObject;
        fieldObject = results[0].First_Name_c;
    }
 private static testmethod void it_should_save_contact(){
        ContactReview.ContactPm pm = new ContactReview.ContactPm(); 
     	pm.FirstName='ContactFirstName';
     	pm.LastName='ContactLastName';
        sut.save(pm);
    }
    
    private static testMethod void it_should_update_flag(){
        Contact_Review__c ctr = new Contact_Review__c();
        ctr.Processed_Flag__c=true;
        insert ctr;
        sut.updateProcessedFlag(ctr.Id);
    }
   
}