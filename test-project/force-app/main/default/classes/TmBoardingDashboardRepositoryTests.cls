@IsTest
private class TmBoardingDashboardRepositoryTests {

    private static final TmBoardingDashboardRepository sut;
    private static final TmBoardingDashboardMock.ofIDataProvider mockDataProvider;
    private static final TmBoardingDashboardMock.ofIDmBuilder mockDmBuilder;
    private static final TmConfigurationMock.ofIStageRepository mockStageRepository;
    private static final Mock.ofIUserInfoService mockUserSvc;
    private static final Mock.ofIUtility mockUtil;
    
    static {
        mockDataProvider = new TmBoardingDashboardMock.ofIDataProvider();
        mockDmBuilder = new TmBoardingDashboardMock.ofIDmBuilder();
        mockStageRepository = new TmConfigurationMock.ofIStageRepository();
        mockUserSvc = new Mock.ofIUserInfoService();
        mockUtil = new Mock.ofIUtility();
        sut = new TmBoardingDashboardRepository(mockDataProvider, mockDmBuilder, mockStageRepository, mockUserSvc, mockUtil);
    }
    
    @IsTest
    static void it_should_call_the_dataprovider_to_get_packets() {
        String packeSObjName = 'TM_Service_Request_Packet__c';
        String packetStageField = 'Stage__c';
        Id userId = objectFactory.getFakeId(User.SObjectType, '1');
        Id teamId = objectFactory.getFakeId(Eb_Team_Member__c.SObjectType, '1');
        String packetStatusKey = 'TmBoardingPacketStatuses';
        Eb_Team_Member__c team = new Eb_Team_Member__c(Id = teamId, User__c = userId);
        Account entity = new Account(Name='real');
        entity.Team_Treasury_Management_Representative__r = team;
        Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c(Name= 'real', Entity__c= entity.id);
        packet.Entity__r = entity;
        Tm_Service_Request__c req = new Tm_Service_Request__c();
        req.Tm_Service_Request_Packet__c = packet.Id;
        req.Tm_Service_Request_Packet__r = packet;
        List<Tm_Service_Request__c> requests = new  List<Tm_Service_Request__c>{req};
        Map<User, userRole> userRoles = new Map<User, UserRole>{new User(id=userId)=> new UserRole()};
        mockDataProvider.setup('getRequestWithActivePackets').returns(requests);
        mockUserSvc.setup('getUserRoleRelationship').returns(userRoles);
        mockUserSvc.setup('getCurrentUserId').returns(userId);
        mockDataProvider.setup('getTeamMembers').returns(new List<Eb_Team_Member__c>());
        List<SelectOption> options = new List<SelectOption>();
        SelectOption o1 = new SelectOption('A','A');
        SelectOption o2 = new SelectOption('B','B');
        options.add(o1);
        options.add(o2);
        mockUtil.setup('ListValuesFromObject', new List<Object>{packeSObjName, packetStageField}).returns(options);
        
        TmBoardingDashboard.searchDm result = sut.getAllActivePackets();
        
        mockDataProvider.verify('getRequestWithActivePackets', Times.Once);
        mockUtil.verify('ListValuesFromObject', new List<Object>{packeSObjName, packetStageField}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_dm_builder_to_build_packet_dms() {
        String packeSObjName = 'TM_Service_Request_Packet__c';
        String packetStageField = 'Stage__c';
        Id userId = objectFactory.getFakeId(User.SObjectType, '1');
        String packetStatusKey = 'TmBoardingPacketStatuses';
        Id teamId = objectFactory.getFakeId(Eb_Team_Member__c.SObjectType, '1');
        Eb_Team_Member__c team = new Eb_Team_Member__c(Id = teamId, User__c = userId);
        Account entity = new Account(Name='real');
        entity.Team_Treasury_Management_Representative__r = team;
        Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c(Name= 'real', Entity__c= entity.id);
        packet.Entity__r = entity;
        Tm_Service_Request__c req = new Tm_Service_Request__c();
        req.Tm_Service_Request_Packet__c = packet.Id;
        req.Tm_Service_Request_Packet__r = packet;
        List<Tm_Service_Request__c> requests = new  List<Tm_Service_Request__c>{req};
        Map<User, userRole> userRoles = new Map<User, UserRole>{new User(id=userId)=> new UserRole()};
        mockDataProvider.setup('getRequestWithActivePackets').returns(requests);
        mockUserSvc.setup('getUserRoleRelationship').returns(userRoles);
        mockUserSvc.setup('getCurrentUserId').returns(userId);
        mockDataProvider.setup('getTeamMembers').returns(new List<Eb_Team_Member__c>());
        List<SelectOption> options = new List<SelectOption>();
        SelectOption o1 = new SelectOption('A','A');
        SelectOption o2 = new SelectOption('B','B');
        options.add(o1);
        options.add(o2);
        mockUtil.setup('ListValuesFromObject', new List<Object>{packeSObjName, packetStageField}).returns(options);
        
        TmBoardingDashboard.searchDm result = sut.getAllActivePackets();
        
        mockDmBuilder.verify('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Exactly(4));
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_get_search_results() {
        String packeSObjName = 'TM_Service_Request_Packet__c';
        String packetStageField = 'Stage__c';
        Id userId = objectFactory.getFakeId(User.SObjectType, '1');
        String packetStatusKey = 'TmBoardingPacketStatuses';
        String rmId = 'testRm';
        String search = 'test';
        String search2 = '%' + search + '%';
        Id teamId = objectFactory.getFakeId(Eb_Team_Member__c.SObjectType, '1');
        Eb_Team_Member__c team = new Eb_Team_Member__c(Id = teamId, User__c = userId);
        Account entity = new Account(Name='real');
        entity.Team_Treasury_Management_Representative__r = team;
        Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c(Name= 'real', Entity__c= entity.id);
        packet.Entity__r = entity;
        Tm_Service_Request__c req = new Tm_Service_Request__c();
        req.Tm_Service_Request_Packet__c = packet.Id;
        req.Tm_Service_Request_Packet__r = packet;
        List<Tm_Service_Request__c> requests = new  List<Tm_Service_Request__c>{req};
        Map<User, userRole> userRoles = new Map<User, UserRole>{new User(id=userId)=> new UserRole()};
        mockDataProvider.setup('getRequestWithActivePacketsBySearch', new List<Object>{search2}).returns(requests);
        mockUserSvc.setup('getUserRoleRelationship').returns(userRoles);
        mockUserSvc.setup('getCurrentUserId').returns(userId);
        mockDataProvider.setup('getTeamMembers').returns(new List<Eb_Team_Member__c>());
        List<SelectOption> options = new List<SelectOption>();
        SelectOption o1 = new SelectOption('A','A');
        SelectOption o2 = new SelectOption('B','B');
        options.add(o1);
        options.add(o2);
        mockUtil.setup('ListValuesFromObject', new List<Object>{packeSObjName, packetStageField}).returns(options);

        TmBoardingDashboard.searchDm result = sut.searchAllPacket(search, rmId);
        
        mockDataProvider.verify('getRequestWithActivePacketsBySearch', new List<Object>{search2}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_the_current_user_from_user_info_svc() {
        String packeSObjName = 'TM_Service_Request_Packet__c';
        String packetStageField = 'Stage__c';
        String packetStatusKey = 'TmBoardingPacketStatuses';
        Id userId = ObjectFactory.getFakeId(User.SObjectType, '1');
        Id userRoleId = ObjectFactory.getFakeId(UserRole.SObjectType, '1');
        User u = new User(Id = userId);
        UserRole ur = new UserRole(Id = userRoleId);
        Map<User, UserRole> users = new Map<User, UserRole>{u => ur};   
        mockUserSvc.setup('getCurrentUserId').returns(userId);
        mockUserSvc.setup('getUserRoleRelationship').returns(users);
        List<SelectOption> options = new List<SelectOption>();
        SelectOption o1 = new SelectOption('A','A');
        SelectOption o2 = new SelectOption('B','B');
        options.add(o1);
        options.add(o2);
        mockUtil.setup('ListValuesFromObject', new List<Object>{packeSObjName, packetStageField}).returns(options);
        
        DmUser result =  sut.currentUser();
        
        mockDmBuilder.verify('build', new List<Object>{u}, Times.Once);
    }

    @IsTest
    static void it_should_get_tm_maints_when_search_is_blank() {  
        PM_Entity_Action_c pm = new PM_Entity_Action_c();
        List<PM_Entity_Action_c> dataProviderResults = new List<PM_Entity_Action_c>{pm};

        TmBoardingDashboard.TmMaintenanceDm result = new TmBoardingDashboard.TmMaintenanceDm();
        result.status = 'test status';
        List<TmBoardingDashboard.TmMaintenanceDm> dmBuilderResults = new List<TmBoardingDashboard.TmMaintenanceDm>{result};

        mockDataProvider.setup('getEntityActions').returns(dataProviderResults);
        mockDmBuilder.setup('buildTmMaintenances', new List<Object>{dataProviderResults}).returns(dmBuilderResults);

        List<TmBoardingDashboard.TmMaintenanceDm> results = sut.getTmMaintenances('');

        mockDataProvider.verify('getEntityActions', Times.Once);
        mockDmBuilder.verify('buildTmMaintenances', new List<Object>{dataProviderResults}, Times.Once);
        System.assertEquals('test status', results[0].status);
    }

    @IsTest
    static void it_should_get_tm_maints_when_search_is_not_blank() {
        PM_Entity_Action_c pm = new PM_Entity_Action_c();
        List<PM_Entity_Action_c> dataProviderResults = new List<PM_Entity_Action_c>{pm};
        String search = 'rrr';

        TmBoardingDashboard.TmMaintenanceDm result = new TmBoardingDashboard.TmMaintenanceDm();
        result.status = 'test status';
        List<TmBoardingDashboard.TmMaintenanceDm> dmBuilderResults = new List<TmBoardingDashboard.TmMaintenanceDm>{result};

        mockDataProvider.setup('getSearchedEntityActions', new List<Object>{search}).returns(dataProviderResults);
        mockDmBuilder.setup('buildTmMaintenances', new List<Object>{dataProviderResults}).returns(dmBuilderResults);

        List<TmBoardingDashboard.TmMaintenanceDm> results = sut.getTmMaintenances(search);

        mockDataProvider.verify('getSearchedEntityActions', new List<Object>{search}, Times.Once);
        mockDmBuilder.verify('buildTmMaintenances', new List<Object>{dataProviderResults}, Times.Once);
        System.assertEquals('test status', results[0].status);
    }

    @IsTest
    private static void it_should_get_stage_logs_for_provided_tm_requests(){
        Id tmRequestId = objectFactory.getFakeId(Tm_Service_Request__c.SObjectType,'1');
        Set<string> tmRequestsIds = new Set<string>{tmRequestId};
        PM_Object_Action_Log_c logPm = new PM_Object_Action_Log_c();
        logPm.Object_Id_c = tmRequestId;
        Map<string, PM_Object_Action_Log_c> stageLogs = new Map<string, PM_Object_Action_Log_c>{
                                        tmRequestId=> logPm};
        mockDataProvider.setup('getStageLogsForTMRequests').returns(stageLogs);

        Map<string, PM_Object_Action_Log_c> result = sut.getStageLogsForTmRequests();

        System.assertEquals(tmRequestId, result.get(tmRequestId).Object_Id_c);
    }
}