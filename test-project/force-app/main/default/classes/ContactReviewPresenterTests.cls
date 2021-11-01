@IsTest
private class ContactReviewPresenterTests {
 	private final static ContactReviewPresenter sut;
    private final static ContactReviewMock.ofIRepository mockRepository;
    private final static ContactReviewMock.ofIVmBuilder mockVmbuilder;
       
   static {
        mockRepository = new ContactReviewMock.ofIRepository();
        mockVmbuilder = new ContactReviewMock.ofIVmBuilder();
        sut = new ContactReviewPresenter(mockRepository,mockVmbuilder);
    }

    @IsTest
    static void it_should_call_repository_to_get_all_contactreviews() {
        sut.init();
         mockRepository.verify('getAllContactReviews', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_vmbuilder_to_build_vms() {
        sut.init();
        mockVmbuilder.verify('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_handle_clicks_and_call_repository_to_get_contactreview_by_id() {
        List<ContactReview.VmExistingContact> existingList = new List<ContactReview.VmExistingContact>();
        ContactReview.VmExistingContact existing = new ContactReview.VmExistingContact();
        existing.Id='xxxxx';
        existing.FirstName='FirstName';
        existing.LastName='LastName';
        existingList.add(existing) ;
        
            
        ContactReview.VmContactReview selected = new ContactReview.VmContactReview();
        selected.Id='yyyy';
        selected.existingContacts=existingList;
        selected.selectedOptionId='xxxxx';
                
        ContactReview.FormVm vmForm = new ContactReview.FormVm();
            vmForm.contactReviews = new List<ContactReview.VmContactReview>{selected} ;  
            
        DmContactReview contactReview = new DmContactReview();
        contactReview.Id='xxxxx';
        contactReview.firstName='koqe';
        contactReview.lastName='kandari';
        contactReview.entity = new DmEntity();
        contactReview.entity.Id = '000001';
            
        mockRepository.setup('getContactReviewById',new List<Object>{selected.Id}).returns(contactReview);
        
        sut.handleAcceptClicked(selected.Id,vmForm);
            
        mockRepository.verify('getContactReviewById', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_handle_clicks_and_call_repository_to_save_contact_with_right_values() {
        List<ContactReview.VmExistingContact> existingList = new List<ContactReview.VmExistingContact>();
        ContactReview.VmExistingContact existing = new ContactReview.VmExistingContact();
        existing.Id='xxxxx';
        existing.FirstName='FirstName';
        existing.LastName='LastName';
        existingList.add(existing) ;
         
        ContactReview.VmContactReview selected = new ContactReview.VmContactReview();
        selected.Id='xxxxx';
        selected.existingContacts=existingList;
        selected.selectedOptionId='xxxxx';
              
        ContactReview.FormVm vmForm = new ContactReview.FormVm();
        vmForm.contactReviews = new List<ContactReview.VmContactReview>{selected} ;  
         
        DmContactReview contactReview = new DmContactReview();
        contactReview.Id='xxxxx';
        contactReview.firstName='koqe';
        contactReview.lastName='kandari';
        contactReview.entity = new DmEntity();
        contactReview.entity.Id = '000001';
         
        mockRepository.setup('getContactReviewById',new List<Object>{selected.Id}).returns(contactReview);
        
        ContactReview.FormVm result = sut.handleAcceptClicked(selected.Id,vmForm);
        List<Object> arguments = (List<Object>)mockRepository.getArgumentsFromCall('getContactReviewById');
        mockRepository.verify('getContactReviewById', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        System.assertEquals((String)arguments[0], selected.Id);
    }
}