global class EntityTMSAGenerator {

    public interface IPresenter{
        FormVm buildFormVm(Account entity);
        Boolean sendForSignature(string entityId, List<TmBoarding.SignerInfo> signers);       
    }
    
    public interface IDataProvider  extends DataProvider.IDataProvider {
        EntityPm  getExtendedEntity(Id entityId);
    }
    
    global class FormVm{
        public string EntityId{get;set;}
        public string EntityName{get;set;}
        public DateTime ExistingTMSADate{get;set;}
        public string ExistingTMSALink{get;set;}
        public string Status{get;set;}
        public List<TMSAContact> ClientContacts{get;set;}
        public List<TMSAContact> TMContacts{get;set;}
    }
    
    global class TMSAContact{
        public string ContactId {get;set;}
        public string FirstName{get;set;}
        public string LastName {get;set;}
        public string Email{get;set;}
        public string Phone{get;set;}
    }

    public class EntityPm{
        public Account Entity{get;set;}
        public List<Contact> relatedContacts{get;set;}
    }

    public class BootstrapException extends Exception { }
    public class SaveException extends Exception {}

    public static IPresenter bootstrap(){
        TmBoarding.IPresenter tmPresenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
        TmBoarding.ISignerManager signatureManager = TmBoardingBootstrapper.getInstanceOfISignerManager();
        EntityTMSAGenerator.IDataProvider dataProvider = new EntityTMSAGeneratorDataProvider();
        return new EntityTMSAGeneratorPresenter(tmPresenter, signatureManager, dataProvider);
    }
}