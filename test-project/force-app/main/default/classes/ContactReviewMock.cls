public class ContactReviewMock {

    public class ofIPresenter extends ApexMoq implements ContactReview.IPresenter{        
        public ContactReview.FormVm init(){
            return (ContactReview.FormVm)handleMethodInvocation('init');
        }
        public ContactReview.FormVm handleAcceptClicked(string contactReviewId, ContactReview.FormVm vm){
            return (ContactReview.FormVm)handleMethodInvocation('handleAcceptClicked', new List<Object> {contactReviewId,vm});
        }
        public void save(ContactReview.SmContact sm){
            handleMethodInvocation('save', new List<Object> {sm});
        }
    }
    
    public class ofIdataProvider extends ApexMoq implements ContactReview.IDataProvider{
        
        public List<ContactReview.AccountPm> getAccountsWithContactsByAccountId(List<Id> accountIds){
            return (List<ContactReview.AccountPm>)handleMethodInvocation('getAccountsWithContactsByAccountId', new List<Object>{accountIds});
        }
        public List<ContactReview.ContactReviewPm> getContactReviewDetails(){
            return (List<ContactReview.ContactReviewPm>)handleMethodInvocation('getContactReviewDetails');
        }
        public void updateProcessedFlag(String contractReviewId){
             handleMethodInvocation('updateProcessedFlag', new List<Object>{contractReviewId});
        }
        public void save(ContactReview.ContactPm pm){
             handleMethodInvocation('save', new List<Object>{pm});
        }
    }
    
    public class ofIDmBuilder extends ApexMoq implements ContactReview.IDmBuilder{
        
        public List<DmContactReview> build(List<ContactReview.ContactReviewPm> reviews, List<ContactReview.AccountPm> accountsWithContacts){
            return (List<DmContactReview>)handleMethodInvocation('build', new List<Object> {reviews, accountsWithContacts});
        }
    }
    
     public class ofIVmBuilder extends ApexMoq implements ContactReview.IVmBuilder{
        
        public List<ContactReview.VmContactReview> build(List<DmContactReview> reviews){
            return (List<ContactReview.VmContactReview>)handleMethodInvocation('build', new List<Object> {reviews});
        }
    }
    public class ofIRepository extends ApexMoq implements Contactreview.IRepository{
        
        public List<DmContactReview> getAllContactReviews(){
            return (List<DmContactReview>)handleMethodInvocation('getAllContactReviews');
        }
        
        public DmContactReview getContactReviewById(String reviewId){
            return (DmContactReview)handleMethodInvocation('getContactReviewById', new List<Object>{reviewId});
        }
        public void save(DmContact contact){
            handleMethodInvocation('save',new List<Object>{contact});
        }
        public void updateProcessedFlag(String reviewId){
            handleMethodInvocation('updateProcessedFlag',new List<Object>{reviewId});
        }
    }
}