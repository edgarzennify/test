@IsTest
private class DataViewerHelperTests {
	
    private static final DataViewerMock.ofIDataProvider mockDataProvider;
    private static final Mock.ofIAttachmentHandler mockAttachment;
    private static final DataViewerHelper sut;
    
    static {
        mockDataProvider = new DataViewerMock.ofIDataProvider();
        mockAttachment = new Mock.ofIAttachmentHandler();
        sut = new DataViewerHelper(mockDataProvider, mockAttachment);
    }
    
    @IsTest
    static void it_should_get_a_template_when_report_obj_is_provided() {
        PM_DvReport report = new PM_DvReport();
        String reportId = ObjectFactory.getFakeId(dvreport__c.SObjectType, '1');
        report.id = reportid;
        report.Use_Attachment_As_Template = true;
        report.Output_Template = 'test-template';
        report.Attatchment_Template_Name = 'test-template-1';
        Attachment a = new Attachment();
        a.name = 'test-template-1';
        a.Body = Blob.valueOf('test-blob');
        List<Attachment> att = new List<Attachment>{a};
        mockAttachment.setup('getAllAttachmentsForParent', new List<Object>{reportid}).returns(att);
		          
        Blob result = sut.getOutputTemplate(report);
        
        System.assertEquals(a.body, result);
    }
    
    @IsTest
    static void it_should_call_the_dataprovider_to_extecute_query() {
        String query = 'SELECT Id FROM Account';
        
        List<Object> result =  sut.executeQuery( query);
        
        mockDataProvider.verify('getResults', new List<Object>{query}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_dataprovider_to_get_instance() {
        String className = 'test-class';
        String contextId = 'context-id';
        
        List<Object> result = sut.getResultsFromReportDataProvider(className, contextId);
        
        mockDataProvider.verify('getReportDataProviderInstance',new List<Object>{className}, Times.Once);
    }
    
    @IsTest
    static void it_should_build_merged_query_when_params_are_provided() {
        String queryTemplate = 'SELECT Id FROM Account WHERE Id={!id}';
        DataViewer.MergeField mfield = new DataViewer.MergeField();
        mfield.Token = '{!id}';
        mfield.Value = '1';
        List<DataViewer.MergeField> mfields = new List<DataViewer.MergeField>{mfield};
        
        String result =  sut.prepareQuery(queryTemplate, mfields);
        
        System.assertEquals('SELECT Id FROM Account WHERE Id=1', result);
    }

    @IsTest
    static void it_should_build_merge_object_when_query_params_are_provider() {
        string contextId = 'context';
         Map<string, string> parameters = new Map<string, string>{'id' => '1'};

        List<DataViewer.MergeField> result =  sut.buildMerges(contextId, parameters);

        System.assertEquals('{!contextId}', result[0].Token);
        System.assertEquals('context', result[0].Value);
        System.assertEquals('{!id}', result[1].Token);
        System.assertEquals('1', result[1].Value);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_report() {
        String name = 'rpt';

        PM_DVReport result = sut.getReportByName(name);

        mockDataProvider.verify('getReportByName', new List<Object>{name}, Times.Once);
    }
}