@IsTest
public class ContactReviewVmBuilderTests {
private static final ContactReviewVmBuilder sut;
    
    static {
        sut = new ContactReviewVmBuilder();
    }
    
     private static testMethod void it_should_build_vm_contact_review(){             
         Id acctId = ObjectFactory.getFakeId(Account.SObjectType, '1');
         List<DmContact> cntcs =  new List<DmContact>();
         DmContact ct1 = new DmContact();
         ct1.Id='yyyyy';
         ct1.accountId=acctId;
         cntcs.add(ct1);
         List<DmContactReview> dmReviews = new List<DmContactReview>();
        
         DmEntity entity = new DmEntity();
         entity.id=acctId;
         entity.contacts = cntcs;
         entity.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
         
         DmContactReview dm1 = new DmContactReview();
         dm1.firstName='CustFirst';
         dm1.lastName='CustLast';
         dm1.phone='314 111 2222';
         dm1.mobilePhone='314 333 4444';
         dm1.mailingStreet='121 N warson';
         dm1.mailingCity='st louis';
         dm1.mailingState='MO';
         dm1.mailingPostalCode='63132';
         dm1.entity=entity;
         dmReviews.add(dm1);
         
         string address = '121 N warson, st louis, MO, 63132' ;
         List<ContactReview.VmContactReview> result=sut.build(dmReviews);

         System.assertEquals(1, result.size());
         System.assertEquals(address, result[0].Address);
         System.assertEquals(acctId, result[0].existingContacts[0].AccountId);
    }
}