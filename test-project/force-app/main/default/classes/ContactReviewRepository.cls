public class ContactReviewRepository implements ContactReview.IRepository{
	private final ContactReview.IDataProvider m_dataProvider;
    private final ContactReview.IDmBuilder m_dmBuilder;
    
    public ContactReviewRepository(ContactReview.IDataProvider dataProvider, ContactReview.IDmBuilder dmbuilder){
        m_dataProvider = dataProvider;
        m_dmBuilder = dmbuilder;
    }
    
    public List<DmContactReview> getAllContactReviews(){
        List<ContactReview.ContactReviewPm> reviews = m_dataProvider.getContactReviewDetails();
        List<Id> acctIds = getAcctIds(reviews); 
		List<ContactReview.AccountPm> accts = m_dataProvider.getAccountsWithContactsByAccountId(acctIds) ;            
        return m_dmBuilder.build(reviews, accts);        
    }   
    
    public DmContactReview getContactReviewById(String reviewId){
        List<DmContactReview> reviews = getAllContactReviews();
        for(DmContactReview dm : reviews){
            if(dm.Id == reviewId) return dm;
        }
        return null;
    }
    
    public void save(DmContact contact){        
        ContactReview.ContactPm newPm = new ContactReview.ContactPm();
		newPm.Id = contact.id;        
        newPm.FirstName = contact.firstName;
        newPm.LastName = contact.lastName;
        newPm.Core_First_Name_c = contact.coreFirstName;
        newPm.Core_Last_Name_c = contact.coreLastName;        
        newPm.MailingStreet = contact.mailingStreet;
        newPm.MailingCity = contact.mailingCity;
        newPm.MailingState = contact.mailingState;
        newPm.MailingPostalCode = contact.mailingPostalCode;
        newPm.Phone = contact.phone;
        newPm.MobilePhone = contact.mobilePhone;        
        newPm.Key_c = contact.syncKey;
        newPm.Import_Source_c = contact.importSource;
        newPm.AccountId = contact.accountId;
        m_dataProvider.save(newPm);
    }
    
    public void updateProcessedFlag(String reviewId){
        m_dataProvider.updateProcessedFlag(reviewId);
    }
    
    private List<Id> getAcctIds(List<ContactReview.ContactReviewPm> reviews){
        
        List<Id> results = new List<Id>();
        if(reviews!=null && reviews.Size() > 0 ){
            for(ContactReview.ContactReviewPm r : reviews){
            	results.add(r.AccountId_c);
        	}
        }
        return results;
    }   
        
}