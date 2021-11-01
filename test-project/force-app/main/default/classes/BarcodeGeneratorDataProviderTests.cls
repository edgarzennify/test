@IsTest
private class BarcodeGeneratorDataProviderTests {
    
    private final static BarcodeGeneratorDataProvider sut;
    
    static {
        sut = new BarcodeGeneratorDataProvider();
    }

    private static testMethod void it_should_get_a_list_of_junctions() {
        BarcodeGeneratorCfgContext__c context = new BarcodeGeneratorCfgContext__c();
        insert context;
        BarcodeGeneratorCfgCategory__c category = new BarcodeGeneratorCfgCategory__c();
        insert category;
        BarcodeGeneratorCfgJunction__c jn = new BarcodeGeneratorCfgJunction__c();
        jn.Context__r = context;
        jn.Category__r = category;
        insert jn;

        List<BarcodeGeneratorCfgJunction__c> result = sut.getJunctions();

        System.assertEquals(1, result.size());
        BarcodeGeneratorCfgJunction__c jnResult = result[0];
        Object fieldInResult = jnResult.Query_Description_Field__c;
        fieldInResult = jnResult.Query_Template__c;
        fieldInResult = jnResult.Query_Value_Field__c;
        fieldInResult = jnResult.Category__r.Id;
        fieldInResult = jnResult.Category__r.Name;
        fieldInResult = jnResult.Category__r.Required_Perrmission_Set_Name__c;
        fieldInResult = jnResult.Context__r.Id;
        fieldInResult = jnResult.Context__r.ObjectName__c;
        fieldInResult = jnResult.JunctionType__c;
    }

    private static testMethod void it_should_get_a_list_of_doctypes() {

        BarcodeGeneratorCfgCategory__c category = new BarcodeGeneratorCfgCategory__c();
        insert category;
        BarcodeGeneratorCfgDocType__c docType = new BarcodeGeneratorCfgDocType__c();
        docType.Category__r = category;
        insert docType;

        List<BarcodeGeneratorCfgDocType__c> result = sut.getDocTypes();

        System.assertEquals(1, result.size());
        BarcodeGeneratorCfgDocType__c dtResult = result[0];
        Object fieldInResult = dtResult.Id;
        fieldInResult = dtResult.Name;
        fieldInResult = dtResult.Category__r.Id;
        fieldInResult = dtResult.Category__r.Name;
        fieldInResult = dtResult.Category__r.Required_Perrmission_Set_Name__c;
    }

    private static testMethod void it_should_save_sobjects() {
        Account a1 = new Account(Name='test account 1');
        Account a2 = new Account(Name='test Account 2');
        insert a2;
        List<Account> accounts = new List<Account>{a1,a2};

        sut.save(accounts);

        List<Account> requeryAccounts = [Select Id, Name FROM Account];
        System.assertEquals(2, requeryAccounts.size());
        System.assert(requeryAccounts[0].Id != null);
        System.assert(requeryAccounts[1].Id != null);      
    }
}