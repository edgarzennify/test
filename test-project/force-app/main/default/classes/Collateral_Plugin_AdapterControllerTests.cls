@IsTest
public class Collateral_Plugin_AdapterControllerTests {

    private static Collateral_Plugin_AdapterController sut;
    private final static PluginMock.ofICollateral_PluginDataProvider mockDataProvider;
    private final static Mock.ofIApexPages mockApexPages;
    private final static Collateral_Code__c testCollCode;
    private final static LLC_BI__Collateral__c testNcinoCollateral;
    private final static LLC_BI__Collateral_Type__c testNcinoCollCode;
    
    static{
        mockDataProvider = new PluginMock.ofICollateral_PluginDataProvider();
        mockApexPages = new Mock.ofIApexPages();        
        sut = new Collateral_Plugin_AdapterController(mockDataProvider, mockApexPages);
               
        testCollCode = ObjectFactory.getCollateralCode('CIA-Owner Occupied', '1234');
        mockDataProvider.setup('getCollateralCode', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testCollCode);

        testNcinoCollCode=ObjectFactory.getNcinoCollateralCode('CIA-Owner Occupied', '1234');               
       
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        collateral.LLC_BI__Collateral_Type__c = testNcinoCollCode.Id; 
        collateral.LLC_BI__Street_Address__c = 'nCinoStreet';
        collateral.LLC_BI__City__c = 'nCinoCity';
        collateral.LLC_BI__State__c = 'nCinoState';
        collateral.LLC_BI__Zip_Code__c = 'nCinoZip';
        insert collateral;
        
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        testEntity.EB_Client_Name__c='testOwner';
        update testEntity;
        
        LLC_BI__Account_Collateral__c testAcctColl1 = new LLC_BI__Account_Collateral__c();
        testAcctColl1.LLC_BI__Primary_Owner__c = true;
        testAcctColl1.LLC_BI__Collateral__c = collateral.Id; 
        testAcctColl1.LLC_BI__Account__c = testEntity.Id;
        insert testAcctColl1;
        
        testNcinoCollateral = [SELECT Id, Name, Actual_Advance_Rate__c, 
                                    LLC_BI__Collateral_Name__c, 
                                    LLC_BI__Collateral_Type__r.Name, 
                                    LLC_BI__Collateral_Type__r.LLC_BI__Collateral_Code__c,
                                    Modified_Collateral_Type__c,
                                    Modified_Collateral_Type__r.LLC_BI__Collateral_Code__c,
                                    Sync_Key__c,
                                    (SELECT Id, Name, LLC_BI__Primary_Owner__c, LLC_BI__Account__c
                                      FROM LLC_BI__Account_Collateral__r),               
                                    LLC_BI__Street_Address__c,
                                    LLC_BI__City__c,
                                    LLC_BI__State__c,
                                    LLC_BI__Zip_Code__c                
                                    FROM LLC_BI__Collateral__c WHERE Id =: collateral.Id LIMIT 1];       
    }
    
