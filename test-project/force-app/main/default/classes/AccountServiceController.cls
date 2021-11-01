global class AccountServiceController {
    public Id recId;

    public AccountServiceController(ApexPages.StandardController controller){
       this.recId = apexpages.currentpage().getparameters().get('Id');
    }

    public static testMethod void verifyAccountServiceController(){
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        Id clientId = Utility.recordTypeObject('Account','Client').Id;
        Account client = new Account(Name='test', RecordTypeId=clientId);
        insert client;
        Treasury_Management__c tm = new Treasury_Management__c();
        tm.Account__c = client.Id;                
        tm.TM_Conv_Master_Account_Number__c = '111';
        tm.RecordTypeId = Utility.recordTypeObject('Treasury_Management__c','ACH').Id;             
        tm.Start_Date__c = d;
        insert tm;
        
        String url = Utility.getServerUrl() +'/apex/Accountservice?id=';
        PageReference pr = testhelper(url + tm.Id);
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(tm);
        AccountServiceController testcontroller = new AccountServiceController(sc);
        testcontroller.recid = tm.Id;
        pagereference psave = testhelper('http://www.google.com');
    }

    public static PageReference testhelper(String url){
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;
    }

}