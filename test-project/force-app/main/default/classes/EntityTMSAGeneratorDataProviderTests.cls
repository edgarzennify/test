@IsTest
private class EntityTMSAGeneratorDataProviderTests {

    private static final EntityTMSAGeneratorDataProvider sut;

    static{
        sut= new EntityTMSAGeneratorDataProvider();
    }

    private static testMethod void it_should_get_account_obj_when_account_id_is_passed(){
        Account a = new Account(Name='test entity');
        insert a;
        Contact c = new Contact(AccountId = a.Id, LastName='last-name');
        insert c;

        EntityTMSAGenerator.EntityPm result = sut.getExtendedEntity(a.Id);

        Object fieldObj = result.entity.Id;
        fieldObj = result.entity.Name;
        fieldObj = result.entity.Date_TM_Master_Agmt_Signed__c;
        fieldObj = result.entity.TMSA_Imaging_Document_Url__c;
        fieldObj = result.relatedContacts[0].Id;
        fieldObj = result.relatedContacts[0].Name;
        fieldObj = result.relatedContacts[0].AccountId;
        fieldObj = result.relatedContacts[0].Email;
        fieldObj = result.relatedContacts[0].FirstName;
        fieldObj = result.relatedContacts[0].LastName;
        fieldObj = result.relatedContacts[0].Phone;
        fieldObj = result.relatedContacts[0].MobilePhone;
        fieldObj = result.relatedContacts[0].Fax;
        fieldObj = result.relatedContacts[0].Primary_TM_Contact__c;
        fieldObj = result.relatedContacts[0].Secondary_TM_Contact__c;
    }
}