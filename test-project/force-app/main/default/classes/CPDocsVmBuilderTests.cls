@IsTest
public class CPDocsVmBuilderTests {
    
    private static Mock.ofISystem mockSystem;
    private static Mock.OfIConfigurations mockConfig;
    private static CPDocsVmBuilder sut;

    static{
        mockSystem = new Mock.ofISystem();
        mockConfig = new Mock.OfIConfigurations();
        sut = new CPDocsVmBuilder(mockSystem, mockConfig);
    }

    @IsTest 
    private static void it_should_build_vms_when_dms_are_provided_for_past_due(){
        Date today = Date.newInstance(2021, 2, 2);
        DmCPDocumentRequest dm = new DmCPDocumentRequest();
        dm.RecordId = 'xy';
        dm.DocumentDueDate = Date.newInstance(2021,1,1);
        dm.Status = 'Open';
        List<DmCPDocumentRequest>  dms = new List<DmCPDocumentRequest>{dm};
        mockSystem.setup('today').returns(today);

        List<CPDocs.DocumentRequest> result = sut.buildVm( dms);

        System.assertequals(1, result.size());
        System.assertequals('xy', result[0].documentRequestId);
        System.assertEquals(true, result[0].isPastDueDate);
        System.assertEquals('2021-01-01 Overdue!', result[0].documentDueDateLabel);
    }

    @IsTest 
    private static void it_should_build_vms_when_dms_are_provided_for_not_past_due(){
        Date today = Date.newInstance(2020, 12, 12);
        DmCPDocumentRequest dm = new DmCPDocumentRequest();
        dm.RecordId = 'xy';
        dm.DocumentDueDate = Date.newInstance(2021,1,1);
        dm.Status = 'Open';
        List<DmCPDocumentRequest>  dms = new List<DmCPDocumentRequest>{dm};
        mockSystem.setup('today').returns(today);

        List<CPDocs.DocumentRequest> result = sut.buildVm( dms);

        System.assertequals(1, result.size());
        System.assertequals('xy', result[0].documentRequestId);
        System.assertEquals(false, result[0].isPastDueDate);
        System.assertEquals('2021-01-01', result[0].documentDueDateLabel);
    }
}