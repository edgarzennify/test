@IsTest
private class TmBoardingDashboardDmBuilderTests {
    
    private static final TmBoardingDashboardDmBuilder sut;
    private static final Mock.ofIUserInfoService mockUserInfoService;

    static {
        mockUserInfoService = new Mock.ofIUserInfoService();
        sut = new TmBoardingDashboardDmBuilder(mockUserInfoService);
    }
    
    @IsTest
    static void it_should_call_the_user_svc_to_get_users() {
        Account entity = new Account();
        TM_Service_Request_Packet__c pac = new TM_Service_Request_Packet__c(Entity__c = entity.Id);
        pac.Entity__r = entity;
        TM_Service_Request__c req = new TM_Service_Request__c(TM_Service_Request_Packet__c = pac.Id);
        req.TM_Service_Request_Packet__r = pac;
        List<TM_Service_Request__c> requests = new List<TM_Service_Request__c>{req};
        Id userId = ObjectFactory.getFakeId(User.SObjectType, '1');
        Id userRoleId = ObjectFactory.getFakeId(UserRole.SObjectType, '1');
        User u = new User(Id = userId);
        UserRole ur = new UserRole(Id = userRoleId);
        Map<User, UserRole> users = new Map<User, UserRole>{u => ur};   
        mockUserInfoService.setup('getUserRoleRelationship').returns(users);
        
        List<DmTmPacket> result = sut.build(requests);
            
        mockUserInfoService.verify('getUserRoleRelationship', Times.Once);
    }

    @IsTest
    static void it_should_build_a_dm_user() {
        Id userId = ObjectFactory.getFakeId(User.SObjectType, '1');
        User u = new User(Id = userId);

        DmUser result = sut.build(u);

        System.assertEquals(u.id, result.id);
    }

    @IsTest
    static void it_should_build_tm_maintenances() {
        TM_Maintenance__c maint = new TM_Maintenance__c();
        Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        maint.Status__c = 'test';
        maint.Type__c = 'type';
        maint.Contact__c = contactId;

        List<TM_Maintenance__c> requests = new List<TM_Maintenance__c>{maint};
        
        List<TmBoardingDashboard.TmMaintenanceDm> results = sut.buildTmMaintenances(requests);

        System.assertEquals(1, results.size());
        System.assertEquals('test', results[0].status);
        System.assertEquals('type', results[0].type);
        System.assertEquals(contactId, results[0].contactId);
    }
}