@IsTest
public class AgreementTestComponentControllerTests{
    static testMethod void it_should_call_the_constructor(){
        AgreementTestComponentController sut = new AgreementTestComponentController();
    }
    static testMethod void brute_force(){
        AgreementTestComponentController sut = new AgreementTestComponentController();
        Agreement__c testAgreement = new Agreement__c(name='test');
        insert testAgreement;
        Agreement_Test__c testTestAgmt = new Agreement_Test__c(Agreement__c = testAgreement.Id);
        insert testTestAgmt;
        sut.agmt = testAgreement;
        sut.test = testTestAgmt;
        sut.selectedAgreementTestId = testTestAgmt.Id;
        
        
        List<Agreement_Test__c > tests = sut.tests;
        
        pagereference pg = sut.showTestFields();
        pg = sut.AddTest();
        pg = sut.EditTest();
        pg = sut.ViewTest();
        pg = sut.DeleteTest();
        sut.showDialog();
        
        pg = sut.cancelDialog();
        pg = sut.RefereshPage();
        
        boolean check = sut.AgreementArchiveStatus;
        check = sut.AgreementActiveStatus;
        check = sut.isEditable;
        check = sut.displayDialog;
        
         
    }

}