@IsTest
private class AuditProfileDetailsTests {

	@IsTest
    static void it_should_set_default_values_when_default_constructor_is_called() {
		AuditProfileDetails sut = new AuditProfileDetails();		

		System.assertEquals('', sut.profileName);
		System.assertEquals(false, sut.readAccess);
		System.assertEquals(false, sut.editAccess);
	}		

	@IsTest
    static void it_should_set_the_id_and_name_of_the_new_object_from_input_params() {
		Id fakeId = ObjectFactory.getFakeId(Profile.SObjectType, '1');
		String testName = 'testName';
		PM_FieldPermissions fp = new PM_FieldPermissions();

		AuditProfileDetails sut = new AuditProfileDetails(fakeId, testName, fp);

		System.assertEquals(fakeId, sut.profileId);
		System.assertEquals(testName, sut.profileName);
	}

	@IsTest
    static void it_should_set_read_and_edit_access_properties_to_true_on_the_new_object_from_input_params() {
		Id fakeId = ObjectFactory.getFakeId(Profile.SObjectType, '1');
		String testName = 'testName';
		PM_FieldPermissions fp = new PM_FieldPermissions();
		fp.PermissionsRead = true;
		fp.PermissionsEdit = true;

		AuditProfileDetails sut = new AuditProfileDetails(fakeId, testName, fp);

		System.assertEquals(true, sut.readAccess);
		System.assertEquals(true, sut.editAccess);
	}

	@IsTest
    static void it_should_set_read_and_edit_access_properties_to_false_on_the_new_object_from_input_params() {
		Id fakeId = ObjectFactory.getFakeId(Profile.SObjectType, '1');
		String testName = 'testName';
		PM_FieldPermissions fp = new PM_FieldPermissions();
		fp.PermissionsRead = false;
		fp.PermissionsEdit = false;

		AuditProfileDetails sut = new AuditProfileDetails(fakeId, testName, fp);

		System.assertEquals(false, sut.readAccess);
		System.assertEquals(false, sut.editAccess);
	}

	@IsTest
    static void it_should_sort_list_of_objects_by_name() {
		Id fakeId = ObjectFactory.getFakeId(Profile.SObjectType, '1');
		PM_FieldPermissions fp = new PM_FieldPermissions();
		fp.PermissionsRead = true;
		fp.PermissionsEdit = true;
		String nameSortedFirst = 'sort1';
		String nameSortedSecond = 'sort2';
		String nameSortedThird = 'sort3';
		String nameSortedFourth = 'sort4';
		AuditProfileDetails item1 = new AuditProfileDetails(fakeId, nameSortedFirst, fp);
		AuditProfileDetails item2 = new AuditProfileDetails(fakeId, nameSortedSecond, fp);
		AuditProfileDetails item3 = new AuditProfileDetails(fakeId, nameSortedThird, fp);
		AuditProfileDetails item4 = new AuditProfileDetails(fakeId, nameSortedFourth, fp);
		List<AuditProfileDetails> sut = new List<AuditProfileDetails>{item3, item1, item4, item2};

		sut.sort();

		System.assertEquals('sort1', sut[0].profileName);
		System.assertEquals('sort2', sut[1].profileName);
		System.assertEquals('sort3', sut[2].profileName);
		System.assertEquals('sort4', sut[3].profileName);
	}
}