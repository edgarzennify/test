@IsTest
private class AuditUserDetailsTests {
	
	@IsTest
    static void it_should_set_default_values_when_default_constructor_is_called() {
		AuditUserDetails sut = new AuditUserDetails();		
		
		System.assertEquals('', sut.userName);
		System.assertEquals(false, sut.readAccess);
		System.assertEquals(false, sut.editAccess);
		System.assertNotEquals(null, sut.permissionSets);
		System.assertNotEquals(null, sut.profile);
	}
	
	@IsTest
    static void it_should_populate_properties_of_the_new_object_from_input_Id() {
		PM_User testUser = new PM_User();
		testUser.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
		testUser.Name = 'test user';
		PM_PermissionSetAssignment permSetAssign = new PM_PermissionSetAssignment();
		permSetAssign.Assignee = testUser;

		AuditUserDetails sut = new AuditUserDetails(permSetAssign);

		System.assertEquals(testUser.Id, sut.userId);
		System.assertEquals(testUser.Name, sut.userName);
		System.assertEquals(false, sut.readAccess);
		System.assertEquals(false, sut.editAccess);
		System.assertNotEquals(null, sut.permissionSets);
		System.assertNotEquals(null, sut.profile);
	}

	@IsTest
    static void it_should_sort_list_of_objects_by_name() {
		PM_User testUser1 = new PM_User();
		testUser1.Name = 't1';
		PM_PermissionSetAssignment permSetAssign1 = new PM_PermissionSetAssignment();
		permSetAssign1.Assignee = testUser1;
		
		PM_User testUser2 = new PM_User();
		testUser2.Name = 't2';
		PM_PermissionSetAssignment permSetAssign2 = new PM_PermissionSetAssignment();
		permSetAssign2.Assignee = testUser2;
		
		PM_User testUser3 = new PM_User();
		testUser3.Name = 't3';
		PM_PermissionSetAssignment permSetAssign3 = new PM_PermissionSetAssignment();
		permSetAssign3.Assignee = testUser3;
		
		PM_User testUser4 = new PM_User();
		testUser4.Name = 't4';
		PM_PermissionSetAssignment permSetAssign4 = new PM_PermissionSetAssignment();
		permSetAssign4.Assignee = testUser4;

		AuditUserDetails item1 = new AuditUserDetails(permSetAssign1);
		AuditUserDetails item2 = new AuditUserDetails(permSetAssign2);
		AuditUserDetails item3 = new AuditUserDetails(permSetAssign3);
		AuditUserDetails item4 = new AuditUserDetails(permSetAssign4);
		List<AuditUserDetails> sut = new List<AuditUserDetails>{item3, item1, item4, item2};

		sut.sort();

		System.assertEquals(testUser1.Name, sut[0].userName);
		System.assertEquals(testUser2.Name, sut[1].userName);
		System.assertEquals(testUser3.Name, sut[2].userName);
		System.assertEquals(testUser4.Name, sut[3].userName);
	}	
}