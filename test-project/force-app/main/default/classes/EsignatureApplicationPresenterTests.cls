@IsTest
private class EsignatureApplicationPresenterTests {

    private final static EsignatureApplicationMock.ofIRepository mockRepository;
    private final static EsignatureApplicationMock.ofIVmBuilder mockVmBuilder;
    private final static EsignatureApplicationMock.ofIRequestBuilder mockRequestBuilder;
    private final static Mock.ofIUserInfoService mockUserInfo;
    private final static DataViewerMock.ofIDocumentHandler mockdocProvider;
    private final static Mock.OfIDigitalSignatureFormGeneratorProxy mockProxy;
    private final static Mock.ofISchema mockSchema;
    private static EsignatureApplicationPresenter sut;

    static {
        mockRepository = new EsignatureApplicationMock.ofIRepository();
        mockVmBuilder = new EsignatureApplicationMock.ofIVmBuilder();
        mockRequestBuilder = new EsignatureApplicationMock.ofIRequestBuilder();
        mockUserInfo = new Mock.ofIUserInfoService();
        mockdocProvider = new DataViewerMock.ofIDocumentHandler();
        mockProxy = new Mock.OfIDigitalSignatureFormGeneratorProxy();
        mockSchema = new Mock.ofISchema();
        sut = new EsignatureApplicationPresenter(mockRepository,mockVmBuilder,mockRequestBuilder,mockUserInfo,mockdocProvider,mockProxy,mockSchema);
    }

    @IsTest
    static void it_should_build_form_vm_by_calling_the_data_provider() {
        String applicationId = '7';
        String salesforceId = 'x';

        mockUserInfo.setup('isSystemAdministrator').returns(true);

        EsignatureApplication.FormVm result = sut.buildFormVm(applicationId, salesforceId);

        mockRepository.verify('buildDm', new List<Object>{applicationId,salesforceId}, Times.Once);
    }

    @IsTest
    static void it_should_build_dm_when_building_form_vm() {
        String applicationId = '7';
        String salesforceId = 'x';
        Boolean hasPermission = true;
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();

        mockUserInfo.setup('isSystemAdministrator').returns(hasPermission);
        mockRepository.setup('buildDm', new List<Object>{applicationId,salesforceId}).returns(dm);

        EsignatureApplication.FormVm result = sut.buildFormVm(applicationId, salesforceId);

        mockVmBuilder.verify('build', new List<object>{dm, hasPermission}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_request_builder_to_send_for_signature() {
        String applicationId = '7';
        String salesforceId = 'aaasa';
        String currentUserId = ObjectFactory.getFakeId(User.SObjectType, '1');
        String dynamicFileTemplateAsBase64 = 'xy';
        String notificationEmail = 'abc@example.com';
        EsignatureApplication.SaveModel sm = new EsignatureApplication.SaveModel();
        String sObj = 'Entity_Action__c';
        Entity_Action__c obj = new Entity_Action__c();

        EsignatureApplication.SaveModelElement el = new EsignatureApplication.SaveModelElement();
        el.fieldId = '1';
        el.fieldValue = 'yes';
        sm.saveData = new List<EsignatureApplication.SaveModelElement>{el};
        sm.dynamicFileTemplateAsBase64 = dynamicFileTemplateAsBase64;
        sm.notificationEmail = notificationEmail;
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();

        mockRepository.setup('buildDm', new List<Object>{applicationId,salesforceId}).returns(dm);
        mockUserInfo.setup('getCurrentUserId').returns(currentUserId);

        Mock.ofISobjectType mocksObjType = new Mock.ofISobjectType();
        mocksObjType.setup('newSObject').returns(obj);
        mockSchema.setup('getSObjectType', new List<object>{sObj}).returns(mocksObjType);

        sut.sendForSignature(applicationId, salesforceId,sm);

        mockRequestBuilder.verify('buildRequest', new List<object>{dm,  currentUserId, salesforceId, sm});
    }

    @IsTest
    static void it_should_call_the_signature_proxy_to_send_for_signature() {
        String applicationId = '7';
        String salesforceId = 'aaasa';
        EsignatureApplication.SaveModel sm = new EsignatureApplication.SaveModel();

        EsignatureApplication.SaveModelElement el = new EsignatureApplication.SaveModelElement();
        el.fieldId = '1';
        el.fieldValue = 'yes';
        sm.saveData = new List<EsignatureApplication.SaveModelElement>{el};
        PM_Esignature_Configuration_c pm = new PM_Esignature_Configuration_c();
        DigitalSignatureFormGeneratorProxy.SignatureRequest req = new DigitalSignatureFormGeneratorProxy.SignatureRequest();
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();

        mockRepository.setup('buildDm', new List<Object>{applicationId,salesforceId}).returns(dm);
        mockRequestBuilder.setup('buildRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(req);

        sut.sendForSignature(applicationId, salesforceId, sm);

        mockProxy.verify('sendForSignature', new List<OBject>{req}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_vm_builder_to_build_signature_history_data() {
        String applicationId = '7';
        DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse res = new DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse();

        mockProxy.setup('getData', new List<OBject>{applicationId}).returns(res);

        EsignatureApplication.SignatureData result = sut.getSignatureData(applicationId);

        mockVmBuilder.verify('Build', new List<Object>{res}, Times.Once);
    }

    @ISTest
    static void it_should_filter_data_based_on_search_provided() {
        String filter ='Out For Signature'; 
        EsignatureApplication.SignatureData data = new  EsignatureApplication.SignatureData();
        EsignatureApplication.SignatureDataItem item = new EsignatureApplication.SignatureDataItem();
        item.status = filter;
        data.items = new List<EsignatureApplication.SignatureDataItem>{item};
       
        EsignatureApplication.SignatureData result = sut.filterData(data, filter);

        System.assertEquals(1, result.items.size());
        System.assertEquals(filter, result.items[0].status);
    }
}