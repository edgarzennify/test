@isTest
public class AgreementStageActionManagerCntrTests{
    static testmethod void it_should_use_the_dataprovider_to_build_a_page_reference(){
        //assemble
        MockDataProvider mockDataProvider = new MockDataProvider();
        EB_Stage_Action_Controller__c krapp = new EB_Stage_Action_Controller__c();
        krapp.Visual_Force_Action_Page__c = 'MoreKrapp';     
        mockDataProvider.getStageControllerByAgreementId_Return = krapp;
        Agreement__c agmt = new Agreement__c();
        insert agmt;
        
        //act
        AgreementStageActionManagerCntr sut = new AgreementStageActionManagerCntr(agmt.Id,mockDataProvider);
        pageReference pageRedirect = sut.RedirectAction();
          
        //assert
        System.assert(pageRedirect.getUrl().contains('MoreKrapp?id=' + string.valueOf(agmt.Id)));
    }
    
    static testMethod void it_should_return_a_null_page_reference_when_the_dataprovider_returns_an_empty_action_controller(){
        //assemble
        MockDataProvider mockDataProvider = new MockDataProvider();
        mockDataProvider.getStageControllerByAgreementId_Return = null;
        
        Agreement__c agmt = new Agreement__c();
        insert agmt;        
        
        //act
        AgreementStageActionManagerCntr sut = new AgreementStageActionManagerCntr(agmt.Id,mockDataProvider);
        pageReference pageRedirect = sut.RedirectAction();
        
        //assert
        system.assertEquals(null, pageRedirect);
    }
    
    static testMethod void dataprovider_should_return_the_correct_action_page(){
        EB_Stage_Action_Controller__c myStageController = new EB_Stage_Action_Controller__c();
        myStageController.Visual_Force_Action_Page__c = 'doesnt matter';
        insert myStageController;
        EB_Loan_App_Stage__c myStage = new EB_Loan_App_Stage__c();
        myStage.Loan_App_Stage_Action_Controller__c = myStageController.Id;
        myStage.Sort_Order__c = 999;
        insert myStage;
        Agreement__c agmt = new Agreement__c();
        insert agmt; 
        agmt.Stage__c = myStage.Id;
        update agmt;
       
        
        AgreementStageActionMgr_Dataprovider sut = new AgreementStageActionMgr_Dataprovider();
        EB_Stage_Action_Controller__c dontCare = sut.getStageControllerByAgreementId(agmt.Id);
        
        system.assertEquals('doesnt matter',dontCare.Visual_Force_Action_Page__c);
    }
    
    //////////////////////////////////////////
    // dependency mocks
    private class MockDataProvider implements AgreementStageActionManagerCntr.IDataProvider{
        public EB_Stage_Action_Controller__c getStageControllerByAgreementId_Return {get;set;}
        
        public EB_Stage_Action_Controller__c getStageControllerByAgreementId(Id agreementId){
            return getStageControllerByAgreementId_Return;            
        }
    }
}