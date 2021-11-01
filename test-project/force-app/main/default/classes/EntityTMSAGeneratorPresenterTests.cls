@IsTest
private class EntityTMSAGeneratorPresenterTests {

    private static final TmBoardingMock.ofIPresenter mockTmPresenter;
    private static final TmBoardingMock.ofISignerManager mockSignerManager;
    private static final EntityTMSAGeneratorMock.ofIDataProvider mockDataProvider;
    private static final EntityTMSAGeneratorPresenter sut;

    static {
        mockTmPresenter = new TmBoardingMock.ofIPresenter();
        mockSignerManager = new TmBoardingMock.ofISignerManager();
        mockDataProvider = new EntityTMSAGeneratorMock.ofIDataProvider();
        sut = new EntityTMSAGeneratorPresenter(mockTmPresenter, mockSignerManager, mockDataProvider);
    }

    @IsTest
    static void it_should_call_the_dataProvider_to_get_extended_entity_fields() {
        Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
       
        String firstName = 'test first';
        String lastName = 'test last';
        String email = 'x@enterprisebank.com';
        Contact testContact = new Contact(Id=contactId);
        testContact.AccountId = entityId;
        testContact.FirstName = firstName;
        testContact.LastName = lastName;
        testContact.Email = email;
        List<Contact> contacts = new List<Contact>{testContact};
               
        String entityName = 'Test Entity';
        String status = 'Any';
        String docUrl = 'http://www.example.com';
        Date dt = Date.newInstance(2001,1,1);
 
        EntityTMSAGenerator.entityPm entityExtended = new EntityTMSAGenerator.entityPm();
        entityExtended.entity = new Account();
        entityExtended.entity.Id = entityId;
        entityExtended.entity.Name = entityName;
        entityExtended.entity.Date_TM_Master_Agmt_Signed__c = dt;
        entityExtended.entity.TMSA_Signature_Status__c = status;
        entityExtended.entity.TMSA_Imaging_Document_Url__c = docUrl;      
        entityExtended.relatedContacts = contacts;

        List<string> tmos = new List<string>{'tmo1|x|y|z', 'tmo2|x2|y2|z2'};
        mockTmPresenter.setup('getTmos').returns(tmos);
        mockDataProvider.setup('getExtendedEntity', new List<Object>{entityId}).returns(entityExtended);

        EntityTMSAGenerator.FormVm result = sut.buildFormVm(new Account(Id= entityId));

        System.assertEquals(entityId, result.EntityId);
        System.assertEquals(entityName, result.EntityName);
        System.assertEquals(dt, result.ExistingTMSADate);
        System.assertEquals(docUrl, result.ExistingTMSALink);

        System.assertEquals(contactId, result.ClientContacts[0].contactId);
        System.assertEquals(firstName, result.ClientContacts[0].firstName);
        System.assertEquals(lastName, result.ClientContacts[0].lastName);
        System.assertEquals(email, result.ClientContacts[0].email);

        System.assertEquals('y', result.TMContacts[0].contactId);
        System.assertEquals('tmo1', result.TMContacts[0].firstName);
        System.assertEquals('x', result.TMContacts[0].lastName);
        System.assertEquals('y', result.TMContacts[0].email);
        System.assertEquals('z', result.TMContacts[0].phone);

        System.assertEquals('y2', result.TMContacts[1].contactId);
        System.assertEquals('tmo2', result.TMContacts[1].firstName);
        System.assertEquals('x2', result.TMContacts[1].lastName);
        System.assertEquals('y2', result.TMContacts[1].email);
        System.assertEquals('z2', result.TMContacts[1].phone);
    }

    @IsTest
    static void it_should_call_the_signature_manager_to_send_for_signature() {
        Integer appId = 2;
        String entityName = 'entity-name';
        String entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        TmBoarding.SignerInfo signer = new TmBoarding.SignerInfo();
        signer.isTmo = true;
        List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>{signer};
        EntityTMSAGenerator.EntityPm entityPm = new EntityTMSAGenerator.EntityPm();
        entityPm.Entity = new Account(Id = entityId, Name = entityName);
        mockDataProvider.setup('getExtendedEntity', new List<Object>{entityId}).returns(entityPm);

        Boolean results = sut.sendForSignature(entityId, signers);

        mockSignerManager.verify('sendForSignature', new List<Object>{entityName,entityId, signers, new List<string>{entityId}, appId }, Times.Once);
    }
}