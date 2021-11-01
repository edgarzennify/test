@IsTest
private class AgreementFinancialCovenantComponentTests {

    private static final AgreementFinancialCovenantComponent sut;
    private static final Mock.ofIConfigurations mockConfigs;

    static {
        mockConfigs = new Mock.ofIConfigurations();
        sut = new AgreementFinancialCovenantComponent(mockConfigs);
    }

    @IsTest
    static void it_should_call_the_constructor() {
        Agreement__c testAgreement = new Agreement__c(name = 'test agreement');
        insert testAgreement;
        Agreement_Financial_Covenant__c testCovenant = new Agreement_Financial_Covenant__c();
        testCovenant.Agreement__c = testAgreement.Id;
        sut.agmt = testAgreement;
        sut.Covenant = testCovenant;
        sut.selectedCovenantId = testCovenant.Id;
    }

    @IsTest
    static void it_should_call_all_the_public_methods() {
        Agreement__c testAgreement = new Agreement__c(name = 'test agreement');
        insert testAgreement;
        Agreement_Financial_Covenant__c testCovenant = new Agreement_Financial_Covenant__c();
        testCovenant.Agreement__c = testAgreement.Id;
        insert testCovenant;
        sut.agmt = testAgreement;
        sut.Covenant = testCovenant;
        sut.selectedCovenantId = testCovenant.Id;
        List<Agreement_Financial_Covenant__c > Covenants = sut.Covenants;
        List<SelectOption> options = sut.getConvenantTypes();
        options = sut.getConvenantTitles();
        options = sut.getEntities();
        PageReference pg = sut.showCovenantFields();
        sut.Mode = AgreementFinancialCovenantComponent.CurrentPopup.Covenant;
        pg = sut.AddCovenant();
        pg = sut.EditCovenant();
        pg = sut.ViewCovenant();
        pg = sut.DeleteCovenant();
        pg = sut.saveDialog();
        pg = sut.cancelDialog();
        boolean check = sut.AgreementArchiveStatus;
        check = sut.AgreementActiveStatus;
        
        sut.toggleCovenantVisibility();
        sut.SetEntitiesOnCovenant();
    }
}