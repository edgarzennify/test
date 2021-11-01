@IsTest
public class AgreementSubordinationComponentTests{
    static testMethod void it_should_call_the_constructor(){
        AgreementSubordinationComponent sut = new AgreementSubordinationComponent();
    }
    static testMethod void it_should_set_the_component(){
        AgreementSubordinationComponent sut = new AgreementSubordinationComponent();
        Agreement__c testAgreement = new Agreement__c(name='testAgreement');
        insert testAgreement;
        sut.agmt = testAgreement;
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement_Subordination__c testSubordinate = new Agreement_Subordination__c();
        testSubordinate.Agreement__c = testAgreement.Id;
        testSubordinate.Creditor__c = entity.Id;
        insert testSubordinate;
        sut.subordination = testSubordinate;
        
        List<Agreement_Subordination__c> subordinates = sut.SubordinationAgreements;
        sut.AddSubordination();
        sut.selectedSubordinationId = testSubordinate.Id;
        sut.EditSubordination();
        PageReference pg = sut.DeleteSubordination();
        pg = sut.ViewSubordination();
        pg = sut.CancelDialog();
        List<String> entities = sut.selectedEntities;
        List<SelectOption> options = sut.getEntities();
        
        boolean check = sut.AgreementArchiveStatus;
        check = sut.AgreementActiveStatus;
        //check = sut.isEditable;
        check = sut.isCommentsRequired;
        check = sut.isPaymentAllowedRequired;
        check = sut.isLimitationRequired;
        sut.resetClickedParameters();
        Map<id,String> entityMap =  sut.entityMap; 
        
        
    }
    static testMethod void it_should_save_the_component(){
        AgreementSubordinationComponent sut = new AgreementSubordinationComponent();
        Agreement__c testAgreement = new Agreement__c(name='testAgreement');
        insert testAgreement;
        sut.agmt = testAgreement;
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement_Subordination__c testSubordinate = new Agreement_Subordination__c();
        testSubordinate.Agreement__c = testAgreement.Id;
        testSubordinate.Creditor__c = entity.Id;
        insert testSubordinate;
        sut.subordination = testSubordinate;
        
        PageReference pg  = sut.SaveDialog();
    }
}