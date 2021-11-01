@isTest
public class AgreementDmLoanAppBuilderTests {
    private static final AgreementDmLoanAppBuilder sut;
    
    static {
        sut = new AgreementDmLoanAppBuilder();
    }
    
    static testMethod void it_should_build_loan_app_dms_given_agmt_loan_app_rels(){
        Account entity1 = new Account();
        entity1.Name = 'TestEntityName';
        insert entity1;

        EB_Loan_Packet__c packet1 = new EB_Loan_Packet__c();
        packet1.Lead_Entity__c = entity1.Id;
        packet1.Name = 'TestPacket';
        insert packet1;

        EB_Loan_App_Stage__c appStage1 = new EB_Loan_App_Stage__c();
        appStage1.Name = 'New';
        appStage1.Sort_Order__c = 1;
        insert appStage1;

        EB_Loan_Application__c loanApp1 = new EB_Loan_Application__c();
        loanApp1.Bank_Owned_Loan_Amount__c = 1000.01;
        loanApp1.Application_Stage__c = appStage1.Id;
        loanApp1.EB_Loan_Packet__c = packet1.Id;
        insert loanApp1;

        EB_Loan_Participation__c loanPartic1 = new EB_Loan_Participation__c();
        loanPartic1.Loan_Application_ID__c = loanApp1.Id;
        loanPartic1.Participated_Amount__c = 300.00;
        loanPartic1.Participating_Institution__c = 'XYZ';
        insert loanPartic1;

        EB_Loan_Participation__c loanPartic2 = new EB_Loan_Participation__c();
        loanPartic2.Loan_Application_ID__c = loanApp1.Id;
        loanPartic2.Participated_Amount__c = 200.00;
        loanPartic2.Participating_Institution__c = 'XYZ';
        insert loanPartic2;

        Agreement_Loan_Application_Relationship__c agmtLoanAppRel1 = new Agreement_Loan_Application_Relationship__c();  
        agmtLoanAppRel1.Loan_Application__c = loanApp1.Id;  
        agmtLoanAppRel1.Agreement__c = ObjectFactory.getAgreement('a','b','c').Id;
        insert agmtLoanAppRel1;

        List<Agreement_Loan_Application_Relationship__c> rels = soqlAgreementLoanApplicationRelationships(agmtLoanAppRel1.Id);

        List<DmLoanApp> result = sut.build(rels);

        EB_Loan_Application__c requeryApp = soqlEbLoanApplication(loanApp1.Id);
        System.assertEquals(loanApp1.Id,result[0].id);
        System.assertEquals(requeryApp.Name,result[0].name);
        System.assertEquals('TestEntityName',result[0].leadEntity.Name);
        System.assertEquals('TestPacket',result[0].packetOrPackageName);
        System.assertEquals(1500.01,result[0].loanAmount);
        System.assertEquals(true,result[0].isNewStage);
    }

    static testMethod void it_should_build_loan_app_dms_given_loan_apps(){
        Account entity1 = new Account();
        entity1.Name = 'TestEntityName';
        insert entity1;

        EB_Loan_Packet__c packet1 = new EB_Loan_Packet__c();
        packet1.Lead_Entity__c = entity1.Id;
        packet1.Name = 'TestPacket';
        insert packet1;

        EB_Loan_App_Stage__c appStage1 = new EB_Loan_App_Stage__c();
        appStage1.Name = 'New';
        appStage1.Sort_Order__c = 1;
        insert appStage1;

        EB_Loan_Application__c loanApp1 = new EB_Loan_Application__c();
        loanApp1.Bank_Owned_Loan_Amount__c = 1000.01;
        loanApp1.Application_Stage__c = appStage1.Id;
        loanApp1.EB_Loan_Packet__c = packet1.Id;
        insert loanApp1;

        EB_Loan_Participation__c loanPartic1 = new EB_Loan_Participation__c();
        loanPartic1.Loan_Application_ID__c = loanApp1.Id;
        loanPartic1.Participated_Amount__c = 300.00;
        loanPartic1.Participating_Institution__c = 'XYZ';
        insert loanPartic1;

        EB_Loan_Participation__c loanPartic2 = new EB_Loan_Participation__c();
        loanPartic2.Loan_Application_ID__c = loanApp1.Id;
        loanPartic2.Participated_Amount__c = 200.00;
        loanPartic2.Participating_Institution__c = 'XYZ';
        insert loanPartic2;

        List<EB_Loan_Application__c> apps = soqlLoanApplications(loanApp1.Id);

        List<DmLoanApp> result = sut.build(apps);

        EB_Loan_Application__c requeryApp = soqlEbLoanApplication(loanApp1.Id);
        System.assertEquals(loanApp1.Id,result[0].id);
        System.assertEquals(requeryApp.Name,result[0].name);
        System.assertEquals('TestEntityName',result[0].leadEntity.Name);
        System.assertEquals('TestPacket',result[0].packetOrPackageName);
        System.assertEquals(1500.01,result[0].loanAmount);
        System.assertEquals(true,result[0].isNewStage);
    }

