@IsTest
private class ContactReviewControllerTests {
	private final static ContactReviewController sut;
    private final static ContactReviewMock.ofIPresenter mockPresenter;
       
    static {
        mockPresenter = new ContactReviewMock.ofIPresenter();
        sut = new ContactReviewController(mockPresenter);
    }    
    
    @IsTest
    static void it_should_do_initialize() {
         sut.initialize();
         
         mockPresenter.verify('init', Times.Once);
    }
    
    @IsTest
    static void it_should_call_presenter() {
        String testId = '123213213';
        ContactReview.FormVm vm = new ContactReview.FormVm();
        
        sut.vm = vm;
        sut.selectedContactReviewId = testId;
        sut.acceptClicked();
      
        mockPresenter.verify('handleAcceptClicked', new List<Object>{testId, vm}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_controller_to_cover_testing() {
        ContactReviewController msut= new ContactReviewController();
    }
}