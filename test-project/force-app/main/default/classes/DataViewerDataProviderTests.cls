@IsTest
private class DataViewerDataProviderTests {
	private static DataViewerDataProvider sut;
    
    static {
        sut = new DataViewerDataProvider();
    }

	@IsTest
    private static void it_should_call_all_fields_in_soql_when_report_is_fetched_by_name() {
    	dvReport__c rpt = new dvReport__c(Name = 'mt-report');
    	insert rpt;

    	PM_DvReport result = sut.getReportByName(rpt.Name);

    	Object fieldObj;

    	fieldObj = result.Id;
    	fieldObj = result.Name;
    	fieldObj = result.Query_Template;
    	fieldObj = result.Output_Template;
    	fieldObj = result.Use_Attachment_As_Template;
    	fieldObj = result.Attatchment_Template_Name;
    	fieldObj = result.Use_Apex_Class_As_Query;
    	fieldObj = result.Apex_Class_Name;
	}

	@IsTest
    private static void it_should_get_an_instance_of_report_dataProvider() {

    	string className = 'DataViewerDataProviderTests.TestReportDataProvider';

    	DataViewer.IReportDataProvider result =  sut.getReportDataProviderInstance(className);

    }

	@IsTest
    private static void it_should_execute_a_query_as_string() {
    	string queryString = 'SELECT Id, Name FROM User';

    	List<Object> result = sut.getResults(queryString);

    	Object fieldObject;

    	fieldObject = ((User)result[0]).Id;
    	fieldObject = ((User)result[0]).Name;
    }

    public class TestReportDataProvider implements DataViewer.IReportDataProvider {
        public List<Object> getResults(String param) {
            return null;
        }
    }
}