@Istest
public class ContactReviewDmBuilderTests {
	private static final ContactReviewDmBuilder sut;
    
    static {
        sut = new ContactReviewDmBuilder();
    }
    
    private static testMethod void it_should_build_dm_contact_review(){       
        
        Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        ContactReview.AccountPm entity = new ContactReview.AccountPm();
        entity.Id=entityId;
        entity.Name='Test Name 1';
        
        Id contact1Id = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        ContactReview.ContactPm ct1 = new ContactReview.ContactPm();
        ct1.Id=contact1Id;
        ct1.firstName='Contact1';    
        ct1.lastName='Last1';    
        Id contact2Id = ObjectFactory.getFakeId(Contact.SObjectType, '2');
        ContactReview.ContactPm ct2 = new ContactReview.ContactPm();
        ct2.Id=contact2Id;
        ct2.firstName='Contact2'; 
        ct2.lastName='Last2';
        entity.Contacts = new List<ContactReview.ContactPm>{ct1, ct2};               
        
        Id contactRev1Id = ObjectFactory.getFakeId(Contact_Review__c.SObjectType, '1');
        ContactReview.ContactReviewPm ctreview1= new ContactReview.ContactReviewPm();
        ctreview1.Id=contactRev1Id;
        ctreview1.AccountId_c=entity.Id;
        ctreview1.First_Name_c='Cust First';
        ctreview1.Last_Name_c='Cust Last';
        
        List<ContactReview.ContactReviewPm> reviews = new List<ContactReview.ContactReviewPm>{ctreview1};        
        List<ContactReview.AccountPm> accounts = new List<ContactReview.AccountPm>{entity};
            
        List<DmContactReview> result = sut.build(reviews, accounts);
        
        System.assertEquals(1, result.size());
        System.assertEquals(contactRev1Id, result[0].Id);
        System.assertEquals('Cust First', result[0].firstName);
        System.assertEquals('Cust Last', result[0].lastName);
        System.assertEquals('Test Name 1', result[0].entity.name);
        System.assertEquals(2, result[0].entity.contacts.size());
        System.assertEquals('Contact1', result[0].entity.contacts[0].firstname);
        System.assertEquals('Contact2', result[0].entity.contacts[1].firstname);
        System.assertEquals('Last1', result[0].entity.contacts[0].lastname);
        System.assertEquals('Last2', result[0].entity.contacts[1].lastname);
    }
   
}