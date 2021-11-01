@IsTest
private class AuditFieldPermissionsCtrlTests {
	
	private static final Map<String, Schema.SObjectType> returnedObjects;
    private static final MockofIAuditFieldPermissionsCtrlDataProv mockDataProv;
    private static final MockofIAuditFieldPermissionsHelper mockHelper;
    private static final AuditFieldPermissionsCtrl sut;
	
    static {
		mockDataProv = new MockofIAuditFieldPermissionsCtrlDataProv();
    	mockHelper = new MockofIAuditFieldPermissionsHelper();
        sut = new AuditFieldPermissionsCtrl(mockDataProv, mockHelper);
	}
	
	@IsTest
	static void it_should_call_the_default_constructor_without_error() {
		AuditFieldPermissionsCtrl sutDefault = new AuditFieldPermissionsCtrl();
	}

	@IsTest
	static void it_should_initialize_and_populate_the_namespace_list_when_initialized() {
		Set<String> namespaces = new set<String>{'test1', 'test2'};
		mockDataProv.setup('getNamespaces').returns(namespaces);
		//act
		sut.initialize();
		//assert
		System.assertEquals(4, sut.m_namespaceList.size());
		System.assertEquals(' --- SELECT NAMESPACE --- ', sut.m_namespaceList[0].getValue());
		System.assertEquals(' --- SELECT NAMESPACE --- ', sut.m_namespaceList[0].getLabel());
		System.assertEquals('', sut.m_namespaceList[1].getValue());
		System.assertEquals('Standard and Unmanaged Objects', sut.m_namespaceList[1].getLabel());
		System.assertEquals('test1', sut.m_namespaceList[2].getValue());
		System.assertEquals('test1', sut.m_namespaceList[2].getLabel());
		System.assertEquals('test2', sut.m_namespaceList[3].getValue());
		System.assertEquals('test2', sut.m_namespaceList[3].getLabel());
	}

	@IsTest
	static void it_should_set_selectedObject_and_selectedField_properties_to_empty_values_when_namespace_is_selected() {
		mockDataProv.setup('getObjects', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<PM_EntityDefinition>());
		// //act
		sut.namespaceSelectedEvent();
		//assert
		System.assertEquals('', sut.m_selectedObject);
		System.assertEquals('', sut.m_selectedField);
	}
	
	
	@IsTest
	static void it_should_populate_the_objectList_and_sort_it_alphabetically_when_namespace_is_selected() {
		String namespace = 'test';
		PM_EntityDefinition ed1 = new PM_EntityDefinition();
		ed1.DeveloperName = 'bbb';
		ed1.QualifiedApiName = 'bbb-api';
		PM_EntityDefinition ed2 = new PM_EntityDefinition();
		ed2.DeveloperName = 'ddd';
		ed2.QualifiedApiName = 'ddd-api';
		PM_EntityDefinition ed3 = new PM_EntityDefinition();
		ed3.DeveloperName = 'aaa';
		ed3.QualifiedApiName = 'aaa-api';
		List<PM_EntityDefinition> eds = new List<PM_EntityDefinition>{ed1, ed2, ed3};

		mockDataProv.setup('getObjects', new List<Object>{namespace}).returns(eds);
		//act
		sut.m_selectedNamespace = namespace;
		sut.namespaceSelectedEvent();
		//assert
		System.assertEquals(4, sut.m_objectList.size());
		System.assertEquals(' --- SELECT OBJECT --- ', sut.m_objectList[0].getValue());
		System.assertEquals(' --- SELECT OBJECT --- ', sut.m_objectList[0].getLabel());
		System.assertEquals('aaa-api', sut.m_objectList[1].getValue());
		System.assertEquals('aaa', sut.m_objectList[1].getLabel());
		System.assertEquals('bbb-api', sut.m_objectList[2].getValue());
		System.assertEquals('bbb', sut.m_objectList[2].getLabel());
		System.assertEquals('ddd-api', sut.m_objectList[3].getValue());
		System.assertEquals('ddd', sut.m_objectList[3].getLabel());
	}

	@IsTest
	static void it_should_set_selectedField_property_to_empty_values_when_object_is_selected() {
		mockDataProv.setup('getFields', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<PM_FieldDefinition>());
		//act
		sut.objectSelectedEvent();
		//assert
		System.assertEquals('', sut.m_selectedField);
	}

	@IsTest
	static void it_should_initialize_access_lists_when_object_is_selected() {
		mockDataProv.setup('getFields', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<PM_FieldDefinition>());
		//act
		sut.objectSelectedEvent();
		//assert
		System.assertEquals(true, sut.m_permissionSetsWithAccess.isEmpty());
		System.assertEquals(true, sut.m_profilesWithAccess.isEmpty());
		System.assertEquals(true, sut.m_usersWithAccess.isEmpty());
	}
	
