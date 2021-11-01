@IsTest
private class TmBoardingDashboardDataProviderTests {
	private static final TmBoardingDashboardDataProvider sut;
    
    static {
        sut = new TmBoardingDashboardDataProvider();
    }
    
    private static testMethod void it_should_get_all_active_packets() {
        Tm_Service_Request_Stage__c stg = new Tm_Service_Request_Stage__c(Name = 'test-New');
        insert stg;
        Tm_Service_Request_Packet__c pac = new Tm_Service_Request_Packet__c(Name='real',Stage__c='test-New');
        insert pac;
        Tm_Service_Request__c req = new Tm_Service_Request__c();
        req.TM_Service_Request_Packet__c = pac.Id;
        req.Stage__c = stg.Id;
        insert req;
        
        List<Tm_Service_Request__c> result = sut.getRequestWithActivePackets();
        
        Object fieldObject = result[0].Id;
        fieldObject = result[0].Name;
        fieldObject = result[0].RecordTypeId;
    }
    
    private static testMethod void it_should_get_all_active_packets_with_search() {
        Tm_Service_Request_Packet__c pac = new Tm_Service_Request_Packet__c(Name='real',Stage__c='New');
        insert pac;
        Tm_Service_Request__c req = new Tm_Service_Request__c();
        req.Tm_Service_Request_Packet__r = pac;
        req.Tm_Service_Request_Packet__c = pac.Id;
        insert req;
        
        List<Tm_Service_Request__c> result = sut.getRequestWithActivePacketsBySearch('real');
        
        Object fieldObject = result[0].Id;
        fieldObject = result[0].Name;
        fieldObject = result[0].RecordTypeId;
    }

    private static testMethod void it_should_get_all_tm_maintenances() {
        TM_Maintenance__c maint = new Tm_Maintenance__c();
        maint.Tm_Portal_Company_Name__c ='TTT';
        insert maint;

        List<TM_Maintenance__c> results = sut.getAllTmMaintenances();

        Object fieldObject = results[0].Id;
        fieldObject = results[0].Name;
        fieldObject = results[0].Contact__r.Account.Id;
        fieldObject = results[0].Contact__r.Account.Entity_Name__c;
        fieldObject = results[0].Status__c;
        fieldObject = results[0].Type__c;
        fieldObject = results[0].Contact__c;
        fieldObject = results[0].Contact__r.Name;
        fieldObject = results[0].TmPortal_First_Name__c;
        fieldObject = results[0].TmPortal_LastName__c;
        fieldObject = results[0].User_Changes_Count__c;
        fieldObject = results[0].Entitlement_Changes_Count__c;
        fieldObject = results[0].CreatedDate;
    }

     private static testMethod void it_should_get_all_tm_maintenances_by_search() {
        TM_Maintenance__c maint = new Tm_Maintenance__c();
        maint.Tm_Portal_Company_Name__c = 'testing';
        String search = 'test';

        insert maint;

        List<TM_Maintenance__c> results = sut.getSearchedTmMaintenances(search);

        Object fieldObject = results[0].Id;
        fieldObject = results[0].Name;
        fieldObject = results[0].Contact__r.Account.Id;
        fieldObject = results[0].Contact__r.Account.Entity_Name__c;
        fieldObject = results[0].Status__c;
        fieldObject = results[0].Type__c;
        fieldObject = results[0].Contact__c;
        fieldObject = results[0].Contact__r.Name;
        fieldObject = results[0].TmPortal_First_Name__c;
        fieldObject = results[0].TmPortal_LastName__c;
        fieldObject = results[0].User_Changes_Count__c;
        fieldObject = results[0].Entitlement_Changes_Count__c;
        fieldObject = results[0].CreatedDate;
    }
}