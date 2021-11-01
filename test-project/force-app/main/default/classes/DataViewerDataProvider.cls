public class DataViewerDataProvider implements DataViewer.IDataProvider {
    public PM_DvReport getReportByName(String name){
        DvReport__c dvrpt = [
            SELECT 
            	Id, 
            	Name, 
            	Query_Template__c, 
            	Output_Template__c, 
            	Use_Attachment_As_Template__c, 
            	Attatchment_Template_Name__c,
            	Use_Apex_Class_As_Query__c,
                Apex_Class_Name__c
            FROM 
            	dvReport__c 
            WHERE 
            	Name =: name 
            LIMIT 1
        ];

        PM_DvReport pm = new PM_DvReport(); 
        pm.Id = dvrpt.Id;
        pm.Name = dvrpt.Name;
        pm.Use_Apex_Class_As_Query = dvrpt.Use_Apex_Class_As_Query__c;
        pm.Apex_Class_Name = dvrpt.Apex_Class_Name__c;
        pm.Query_Template = dvrpt.Query_Template__c;
        pm.Use_Attachment_As_Template = dvrpt.Use_Attachment_As_Template__c;
        pm.Attatchment_Template_Name = dvrpt.Attatchment_Template_Name__c;
        pm.Output_Template = dvrpt.Output_Template__c;
        return pm;
    }
    
    public List<Object> getResults(String queryString){
        return Database.query(queryString);
    }
    
    public DataViewer.IReportDataProvider getReportDataProviderInstance(String className){
        return (DataViewer.IReportDataProvider)Type.forName(className).newInstance();
    }
}