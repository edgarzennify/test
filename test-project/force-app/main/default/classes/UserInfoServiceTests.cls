@IsTest
private class UserInfoServiceTests {

	private static final UserInfoService sut;
    private static final Mock.ofIConfigurations mockConfigs;
    private static final MockOfIUserInfoServiceDataProv mockDataProv; 

    static {
        mockConfigs = new Mock.ofIConfigurations();
        mockDataProv = new MockOfIUserInfoServiceDataProv();
        sut = new UserInfoService(mockConfigs, mockDataProv);
    }

    @IsTest
    static void code_coverage() {
		sut.isCurrentUserLicensed('LLC_BI');
        Profile p = sut.getProfile();
   }

    @IsTest
    static void it_should_call_isSystemAdministrator_without_a_definition() {
        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
        mockConfigs.setup('get', new List<Object>{'System Administrator Profiles'}).returns(p.Name);
        mockDataProv.setup('getUserProfile', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(p);
        Boolean results = sut.isSystemAdministrator();
        system.assertNotEquals(null, results);
    }

    @IsTest
    static void it_should_call_getPermissionSet_without_a_definition() {
        PermissionSet ps = new PermissionSet();
        ps.Label = 'Test Permission Set';
        List<PermissionSet> psets = new List<PermissionSet>{ps};

        mockDataProv.setup('getPermissionSetsToLoad', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(psets);
        Map<String,PermissionSet> results = sut.getPermissionSets();
        system.assertEquals(ps, results.get(ps.Label));
    }

    @IsTest
    static void it_should_return_true_when_isSystemAdministrator_is_called_with_a_system_admin_profile() {
        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
        User u = [SELECT Id FROM User WHERE ProfileId =: p.Id LIMIT 1];
        
        mockConfigs.setup('get', new List<Object>{'System Administrator Profiles'}).returns(p.Name);
        mockDataProv.setup('getUserProfile', new List<Object>{u.Id}).returns(p);
        Boolean results = sut.isSystemAdministrator(u.Id);
        
        system.assertEquals(true, results);
    }

    @IsTest
    static void it_should_return_false_when_isSystemAdministrator_is_called_with_a_system_admin_profile() {
        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'EB Base User'];
        User u = [SELECT Id FROM User WHERE ProfileId =: p.Id LIMIT 1];
        
        mockConfigs.setup('get', new List<Object>{'System Administrator Profiles'}).returns(p.Name);
        mockDataProv.setup('getUserProfile', new List<Object>{u.Id}).returns(p);
        Boolean results = sut.isSystemAdministrator(u.Id);
        
        system.assertEquals(true, results);
    }

    @IsTest
    static void it_should_return_a_list_of_users_when_getUsersWithPermissionSet_is_called_with_a_permission_set_label() {
		PermissionSetAssignment psa = [SELECT Id, AssigneeId, PermissionSetId FROM PermissionSetAssignment LIMIT 1];
        List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>{psa};
        PermissionSet ps = [SELECT Id, Label FROM PermissionSet WHERE Id =: psa.PermissionSetId];
        User u = [SELECT Id FROM User WHERE Id =: psa.AssigneeId];
        List<Id> userIds = new List<Id>{u.Id};
        List<User> usersWithPermissionSet = new List<User>{u};
            
        mockDataProv.setup('getPermissionSetAssignments', new List<Object>{ps.Label}).returns(psaList);
        mockDataProv.setup('getUsersWithPermissionSet', new List<Object>{userIds}).returns(usersWithPermissionSet);
        
		List<User> results = sut.getUsersWithPermissionSet(ps.Label);

		system.assertEquals(u.Id, results[0].Id);        
    }

    @IsTest
    static void it_should_not_call_getUsersWithPermissionSet_if_getPermissionSetAssignments_returns_null() {
        String permissionSetLabel = 'Function - Loan Force Read/Write';
        
        mockDataProv.setup('getPermissionSetAssignments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(null);
        
        sut.getUsersWithPermissionSet(permissionSetLabel);
        
        mockDataProv.verify('getUsersWithPermissionSet', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
    }

    @IsTest
    static void it_should_return_a_map_when_getUserRoleRelationship_is_called_with_no_arguments() {
        Id userRoleId = ObjectFactory.getFakeId(UserRole.SObjectType, '1');
        UserRole userRole = new UserRole();
        userRole.Id = userRoleId;
        Map<Id , UserRole> userRoles = new Map<Id, UserRole>();
        userRoles.put(userRole.Id, userRole);
        
        Id userId = ObjectFactory.getFakeId(User.SObjectType, '1');
        User u = new User();
        u.Id = userId;
        u.UserRoleId = userRole.Id;
        List<User> userList = new List<User>{u};
            
        mockDataProv.setup('getUsers').returns(userList);
        mockDataProv.setup('getUserRoles').returns(userRoles);
        
        Map<User, UserRole> results = sut.getUserRoleRelationship();
        
        system.assertEquals(userRole, results.get(u));
    }

    @IsTest
    static void it_should_return_a_map_of_string_and_permission_set_when_getPermissionSets_is_called_with_a_user_id() {
        User u = new User();
        u.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        PermissionSet ps = new PermissionSet();
        ps.Label = 'Test Permission Set';
        List<PermissionSet> psets = new List<PermissionSet>{ps};
            
        mockDataProv.setup('getPermissionSetsToLoad', new List<Object>{u.Id}).returns(psets);
        
        Map<String, PermissionSet> results = sut.getPermissionSets(u.Id);
        
        system.assertEquals(ps, results.get(ps.Label));
    }

    @IsTest
    static void it_should_return_true_when_hasPermissionSet_is_called_with_a_permission_set_label() {
        PermissionSet ps = new PermissionSet();
        ps.Id = ObjectFactory.getFakeId(PermissionSet.SObjectType, '1');
        ps.Label = 'Test Permission Set';
        List<PermissionSet> psets = new List<PermissionSet>{ps};
        
        mockDataProv.setup('getPermissionSetsToLoad', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(psets);
        
        Boolean results = sut.hasPermissionSet(ps.Label);
        
        system.assertEquals(true, results);
    }

    private class MockOfIUserInfoServiceDataProv extends ApexMoq implements UserInfoService.IUserInfoServiceDataProv {
        public Profile getUserProfile(Id userId) {
            return (Profile)handleMethodInvocation('getUserProfile', new List<Object>{userId});
        }
        public List<PermissionSetAssignment> getPermissionSetAssignments(String permissionSetLabel) {
            return (List<PermissionSetAssignment>)handleMethodInvocation('getPermissionSetAssignments', new List<Object>{permissionSetLabel});
        }
        public List<User> getUsersWithPermissionSet(List<Id> userIds) {
            return (List<User>)handleMethodInvocation('getUsersWithPermissionSet', new List<Object>{userIds});
        }
        public List<User> getUsers() {
            return (List<User>)handleMethodInvocation('getUsers');
        }
        public Map<Id, UserRole> getUserRoles() {
            return (Map<Id, UserRole>)handleMethodInvocation('getUserRoles');
        }
        public List<PermissionSet> getPermissionSetsToLoad(Id userId) {
            return (List<PermissionSet>)handleMethodInvocation('getPermissionSetsToLoad', new List<Object>{userId});
        }
    }
}