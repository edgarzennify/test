@IsTest
private class TmBoardingServiceClientInfoProviderTests {
    
    private static final Mock.ofIConfigurations mockConfiguration;
    private static TmBoardingServiceClientInfoProvider sut;

    static{
        mockConfiguration = new Mock.ofIConfigurations();
        sut = new TmBoardingServiceClientInfoProvider(mockConfiguration);
    }

    @IsTest
    static void it_should_call_the_configs() {
        Id contactId = ObjectFactory.getFakeId(Contact.SOBjectType, '1');
        Contact c = new Contact();
        Map<String, Contact> contacts = new Map<String, Contact>{contactId => c};
        TmBoarding.SignerInfo sInfo = new TmBoarding.SignerInfo();
        sInfo.SignerId = contactId;
        sInfo.SecurityCode = '1234';
        sInfo.SignerCode = 'LL';
        sInfo.Priority = 1;
        List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>{sInfo};
        String roleIdentifier = 'PQ';
        String DebugLabel = 'TmBoardingSignatureEmailDebug';
        String firstNameLabel = 'TmBoardingSignatureEmailFirstName';
        String firstNameValue = 'fitst-name';
        mockConfiguration.setup('get', new List<Object>{DebugLabel}).returns('true');
        mockConfiguration.setup('get', new List<Object>{firstNameLabel}).returns(firstNameValue);

        List<TmBoardingServiceProxy.ClientInfo> result = sut.getClientInfo(contacts, signers, roleIdentifier);

        mockConfiguration.verify('get', new List<Object>{DebugLabel}, Times.Once);
        System.assertEquals(firstNameValue , result[0].firstName);
        System.assertEquals(firstNameValue , result[0].firstName);
    }

    @IsTest
    static void it_should_throw_when_debug_mode_is_empty_for_client_info() {
        Id contactId = ObjectFactory.getFakeId(Contact.SOBjectType, '1');
        Contact c = new Contact();
        Map<String, Contact> contacts = new Map<String, Contact>{contactId => c};
        TmBoarding.SignerInfo sInfo = new TmBoarding.SignerInfo();
        sInfo.SignerId = contactId;
        sInfo.SecurityCode = '1234';
        sInfo.SignerCode = 'LL';
        sInfo.Priority = 1;
        List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>{sInfo};
        String roleIdentifier = 'PQ';
        String DebugLabel = 'TmBoardingSignatureEmailDebug';
        String firstNameLabel = 'TmBoardingSignatureEmailFirstName';
        String firstNameValue = 'fitst-name';
        mockConfiguration.setup('get', new List<Object>{firstNameLabel}).returns(firstNameValue);

        try {
            List<TmBoardingServiceProxy.ClientInfo> result = sut.getClientInfo(contacts, signers, roleIdentifier);
            System.assert(false, 'The test should have thrown an exception.');
        } catch (TmBoarding.SignerClientInfoException ex) {
            System.assert(true);
        } catch (Exception e) {
            System.assert(false, 'The test threw the wrong type of exception.');
        } 
    }

    @IsTest
    static void it_should_get_debug_client_info_when_debug_is_set_to_true_and_tmsa_is_selected() {
        Id contactId = ObjectFactory.getFakeId(Contact.SOBjectType, '1');
        string firstName = 'first-Name';
        string lastName = 'last-name';
        string email = 'x@x.com';
        string tmsaEmail = 'tmsa@x.com';
        string initial = 'ini';
        string phone = '111-111-1111';
        string isDebug = 'true';
        Contact c = new Contact();
        Map<String, Contact> contacts = new Map<String, Contact>{contactId => c};
        TmBoarding.SignerInfo sInfo = new TmBoarding.SignerInfo();
        sInfo.SignerId = '';
        sInfo.SecurityCode = '1234';
        sInfo.SignerCode = 'LL';
        sInfo.Priority = 1;
        sInfo.tmo = new TmBoarding.TmoSigner();
        sInfo.tmo.FirstName = firstName;
        sInfo.tmo.LastName = lastName;
        sInfo.tmo.Email = tmsaEmail;
        sInfo.tmo.Phone = phone;

        List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>{sInfo};
        String roleIdentifier = 'PQ';
        String debugLabel = 'TmBoardingSignatureEmailDebug';
        String firstNameLabel = 'TmBoardingSignatureEmailFirstName';
        String lastNameLabel = 'TmBoardingSignatureEmailLastName';
        String initialLabel = 'TmBoardingSignatureEmailInitial';
        String emailLabel = 'email';
        String tmsaEmailLabel = 'TmBoardingTMSASignatureEmail';

        mockConfiguration.setup('get', new List<Object>{debugLabel}).returns(isDebug);
        mockConfiguration.setup('get', new List<Object>{firstNameLabel}).returns(firstName);
        mockConfiguration.setup('get', new List<Object>{lastNameLabel}).returns(lastName);
        mockConfiguration.setup('get', new List<Object>{initialLabel}).returns(initial);
        mockConfiguration.setup('get', new List<Object>{emailLabel}).returns(email);
        mockConfiguration.setup('get', new List<Object>{tmsaEmailLabel}).returns(tmsaEmail);

        List<TmBoardingServiceProxy.ClientInfo> result = sut.getClientInfo(contacts, signers, roleIdentifier);

        System.assertEquals(1 , result.size());
        System.assertEquals(firstName, result[0].firstName);
        System.assertEquals(lastName, result[0].lastName);
        System.assertEquals(tmsaEmail, result[0].EmailAddress);
    }