	@IsTest
	static void it_populate_the_fieldList_and_sort_it_alphabetically_when_object_is_selected() {
		String selectedObject = 'test';
		PM_FieldDefinition fd1 = new PM_FieldDefinition();
		fd1.DeveloperName = 'zzz';
		fd1.QualifiedApiName = 'zzz-api';
		PM_FieldDefinition fd2 = new PM_FieldDefinition();
		fd2.DeveloperName = 'aaa';
		fd2.QualifiedApiName = 'aaa-api';
		PM_FieldDefinition fd3 = new PM_FieldDefinition();
		fd3.DeveloperName = 'rrr';
		fd3.QualifiedApiName = 'rrr-api';
		List<PM_FieldDefinition> fds = new List<PM_FieldDefinition>{fd1, fd2, fd3};

		mockDataProv.setup('getFields', new List<Object>{selectedObject}).returns(fds);
		//act
		sut.m_selectedObject = selectedObject;
		sut.objectSelectedEvent();
		//assert
		System.assertEquals(4, sut.m_fieldList.size());
		System.assertEquals(' --- SELECT FIELD --- ', sut.m_fieldList[0].getValue());
		System.assertEquals(' --- SELECT FIELD --- ', sut.m_fieldList[0].getLabel());
		System.assertEquals('test.aaa-api', sut.m_fieldList[1].getValue());
		System.assertEquals('aaa', sut.m_fieldList[1].getLabel());
		System.assertEquals('test.rrr-api', sut.m_fieldList[2].getValue());
		System.assertEquals('rrr', sut.m_fieldList[2].getLabel());
		System.assertEquals('test.zzz-api', sut.m_fieldList[3].getValue());
		System.assertEquals('zzz', sut.m_fieldList[3].getLabel());
	}

