@IsTest
private class AuditFieldPermissionsCtrlDataProvTests {
    
    private static final AuditFieldPermissionsCtrlDataProv sut;

    static {
        sut = new AuditFieldPermissionsCtrlDataProv();
    }

    @IsTest
    static void it_should_return_a_list_of_pm_permissionSets_when_given_a_compound_field_name() {
        String input = 'LLC_BI__Loan__c.Sync_Key__c';
        
        List<PM_PermissionSet> results = sut.getFieldAccessInformation(input);
        
        System.assertNotEquals(null, results);
    }

    @IsTest
    static void it_should_return_a_set_of_namespaces_as_strings() {
        Set<String> results = sut.getNamespaces();
        
        System.assertEquals(true, results.contains('LLC_BI'));
        System.assertEquals(false, results.contains(null));
    }

    @IsTest
    static void it_should_return_a_list_of_pm_entityDefinitions_when_given_a_valid_namespace() {
        String namespace = 'LLC_BI';
        
        List<PM_EntityDefinition> results = sut.getObjects(namespace);

        System.assertNotEquals(null, results);
    }

    @IsTest
    static void it_should_return_a_list_of_pm_entityDefinitions_when_given_a_blank_namespace() {
        String namespace = '';
        
        List<PM_EntityDefinition> results = sut.getObjects(namespace);

        System.assertNotEquals(null, results);
    }

    @IsTest
    static void it_should_return_a_list_of_pm_fieldDefinitions_when_given_an_object_name() {
        String selectedObject = 'Object_Action_Log__c';
        
        List<PM_FieldDefinition> results = sut.getFields(selectedObject);

        System.assertNotEquals(null, results);
    }
}