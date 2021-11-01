@IsTest
public class AgreementFeeComponentControllerTests{
    static  testMethod void it_should_call_the_constructor(){
        AgreementFeeComponentController sut = new AgreementFeeComponentController();
    }
    
    static testMethod void it_should_call_the_methods(){
        AgreementFeeComponentController sut = new AgreementFeeComponentController();
       
        Agreement__c testAgreement = new Agreement__c(name = 'test agreement');
        insert testAgreement;
        Agreement_Fee__c testFee = new Agreement_Fee__c();
        testFee.Agreement__c = testAgreement.Id;
        insert testfee;
        sut.agmt = testAgreement;
        sut.fee = testFee;
        sut.selectedAgreementFeeId = testFee.Id;
        List<Agreement_Fee__c > fees = sut.fees;
        List<SelectOption> options = sut.getFeeTypes();
        PageReference pg = sut.showFeeFields();
        pg = sut.AddFee();
        pg = sut.EditFee();
        pg = sut.ViewFee();
        pg = sut.DeleteFee();
        pg = sut.cancelDialog();
        pg = sut.closeDialog();
        pg = sut.RefereshPage();
        sut.showDialog();
        boolean check = sut.AgreementArchiveStatus;
        check = sut.AgreementActiveStatus;
        //check = sut.isEditable;
        sut.ResetClickedParameters();
        
    }
        

}