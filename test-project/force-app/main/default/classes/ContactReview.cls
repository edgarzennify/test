global class ContactReview {
    public interface IPresenter {
        FormVm init();
        FormVm handleAcceptClicked(string contactReviewId, FormVm vm);
        void save(SmContact sm);
    }
    
    public Interface IRepository {        
        List<DmContactReview> getAllContactReviews();
        DmContactReview getContactReviewById(String reviewId);        
        void save(DmContact contact);
        void updateProcessedFlag(String reviewId);
    }
    
    public Interface IDataProvider {
        List<AccountPm> getAccountsWithContactsByAccountId(List<String> accountIds);
        List<ContactReviewPm> getContactReviewDetails();        
        void updateProcessedFlag(String contractReviewId);
        void save(ContactPm pm);
    }	  
        
    public Interface IDmBuilder{
        List<DmContactReview> build(List<ContactReviewPm> reviews, List<AccountPm> accountsWithContacts);        
    }
    
    public Interface IVmBuilder{
        List<ContactReview.VmContactReview> build(List<DmContactReview> dmReviews);
    }
    
    global class FormVm{
        public List<VmContactReview> contactReviews{get;set;}
    }
    
    public class VmContactReview{
        public string Id {get; set;}
        public string FirstName {get; set;}
        public string LastName {get; set;}
        public string EntityName {get; set;}
        public string Phone {get; set;}
        public string MobilePhone {get; set;}
        public string Address {get; set;}
        public List<VmExistingContact> existingContacts {get;set;} 
        public List<SelectOption> existingContactOptions {get;set;}
        public String selectedOptionId {get;set;}
    }
    
    global class VmExistingContact{
        public string Id {get;set;}
        public string AccountId {get;set;}
        public string FirstName{get;set;}
        public string LastName{get;set;}
        public string Phone {get; set;}
        public string MobilePhone {get; set;}
        public string Address {get; set;}
    }
    
    global class SmContact {
        public string ContactReviewId {get;set;}
        public string ExistingContactId {get;set;}
        public string FirstName {get;set;}
        public string LastName {get;set;}
    }
    
    public class AccountPm {
        public string Id {get;set;}
        public string Name {get;set;}
        public List<ContactPm> Contacts {get;set;}
    }
    
    public class ContactPm {
        public string Id {get;set;}        
        public string AccountId {get;set;}
        public string Core_First_Name_c {get;set;}
        public string Core_Last_Name_c {get;set;}
        public string FirstName {get;set;}
        public string LastName {get;set;}
        public string Key_c {get;set;}
        public string Phone {get;set;}
        public string MobilePhone {get;set;}
        public string MailingStreet {get;set;}
        public string MailingCity {get;set;}
        public string MailingState {get;set;}
        public string MailingPostalCode {get;set;}
        public string Import_Source_c {get;set;}
    }
    
    public class ContactReviewPm {
        public string Id {get;set;}
        public string First_Name_c {get;set;}
        public string Last_Name_c {get;set;}
        public string AccountId_c {get;set;}
        public string Phone_c {get;set;}
        public string Mobile_Phone_c {get;set;}
        public string Mailing_Street_c {get;set;}
        public string Mailing_City_c {get;set;}
        public string Mailing_State_c {get;set;}
        public string Mailing_Postal_Code_c {get;set;}
        public string Core_First_Name_c {get;set;}
        public string Core_Last_Name_c {get;set;}
        public string Key_c {get;set;}
        public string Import_Source_c {get;set;}
        public string Processed_Flag_c {get;set;}
    }
}