    @IsTest
    static void it_should_call_the_data_provider_when_getting_eb_coll_and_forwarding(){   
        List<EB_Collateral__c> testEbColls = new List<EB_Collateral__c>();
        EB_Collateral__c testEbColl = new EB_Collateral__c();
        testEbColl.Name='12345-20';
        testEbColl.Id = 'a0a180000000000';
        testEbColls.add(testEbColl);
        
        mockApexPages.setup('getParameter',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testNcinoCollateral.Id);
        mockDataProvider.setup('getNcinoCollateralById', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testNcinoCollateral);
        mockDataProvider.setup('getEbCollateralByNameOrKey', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testEbColls);
        mockDataProvider.setup('save', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testEbColl);
        
        PageReference result = sut.GetEbCollateralAndForwardToAppraisalOrder();      
        
        mockApexPages.verify('getParameter',ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        mockDataProvider.verify('getNcinoCollateralById', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        mockDataProvider.verify('getEbCollateralByNameOrKey', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);        
        mockDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        mockDataProvider.verify('getCollateralCode', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Twice);

        String expected = '/apex/AppraisalOrder?collateralId=' + testEbColl.Id + '&retURL=%2F' + testNcinoCollateral.Id + '&scontrolCaching=1&sfdc.override=1';
        System.assertEquals(expected, result.getUrl());
    }
    
    @IsTest
    static void it_should_forward_to_error_page_when_no_owner_in_collateral(){   
        LLC_BI__Collateral__c testNcinoCollNoOwner = new LLC_BI__Collateral__c();
        testNcinoCollNoOwner.LLC_BI__Collateral_Type__c =testNcinoCollCode.Id; 
        insert testNcinoCollNoOwner;
        
        mockDataProvider.setup('getNcinoCollateralById', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testNcinoCollNoOwner);
        mockApexPages.setup('getParameter',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testNcinoCollNoOwner.Id);
        
        PageReference result = sut.GetEbCollateralAndForwardToAppraisalOrder();      
      
        String expected = '/apex/Collateral_Plugin_No_Owner_Error';
        System.assertEquals(expected, result.getUrl());
    }
    
    @IsTest
    static void it_should_create_ebCollateral_with_all_appropriate_fields_when_no_matchingEbColl_found(){           
        EB_Collateral__c testProspectiveEbColl = new EB_Collateral__c();
        testProspectiveEbColl.Id = 'a0a180000000000';
        testProspectiveEbColl.Collateral_Code__c = 'a0118000000VyR0';
        testProspectiveEbColl.Core_Collateral_Code__c = 'a0118000000VyR0';    
        testProspectiveEbColl.Street__c = 'nCinoStreet';
        testProspectiveEbColl.City__c = 'nCinoCity';
        testProspectiveEbColl.State__c = 'nCinoState';
        testProspectiveEbColl.Zip_Code__c = 'nCinoZip';
        
        mockDataProvider.setup('getNcinoCollateralById', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testNcinoCollateral);     
        mockApexPages.setup('getParameter',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testNcinoCollateral.Id);
        mockDataProvider.setup('getEbCollateralByNameOrKey', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(null);
        mockDataProvider.setup('save', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testProspectiveEbColl);
        
        sut.GetEbCollateralAndForwardToAppraisalOrder();
        
        List<Object> arguments = (List<Object>)mockDataProvider.getArgumentsFromCall('save');

        EB_Collateral__c newEbColltoInsert = (EB_Collateral__c)arguments[0];
        System.AssertEquals(testNcinoCollateral.Name, newEbColltoInsert.Name);
        System.AssertEquals(testNcinoCollateral.Name, newEbColltoInsert.Collateral_Number__c);
        System.AssertEquals(testCollCode.Id, newEbColltoInsert.Core_Collateral_Code__c);
        System.AssertEquals(testCollCode.Id, newEbColltoInsert.Collateral_Code__c);
        System.AssertEquals('nCinoStreet', newEbColltoInsert.Street__c);
        System.AssertEquals('nCinoCity', newEbColltoInsert.City__c);
        System.AssertEquals('nCinoState', newEbColltoInsert.State__c);
        System.AssertEquals('nCinoZip', newEbColltoInsert.Zip_Code__c);
    }
    
    @IsTest
    static void it_should_update_ebCollateral_with_all_appropriate_fields_when_matchingEbColl_found(){     
        List<EB_Collateral__c> testExistingEbColls = new List<EB_Collateral__c>();
        EB_Collateral__c testExistingEbColl = new EB_Collateral__c();
        testExistingEbColl.Name='12345-20';
        testExistingEbColl.Collateral_Number__c='12345-20';
        testExistingEbColl.Key__c = '616-20-12345';
        testExistingEbColl.Id = 'a0a180000000000';
        testExistingEbColl.Collateral_Code__c = 'a0118000000VyR0';
        testExistingEbColl.Core_Collateral_Code__c = 'a0118000000VyR0';    
        testExistingEbColl.Street__c = 'nCinoStreet';
        testExistingEbColl.City__c = 'nCinoCity';
        testExistingEbColl.State__c = 'nCinoState';
        testExistingEbColl.Zip_Code__c = 'nCinoZip';    
        testExistingEbColls.add(testExistingEbColl);
        
        mockApexPages.setup('getParameter', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testNcinoCollateral.Id);
        mockDataProvider.setup('getNcinoCollateralById', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testNcinoCollateral);
        mockDataProvider.setup('getEbCollateralByNameOrKey', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testExistingEbColls);
        mockDataProvider.setup('save', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testExistingEbColl);
       
        sut.GetEbCollateralAndForwardToAppraisalOrder();
        
        List<Object> arguments = (List<Object>)mockDataProvider.getArgumentsFromCall('save');

        EB_Collateral__c ebCollToUpdate = (EB_Collateral__c)arguments[0];
        System.AssertEquals(testExistingEbColl.Name, ebCollToUpdate.Name);
        System.AssertEquals(testExistingEbColl.Name, ebCollToUpdate.Collateral_Number__c);
        System.AssertEquals(testCollCode.Id, ebCollToUpdate.Core_Collateral_Code__c);
        System.AssertEquals(testCollCode.Id, ebCollToUpdate.Collateral_Code__c);
        System.AssertEquals('nCinoStreet', ebCollToUpdate.Street__c);
        System.AssertEquals('nCinoCity', ebCollToUpdate.City__c);
        System.AssertEquals('nCinoState', ebCollToUpdate.State__c);
        System.AssertEquals('nCinoZip', ebCollToUpdate.Zip_Code__c);        
    } 

    @IsTest
    static void it_should_return_the_first_related_entity_for_collateral_primary_owner_when_no_entities_are_marked_as_primary_owner(){             
        LLC_BI__Collateral__c testNcinoCollateral2 = new LLC_BI__Collateral__c();
        testNcinoCollateral2.LLC_BI__Collateral_Type__c = testNcinoCollCode.Id; 
        insert testNcinoCollateral2;
        
        Account testEntity2 = ObjectFactory.getValidEntity('testEntity2');
        testEntity2.EB_Client_Name__c='testEbClientName';
        update testEntity2;
        
        LLC_BI__Account_Collateral__c testAcctColl2 = new LLC_BI__Account_Collateral__c();
        testAcctColl2.LLC_BI__Primary_Owner__c = false;
        testAcctColl2.LLC_BI__Collateral__c = testNcinoCollateral2.Id; 
        testAcctColl2.LLC_BI__Account__c = testEntity2.Id;
        insert testAcctColl2;
        
        List<LLC_BI__Collateral__c> testNcinoCollateralNoPrimaryOwner = [SELECT Id, Name, Actual_Advance_Rate__c, 
                                    LLC_BI__Collateral_Name__c, 
                                    LLC_BI__Collateral_Type__r.Name, 
                                    LLC_BI__Collateral_Type__r.LLC_BI__Collateral_Code__c, 
                                    Sync_Key__c,
                                    (SELECT Id, Name, LLC_BI__Primary_Owner__c, LLC_BI__Account__c
                                      FROM LLC_BI__Account_Collateral__r),
                                    LLC_BI__Street_Address__c,
                                    LLC_BI__City__c,
                                    LLC_BI__State__c,
                                    LLC_BI__Zip_Code__c                                 
                                    FROM LLC_BI__Collateral__c WHERE Id =: testNcinoCollateral2.Id LIMIT 1]; 

        mockApexPages.setup('getParameter',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testNcinoCollateral.Id);
        mockDataProvider.setup('getNcinoCollateralById', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testNcinoCollateralNoPrimaryOwner[0]);
        mockDataProvider.setup('getEbCollateralByNameOrKey', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(null);
        
        EB_Collateral__c testEbColl = new EB_Collateral__c();
        testEbColl.Id = 'a0a180000000000';
        mockDataProvider.setup('save', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testEbColl);

        sut.GetEbCollateralAndForwardToAppraisalOrder();

        List<Object> arguments = (List<Object>)mockDataProvider.getArgumentsFromCall('save');

        EB_Collateral__c newEbColltoInsert = (EB_Collateral__c)arguments[0];
        System.AssertEquals(testEntity2.Id, newEbColltoInsert.Collateral_Owner__c);
    } 

    @IsTest
    static void it_should_save_a_collateral_that_has_the_correct_types_when_the_type_is_being_modified(){
        Id coreCollateralCodeId = ObjectFactory.getFakeId(Collateral_Code__c.SObjectType, '1');
        Id modifiedCollateralCodeId = ObjectFactory.getFakeId(Collateral_Code__c.SObjectType, '2');
        Collateral_Code__c coreCollateralCode = new Collateral_Code__c(Id=coreCollateralCodeId);
        Collateral_Code__c modifiedCollateralCode = new Collateral_Code__c(Id=modifiedCollateralCodeId);
        LLC_BI__Collateral_Type__c coreType = new LLC_BI__Collateral_Type__c();
        LLC_BI__Collateral_Type__c modifiedType = new LLC_BI__Collateral_Type__c();
        coreType.LLC_BI__Collateral_Code__c = 'A';
        modifiedType.LLC_BI__Collateral_Code__c = 'B';
        testNcinoCollateral.LLC_BI__Collateral_Type__r = coreType;
        testNcinoCollateral.Modified_Collateral_Type__r = modifiedType;
        mockDataProvider.setup('getNcinoCollateralById', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(testNcinoCollateral);
        mockDataProvider.setup('getCollateralCode', new List<Object>{coreType.LLC_BI__Collateral_Code__c}).returns(coreCollateralCode);
        mockDataProvider.setup('getCollateralCode', new List<Object>{modifiedType.LLC_BI__Collateral_Code__c}).returns(modifiedCollateralCode);
       
        sut.GetEbCollateralAndForwardToAppraisalOrder();
        
        List<Object> arguments = (List<Object>) mockDataProvider.getArgumentsFromCall('save');
        EB_Collateral__c ebcoll = (EB_Collateral__c) arguments[0];
        System.AssertEquals(coreCollateralCode.Id, ebcoll.Core_Collateral_Code__c);
        System.AssertEquals(modifiedCollateralCode.Id, ebcoll.Collateral_Code__c);
    } 
 
    @IsTest
    static void code_coverage(){  
        sut = new Collateral_Plugin_AdapterController();
    }
}