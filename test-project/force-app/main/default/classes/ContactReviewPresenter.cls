public class ContactReviewPresenter implements ContactReview.IPresenter {
	public final Contactreview.IRepository m_repository;
    public final ContactReview.IVmBuilder m_vmBuilder;
   
    public ContactReviewPresenter(ContactReview.IRepository repository, ContactReview.IVmBuilder vmBuilder){
        m_repository = repository;
        m_vmBuilder = vmBuilder;
    }
    
    public ContactReview.FormVm init(){
        List<DmContactReview> reviews = m_repository.getAllContactReviews();
        List<ContactReview.VmContactReview> vms = m_vmBuilder.build(reviews);        
        return buildForm(vms);
    }
    
    public ContactReview.FormVm handleAcceptClicked(string contactReviewId, ContactReview.FormVm vm){
        ContactReview.VmContactReview selected = getSelectedContactReview(contactReviewId, vm);        
        ContactReview.VmExistingContact existing = getSelectedExistingContact(selected);
        DmContactReview contactReview = m_repository.getContactReviewById(contactReviewId);        
        saveContact(contactReview, existing);
        m_repository.updateProcessedFlag(contactReview.Id);
        return init();
    }
    
    public void save(ContactReview.SmContact sm){
        DmContactReview contactReview = m_repository.getContactReviewById(sm.ContactReviewId);        
        saveContact(contactReview, sm);
        m_repository.updateProcessedFlag(contactReview.Id);
    }
     
    private void saveContact(DmContactReview review, ContactReview.SmContact sm){        
        DmContact contact = new DmContact();
        contact.id = !string.isEmpty(sm.ExistingContactId) ? sm.ExistingContactId : null;
        contact.firstName = !string.isEmpty(sm.ExistingContactId) ? sm.FirstName : review.firstName;
        contact.lastName = !string.isEmpty(sm.ExistingContactId) ? sm.LastName : review.lastName;
        contact.coreFirstName = review.firstName;
        contact.coreLastName = review.lastName;
        contact.mailingStreet = review.mailingStreet;
        contact.mailingCity = review.mailingCity;
        contact.mailingState = review.mailingState;
        contact.mailingPostalCode = review.mailingPostalCode;
        contact.mobilePhone = review.mobilePhone;
        contact.phone = review.phone;
        contact.syncKey = review.key;
        contact.importSource = review.importSource;
        contact.accountId = review.entity.id;        
        m_repository.save(contact);
    }
    
    private void saveContact(DmContactReview review, ContactReview.VmExistingContact existing){        
        DmContact contact = new DmContact();
        contact.id = existing != null ? existing.Id : null;
        contact.firstName = existing != null ? existing.FirstName : review.firstName;
        contact.lastName = existing != null ? existing.LastName : review.lastName;
        contact.coreFirstName = review.firstName;
        contact.coreLastName = review.lastName;
        contact.mailingStreet = review.mailingStreet;
        contact.mailingCity = review.mailingCity;
        contact.mailingState = review.mailingState;
        contact.mailingPostalCode = review.mailingPostalCode;
        contact.mobilePhone = review.mobilePhone;
        contact.phone = review.phone;
        contact.syncKey = review.key;
        contact.importSource = review.importSource;
        contact.accountId = review.entity.id;        
        m_repository.save(contact);
    }
        
    private ContactReview.VmContactReview getSelectedContactReview(string contactReviewId, ContactReview.FormVm vm){
        for(ContactReview.VmContactReview cr : vm.contactReviews){
            if(cr.Id == contactReviewId){
                return cr;
            }
        }
        return null;
    }
    
    private ContactReview.VmExistingContact getSelectedExistingContact(ContactReview.VmContactReview contactReviewVm){
        for(ContactReview.VmExistingContact c : contactReviewVm.existingContacts){
            if(c.Id == contactReviewVm.selectedOptionId){
                return c;
            }
        }
        return null;
    }
    
    private Contactreview.FormVm buildForm(List<ContactReview.VmContactReview> vms){
        Contactreview.FormVm result = new Contactreview.FormVm();
      	result.contactreviews = vms;
        return result;
    }
}