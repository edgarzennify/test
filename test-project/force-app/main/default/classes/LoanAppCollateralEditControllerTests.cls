@isTest
private class LoanAppCollateralEditControllerTests {

  private static testMethod void verifyLoanAppCollteralNewPageReference(){
            String url = Utility.getServerUrl()+ '/apex/LoanAppCollateralEdit?aid=';
              
                
            Account acctProspect = testObjectClass.getTestAccount();
            EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
            PageReference pr = utility.testhelper(url + app.Id);
            test.setCurrentPage(pr);
            ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
            LoanAppCollateralEditController testcontroller = new LoanAppCollateralEditController(sc);
            PageReference  psearch = testcontroller.SetSearch();
            PageReference psave  = testcontroller.SaveCollateral();
            psave  = testcontroller.SaveQuickCollateral();
             
            PageReference pCancel = testcontroller.CancelCollateral();
            pcancel = testcontroller.NewAppraisal();
    }
    
    //Edit record for Collateral and Relationship
    private static testMethod void verifyLoanAppCollteralEditPageReference(){
        String url = Utility.getServerUrl() +'/apex/LoanAppCollateralEdit?id=';
        TestUtilities.createLoanAppStages();
        TestUtilities.createCollateralCodes();
                
        Account acctProspect = testObjectClass.getTestAccount();
        EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
        EB_Loan_App_Entity_Relationship__c entityrel = testObjectClass.getLoanAppEntityRealationship(acctProspect, app);
        EB_Collateral__c collateral = testObjectClass.getTestCollateralObj();
        EB_Collateral_Client_Relationship__c relOwner = testObjectClass.getTestCollateralClientObject(acctProspect, collateral);
        EB_Loan_App_Collateral_Relationship__c rel = testObjectClass.getTestLoanAppCollateralRelationshipObj(collateral, app);
        PageReference pr = utility.testhelper(url + rel.Id + '&retURL=' + app.Id + '&sfdc.override=1');
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        LoanAppCollateralEditController testcontroller = new LoanAppCollateralEditController(sc);
        PageReference  psearch = testcontroller.SetSearch();
        PageReference psave  = testcontroller.SaveCollateral();
        psave = testcontroller.SaveQuickCollateral();
        PageReference pCancel = testcontroller.CancelCollateral();
        pcancel = testcontroller.NewAppraisal();
        pcancel = testcontroller.EditAppraisal();
    }
  
    //Relationship only record for Collateral and Relationship
    private static testMethod void verifyLoanAppCollteralRelationshipOnlyPageReference(){
        TestUtilities.createLoanAppStages();
        TestUtilities.createCollateralCodes();
        String url = Utility.getServerUrl()+ '/apex/LoanAppCollateralEdit?aid=';     
                
        Account acctProspect = testObjectClass.getTestAccount();
        EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
        EB_Loan_App_Entity_Relationship__c entityrel = testObjectClass.getLoanAppEntityRealationship(acctProspect, app);
        EB_Collateral__c collateral = testObjectClass.getTestCollateralObj();
        EB_Collateral_Client_Relationship__c relOwner = testObjectClass.getTestCollateralClientObject(acctProspect, collateral);
        EB_Loan_App_Collateral_Relationship__c rel = testObjectClass.getTestLoanAppCollateralRelationshipObj(collateral, app);
        PageReference pr = utility.testhelper(url + app.Id + '&cid=' + collateral.Id );
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        LoanAppCollateralEditController testcontroller = new LoanAppCollateralEditController(sc);
        PageReference  psearch = testcontroller.SetSearch();
        PageReference psave  = testcontroller.SaveCollateral();
        psave = testcontroller.SaveQuickCollateral();
        PageReference pCancel = testcontroller.CancelCollateral();
        pcancel = testcontroller.NewAppraisal();
    }
    