    static testMethod void it_should_build_dms_given_loan_app_dm_and_entity(){
        DmLoanApp appDm = new DmLoanApp();
        appDm.id = 'testid';
        Account entity = new Account(Name='test testerson');

        Agreements.LoanAppEntityRelationship result = sut.build(appDm, entity);

        System.assertEquals(appDm, result.loanApp);
        System.assertEquals(entity, result.entity);
    }

    static testMethod void it_should_build_loan_app_dms_given_llc_bi_loans(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        loan.Name = 'TestName';
        Id acctId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Account leadEntity = new Account(Id=acctId, Name='Mr. Lead Entity');
        loan.LLC_BI__Account__r = leadEntity;
        LLC_BI__Product_Package__c prodPackage = new LLC_BI__Product_Package__c();
        prodPackage.Name = 'Package Name';
        loan.LLC_BI__Product_Package__r = prodPackage;
        loan.LLC_BI__Amount__c = 123.45;
        List<LLC_BI__Loan__c> llcBiLoans = new List<LLC_BI__Loan__c>{loan};

        List<DmLoanApp> result = sut.build(llcBiLoans);

        DmLoanApp dm = result[0];
        System.assertEquals(loan.Id, dm.id);
        System.assertEquals('TestName', dm.name);
        System.assertEquals(String.valueOf(leadEntity.Id), dm.leadEntity.Id);
        System.assertEquals('Mr. Lead Entity', dm.leadEntity.Name);
        System.assertEquals('Package Name', dm.packetOrPackageName);
        System.assertEquals(123.45, dm.loanAmount);
        System.assertEquals(true, dm.isNewStage);
    }

    static testMethod void it_should_build_loan_app_dms_given_agmt_llc_bi_loan_rels(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        loan.Name = 'TestName';
        Id acctId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Account leadEntity = new Account(Id=acctId, Name='Mr. Lead Entity');
        loan.LLC_BI__Account__r = leadEntity;
        LLC_BI__Product_Package__c prodPackage = new LLC_BI__Product_Package__c();
        prodPackage.Name = 'Package Name';
        loan.LLC_BI__Product_Package__r = prodPackage;
        loan.LLC_BI__Amount__c = 123.45;

        Agreement_LLC_BI_Loan_Relationship__c agmtLlcBiLoanRel = new Agreement_LLC_BI_Loan_Relationship__c();
        agmtLlcBiLoanRel.LLCBI_Loan__r = loan;
        List<Agreement_LLC_BI_Loan_Relationship__c> agmtLlcBiLoanRels = new List<Agreement_LLC_BI_Loan_Relationship__c>{agmtLlcBiLoanRel};

        List<DmLoanApp> result = sut.build(agmtLlcBiLoanRels);

        DmLoanApp dm = result[0];
        System.assertEquals(loan.Id, dm.id);
        System.assertEquals('TestName', dm.name);
        System.assertEquals(String.valueOf(leadEntity.Id), dm.leadEntity.Id);
        System.assertEquals('Mr. Lead Entity', dm.leadEntity.Name);
        System.assertEquals('Package Name', dm.packetOrPackageName);
        System.assertEquals(123.45, dm.loanAmount);
        System.assertEquals(true, dm.isNewStage);
    }

    static List<EB_Loan_Application__c> soqlLoanApplications(Id appId){
        return [
            SELECT 
                Id,
                Name,
                EB_Loan_Packet__r.Name,
                EB_Loan_Packet__r.Lead_Entity__r.Name,
                Total_Loan_Amount__c,
                Application_Stage__r.Name
            FROM 
                EB_Loan_Application__c 
            WHERE Id=: appId
        ];
    }

    static List<Agreement_Loan_Application_Relationship__c> soqlAgreementLoanApplicationRelationships(Id relId){
        return [
            SELECT 
                Loan_Application__c,
                Loan_Application__r.Name,
                Loan_Application__r.EB_Loan_Packet__r.Name,
                Loan_Application__r.EB_Loan_Packet__r.Lead_Entity__r.Name,
                Loan_Application__r.Total_Loan_Amount__c,
                Loan_Application__r.Application_Stage__r.Name
            FROM 
                Agreement_Loan_Application_Relationship__c 
            WHERE Id=: relId
        ];
    }

    static EB_Loan_Application__c soqlEbLoanApplication(Id appId){
        return [
            SELECT
                Name
            FROM
                EB_Loan_Application__c
            WHERE
                Id =: appId
        ];
    }
}