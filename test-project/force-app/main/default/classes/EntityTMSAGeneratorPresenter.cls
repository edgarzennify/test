global class EntityTMSAGeneratorPresenter implements EntityTMSAGenerator.IPresenter{

    private static final Integer SVC_APPLICATION_ID = 2;
    private static final String TMSA_ENTITY_STATUS = 'Out for Signature';


    private final TmBoarding.IPresenter m_tmBoardingPresenter;
    private final TmBoarding.ISignerManager m_signerManager;
    private final EntityTMSAGenerator.IDataProvider m_dataProvider;

    
    public EntityTMSAGeneratorPresenter(TmBoarding.IPresenter tmBoardingPresenter, TmBoarding.ISignerManager signerManager, EntityTMSAGenerator.IDataProvider dataProvider) {
        m_tmBoardingPresenter = tmBoardingPresenter;
        m_signerManager = signerManager;
        m_dataProvider = dataProvider;
    }
    
    public EntityTMSAGenerator.FormVm buildFormVm(Account entity){
        EntityTMSAGenerator.FormVm formVm = new EntityTMSAGenerator.FormVm();
        List<string> tmos = m_tmBoardingPresenter.getTmos();
        formVm.TMContacts = getTMOContacts(tmos);
        EntityTMSAGenerator.EntityPm entityPm = m_dataProvider.getExtendedEntity(entity.Id);
        if(entityPm != null && entityPm.entity != null && entityPm.relatedContacts != null){
            List<Contact> clientInfos = entityPm.relatedContacts;
            formVm.EntityId = String.valueOf(entityPm.entity.Id);
            formVm.EntityName = entityPm.entity.Name;
            formVm.ExistingTMSADate = entityPm.entity.Date_TM_Master_Agmt_Signed__c;
            formVm.ExistingTMSALink = entityPm.entity.TMSA_Imaging_Document_Url__c;    
            formVm.Status =  entityPm.entity.TMSA_Signature_Status__c;      
            formVm.ClientContacts = getClientContacts(clientInfos);
        }
        return formVm;
    }

    public Boolean sendForSignature(string entityId, List<TmBoarding.SignerInfo> signers){
        EntityTMSAGenerator.EntityPm entityPm = m_dataProvider.getExtendedEntity(entityId);
        boolean response = m_signerManager.sendForSignature(entityPm.entity.Name, entityPm.entity.Id, signers, new List<string>{entityPm.entity.Id},  SVC_APPLICATION_ID);
        if(response == true){
            m_dataProvider.save(new Account(Id=entityPm.entity.Id, TMSA_Signature_Status__c=TMSA_ENTITY_STATUS));
            return true;
        }
        return false;
    }
    
    private List<EntityTMSAGenerator.TMSAContact> getTMOContacts(List<string> tmos){
        List<EntityTMSAGenerator.TMSAContact> contacts = new List<EntityTMSAGenerator.TMSAContact>();
        for(String tmo: tmos){
            if (tmo.length() > 0) {
                List<string> contactInfos = tmo.split('\\|');
                EntityTMSAGenerator.TMSAContact tmsaContact = new EntityTMSAGenerator.TMSAContact();
                tmsaContact.ContactId = contactInfos[2];
                tmsaContact.FirstName =contactInfos[0];
                tmsaContact.LastName =contactInfos[1];
                tmsaContact.Email = contactInfos[2];
                if (contactInfos.size() > 3) {
                    tmsaContact.Phone = contactInfos[3];
                }
                contacts.add(tmsaContact);
            }
        }
        return contacts;
    }
    
    private List<EntityTMSAGenerator.TMSAContact> getClientContacts(List<Contact> clientContacts){
        List<EntityTMSAGenerator.TMSAContact> contacts = new List<EntityTMSAGenerator.TMSAContact>();
        for(Contact c: clientContacts){
            EntityTMSAGenerator.TMSAContact tmsaContact = new EntityTMSAGenerator.TMSAContact();
            tmsaContact.ContactId = c.Id;
            tmsaContact.FirstName = c.FirstName;
            tmsaContact.LastName =c.LastName;
            tmsaContact.Email = c.Email;
            tmsaContact.Phone = c.Phone;
            contacts.add(tmsaContact);
        }
        return contacts;
    }
}