    private static testMethod void verifyLoanAppCollteralMethods(){
        String url = Utility.getServerUrl()+'/apex/LoanAppCollateralEdit?aid=';
        TestUtilities.createLoanAppStages();
        TestUtilities.createCollateralCodes();  
                
        Account acctProspect = testObjectClass.getTestAccount();
        EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
        EB_Loan_App_Entity_Relationship__c entityrel = testObjectClass.getLoanAppEntityRealationship(acctProspect, app);
        EB_Collateral__c collateral = testObjectClass.getTestCollateralObj();
        EB_Collateral_Client_Relationship__c relOwner = testObjectClass.getTestCollateralClientObject(acctProspect, collateral);
        EB_Loan_App_Collateral_Relationship__c rel = testObjectClass.getTestLoanAppCollateralRelationshipObj(collateral, app);
        PageReference pr = utility.testhelper(url + app.Id + '&cid=' + collateral.Id );
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        LoanAppCollateralEditController testcontroller = new LoanAppCollateralEditController(sc);
        testcontroller.getQueryParameters();
        testcontroller.Initialize();
        List<selectoption> names = testcontroller.getBorrowerNames();
        String deed = testcontroller.getCheckIncreaseToExistingDeed();
        String codename = testcontroller.getCollateralCodeAndName();
        Id owner = testcontroller.getOwnerIDForCollateralID(collateral.Id);
        List<selectoption> codes =  testcontroller.getCollateralCodes();
        String quote = testcontroller.getQuotes();
        List<selectoption> purpose = testcontroller.getPurposeOfCollateral();
        List<EB_Appraisal_Order__c>  ap = testcontroller.getAppraisals();
        String readonly = testcontroller.getReadonlyStatus();
        boolean ppurpose =  testcontroller.PrimaryPurposeOfCollateralExistsOnLoanApp();
        String s1 = testcontroller.getLoanRecordType();
        String s2 = testcontroller.getRenewalOnly();
        s2 = testcontroller.getReturnUrl();
        List<selectoption> testselection = testcontroller.getCounties();
        testselection = testcontroller.getSurvey();
        testselection = testcontroller.getValuationType();   
        testSelection = testcontroller.getChangeCollateral();      
    }

    private static testMethod void it_should_return_true_if_collateral_id_is_in_real_estate_category() {
        Collateral_Code__c realEstateCollatCode = new Collateral_Code__c();
        realEstateCollatCode.Category__c = 'Real Estate';
        realEstateCollatCode.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCode;
        EB_Loan_Application__c testApp = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(testApp);
        LoanAppCollateralEditController sut = new LoanAppCollateralEditController(sc);
        sut.dropdownCollateralCodeId = realEstateCollatCode.Id;

        string returnVal = sut.getRealEstateRenderStatus();

        System.assertEquals('true', returnVal);
    }

    private static testMethod void it_should_return_false_if_collateral_id_is_not_in_real_estate_category() {
        Collateral_Code__c realEstateCollatCode = new Collateral_Code__c();
        realEstateCollatCode.Category__c = 'Real Estate';
        realEstateCollatCode.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCode;
        Collateral_Code__c nonRealEstateCollatCode = new Collateral_Code__c();
        nonRealEstateCollatCode.Category__c = 'Other';
        nonRealEstateCollatCode.Subcategory__c = 'Other';
        nonRealEstateCollatCode.Collateral_Code_ID__c = 'OTH';
        insert nonRealEstateCollatCode;
        EB_Loan_Application__c testApp = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(testApp);
        LoanAppCollateralEditController sut = new LoanAppCollateralEditController(sc);
        sut.dropdownCollateralCodeId = nonRealEstateCollatCode.Id;

        string returnVal = sut.getRealEstateRenderStatus();

        System.assertEquals('false', returnVal);
    }


    private static testMethod void it_should_return_true_if_collateral_id_is_in_real_estate_category_but_not_land_or_construction_subcategory() {
        Collateral_Code__c realEstateCollatCode = new Collateral_Code__c();
        realEstateCollatCode.Category__c = 'Real Estate';
        realEstateCollatCode.Subcategory__c = 'Other';
        realEstateCollatCode.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCode;
        EB_Loan_Application__c testApp = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(testApp);
        LoanAppCollateralEditController sut = new LoanAppCollateralEditController(sc);
        sut.dropdownCollateralCodeId = realEstateCollatCode.Id;

        string returnVal = sut.getLoanDetailsRealEstateRenderStatus();

        System.assertEquals('true', returnVal);
    }

