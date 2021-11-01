public class TmArchivingDataProvider implements TmArchiving.IDataProvider {
    public EB_Industry_Code__c getIndustryIdFromCode(String industryCode){
		List<EB_Industry_Code__c> pms = [
			Select
				Id
                ,Name
                ,Industry_Code__c
                ,Industry_Group__c
			FROM
				EB_Industry_Code__c
			WHERE
				Industry_Code__c =: industryCode
			LIMIT 1
		];
        return pms == null || pms.size() > 0?pms[0]:null;
	}

    public List<Tm_Service_Request_Archive__c> getArchives(string requestId){
        return [
            SELECT
                Id
                ,Name
                ,Treasury_Management_Service__r.Id
                ,Treasury_Management_Service__r.Name
                ,Treasury_Management_Service__r.RecordType.Name
                ,Treasury_Management_Service__r.RecordType.Id
                ,Treasury_Management_Service__r.Product_Pl__c
                ,Tm_Service_Request__r.Id
                ,Tm_Service_Request__r.Name
                ,CreatedDate
                ,CreatedById
                ,CreatedBy.Name
            FROM
                Tm_Service_Request_Archive__c
            WHERE
                Tm_Service_Request__c =:requestId
                AND Tm_Service_Request__c <> NULL

        ];
    }
}