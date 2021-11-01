@IsTest
private class TmArchivingDataProviderTests {
    private static TmArchivingDataProvider sut;

    static{
        sut = new TmArchivingDataProvider();
    }

    private static testMethod void it_should_industry_code_obj_from_code() {
        EB_Industry_Code__c obj = new EB_Industry_Code__c(Industry_code__c='122');
        insert obj;

        EB_Industry_Code__c result =  sut.getIndustryIdFromCode('122');

        Object fieldObj = result.Id;
        fieldObj = result.Name;
        fieldObj = result.Industry_Code__c;
        fieldObj = result.Industry_Group__c;
    }

    private static testMethod void it_should_get_archive_objects_when_tm_request_id_is_provided(){

        Tm_Service_request_Packet__c packet = new Tm_Service_request_Packet__c();
        insert packet;
        Tm_Service_Request__c req = new Tm_Service_Request__c(Tm_Service_Request_Packet__c = packet.Id);
        insert req;
        Tm_Service_Request_Archive__c archive = new Tm_Service_Request_Archive__c(Tm_Service_Request__c = req.Id);
        insert archive;

        List<Tm_Service_Request_Archive__c> result = sut.getArchives(req.Id);

        System.assertEquals(1, result.size());

        Object fieldObj = result[0].Id;
        fieldObj = result[0].Name;
        fieldObj = result[0].Treasury_Management_Service__r.Id;
        fieldObj = result[0].Treasury_Management_Service__r.Name;
        fieldObj = result[0].Treasury_Management_Service__r.RecordType.Name;
        fieldObj = result[0].Treasury_Management_Service__r.RecordType.Id;
        fieldObj = result[0].Treasury_Management_Service__r.Product_Pl__c;
        fieldObj = result[0].Tm_Service_Request__r.Id;
        fieldObj = result[0].Tm_Service_Request__r.Name;
        fieldObj = result[0].CreatedDate;
        fieldObj = result[0].CreatedById;
        fieldObj = result[0].CreatedBy.Name;
    }
}