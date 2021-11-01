@IsTest
private class AuditPermissionSetDetailsTests {
	
	@IsTest
    static void it_should_set_default_values_when_default_constructor_is_called() {
		AuditPermissionSetDetails sut = new AuditPermissionSetDetails();		

		System.assertEquals('', sut.permissionSetName);
		System.assertEquals(false, sut.readAccess);
		System.assertEquals(false, sut.editAccess);
	}	

	@IsTest
    static void it_should_set_the_id_and_name_of_the_new_object_from_input_params() {
		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.Id = ObjectFactory.getFakeId(PermissionSet.SObjectType, '1');
		permSet.Name = 'sort1';
		PM_FieldPermissions fp = new PM_FieldPermissions();

		AuditPermissionSetDetails sut = new AuditPermissionSetDetails(permSet, fp);

		System.assertEquals(permSet.Id, sut.permissionSetId);
		System.assertEquals('sort1', sut.permissionSetName);
	}

	@IsTest
    static void it_should_set_read_and_edit_access_properties_to_true_on_the_new_object_from_input_params() {
		PM_PermissionSet permSet = new PM_PermissionSet();
		PM_FieldPermissions fp = new PM_FieldPermissions();
		fp.PermissionsRead = true;
		fp.PermissionsEdit = true;

		AuditPermissionSetDetails sut = new AuditPermissionSetDetails(permSet, fp);

		System.assertEquals(true, sut.readAccess);
		System.assertEquals(true, sut.editAccess);
	}

	@IsTest
    static void it_should_set_read_and_edit_access_properties_to_false_on_the_new_object_from_input_params() {
		PM_PermissionSet permSet = new PM_PermissionSet();
		PM_FieldPermissions fp = new PM_FieldPermissions();
		fp.PermissionsRead = false;
		fp.PermissionsEdit = false;

		AuditPermissionSetDetails sut = new AuditPermissionSetDetails(permSet, fp);

		System.assertEquals(false, sut.readAccess);
		System.assertEquals(false, sut.editAccess);
	}

	@IsTest
    static void it_should_sort_list_of_objects_by_name() {
		PM_FieldPermissions fp = new PM_FieldPermissions();
		fp.PermissionsRead = true;
		fp.PermissionsEdit = false;

		PM_PermissionSet permSet1 = new PM_PermissionSet();
		permSet1.Id = ObjectFactory.getFakeId(PermissionSet.SObjectType, '1');
		permSet1.Name = 'sort1';
		PM_PermissionSet permSet2 = new PM_PermissionSet();
		permSet2.Id = ObjectFactory.getFakeId(PermissionSet.SObjectType, '2');
		permSet2.Name = 'sort2';
		PM_PermissionSet permSet3 = new PM_PermissionSet();
		permSet3.Id = ObjectFactory.getFakeId(PermissionSet.SObjectType, '3');
		permSet3.Name = 'sort3';
		PM_PermissionSet permSet4 = new PM_PermissionSet();
		permSet4.Id = ObjectFactory.getFakeId(PermissionSet.SObjectType, '4');
		permSet4.Name = 'sort4';

		AuditPermissionSetDetails item1 = new AuditPermissionSetDetails(permSet1, fp);
		AuditPermissionSetDetails item2 = new AuditPermissionSetDetails(permSet2, fp);
		AuditPermissionSetDetails item3 = new AuditPermissionSetDetails(permSet3, fp);
		AuditPermissionSetDetails item4 = new AuditPermissionSetDetails(permSet4, fp);
		List<AuditPermissionSetDetails> sut = new List<AuditPermissionSetDetails>{item3, item1, item4, item2};

		sut.sort();

		System.assertEquals(permSet1.Name, sut[0].permissionSetName);
		System.assertEquals(permSet2.Name, sut[1].permissionSetName);
		System.assertEquals(permSet3.Name, sut[2].permissionSetName);
		System.assertEquals(permSet4.Name, sut[3].permissionSetName);
	}	
}