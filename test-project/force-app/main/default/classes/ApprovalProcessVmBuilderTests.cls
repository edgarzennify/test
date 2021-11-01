@IsTest
private class ApprovalProcessVmBuilderTests {
    private static ApprovalProcessMock.ofIVmBuilderHelper mockHelper;
    private static ApprovalProcessVmBuilder sut;
   
    static{
        mockHelper = new ApprovalProcessMock.ofIVmBuilderHelper();
        sut = new ApprovalProcessVmBuilder(mockHelper);
    }
    
    @IsTest
    private static void it_should_call_the_helper_to_build_steps(){
        String name = 'test-approval';
        String sobjectApiName = 'tm_service_request_approval__c';
        DmApproval.Info dm = new DmApproval.Info();
        DmApproval.DmInstance ins = new DmApproval.DmInstance();
        ins.OverallStatus =  'status';
        DmApproval.DmHistory hist= new DmApproval.DmHistory();
        ins.history = new List<DmApproval.DmHistory>{hist};
        dm.instances = new List<DmApproval.DmInstance>{ins};
        dm.name = name;
        dm.sobjectApiName = sobjectApiName;

        String recordId = 'record-id';
        ApprovalProcess.ApprovalProcessItem insVm = new ApprovalProcess.ApprovalProcessItem();
        insVm.StepTitle = 'title';
        insVm.OverallStatus = 'status';
        ApprovalProcess.ApprovalProcessDetail detl = new ApprovalProcess.ApprovalProcessDetail();
        detl.StepName = 'step-name';
        mockHelper.setup('buildStepVm', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(insVm);
        mockHelper.setup('buildStepDetailVm', new List<Object>{ins,hist,recordid}).returns(detl);
        mockHelper.setup('getStepTitle', new List<Object>{'step-name', 'status'}).returns(insVm.StepTitle);
        
        ApprovalProcess.ApprovalProcessInformation result = sut.buildVm(dm, recordId);

        System.assertEquals(name, result.name);
        System.assertEquals(sobjectApiName, result.SObjectName); 
        System.assertEquals('status',result.Action); 
        System.assertEquals('Submit for Approval',result.ActionText); 
    }
}