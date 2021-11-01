global class EntityTMSAGeneratorController {

    private final IStandardController m_controller;
    private final IJson m_json;


    public string recordJson {get;set;}

    public EntityTMSAGeneratorController(ApexPages.StandardController controller){
        m_json = new JsonWrapper();
        m_controller = new StandardControllerWrapper(controller);
        init(); 
    }
    
    private void init() {
        Account record = (Account) m_controller.getRecord();
        recordJson = m_json.serialize(record);
    }
    
    @RemoteAction
    global static EntityTMSAGenerator.FormVm bootstrap(string recordJson) {
        try{
            Account req = getRequest(recordJson);
            EntityTMSAGenerator.IPresenter presenter = EntityTMSAGenerator.bootstrap();
            return presenter.buildFormVm(req); 
        }catch(exception ex){
            throw new EntityTMSAGenerator.BootstrapException(ex.getMessage());
        }  
    }

    @RemoteAction
    global static Boolean sendForSignature(SignatureInfo info, string recordAsJson){
        
        try {
            Account entity = getRequest(recordAsJson);
            List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>();
            for(SignerInfo i : info.Signer){
                TmBoarding.SignerInfo signer = new TmBoarding.SignerInfo();
                signer.SignerId = i.Id;
                signer.SecurityCode = i.SecurityCode;
                signer.SignerCode = i.SignerCode;
                signer.Priority = i.Priority;
                if(i.Tmo != null){
                    signer.Tmo = new TmBoarding.TmoSigner();
                    signer.Tmo.FirstName = i.Tmo.FirstName;
                    signer.Tmo.LastName = i.Tmo.LastName;
                    signer.Tmo.Email = i.Tmo.Email;
                    signer.Tmo.Phone = i.Tmo.Phone;
                }
                signers.add(signer);
            }

            EntityTMSAGenerator.IPresenter presenter = EntityTMSAGenerator.bootstrap();
            return presenter.sendForSignature(entity.Id, signers);
        } catch (Exception ex) {           
            throw new EntityTMSAGenerator.SaveException(ex.getMessage());
        }
       
    }

    global static Account getRequest(String record) {
            IJson j = new JsonWrapper();
            Account req = (Account)j.deserialize(record, Account.class);
            return string.isBlank(req.Id)
                            ? new Account(Id = null, RecordTypeId = req.recordTypeId)
                            : new Account(Id=req.Id, RecordTypeId = req.recordTypeId);
    }
    
    global class TMSAResponse{
        public string EntityId{get;set;}
        public string EntityName{get;set;}
        public DateTime ExistingTMSADate{get;set;}
        public string ExistingTMSALink{get;set;}
        public List<TMSAContact> ClientContacts{get;set;}
        public List<TMSAContact> TMContacts{get;set;}
    }
    
    global class TMSAContact{
        public string ContactId {get;set;}
        public string Name{get;set;}
        public string Email{get;set;}
        public string Phone{get;set;}
    }

    global class SignatureInfo{
        public List<SignerInfo> Signer{get;set;}
        public string PacketId{get;set;}
        public List<string> tmRequests{get;set;}
    }

    global class SignerInfo{
        public string Id{get;set;}
        public string SecurityCode{get;set;}
        public string SignerCode{get;set;}
        public Integer Priority{get;set;}
        public TmoUser Tmo{get;set;}
    }
    
    global class TmoUser{
        public string FirstName{get;set;}
        public string LastName{get;set;}
        public string Email{get;set;}
        public string Phone{get;set;}
    }
}