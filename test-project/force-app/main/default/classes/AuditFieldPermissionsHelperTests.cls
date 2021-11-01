@IsTest
private class AuditFieldPermissionsHelperTests {

	private static final AuditFieldPermissionsHelper sut;

	static {
		sut = new AuditFieldPermissionsHelper();
	}
	
	@IsTest
	static void it_should_get_assigned_user_proxies_when_given_a_permissionSet_proxy() {
		PM_User u1 = new PM_User();
		u1.Name = 'test user 1';
		PM_User u2 = new PM_User();
		u2.Name = 'bono';
		
		PM_PermissionSetAssignment a1 = new PM_PermissionSetAssignment();
		a1.Assignee = u1;
		PM_PermissionSetAssignment a2 = new PM_PermissionSetAssignment();
		a2.Assignee = u2;

		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.Assignments = new List<PM_PermissionSetAssignment>{a1, a2};
		
		List<PM_PermissionSetAssignment> results = sut.getAssignedUsers(permSet);

		System.assertEquals(2, results.size());
	}
	
	@IsTest
	static void it_should_return_the_fieldPermissions_proxy_for_the_given_field() {
		String fieldOfInterest = 'asdf';
		PM_FieldPermissions fp1 = new PM_FieldPermissions();
		fp1.Field = 'qwert'; 
		PM_FieldPermissions fp2 = new PM_FieldPermissions();
		fp2.Field = 'asdf';
		List<PM_FieldPermissions> fps = new List<PM_FieldPermissions>{fp1, fp2};
		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.FieldPerms = fps;

		PM_FieldPermissions results = sut.getPermissionForField(permSet, fieldOfInterest);

		System.assertEquals('asdf', results.Field);
	}

	@IsTest
	static void it_should_return_an_empty_fieldPermissions_proxy_when_the_permissionSet_has_no_fieldPermissions_for_the_given_field() {
		String fieldOfInterest = 'asdf';
		PM_FieldPermissions fp1 = new PM_FieldPermissions();
		fp1.Field = 'qwert'; 
		List<PM_FieldPermissions> fps = new List<PM_FieldPermissions>{fp1};
		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.FieldPerms = fps;

		PM_FieldPermissions results = sut.getPermissionForField(permSet, fieldOfInterest);

		System.assertEquals(null, results.Field);
	}

	@IsTest
	static void it_should_return_the_profile_name_from_permission_set() {
		PM_Profile prof = new PM_Profile();
		prof.Name = 'prof name';
		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.Profile = prof;

		String results = sut.getProfileName(permSet);

		System.assertEquals('prof name', results);
	}

	@IsTest
	static void it_should_return_true_when_permissionSet_objectRead_value_is_true() {
		PM_ObjectPermissions op = new PM_ObjectPermissions();
		op.PermissionsRead = true;
		
		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.Objectperms = new List<PM_ObjectPermissions>{op};

		Boolean results = sut.getProfileObjectReadPermission(permSet);

		System.assertEquals(true, results);
	}

	@IsTest
	static void it_should_return_false_when_permissionSet_objectRead_value_is_false() {
		PM_ObjectPermissions op = new PM_ObjectPermissions();
		op.PermissionsRead = false;
		
		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.Objectperms = new List<PM_ObjectPermissions>{op};

		Boolean results = sut.getProfileObjectReadPermission(permSet);

		System.assertEquals(false, results);
	}

	@IsTest
	static void it_should_return_false_when_permissionSet_has_no_objectRead_permissions() {
		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.Objectperms = new List<PM_ObjectPermissions>();

		Boolean results = sut.getProfileObjectReadPermission(permSet);

		System.assertEquals(false, results);
	}

	@IsTest
	static void it_should_return_true_when_permissionSet_objectEdit_value_is_true() {
		PM_ObjectPermissions op = new PM_ObjectPermissions();
		op.PermissionsEdit = true;
		
		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.Objectperms = new List<PM_ObjectPermissions>{op};

		Boolean results = sut.getProfileObjectEditPermission(permSet);

		System.assertEquals(true, results);
	}

	@IsTest
	static void it_should_return_false_when_permissionSet_objectEdit_value_is_false() {
		PM_ObjectPermissions op = new PM_ObjectPermissions();
		op.PermissionsEdit = false;
		
		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.Objectperms = new List<PM_ObjectPermissions>{op};

		Boolean results = sut.getProfileObjectEditPermission(permSet);

		System.assertEquals(false, results);
	}

	@IsTest
	static void it_should_return_false_when_permissionSet_has_no_objectEdit_permissions() {
		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.Objectperms = new List<PM_ObjectPermissions>();

		Boolean results = sut.getProfileObjectEditPermission(permSet);

		System.assertEquals(false, results);
	}
}