    private static testMethod void it_should_return_false_if_collateral_id_is_not_in_real_estate_category_or_in_land_or_construction_subcategory() {
        Collateral_Code__c realEstateCollatCodeLandSub = new Collateral_Code__c();
        realEstateCollatCodeLandSub.Category__c = 'Real Estate';
        realEstateCollatCodeLandSub.Subcategory__c = 'Land';
        realEstateCollatCodeLandSub.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCodeLandSub;
        Collateral_Code__c realEstateCollatCodeConstSub = new Collateral_Code__c();
        realEstateCollatCodeConstSub.Category__c = 'Real Estate';
        realEstateCollatCodeConstSub.Subcategory__c = 'Construction';
        realEstateCollatCodeConstSub.Collateral_Code_ID__c = 'CON';
        insert realEstateCollatCodeConstSub;
        Collateral_Code__c nonRealEstateCollatCode = new Collateral_Code__c();
        nonRealEstateCollatCode.Category__c = 'Other';
        nonRealEstateCollatCode.Subcategory__c = 'Other';
        nonRealEstateCollatCode.Collateral_Code_ID__c = 'OTH';
        insert nonRealEstateCollatCode;
        EB_Loan_Application__c testApp = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(testApp);
        LoanAppCollateralEditController sut = new LoanAppCollateralEditController(sc);

        sut.dropdownCollateralCodeId = realEstateCollatCodeLandSub.Id;
        string returnVal = sut.getLoanDetailsRealEstateRenderStatus();

        System.assertEquals('false', returnVal, 'Loan Details Real Estate Render not displaying per specifications when subcollateral is land.');

        sut.dropdownCollateralCodeId = realEstateCollatCodeConstSub.Id;
        returnVal = sut.getLoanDetailsRealEstateRenderStatus();

        System.assertEquals('false', returnVal, 'Loan Details Real Estate Render not displaying per specifications when subcollateral is construction.');

        sut.dropdownCollateralCodeId = nonRealEstateCollatCode.Id;
        returnVal = sut.getLoanDetailsRealEstateRenderStatus();

        System.assertEquals('false', returnVal, 'Loan Details Real Estate Render not displaying per specifications when collateral is not real estate.');
    }


    private static testMethod void it_should_return_true_if_collateral_id_is_in_real_estate_category_and_land_subcategory() {
        Collateral_Code__c realEstateCollatCode = new Collateral_Code__c();
        realEstateCollatCode.Category__c = 'Real Estate';
        realEstateCollatCode.Subcategory__c = 'Land';
        realEstateCollatCode.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCode;
        EB_Loan_Application__c testApp = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(testApp);
        LoanAppCollateralEditController sut = new LoanAppCollateralEditController(sc);
        sut.dropdownCollateralCodeId = realEstateCollatCode.Id;

        string returnVal = sut.getLoanDetailsLandRenderStatus();

        System.assertEquals('true', returnVal);
    }

