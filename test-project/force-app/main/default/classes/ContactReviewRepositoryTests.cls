@IsTest
private class ContactReviewRepositoryTests {
    private final static ContactReviewRepository sut;
	private final static ContactReviewMock.ofIDataProvider mockDataProvider;
    private final static ContactReviewMock.ofIDmBuilder mockDmBuilder;
    
   static {
        mockDataProvider = new ContactReviewMock.ofIDataProvider();
        mockDmBuilder = new ContactReviewMock.ofIDmBuilder();
        sut = new ContactReviewRepository(mockDataProvider,mockDmBuilder);
    }
    
    @IsTest
    static void it_should_call_dataprovider_to_save() {
        DmContact ct = new DmContact();
        ct.id='yyyyyy';
        
        sut.save(ct);

        mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }
    
    @IsTest
    static void it_should_call_dataprovider_to_get_contact_review_by_id() {
        Id acctId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        List<Id> acctIds= new List<Id>{acctId};
            
        ContactReview.ContactReviewPm ctreview1 = new ContactReview.ContactReviewPm();
        ctreview1.AccountId_c=acctId;    
            
        List<ContactReview.ContactReviewPm> pmReviews= new List<ContactReview.ContactReviewPm>();
        pmReviews.Add(ctreview1);
        
        ContactReview.AccountPm acctPm1 = new ContactReview.AccountPm();
       
        ContactReview.ContactPm ct = new ContactReview.ContactPm();
        ct.AccountId=acctId;
        
        List<ContactReview.ContactPm> cts = new List<ContactReview.ContactPm>();
        cts.add(ct);
        acctPm1.Contacts=cts;
        List<ContactReview.AccountPm> returndedAcctpms= new List<ContactReview.AccountPm>(); 
        
        List<DmContactReview> dms = new List<DmContactReview>();
        DmContactReview dm = new DmContactReview();
        dm.Id='yyyyyyy';
        dms.add(dm);
           
        mockDataProvider.setup('getContactReviewDetails').returns(pmReviews);
        mockDataProvider.setup('getAccountsWithContactsByAccountId', new List<Object>{acctIds}).returns(returndedAcctpms);
        mockDmBuilder.setup('build',new List<Object>{pmReviews,returndedAcctpms}).returns(dms);
         
        sut.getContactReviewById('xxxxxxx');

        mockDataProvider.verify('getContactReviewDetails', Times.Once);
    }
    
    @IsTest
    static void it_should_call_dataprovider_to_update_flag() {
        sut.updateProcessedFlag('xxxxxx');
        mockDataProvider.verify('updateProcessedFlag', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }
    
    @IsTest
    static void it_should_call_dataprovider_and_return_contactreviews() {
        Id acctId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        List<Id> acctIds= new List<Id>{acctId};
            
        ContactReview.ContactReviewPm ctreview1 = new ContactReview.ContactReviewPm();
        ctreview1.AccountId_c=acctId;    
            
        List<ContactReview.ContactReviewPm> pmReviews= new List<ContactReview.ContactReviewPm>();
        pmReviews.Add(ctreview1);
        
        ContactReview.AccountPm acctPm1 = new ContactReview.AccountPm();
       
        ContactReview.ContactPm ct = new ContactReview.ContactPm();
        ct.AccountId=acctId;
        
        List<ContactReview.ContactPm> cts = new List<ContactReview.ContactPm>();
        cts.add(ct);
        acctPm1.Contacts=cts;
        List<ContactReview.AccountPm> returndedAcctpms= new List<ContactReview.AccountPm>(); 
        
        mockDataProvider.setup('getContactReviewDetails').returns(pmReviews);
        mockDataProvider.setup('getAccountsWithContactsByAccountId', new List<Object>{acctIds}).returns(returndedAcctpms);
        mockDmBuilder.setup('build',new List<Object>{pmReviews,returndedAcctpms});
        
         List<DmContactReview> results = sut.getAllContactReviews();
         
       	mockDmBuilder.verify('build', new List<Object>{pmReviews,returndedAcctpms}, Times.Once);
    }
}