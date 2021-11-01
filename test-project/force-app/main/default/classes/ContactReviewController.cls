global class ContactReviewController {
    private ContactReview.IPresenter m_presenter;

    public ContactReview.FormVm vm {get;set;}
    public string selectedContactReviewId {get;set;}    

    public ContactReviewController(){
       	m_presenter = ContactReviewBootstrapper.getInstanceOfIPresenter();
    }

    public ContactReviewController(ContactReview.IPresenter presenter){
        m_presenter = presenter;    
    }
    
    public void initialize(){
        vm = m_presenter.init();
    }
    
    public PageReference acceptClicked(){
        vm = m_presenter.handleAcceptClicked(selectedContactReviewId, vm);
        return new PageReference('/apex/contactreview');
    }
    
    @RemoteAction
    global static ContactReview.FormVm remoteBootstrap() {
        ContactReview.IPresenter presenter = ContactReviewBootstrapper.getInstanceOfIPresenter();
        return presenter.init();
    }
    
    @RemoteAction
    global static void remoteAccept(ContactReview.SmContact sm) {
        ContactReview.IPresenter presenter = ContactReviewBootstrapper.getInstanceOfIPresenter();
        presenter.save(sm);        
    }
}