    private static testMethod void it_should_return_false_if_collateral_id_is_not_in_real_estate_category_or_not_in_land_subcategory() {
        Collateral_Code__c realEstateCollatCodeNonLandSub = new Collateral_Code__c();
        realEstateCollatCodeNonLandSub.Category__c = 'Real Estate';
        realEstateCollatCodeNonLandSub.Subcategory__c = 'Other';
        realEstateCollatCodeNonLandSub.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCodeNonLandSub;
        Collateral_Code__c nonRealEstateCollatCode = new Collateral_Code__c();
        nonRealEstateCollatCode.Category__c = 'Other';
        nonRealEstateCollatCode.Subcategory__c = 'Other';
        nonRealEstateCollatCode.Collateral_Code_ID__c = 'OTH';
        insert nonRealEstateCollatCode;
        EB_Loan_Application__c testApp = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(testApp);
        LoanAppCollateralEditController sut = new LoanAppCollateralEditController(sc);

        sut.dropdownCollateralCodeId = realEstateCollatCodeNonLandSub.Id;
        string returnVal = sut.getLoanDetailsLandRenderStatus();

        System.assertEquals('false', returnVal, 'it_should_return_false_if_collateral_id_is_not_in_real_estate_category_or_not_in_land_subcategory: Loan Details Land Render not displaying per specifications when subcollateral is not land.');

        sut.dropdownCollateralCodeId = nonRealEstateCollatCode.Id;
        returnVal = sut.getLoanDetailsLandRenderStatus();

        System.assertEquals('false', returnVal, 'it_should_return_false_if_collateral_id_is_not_in_real_estate_category_or_not_in_land_subcategory: Loan Details Land Render not displaying per specifications when collateral is not real estate.');
    }

    private static testMethod void it_should_return_true_if_collateral_id_is_in_stock_subcategory() {
        Collateral_Code__c stockSubCollatCode = new Collateral_Code__c();
        stockSubCollatCode.Category__c = 'General';
        stockSubCollatCode.Subcategory__c = 'Stock';
        stockSubCollatCode.Collateral_Code_ID__c = 'GEN';
        insert stockSubCollatCode;
        EB_Loan_Application__c testApp = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(testApp);
        LoanAppCollateralEditController sut = new LoanAppCollateralEditController(sc);
        sut.dropdownCollateralCodeId = stockSubCollatCode.Id;

        string returnVal = sut.getLoanDetailsStockRenderStatus();

        System.assertEquals('true', returnVal);
    }

    private static testMethod void it_should_return_false_if_collateral_id_is_not_in_stock_subcategory() {
        Collateral_Code__c nonStockSubCollatCode = new Collateral_Code__c();
        nonStockSubCollatCode.Category__c = 'General';
        nonStockSubCollatCode.Subcategory__c = 'NotStock';
        nonStockSubCollatCode.Collateral_Code_ID__c = 'GEN';
        insert nonStockSubCollatCode;
        EB_Loan_Application__c testApp = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(testApp);
        LoanAppCollateralEditController sut = new LoanAppCollateralEditController(sc);
        sut.dropdownCollateralCodeId = nonStockSubCollatCode.Id;

        string returnVal = sut.getLoanDetailsStockRenderStatus();

        System.assertEquals('false', returnVal);
    }