    @IsTest
    static void it_should_get_debug_client_info_when_debug_is_set_to_true_and_tmsa_is_not_selected() {
        Id contactId = ObjectFactory.getFakeId(Contact.SOBjectType, '1');
        string firstName = 'first-Name';
        string lastName = 'last-name';
        string email = 'x@x.com';
        string tmsaEmail = 'tmsa@x.com';
        string initial = 'ini';
        string phone = '111-111-1111';
        string isDebug = 'true';
        Contact c = new Contact();
        Map<String, Contact> contacts = new Map<String, Contact>{contactId => c};
        TmBoarding.SignerInfo sInfo = new TmBoarding.SignerInfo();
        sInfo.SignerId = '';
        sInfo.SecurityCode = '1234';
        sInfo.SignerCode = 'LL';
        sInfo.Priority = 1;

        List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>{sInfo};
        String roleIdentifier = 'PQ';
        String debugLabel = 'TmBoardingSignatureEmailDebug';
        String firstNameLabel = 'TmBoardingSignatureEmailFirstName';
        String lastNameLabel = 'TmBoardingSignatureEmailLastName';
        String initialLabel = 'TmBoardingSignatureEmailInitial';
        String emailLabel = 'TmBoardingSignatureEmail';
        String tmsaEmailLabel = 'TmBoardingTMSASignatureEmail';

        mockConfiguration.setup('get', new List<Object>{debugLabel}).returns(isDebug);
        mockConfiguration.setup('get', new List<Object>{firstNameLabel}).returns(firstName);
        mockConfiguration.setup('get', new List<Object>{lastNameLabel}).returns(lastName);
        mockConfiguration.setup('get', new List<Object>{initialLabel}).returns(initial);
        mockConfiguration.setup('get', new List<Object>{emailLabel}).returns(email);
        mockConfiguration.setup('get', new List<Object>{tmsaEmailLabel}).returns(tmsaEmail);

        List<TmBoardingServiceProxy.ClientInfo> result = sut.getClientInfo(contacts, signers, roleIdentifier);

        System.assertEquals(1 , result.size());
        System.assertEquals(firstName, result[0].firstName);
        System.assertEquals(lastName, result[0].lastName);
        System.assertEquals(email, result[0].EmailAddress);
    }

    @IsTest
    static void it_should_get_debug_client_info_when_debug_is_set_to_false_and_tmsa_is_selected() {
        Id contactId = ObjectFactory.getFakeId(Contact.SOBjectType, '1');
        string firstName = 'first-Name';
        string lastName = 'last-name';
        string email = 'x@x.com';
        string tmsaEmail = 'tmsa@x.com';
        string initial = 'ini';
        string phone = '111-111-1111';
        string isDebug = 'false';
        Contact c = new Contact();
        c.Id = contactId;
        c.firstName = firstName;
        c.lastName = lastName;
        c.email = email;
        Map<String, Contact> contacts = new Map<String, Contact>{contactId => c};
        TmBoarding.SignerInfo sInfo = new TmBoarding.SignerInfo();
        sInfo.SignerId = contactId;
        sInfo.SecurityCode = '1234';
        sInfo.SignerCode = 'LL';
        sInfo.Priority = 1;
        sInfo.tmo = new TmBoarding.TmoSigner();
        sInfo.tmo.FirstName = firstName;
        sInfo.tmo.LastName = lastName;
        sInfo.tmo.Email = tmsaEmail;
        sInfo.tmo.Phone = phone;

        List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>{sInfo};
        String roleIdentifier = 'PQ';
        String debugLabel = 'TmBoardingSignatureEmailDebug';
        mockConfiguration.setup('get', new List<Object>{debugLabel}).returns(isDebug);

        List<TmBoardingServiceProxy.ClientInfo> result = sut.getClientInfo(contacts, signers, roleIdentifier);

        System.assertEquals(1 , result.size());
        System.assertEquals(firstName, result[0].firstName);
        System.assertEquals(lastName, result[0].lastName);
        System.assertEquals(tmsaEmail, result[0].EmailAddress); 
    }

    @IsTest
    static void it_should_get_debug_client_info_when_debug_is_set_to_false_and_tmsa_is_not_selected() {
        Id contactId = ObjectFactory.getFakeId(Contact.SOBjectType, '1');
        string firstName = 'first-Name';
        string lastName = 'last-name';
        string email = 'x@x.com';
        string tmsaEmail = 'tmsa@x.com';
        string initial = 'ini';
        string phone = '111-111-1111';
        string isDebug = 'false';
        Contact c = new Contact();
        c.Id = contactId;
        c.firstName = firstName;
        c.lastName = lastName;
        c.email = email;
        Map<String, Contact> contacts = new Map<String, Contact>{contactId => c};
        TmBoarding.SignerInfo sInfo = new TmBoarding.SignerInfo();
        sInfo.SignerId = contactId;
        sInfo.SecurityCode = '1234';
        sInfo.SignerCode = 'LL';
        sInfo.Priority = 1;

        List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>{sInfo};
        String roleIdentifier = 'PQ';
        String debugLabel = 'TmBoardingSignatureEmailDebug';
        mockConfiguration.setup('get', new List<Object>{debugLabel}).returns(isDebug);

        List<TmBoardingServiceProxy.ClientInfo> result = sut.getClientInfo(contacts, signers, roleIdentifier);

        System.assertEquals(1 , result.size());
        System.assertEquals(firstName, result[0].firstName);
        System.assertEquals(lastName, result[0].lastName);
        System.assertEquals(email, result[0].EmailAddress);
    }
}