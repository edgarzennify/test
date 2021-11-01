@isTest
private class SL_Office_Test {
    private  static Contact oProvider, oMember;
    private static Account oFacility;
    private static void createTestData(){
        oFacility = new Account(
            Name = 'Facility'
        );
        insert oFacility;
        oProvider = new Contact(
            LastName = 'Provider',
            AccountId = oFacility.ID,
            Description = '{"mo":["0-23"]}'
        );
        insert oProvider;
        oMember = new Contact(
            LastName = 'Member',
            AccountId = oFacility.ID
        );
        insert oMember;
    }	
	static testMethod void SL_Test_Office() {
        createTestData();
        String sRequestResult;
        Map<String, String> aRequestResult;

        system.assertNotEquals(
            SL_Office.CA_Remote(JSON.serialize(new Map<String, String>{
                    'event' => 'getStructure',
                    'object' => 'contact',
                    'fields' => 'name,ownerid,ownerid.name',
                    'fieldset' => ''
                }
            )), 
            ''
        ); 
        system.assertNotEquals(
            SL_Office.CA_Remote(JSON.serialize(new Map<String, String>{
                    'event' => 'getData',
                    'title' => 'name',
                    'startField' => 'createdbydate',
                    'endField' => 'lastmodifieddate',
                    'object' => 'contact',
                    'fields' => 'name,ownerid',
                    'hm' => '20',
                    'offset' => '0',
                    'start' => '2017-01-01T00:00:00',
                    'end' => '2018-01-01T00:00:00'

                }
            )), 
            ''
        ); 

        system.assertNotEquals(
            SL_Office.CA_Remote(JSON.serialize(new Map<String, String>{
                    'event' => 'getElement',
                    'recordId' => '' + oMember.id,
                    'object' => 'contact',
                    'fields' => 'name.ownerid,ownerid.name,hasoptedoutoffax,email,birthdate,leadsource,reportstoid'
                }
            )), 
            ''
        ); 
        system.assertNotEquals(
            SL_Office.CA_Remote(JSON.serialize(new Map<String, String>{
                    'event' => 'saveElement',
                    'recordId' => '' + oMember.id,
                    'object' => 'contact',
                    'data' => '{"lastname":"New Member","hasoptedoutoffax":"true","email":"name@email.com","birthdate":"20000101","assistantphone":"2223344","leadsource":"Other","reportstoid":"' + oProvider.id + '"}'
                }
            )), 
            ''
        ); 
        sRequestResult = SL_Office.CA_Remote(JSON.serialize(new Map<String, String>{
                    'event' => 'del',
                    'id' => '' + oMember.id
                }
            ));
        aRequestResult = (Map<String, String>) JSON.deserialize(sRequestResult, Map<String, String>.class);
        system.assertNotEquals(aRequestResult.get('status'), 'error', aRequestResult.containsKey('error') ? aRequestResult.get('error') : '---');

        sRequestResult = SL_Office.CA_Remote(JSON.serialize(new Map<String, String>{
                    'event' => 'getReferenceOptions',
                    'title' => 'name',
                    'startField' => null,
                    'endField' => null,
                    'object' => 'contact',
                    'fields' => 'name,ownerid',
                    'hm' => '20',
                    'offset' => '0'
                }
            ));
        aRequestResult = (Map<String, String>) JSON.deserialize(sRequestResult, Map<String, String>.class);
        system.assertNotEquals(aRequestResult.get('status'), 'error', aRequestResult.containsKey('error') ? aRequestResult.get('error') : '---');

        SL_Office_DescribedCore oCore = SL_Office_DescribedCore.getInstance();
        system.assertNotEquals(oCore, null, 'error');
        system.assertNotEquals(oCore.getFieldDescribe('event', 'ownerid'), null, 'field describe');
        system.assertNotEquals(oCore.getRecordByTypeName('event'), null, 'new record');
        system.assertNotEquals(oCore.isFieldCreateable('event', 'ownerid'), null, 'is field editable');
        system.assertNotEquals(oCore.isObjectAccessable('event'), null, 'is object accessible');
        system.assertNotEquals(oCore.isObjectEditable('event'), null, 'is object  editable');
        system.assertNotEquals(oCore.isObjectCreateable('event'), null, 'is object  createable');
        system.assertNotEquals(oCore.isObjectDeleteable('event'), null, 'is object  deletable');
        system.assertNotEquals(oCore.isFieldUpdatable('event', 'ownerid'), null, 'is field updateable');
        system.assertNotEquals(oCore.getObjectAllQueryFields('event'), null, 'all query fields');
        system.assertNotEquals(oCore.getFieldsInSOQL('event', new List<String>{'ownerid'}), null, 'all query fields');
        system.assertNotEquals(oCore.getReferenceField('event', 'ownerid.name'), null, 'reference field');
        system.assertNotEquals(oCore.checkFLS('all', 'event', 'ownerid'), null, 'check FLS');
        
/*        SL_DescribeCore oCoreDC = SL_DescribeCore.getInstance();
        system.assertNotEquals(oCoreDC, null, 'error');
//        system.assertNotEquals(oCoreDC.getFieldDescribe('event', 'ownerid'), null, 'field describe');
        system.assertNotEquals(oCoreDC.getRecordByTypeName('event'), null, 'new record');
        system.assertNotEquals(oCoreDC.isFieldCreateable('event', 'ownerid'), null, 'is field editable');
        system.assertNotEquals(oCoreDC.isObjectAccessable('event'), null, 'is object accessible');
        system.assertNotEquals(oCoreDC.isObjectEditable('event'), null, 'is object  editable');
        system.assertNotEquals(oCoreDC.isObjectCreateable('event'), null, 'is object  createable');
        system.assertNotEquals(oCoreDC.isObjectDeleteable('event'), null, 'is object  deletable');
        system.assertNotEquals(oCoreDC.isFieldUpdatable('event', 'ownerid'), null, 'is field updateable');
        system.assertNotEquals(oCoreDC.getObjectAllQueryFields('event'), null, 'all query fields');
        system.assertNotEquals(oCoreDC.getFieldsInSOQL('event', new List<String>{'ownerid'}), null, 'all query fields');
        system.assertNotEquals(oCoreDC.getReferenceField('event', 'ownerid.name'), null, 'reference field');
        system.assertNotEquals(oCoreDC.checkFLS('all', 'event', 'ownerid'), null, 'check FLS');
        system.assertNotEquals(oCoreDC.getFieldsDescribesByObjectName('event', true), null, 'getFieldsDescribesByObjectName');
//        system.assertNotEquals(oCoreDC.isStringNullOrEmpty('event'), null, 'isStringNullOrEmpty');
        system.assertNotEquals(oCoreDC.getDefaultFieldValueByName('event', 'subject'), null, 'getDefaultFieldValueByName');
        system.assertNotEquals(oCoreDC.getObjects('All Objects'), null, 'getObjects');
        system.assertNotEquals(oCoreDC.isObjectExist('event'), null, 'isObjectExist');
//        system.assertNotEquals(oCoreDC.isTextType('TEXTAREA'), null, 'isTextType');
        system.assertNotEquals(oCoreDC.getFieldTypeByName('event', 'ownerid'), null, 'getFieldTypeByName');
        system.assertNotEquals(oCoreDC.getObjectRecordTypeValues('event'), null, 'getObjectRecordTypeValues');
        system.assertNotEquals(oCoreDC.hasField('event', 'ownerid'), null, 'hasField');
        system.assertNotEquals(oCoreDC.isFieldAccessible('event', 'ownerid.name'), null, 'isFieldAccessible');
        system.assertNotEquals(oCoreDC.getFieldLabelByName('event', 'ownerid.name'), null, 'getFieldLabelByName');
        system.assertNotEquals(oCoreDC.getObjectLabelByName('event'), null, 'getObjectLabelByName');
        system.assertNotEquals(oCoreDC.getObjectFieldsByType('event', 'DATETIME'), null, 'getObjectFieldsByType');
        system.assertNotEquals(oCoreDC.getReferencedObjectPrefixByFieldName('event', 'ownerid'), null, 'getReferencedObjectPrefixByFieldName');
        system.assertNotEquals(oCoreDC.getFieldReferenceByName('event', 'ownerid'), null, 'getFieldReferenceByName');
        system.assertNotEquals(oCoreDC.getFieldDescriptionByName('event', 'ownerid'), null, 'getFieldDescriptionByName');
        system.assertNotEquals(oCoreDC.getObjectDescription('event'), null, 'getObjectDescription');
        system.assertNotEquals(oCoreDC.getObjectDescribe('event'), null, 'getObjectDescribe');
        system.assertNotEquals(oCoreDC.getObjectNameField('event'), null, 'getObjectNameField');
        system.assertNotEquals(oCoreDC.getFieldsTypesInSOQL('event', new Set<String>{'ownerid'}), null, 'getFieldsTypesInSOQL');
*/        
        

    }
}