@isTest
private class XStageActionControllerTests{
    
    static testMethod void it_should_redirect_to_loan_app_stage_page_if_given_loan_app_id(){       
        //assemble
        TestUtilities.createLoanAppStages();
        Account newEntity = ObjectFactory.getValidEntity('test entity');
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c loanapp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
        
        //act
        XStageActionController sut = new XStageActionController(loanApp.Id,'/apex/LoanAppApprovedAction');
        PageReference redirectPage = sut.RedirectAction();
        
        //assert
        System.assert(redirectPage.getUrl().contains('apex/LoanAppStageAction?id=' + string.valueOf(loanapp.Id)));
    }
    
    static testMethod void it_should_redirect_to_archive_app_stage_page_if_given_archive_app_id(){
        //assemble
        EB_Booked_Loan_App__c bookedApp = new EB_Booked_Loan_App__c();
        insert bookedApp;
        
        //act
        XStageActionController sut = new XStageActionController(bookedApp.Id,'/apex/LoanAppApprovedAction');
        PageReference redirectPage = sut.RedirectAction();
        
        //assert
        System.assert(redirectPage.getUrl().contains('apex/LoanArchivedStageAction?id=' + string.valueOf(bookedApp.Id)));
    }
    
    static testMethod void it_should_redirect_to_agreement_stage_page_if_given_agreement_id(){
        //assemble
        Agreement__c agmt = new Agreement__c();
        insert agmt;
        
        //act
        XStageActionController sut = new XStageActionController(agmt.Id,'/apex/LoanAppApprovedAction');
        PageReference redirectPage = sut.RedirectAction();
        
        //assert
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
    }

    static testMethod void it_should_redirect_for_all_visual_force_action_pages(){
        Agreement__c agmt = new Agreement__c();
        insert agmt;
        
        XStageActionController sut;
        PageReference redirectPage;
  
        //approved
        sut = new XStageActionController(agmt.Id,'/apex/LoanAppApprovedAction');
        redirectPage = sut.RedirectAction();
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
        
        //archiving
        sut = new XStageActionController(agmt.Id,'/apex/LoanAppArchivedAction');
        redirectPage = sut.RedirectAction();
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
        
        //booking
        sut = new XStageActionController(agmt.Id,'/apex/LoanAppBookedAction');
        redirectPage = sut.RedirectAction();
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
        
        //documentation
        sut = new XStageActionController(agmt.Id,'/apex/LoanAppDocumentationAction');
        redirectPage = sut.RedirectAction();
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
        
        //new
        sut = new XStageActionController(agmt.Id,'/apex/LoanAppNewAction');
        redirectPage = sut.RedirectAction();
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
        
        //pending approval
        sut = new XStageActionController(agmt.Id,'/apex/LoanAppPendingApprovalAction');
        redirectPage = sut.RedirectAction();
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
        
        //underwriting
        sut = new XStageActionController(agmt.Id,'/apex/LoanAppUnderwritingAction');
        redirectPage = sut.RedirectAction();
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
        
        //checkback
        sut = new XStageActionController(agmt.Id,'/apex/LoanArchivedCheckbackAction?id=');
        redirectPage = sut.RedirectAction();
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
        
        //file review
        sut = new XStageActionController(agmt.Id,'/apex/LoanArchivedFileReviewAction?id=');
        redirectPage = sut.RedirectAction();
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
        
        //image prep
        sut = new XStageActionController(agmt.Id,'/apex/LoanArchivedImagePrepAction?id=');
        redirectPage = sut.RedirectAction();
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
        
        //shred & file
        sut = new XStageActionController(agmt.Id,'/apex/LoanArchivedShredFileAction?id=');
        redirectPage = sut.RedirectAction();
        System.assert(redirectPage.getUrl().contains('apex/AgreementStageAction?id=' + string.valueOf(agmt.Id)));
    }
    
    static testMethod void it_should_return_null_when_the_current_page_is_valid_but_the_object_is_not_part_of_the_loan_app_stage_system(){
        Account newEntity = ObjectFactory.getValidEntity('test entity');
        XStageActionController sut = new XStageActionController(newEntity.Id,'/apex/LoanAppUnderwritingAction');
        PageReference redirectPage = sut.RedirectAction();
        system.assertEquals(null,redirectPage);
    }
}