	@IsTest
	static void it_should_initialize_access_lists_when_field_is_selected() {
		mockDataProv.setup('getFieldAccessInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<PM_PermissionSet>());
		//act
		sut.fieldSelectedEvent();
		//assert
		System.assertEquals(true, sut.m_permissionSetsWithAccess.isEmpty());
		System.assertEquals(true, sut.m_profilesWithAccess.isEmpty());
		System.assertEquals(true, sut.m_usersWithAccess.isEmpty());
	}

	@IsTest
	static void it_should_retrieve_field_security_details_for_permission_sets_not_owned_by_a_profile_when_field_is_selected() {
		String fieldName = 'test';

		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.Id = ObjectFactory.getFakeId(PermissionSet.SObjectType, '1');
		permSet.Name = 'pset name';
		permSet.Profile = new PM_Profile();
		List<PM_PermissionSet> permSets = new List<PM_PermissionSet>{permSet};

		PM_FieldPermissions fieldPermissions = new PM_FieldPermissions();
		fieldPermissions.PermissionsRead = true;
		fieldPermissions.PermissionsEdit = true;

		PM_PermissionSetAssignment assignment = new PM_PermissionSetAssignment();
		assignment.Assignee = new PM_User();
		assignment.Assignee.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
		assignment.Assignee.Name = 'test name'; 
		List<PM_PermissionSetAssignment> assignemnts = new List<PM_PermissionSetAssignment>{assignment};
		
		mockDataProv.setup('getFieldAccessInformation', new List<Object>{fieldName}).returns(permSets);
		mockHelper.setup('getProfileName', new List<Object>{permSet}).returns(null);
		mockHelper.setup('getPermissionForField', new List<Object>{permset, fieldName}).returns(fieldPermissions);
		mockHelper.setup('getAssignedUsers', new List<Object>{permSet}).returns(assignemnts);
		//act
		sut.m_selectedField = fieldName;
		sut.fieldSelectedEvent();
		//assert
		System.assertEquals(1, sut.m_permissionSetsWithAccess.size());
		System.assertEquals(permSet.Id, sut.m_permissionSetsWithAccess[0].permissionSetId);
		System.assertEquals('pset name', sut.m_permissionSetsWithAccess[0].permissionSetName);
		System.assertEquals(true, sut.m_permissionSetsWithAccess[0].readAccess);
		System.assertEquals(true, sut.m_permissionSetsWithAccess[0].editAccess);
		System.assertEquals(1, sut.m_usersWithAccessCount);
		System.assertEquals(1, sut.m_usersWithAccess.size());
		System.assertEquals(assignment.Assignee.Id, sut.m_usersWithAccess[0].userId);
		System.assertEquals('test name', sut.m_usersWithAccess[0].userName);
		System.assertEquals(true, sut.m_usersWithAccess[0].readAccess);
		System.assertEquals(true, sut.m_usersWithAccess[0].editAccess);
		System.assertEquals(1, sut.m_usersWithAccess[0].permissionSets.size());
		System.assertEquals(0, sut.m_profilesWithAccess.size());
	}

	@IsTest
	static void it_should_retrieve_field_security_details_for_permission_sets_owned_by_a_profile_when_field_is_selected() {
		String fieldName = 'test';

		PM_PermissionSet permSet = new PM_PermissionSet();
		permSet.Id = ObjectFactory.getFakeId(PermissionSet.SObjectType, '1');
		permSet.Name = 'pset name';
		permSet.Label = ObjectFactory.getFakeId(PermissionSet.SObjectType, '1');
		permSet.Profile = new PM_Profile();
		permSet.Profile.Name = 'test profile name';
		List<PM_PermissionSet> permSets = new List<PM_PermissionSet>{permSet};

		PM_FieldPermissions fieldPermissions = new PM_FieldPermissions();
		fieldPermissions.PermissionsRead = true;
		fieldPermissions.PermissionsEdit = true;

		PM_PermissionSetAssignment assignment = new PM_PermissionSetAssignment();
		assignment.Assignee = new PM_User();
		assignment.Assignee.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
		assignment.Assignee.Name = 'test assignee name'; 
		List<PM_PermissionSetAssignment> assignemnts = new List<PM_PermissionSetAssignment>{assignment};
		
		mockDataProv.setup('getFieldAccessInformation', new List<Object>{fieldName}).returns(permSets);
		mockHelper.setup('getProfileName', new List<Object>{permSet}).returns(permSet.Profile.Name);
		mockHelper.setup('getPermissionForField', new List<Object>{permset, fieldName}).returns(fieldPermissions);
		mockHelper.setup('getAssignedUsers', new List<Object>{permSet}).returns(assignemnts);
		mockHelper.setup('getProfileObjectReadPermission', new List<Object>{permSet}).returns(true);
		mockHelper.setup('getProfileObjectEditPermission', new List<Object>{permSet}).returns(true);
		//act
		sut.m_selectedField = fieldName;
		sut.fieldSelectedEvent();
		//assert
		System.assertEquals(1, sut.m_usersWithAccessCount);
		System.assertEquals(1, sut.m_usersWithAccess.size());
		System.assertEquals(assignment.Assignee.Id, sut.m_usersWithAccess[0].userId);
		System.assertEquals('test assignee name', sut.m_usersWithAccess[0].userName);
		System.assertEquals(true, sut.m_usersWithAccess[0].readAccess);
		System.assertEquals(true, sut.m_usersWithAccess[0].editAccess);
		System.assertEquals(0, sut.m_usersWithAccess[0].permissionSets.size());
		System.assertEquals(1, sut.m_profilesWithAccess.size());
		System.assertEquals(permSet.Label, sut.m_profilesWithAccess[0].profileId);
		System.assertEquals('test profile name', sut.m_profilesWithAccess[0].profileName);
		System.assertEquals(true, sut.m_profilesWithAccess[0].readAccess);
		System.assertEquals(true, sut.m_profilesWithAccess[0].editAccess);
		System.assertEquals(0, sut.m_permissionSetsWithAccess.size());
	}

	private class MockofIAuditFieldPermissionsCtrlDataProv extends ApexMoq implements AuditFieldPermissions.IAuditFieldPermissionsCtrlDataProv{
		public List<PM_PermissionSet> getFieldAccessInformation(String fieldName){
			return (List<PM_PermissionSet>)handleMethodInvocation('getFieldAccessInformation', new List<Object>{fieldName});
		}
		public Set<String> getNamespaces(){
			return (Set<String>)handleMethodInvocation('getNamespaces');
		}
		public List<PM_EntityDefinition> getObjects(String namespace){
			return (List<PM_EntityDefinition>)handleMethodInvocation('getObjects', new List<Object>{namespace});
		}
		public List<PM_FieldDefinition> getFields(String selectedObject){
			return (List<PM_FieldDefinition>)handleMethodInvocation('getFields', new List<Object>{selectedObject});
		}
	}

	private class MockofIAuditFieldPermissionsHelper extends ApexMoq implements AuditFieldPermissions.IAuditFieldPermissionsHelper {
		public List<PM_PermissionSetAssignment> getAssignedUsers(PM_PermissionSet permissionSet){
			return (List<PM_PermissionSetAssignment>)handleMethodInvocation('getAssignedUsers', new List<Object>{permissionSet});
		}
		public PM_FieldPermissions getPermissionForField(PM_PermissionSet permissionSet, String fieldName){
			return (PM_FieldPermissions)handleMethodInvocation('getPermissionForField', new List<Object>{permissionSet, fieldName});
		}
		public String getProfileName(PM_PermissionSet permissionSet){
			return (String)handleMethodInvocation('getProfileName', new List<Object>{permissionSet});
		}
		public Boolean getProfileObjectReadPermission(PM_PermissionSet profilePermissionSet){
			return (Boolean)handleMethodInvocation('getProfileObjectReadPermission', new List<Object>{profilePermissionSet});
		}
		public Boolean getProfileObjectEditPermission(PM_PermissionSet profilePermissionSet){
			return (Boolean)handleMethodInvocation('getProfileObjectEditPermission', new List<Object>{profilePermissionSet});
		}
	}
}