    private static testMethod void it_should_return_1_if_prop_leased_by_borr_or_aff_is_empty_but_is_in_real_estate_and_not_land_or_const() {
        Collateral_Code__c realEstateCollatCodeOtherSub = new Collateral_Code__c();
        realEstateCollatCodeOtherSub.Category__c = 'Real Estate';
        realEstateCollatCodeOtherSub.Subcategory__c = 'Other';
        realEstateCollatCodeOtherSub.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCodeOtherSub;
        EB_Collateral__c sut = new EB_Collateral__c();
        sut.Name = 'MySUTCollateral';
        sut.Collateral_Code__c = realEstateCollatCodeOtherSub.Id;
        insert sut;

        sut = [SELECT Missing_Is_prop_leased_by_borr_or_affil__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(1, sut.Missing_Is_prop_leased_by_borr_or_affil__c);
    }

    private static testMethod void it_should_return_0_if_prop_leased_by_borr_or_aff_is_not_empty_or_collat_is_not_in_real_estate_or_in_land_or_const() {
        Collateral_Code__c realEstateCollatCodeOtherSub = new Collateral_Code__c();
        realEstateCollatCodeOtherSub.Category__c = 'Real Estate';
        realEstateCollatCodeOtherSub.Subcategory__c = 'Other';
        realEstateCollatCodeOtherSub.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCodeOtherSub;
        Collateral_Code__c realEstateCollatCodeLandSub = new Collateral_Code__c();
        realEstateCollatCodeLandSub.Category__c = 'Real Estate';
        realEstateCollatCodeLandSub.Subcategory__c = 'Land';
        realEstateCollatCodeLandSub.Collateral_Code_ID__c = 'LND';
        insert realEstateCollatCodeLandSub;
        Collateral_Code__c realEstateCollatCodeConstSub = new Collateral_Code__c();
        realEstateCollatCodeConstSub.Category__c = 'Real Estate';
        realEstateCollatCodeConstSub.Subcategory__c = 'Construction';
        realEstateCollatCodeConstSub.Collateral_Code_ID__c = 'CON';
        insert realEstateCollatCodeConstSub;
        EB_Collateral__c sut = new EB_Collateral__c();
        sut.Name = 'MySUTCollateral';
        sut.Collateral_Code__c = realEstateCollatCodeOtherSub.Id;
        sut.Is_prop_leased_by_borr_or_an_affiliate__c = 'Yes';
        insert sut;

        sut = [SELECT Id, Collateral_Code__c, Missing_Is_prop_leased_by_borr_or_affil__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(0, sut.Missing_Is_prop_leased_by_borr_or_affil__c, 'Return did not meet specs when in Real Estate/Other and Is_prop_leased_by_borr_or_an_affiliate__c filled out');

        sut.Collateral_Code__c = realEstateCollatCodeLandSub.Id;
        sut.Is_prop_leased_by_borr_or_an_affiliate__c = '';
        update sut;

        sut = [SELECT Id, Collateral_Code__c, Missing_Is_prop_leased_by_borr_or_affil__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(0, sut.Missing_Is_prop_leased_by_borr_or_affil__c, 'Return did not meet specs when in Land subcategory');


        sut.Collateral_Code__c = realEstateCollatCodeConstSub.Id;
        sut.Is_prop_leased_by_borr_or_an_affiliate__c = '';
        update sut;

        sut = [SELECT Id, Collateral_Code__c, Missing_Is_prop_leased_by_borr_or_affil__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(0, sut.Missing_Is_prop_leased_by_borr_or_affil__c, 'Return did not meet specs when in Construction subcategory');
    }

    private static testMethod void it_should_return_1_if_prop_leased_by_borr_or_aff_is_yes_and_borr_ctrl_20_of_leas_is_empty() {
        Collateral_Code__c realEstateCollatCodeOtherSub = new Collateral_Code__c();
        realEstateCollatCodeOtherSub.Category__c = 'Real Estate';
        realEstateCollatCodeOtherSub.Subcategory__c = 'Other';
        realEstateCollatCodeOtherSub.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCodeOtherSub;
        EB_Collateral__c sut = new EB_Collateral__c();
        sut.Name = 'MySUTCollateral';
        sut.Collateral_Code__c = realEstateCollatCodeOtherSub.Id;
        sut.Is_prop_leased_by_borr_or_an_affiliate__c = 'Yes';
        insert sut;

        sut = [SELECT Id, Missing_Borr_control_20_of_leasing_ent__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(1, sut.Missing_Borr_control_20_of_leasing_ent__c);
    }

    private static testMethod void it_should_return_0_if_prop_leased_by_borr_or_aff_is_yes_and_borr_ctrl_20_of_leas_is_answered_or_if_prop_leased_by_borr_is_not_yes() {
        Collateral_Code__c realEstateCollatCodeOtherSub = new Collateral_Code__c();
        realEstateCollatCodeOtherSub.Category__c = 'Real Estate';
        realEstateCollatCodeOtherSub.Subcategory__c = 'Other';
        realEstateCollatCodeOtherSub.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCodeOtherSub;
        EB_Collateral__c sut = new EB_Collateral__c();
        sut.Name = 'MySUTCollateral';
        sut.Collateral_Code__c = realEstateCollatCodeOtherSub.Id;
        sut.Is_prop_leased_by_borr_or_an_affiliate__c = 'Yes';
        sut.Borr_control_20_of_leasing_entities__c = 'No';
        insert sut;

        sut = [SELECT Id, Is_prop_leased_by_borr_or_an_affiliate__c, Borr_control_20_of_leasing_entities__c, Missing_Borr_control_20_of_leasing_ent__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(0, sut.Missing_Borr_control_20_of_leasing_ent__c);

        sut.Is_prop_leased_by_borr_or_an_affiliate__c = 'No';
        sut.Borr_control_20_of_leasing_entities__c = '';
        update sut;

        sut = [SELECT Id, Missing_Borr_control_20_of_leasing_ent__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(0, sut.Missing_Borr_control_20_of_leasing_ent__c);
    }

    private static testMethod void it_should_return_1_if_borr_ctrl_20_of_leas_is_no_and_src_repymt_from_50_rental_is_empty() {
        Collateral_Code__c realEstateCollatCodeOtherSub = new Collateral_Code__c();
        realEstateCollatCodeOtherSub.Category__c = 'Real Estate';
        realEstateCollatCodeOtherSub.Subcategory__c = 'Other';
        realEstateCollatCodeOtherSub.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCodeOtherSub;
        EB_Collateral__c sut = new EB_Collateral__c();
        sut.Name = 'MySUTCollateral';
        sut.Collateral_Code__c = realEstateCollatCodeOtherSub.Id;
        sut.Borr_control_20_of_leasing_entities__c = 'No';
        insert sut;

        sut = [SELECT Id, Missing_Src_of_repymt_from_50_rental_inc__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(1, sut.Missing_Src_of_repymt_from_50_rental_inc__c);
    }

    private static testMethod void it_should_return_0_if_borr_ctrl_20_of_leas_is_no_and_src_repymt_from_50_rental_is_not_empty_or_if_borr_ctrl_20_of_leas_is_not_no() {
        Collateral_Code__c realEstateCollatCodeOtherSub = new Collateral_Code__c();
        realEstateCollatCodeOtherSub.Category__c = 'Real Estate';
        realEstateCollatCodeOtherSub.Subcategory__c = 'Other';
        realEstateCollatCodeOtherSub.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCodeOtherSub;
        EB_Collateral__c sut = new EB_Collateral__c();
        sut.Name = 'MySUTCollateral';
        sut.Collateral_Code__c = realEstateCollatCodeOtherSub.Id;
        sut.Borr_control_20_of_leasing_entities__c = 'No';
        sut.Src_of_repymt_from_50_rental_income__c = 'No';
        insert sut;

        sut = [SELECT Id, Borr_control_20_of_leasing_entities__c, Src_of_repymt_from_50_rental_income__c, Missing_Src_of_repymt_from_50_rental_inc__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(0, sut.Missing_Src_of_repymt_from_50_rental_inc__c);

        sut.Borr_control_20_of_leasing_entities__c = '';
        sut.Src_of_repymt_from_50_rental_income__c = '';
        update sut;

        sut = [SELECT Id, Missing_Src_of_repymt_from_50_rental_inc__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(0, sut.Missing_Src_of_repymt_from_50_rental_inc__c);
    }

    private static testMethod void it_should_return_1_if_subcat_is_land_and_can_be_used_as_farmland_is_empty() {
        Collateral_Code__c realEstateCollatCodeLandSub = new Collateral_Code__c();
        realEstateCollatCodeLandSub.Category__c = 'Real Estate';
        realEstateCollatCodeLandSub.Subcategory__c = 'Land';
        realEstateCollatCodeLandSub.Collateral_Code_ID__c = 'LND';
        insert realEstateCollatCodeLandSub;
        EB_Collateral__c sut = new EB_Collateral__c();
        sut.Name = 'MySUTCollateral';
        sut.Collateral_Code__c = realEstateCollatCodeLandSub.Id;
        insert sut;

        sut = [SELECT Missing_Can_land_be_used_as_farmland__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(1, sut.Missing_Can_land_be_used_as_farmland__c);
    }

    private static testMethod void it_should_return_0_if_subcat_is_land_and_can_be_used_as_farmland_is_not_empty_or_if_not_in_land_subcat() {
        Collateral_Code__c realEstateCollatCodeOtherSub = new Collateral_Code__c();
        realEstateCollatCodeOtherSub.Category__c = 'Real Estate';
        realEstateCollatCodeOtherSub.Subcategory__c = 'Other';
        realEstateCollatCodeOtherSub.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCodeOtherSub;
        Collateral_Code__c realEstateCollatCodeLandSub = new Collateral_Code__c();
        realEstateCollatCodeLandSub.Category__c = 'Real Estate';
        realEstateCollatCodeLandSub.Subcategory__c = 'Land';
        realEstateCollatCodeLandSub.Collateral_Code_ID__c = 'LND';
        insert realEstateCollatCodeLandSub;
        EB_Collateral__c sut = new EB_Collateral__c();
        sut.Name = 'MySUTCollateral';
        sut.Collateral_Code__c = realEstateCollatCodeLandSub.Id;
        sut.Can_land_be_used_as_farmland__c = 'No';
        insert sut;

        sut = [SELECT Id, Collateral_Code__c, Can_land_be_used_as_farmland__c, Missing_Can_land_be_used_as_farmland__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(0, sut.Missing_Can_land_be_used_as_farmland__c);

        sut.Collateral_Code__c = realEstateCollatCodeOtherSub.Id;
        sut.Can_land_be_used_as_farmland__c = '';
        update sut;
        sut = [SELECT Missing_Can_land_be_used_as_farmland__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(0, sut.Missing_Can_land_be_used_as_farmland__c);
    }


    private static testMethod void it_should_return_1_if_collat_subcategory_is_stock_and_is_publicly_traded_is_empty() {
        Collateral_Code__c realEstateCollatCodeStock = new Collateral_Code__c();
        realEstateCollatCodeStock.Category__c = 'Other';
        realEstateCollatCodeStock.Subcategory__c = 'Stock';
        realEstateCollatCodeStock.Collateral_Code_ID__c = 'STK';
        insert realEstateCollatCodeStock;
        EB_Collateral__c sut = new EB_Collateral__c();
        sut.Name = 'MySUTCollateral';
        sut.Collateral_Code__c = realEstateCollatCodeStock.Id;
        insert sut;

        sut = [SELECT Missing_Is_stock_publicly_traded__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(1, sut.Missing_Is_stock_publicly_traded__c);
    }

    private static testMethod void it_should_return_1_if_collat_subcategory_is_stock_and_is_publicly_traded_is_not_empty_or_collat_subcategory_is_not_stock() {
        Collateral_Code__c realEstateCollatCodeOtherSub = new Collateral_Code__c();
        realEstateCollatCodeOtherSub.Category__c = 'Real Estate';
        realEstateCollatCodeOtherSub.Subcategory__c = 'Other';
        realEstateCollatCodeOtherSub.Collateral_Code_ID__c = 'RET';
        insert realEstateCollatCodeOtherSub;
        Collateral_Code__c realEstateCollatCodeStock = new Collateral_Code__c();
        realEstateCollatCodeStock.Category__c = 'Other';
        realEstateCollatCodeStock.Subcategory__c = 'Stock';
        realEstateCollatCodeStock.Collateral_Code_ID__c = 'STK';
        insert realEstateCollatCodeStock;
        EB_Collateral__c sut = new EB_Collateral__c();
        sut.Name = 'MySUTCollateral';
        sut.Collateral_Code__c = realEstateCollatCodeStock.Id;
        sut.Is_stock_publicly_traded__c = 'No';
        insert sut;

        sut = [SELECT Id, Collateral_Code__c, Is_stock_publicly_traded__c, Missing_Is_stock_publicly_traded__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(0, sut.Missing_Is_stock_publicly_traded__c);

        sut.Collateral_Code__c = realEstateCollatCodeOtherSub.Id;
        sut.Is_stock_publicly_traded__c = '';
        update sut;
        sut = [SELECT Missing_Is_stock_publicly_traded__c FROM EB_Collateral__c WHERE Id =: sut.Id];

        System.assertEquals(0, sut.Missing_Is_stock_publicly_traded__c);
    }



}