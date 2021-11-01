@IsTest
private class LLCBI_LoanTriggerHandlerTests {

	private static LLCBI_LoanTriggerHandler sut;
	private static TriggerHandlerTester tester;
	private static MockOfILLCBI_LoanTriggerHandlerDataProvider mockDataProvider;
	private static MockofILMS_SubstageCalculator mockSubStageCalculator;
	private static Mock.ofIObjectActionLogService mockObjectActionLogSvc;
    private static Mock.ofIEventLogWriter mockEventWriter;
    private static MockofILLCBI_LoanTriggerHandlerHelper mockHelper;
    private static MockOfILoanDefaultAppFieldCalculator mockDefaultAppCalculator;
    private static MockOfClosingDisclosureFieldCalculator mockClosingDisclosureFieldCalculator;
    private static MockOfCheckbackDateFieldCalculator mockCheckbackDateFieldCalculator;
    private static MockOfHasRealEstateColFieldCalculator mockHasRealEstateColFieldCalculator;
    private static MockOfPolicyExceptionsFieldCalculator mockPolicyExceptionsFieldCalculator;
    private static MockOfMoreLoanObjectFactory mockMoreLoanObjectFactory;
    private static MockOfProductPackageObjectFactory mockProductPackageFactory;
	
    static {
		mockDataProvider = new MockOfILLCBI_LoanTriggerHandlerDataProvider();
		mockSubStageCalculator = new MockofILMS_SubstageCalculator();
		mockObjectActionLogSvc = new Mock.ofIObjectActionLogService();
        mockEventWriter = new Mock.ofIEventLogWriter();
        mockHelper = new MockofILLCBI_LoanTriggerHandlerHelper();
        mockDefaultAppCalculator = new MockOfILoanDefaultAppFieldCalculator();
        mockClosingDisclosureFieldCalculator = new MockOfClosingDisclosureFieldCalculator();
        mockCheckbackDateFieldCalculator = new MockOfCheckbackDateFieldCalculator();
        mockHasRealEstateColFieldCalculator = new MockOfHasRealEstateColFieldCalculator();
        mockPolicyExceptionsFieldCalculator = new MockOfPolicyExceptionsFieldCalculator();
        mockMoreLoanObjectFactory = new MockOfMoreLoanObjectFactory();
        mockProductPackageFactory = new MockOfProductPackageObjectFactory();
		sut = new LLCBI_LoanTriggerHandler(
            mockDataProvider
            ,mockSubStageCalculator
            ,mockObjectActionLogSvc
            ,mockEventWriter
            ,mockHelper
            ,mockDefaultAppCalculator
            ,mockClosingDisclosureFieldCalculator
            ,mockCheckbackDateFieldCalculator
            ,mockHasRealEstateColFieldCalculator
            ,mockPolicyExceptionsFieldCalculator
            ,mockMoreLoanObjectFactory
        	,mockProductPackageFactory);
        tester = new TriggerHandlerTester();
	}

    @IsTest
    static void it_should_call_field_calculator_dependencies_before_insert() {
		Id lnId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		Id lnId2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c(Id = lnId1);
        LLC_BI__Loan__c ln2 = new LLC_BI__Loan__c(Id = lnId2);
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{ln1, ln2};
		tester.triggerOld.add(ln1);
		tester.triggerOld.add(ln2);

        tester.beforeTriggerInsertSequence(sut);
        
        mockClosingDisclosureFieldCalculator.verify('calculate', new List<Object>{loans});
        mockCheckbackDateFieldCalculator.verify('calculate', new List<Object>{loans});
    }

    @IsTest
    static void it_should_call_field_calculator_dependencies_before_update() {
		Id id1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		Id id2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        LLC_BI__Loan__c oldLn1 = new LLC_BI__Loan__c(Id = id1);
        LLC_BI__Loan__c newLn1 = new LLC_BI__Loan__c(Id = id1);
        LLC_BI__Loan__c oldLn2 = new LLC_BI__Loan__c(Id = id2);
        LLC_BI__Loan__c newLn2 = new LLC_BI__Loan__c(Id = id2);
        List<LLC_BI__Loan__c> oldLoans = new List<LLC_BI__Loan__c>{oldLn1, oldLn2};
        Map<Id, LLC_BI__Loan__c> newLoans = new Map<Id, LLC_BI__Loan__c>();
        newLoans.put(Id1, newLn1);
        newLoans.put(Id2, newLn2);

		tester.triggerOld.add(oldLn1);
		tester.triggerOld.add(oldLn2);
		tester.triggerNew.add(newLn1);
		tester.triggerNew.add(newLn2);

        List<LLC_BI__Loan_Collateral2__c> pledges = new List<LLC_BI__Loan_Collateral2__c>();

		mockDataProvider.setup('getPledges', new List<Object>{newloans.values()}).returns(pledges);

        tester.beforeTriggerUpdateSequence(sut);
        
        mockClosingDisclosureFieldCalculator.verify('calculate', new List<Object>{newLoans.values()});
        mockCheckbackDateFieldCalculator.verify('calculate', new List<Object>{oldLoans, newLoans});
        mockHasRealEstateColFieldCalculator.verify('calculate', new List<Object>{newLoans.values(), pledges});
        mockPolicyExceptionsFieldCalculator.verify('calculate', new List<Object>{newLoans.values()});
    }

	@IsTest
    static void it_should_call_the_substage_calculator_and_update_the_substage_when_before_update_is_triggered() {
		Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		LLC_BI__Loan__c before = new LLC_BI__Loan__c(Id=loanId, Loan_Metric_Substage__c='new');
		LLC_BI__Loan__c after = new LLC_BI__Loan__c(Id=loanId, Loan_Metric_Substage__c='still_new');
		tester.triggerOld.add(before);
		tester.triggerNew.add(after);

        Id substageId = ObjectFactory.getFakeId(LMS_Substage__c.SObjectType, '1');
        LMS_Substage__c substage = new LMS_Substage__c();
        substage.Name = 'not_new';
        List<LMS_Substage__c> substages = new List<LMS_Substage__c>{substage};

        Id definitionId = ObjectFactory.getFakeId(LMS_Definition__c.SObjectType, '1');
        LMS_Definition__c definition = new LMS_Definition__c();
        List<LMS_Definition__c> definitions = new List<LMS_Definition__c>{definition};

        LMS_Definition_Detail__c detail = new LMS_Definition_Detail__c();
        List<LMS_Definition_Detail__c> details = new List<LMS_Definition_Detail__c>{detail};
        
		mockDataProvider.setup('getAllSubstageRecords').returns(substages);
		mockDataProvider.setup('getAllSubstageDefinitions').returns(definitions);
		mockDataProvider.setup('getAllDefinitionDetails').returns(details);
		mockSubStageCalculator.setup('calculateSubstage', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns('not_new');

		tester.beforeTriggerUpdateSequence(sut);

		System.assertEquals('not_new', after.Loan_Metric_Substage__c);
	}

	@IsTest
    static void it_should_call_the_substage_calculator_and_update_the_substage_when_before_insert_is_triggered() {
		Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		LLC_BI__Loan__c loan = new LLC_BI__Loan__c(Id=loanId, Loan_Metric_Substage__c='');
		tester.triggerOld.add(loan);

        Id substageId = ObjectFactory.getFakeId(LMS_Substage__c.SObjectType, '1');
        LMS_Substage__c substage = new LMS_Substage__c();
        substage.Name = 'not_new';
        List<LMS_Substage__c> substages = new List<LMS_Substage__c>{substage};

        Id definitionId = ObjectFactory.getFakeId(LMS_Definition__c.SObjectType, '1');
        LMS_Definition__c definition = new LMS_Definition__c();
        List<LMS_Definition__c> definitions = new List<LMS_Definition__c>{definition};

        LMS_Definition_Detail__c detail = new LMS_Definition_Detail__c();
        List<LMS_Definition_Detail__c> details = new List<LMS_Definition_Detail__c>{detail};
        
		mockDataProvider.setup('getAllSubstageRecords').returns(substages);
		mockDataProvider.setup('getAllSubstageDefinitions').returns(definitions);
		mockDataProvider.setup('getAllDefinitionDetails').returns(details);
		mockSubStageCalculator.setup('calculateSubstage', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns('not_new');

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals('not_new', loan.Loan_Metric_Substage__c);
	}

    @IsTest
    static void it_should_add_a_record_to_the_stage_log_when_the_stage_is_changing_on_insert() {
		Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		LLC_BI__Loan__c loan = new LLC_BI__Loan__c(Id=loanId, Loan_Metric_Substage__c='stage_2');
		tester.triggerNew.add(loan);

        mockObjectActionLogSvc.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        mockEventWriter.setup('createLog', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new EventLog__c());
        mockMoreLoanObjectFactory.setup('create', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<More_Loan__c>());
        
		tester.afterTriggerInsertSequence(sut);
        
        mockObjectActionLogSvc.verify('log', new List<Object>{'LLC_BI__Loan__c', String.valueOf(loan.Id), 'Stage Logging','stage_2'}, Times.Once);
		mockObjectActionLogSvc.verify('getCachedLogs', Times.Once);
	}

    @IsTest
    static void it_should_record_a_stage_log_when_the_stage_is_changing_bulkAfterUpdate() {
		Id loanId01 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		Id loanId02 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');

		LLC_BI__Loan__c oldLoan01 = new LLC_BI__Loan__c();
        oldLoan01.Id = loanId01;
        oldLoan01.Loan_Metric_Substage__c = 'test substage 01';

		LLC_BI__Loan__c oldLoan02 = new LLC_BI__Loan__c();
        oldLoan02.Id = loanId02;
        oldLoan02.Loan_Metric_Substage__c = 'substage did not change';

        LLC_BI__Loan__c newLoan01 = new LLC_BI__Loan__c();
        newLoan01.Id = loanId01;
        newLoan01.Loan_Metric_Substage__c = 'substage changed';

        LLC_BI__Loan__c newLoan02 = new LLC_BI__Loan__c();
        newLoan02.Id = loanId02;
        newLoan02.Loan_Metric_Substage__c = 'substage did not change';

        tester.triggerOld.add(oldLoan01);
        tester.triggerOld.add(oldLoan02);
        tester.triggerNew.add(newLoan01);
        tester.triggerNew.add(newLoan02);

        mockObjectActionLogSvc.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        
        tester.afterTriggerUpdateSequence(sut);
        
        mockObjectActionLogSvc.verify('log', new List<Object>{'LLC_BI__Loan__c', String.valueOf(newLoan01.Id), 'Stage Logging','substage changed'}, Times.Once);
        mockObjectActionLogSvc.verify('log', new List<Object>{'LLC_BI__Loan__c', String.valueOf(newLoan02.Id), 'Stage Logging','substage did not change'}, Times.Never);
    }

    @IsTest
    static void it_should_call_save_on_the_dataprovider_once_afterUpdate() {
        List<SObject> objs = new List<SObject>();        
        mockEventWriter.setup('createLog', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(objs);
        mockObjectActionLogSvc.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        
        tester.afterTriggerUpdateSequence(sut);
        
        mockDataProvider.verify('save', new List<Object>{objs}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_LoanDefaultAppFieldCalculator_when_given_loans_before_insert() {
        LLC_BI__Loan__c lnBooked = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1'),
            LLC_BI__Product__c = 'Credit Card',
            LLC_BI__Stage__c = 'Booked'
        );
        LLC_BI__Loan__c lnComplete = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2'),
            LLC_BI__Product__c = 'Credit Card',
            LLC_BI__Stage__c = 'Complete'
        );
		tester.triggerOld.add(lnBooked);
        tester.triggerOld.add(lnComplete);
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{lnBooked, lnComplete};
        
        tester.beforeTriggerInsertSequence(sut);
        
        mockDefaultAppCalculator.verify('calculate', new List<Object>{loans});
    }

    @IsTest
    static void it_should_call_the_LoanDefaultAppFieldCalculator_when_given_loans_before_update() {
        LLC_BI__Loan__c lnBooked = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1'),
            LLC_BI__Product__c = 'Credit Card',
            LLC_BI__Stage__c = 'Booked'
        );
        LLC_BI__Loan__c lnComplete = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2'),
            LLC_BI__Product__c = 'Credit Card',
            LLC_BI__Stage__c = 'Complete'
        );
		tester.triggerNew.add(lnBooked);
        tester.triggerNew.add(lnComplete);
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{lnBooked, lnComplete};
        
        tester.beforeTriggerUpdateSequence(sut);
        
        mockDefaultAppCalculator.verify('calculate', new List<Object>{loans});
    }
        
    @IsTest
    static void it_should_call_save_on_the_dataprovider_once_afterInsert() {
        List<SObject> objs = new List<SObject>();    

        mockEventWriter.setup('createLog', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(objs);
        mockObjectActionLogSvc.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        mockMoreLoanObjectFactory.setup('create', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<More_Loan__c>());
        //act
        tester.afterTriggerInsertSequence(sut);
        //assert
        mockDataProvider.verify('save', new List<Object>{objs}, Times.Once);
    }

    @IsTest
    static void it_should_record_eventLogs_afterInsert() {
        Id loanId01 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id loanId02 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
		LLC_BI__Loan__c ln01 = new LLC_BI__Loan__c(Id=loanId01, Loan_Metric_Substage__c='Substage Unknown');
		LLC_BI__Loan__c ln02 = new LLC_BI__Loan__c(Id=loanId02, Loan_Metric_Substage__c='test substage');
		tester.triggerNew.add(ln01);
		tester.triggerNew.add(ln02);

        mockObjectActionLogSvc.setup('getCachedLogs').returns(new List<SObject>());
        mockMoreLoanObjectFactory.setup('create', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<More_Loan__c>());
        //act
        tester.afterTriggerInsertSequence(sut);
        //verify
        mockEventWriter.verify('createLog', new List<Object>{'info', 'Loan Substage Calculator', String.valueOf(ln01), 'Unable to find Substage for given loan'}, Times.Once);
        mockEventWriter.verify('createLog', new List<Object>{'debug', 'Loan Substage Calculator', String.valueOf(ln02), 'Loan Trigger Handler Debugging'}, Times.Once);
    }

    @IsTest
    static void it_should_record_eventLogs_afterUpdate() {
        Id loanId01 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id loanId02 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
		LLC_BI__Loan__c ln01 = new LLC_BI__Loan__c(Id=loanId01, Loan_Metric_Substage__c='Substage Unknown');
		LLC_BI__Loan__c ln02 = new LLC_BI__Loan__c(Id=loanId02, Loan_Metric_Substage__c='test substage');
		tester.triggerNew.add(ln01);
		tester.triggerNew.add(ln02);

        mockObjectActionLogSvc.setup('getCachedLogs').returns(new List<SObject>());
        //act
        tester.afterTriggerUpdateSequence(sut);
        //verify
        mockEventWriter.verify('createLog', new List<Object>{'info', 'Loan Substage Calculator', String.valueOf(ln01), 'Unable to find Substage for given loan'}, Times.Once);
        mockEventWriter.verify('createLog', new List<Object>{'debug', 'Loan Substage Calculator', String.valueOf(ln02), 'Loan Trigger Handler Debugging'}, Times.Once);
    }

    @IsTest
    static void it_should_not_record_null_eventLog_records_when_save_called_on_dataprovider() {
        Id loanId01 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id loanId02 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        Id loanId03 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '3');
		LLC_BI__Loan__c ln01 = new LLC_BI__Loan__c(Id=loanId01, Loan_Metric_Substage__c='Substage Unknown');
		LLC_BI__Loan__c ln02 = new LLC_BI__Loan__c(Id=loanId02, Loan_Metric_Substage__c='test substage');
		LLC_BI__Loan__c ln03 = new LLC_BI__Loan__c(Id=loanId03, Loan_Metric_Substage__c='test substage');
		tester.triggerNew.add(ln01);
		tester.triggerNew.add(ln02);
		tester.triggerNew.add(ln03); 
        /////////mock items
        Id oalId01 = ObjectFactory.getFakeId(Object_Action_Log__c.SObjectType, '1');
        Object_Action_Log__c oal01 = new Object_Action_Log__c(Id=oalId01);
        List<Object_Action_Log__c> oals = new List<Object_Action_Log__c>{oal01};

        Id logId01 = ObjectFactory.getFakeId(EventLog__c.SObjectType, '1');
        Id logId03 = ObjectFactory.getFakeId(EventLog__c.SObjectType, '3');
        EventLog__c log01 = new EventLog__c(Id=logId01);
        EventLog__c log02 = null;
        EventLog__c log03 = new EventLog__c(Id=logId03);

        mockObjectActionLogSvc.setup('getCachedLogs').returns(oals);
        mockEventWriter.setupSequence('createLog', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(log01).returns(log02).returns(log03);
        //act
        tester.afterTriggerUpdateSequence(sut);
        //verify
        List<Object> arguments = mockDataProvider.getArgumentsFromCall('save');
        List<SObject> saves = (List<SObject>)arguments[0];
        System.assertEquals(3, saves.size());
        System.assertEquals(true, saves.contains(oal01));
        System.assertEquals(true, saves.contains(log01));
        System.assertEquals(true, saves.contains(log03));
    }
    @IsTest
    static void it_should_set_default_field_values_if_SBA_Paycheck_Protection_Program_niche_product() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Niche_Products_fx__c = 'SBA Paycheck Protection Program';
        List<SObject> sos = new List<SObject>{loan};
        sut.bulkBeforeInsert(sos);
        system.assertEquals('N/A - Internal', loan.Attorney_Docs__c);
        system.assertEquals('No', loan.Is_Loan_to_Gov_t_Related_Entity__c);
        system.assertEquals('No', loan.Is_Loan_to_Financial_Institution__c);
        system.assertEquals('Working Capital', loan.Use_of_Funds_Purpose__c);
        system.assertEquals('No', loan.Is_Repayment_Reliant_on_Ag_Income__c);
        system.assertEquals('No', loan.Financial_Institution_Accept_Deposits__c);
        system.assertEquals('N/A', loan.Policy_Exceptions__c);
        system.assertEquals('02', loan.LLC_BI__Risk_Grade__c);
        system.assertEquals('2 - Maintain', loan.Lending_Strategy__c);
        system.assertEquals(system.today(), loan.Application_Date__c);
        system.assertEquals(system.today() + 2, loan.Close_Date__c);
        system.assertEquals(system.today() + 2, loan.Provide_Documents_By__c);
        system.assertEquals(system.today() + 2, loan.Projected_Funding_Date__c);
        system.assertEquals(true, loan.Immediate_Funding__c);
        system.assertEquals('No', loan.Centralized_Disbursing__c);
        system.assertEquals('Fixed', loan.LLC_BI__Pricing_Basis__c);
        system.assertEquals('Installment', loan.LLC_BI__Payment_Type__c);
    }

    @IsTest
    static void it_should_save_condition_relationships_if_bulkAfterInsert_is_called_with_loans_that_are_takedowns_related_to_packages_with_conditions() {
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        Set<Id> packIds = new Set<Id>{packId};
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Structure_Hierarchy__c = 'Current Takedown';
        loan.LLC_BI__Product_Package__c = packId;
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<SObject> sos = new List<SObject>{loan};
        Conditions__c relatedCondition = new Conditions__c();
        relatedCondition.Id = ObjectFactory.getFakeId(Conditions__c.SObjectType, '1');
        relatedCondition.Funding_Condition__c = true;
        relatedCondition.Loan__c = loan.Id;
        relatedCondition.Product_Package__c = packId;
        relatedCondition.Status__c = 'New';
        List<Conditions__c> relatedConditions = new List<Conditions__c>{relatedCondition};
        Map<Id, List<Conditions__c>> conditionMap = new Map<Id, List<Conditions__c>>();
        conditionMap.put(packId, relatedConditions);
        Condition_Relationship__c condRel = new Condition_Relationship__c();
        condRel.Condition__c = relatedCondition.Id;
        condRel.Funding_Condition__c = relatedCondition.Funding_Condition__c;
        condRel.Loan__c = relatedCondition.Loan__c;
        condRel.Product_Package__c = relatedCondition.Product_Package__c;
        condRel.Status__c = relatedCondition.Status__c;
        List<SObject> objects = new List<SObject>{condRel};
            
        Id oalId01 = ObjectFactory.getFakeId(Object_Action_Log__c.SObjectType, '1');
        Object_Action_Log__c oal01 = new Object_Action_Log__c(Id=oalId01);
        List<Object_Action_Log__c> oals = new List<Object_Action_Log__c>{oal01};
        objects.addAll((List<SObject>)oals);
        mockObjectActionLogSvc.setup('getCachedLogs').returns(oals);
        mockHelper.setup('gatherPackageIds', new List<Object>{sos}).returns(packIds);
        mockDataProvider.setup('getAllRelatedConditions', new List<Object>{packIds}).returns(relatedConditions);
        mockHelper.setup('mapConditions', new List<Object>{relatedConditions}).returns(conditionMap);
        mockMoreLoanObjectFactory.setup('create', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<More_Loan__c>());
        
        sut.bulkAfterInsert(sos);
        
        mockDataProvider.verify('Save', new List<Object>{objects}, Times.Once);
    }

    @IsTest
    static void it_should_handle_updating_entities_with_annual_revenue_from_a_loan() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        LLC_BI__Loan__c beforeLoan = new LLC_BI__Loan__c();
        beforeLoan.Id = loanId;
        beforeLoan.LLC_BI__Account__c = entityId;
        beforeLoan.HasRealEstateCollateral__c = false;
        beforeLoan.LLC_BI__Default_App__c = 'please contact IT helpdesk';
        Account entity = new Account();
        entity.Id = entityId;
        List<Account> relatedEntities = new List<Account>{entity};
        List<Id> loanIdList = new List<Id>{loanId};
        Set<Id> entityIdSet = new Set<Id>{entityId};
        List<SObject> oldSos = new List<SObject>{beforeLoan};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(beforeLoan.Id, beforeLoan);
        mockHelper.setup('gatherEntityIds', new List<Object>{oldSos}).returns(entityIdSet);
        mockDataProvider.setup('gatherRelatedEntities', new List<Object>{entityIdSet}).returns(relatedEntities);
        mockHelper.setup('gatherEntitiesToUpdate', new List<Object>{oldSos, newSosMap, relatedEntities}).returns(relatedEntities);
        sut.bulkBeforeUpdate(oldSos, newSosMap);
        mockDataProvider.verify('save', new List<Object>{relatedEntities});
    }
    
    @IsTest
    static void it_should_call_the_more_loan_factory_dependency_to_build_more_loan_records_when_loans_are_inserted() {
        Id lnId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		Id lnId2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c(Id = lnId1);
        LLC_BI__Loan__c ln2 = new LLC_BI__Loan__c(Id = lnId2);
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{ln1, ln2};
		tester.triggerNew.add(ln1);
		tester.triggerNew.add(ln2);

        mockMoreLoanObjectFactory.setup('create', new List<Object>{loans}).returns(new List<More_Loan__c>());
        mockObjectActionLogSvc.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());

        tester.afterTriggerInsertSequence(sut);

        mockMoreLoanObjectFactory.verify('create', new List<Object>{loans});
    }

    @IsTest
    static void it_should_set_CRA_fields_when_bulkBeforeInsert_is_called_with_a_record_that_meets_the_criteria(){
        List<String> stateCodes = new List<String>{'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'LA',
            										'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 
            										'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'};
        List<Account> accts = buildEntities(stateCodes);
        Set<Id> acctIds = buildAcctIds(accts);
        List<SObject> sos = buildSosForPPP(accts);
        
        mockDataProvider.setup('gatherRelatedEntities', new List<Object>{acctIds}).returns(accts);
        sut.bulkBeforeInsert(sos);
        
        LLC_BI__Loan__c loan = (LLC_BI__Loan__c)sos[0];
        system.assertEquals(true, stateCodes.contains(loan.Use_of_Funds_State__c));
    }

    @IsTest
    static void it_should_not_set_CRA_fields_when_bulkBeforeInsert_is_called_with_a_record_that_does_not_meets_the_criteria(){
        List<String> stateCodes = new List<String>{'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'LA',
            										'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 
            										'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'};
                                        
        List<Account> accts = buildEntities(stateCodes);
        Set<Id> acctIds = buildAcctIds(accts);
        List<SObject> sos = buildSos(accts);
            
        mockDataProvider.setup('gatherRelatedEntities', new List<Object>{acctIds}).returns(accts);
        sut.bulkBeforeInsert(sos);
        LLC_BI__Loan__c loan = (LLC_BI__Loan__c)sos[0];
        system.assertEquals(null, loan.Use_of_Funds_State__c);
    }
    @isTest
    static void it_should_return_product_packages_for_updating_when_bulkAfterInsert_is_called_with_loans_that_need_the_package_updated(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<SObject> oldSos = new List<SObject>();
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Contains_Policy_Exceptions__c = true;
        List<LLC_BI__Product_Package__c> updatedPackages = new List<LLC_BI__Product_Package__c>{pack};
        List<SObject> savedObjects = new List<SObject>();
        savedObjects.addAll(updatedPackages);
        Id oalId01 = ObjectFactory.getFakeId(Object_Action_Log__c.SObjectType, '1');
        Object_Action_Log__c oal01 = new Object_Action_Log__c(Id=oalId01);
        List<Object_Action_Log__c> oals = new List<Object_Action_Log__c>{oal01};
        savedObjects.addAll(oals);

        mockObjectActionLogSvc.setup('getCachedLogs').returns(oals);
        mockProductPackageFactory.setup('updatePackages', new List<Object>{oldSos, newSosMap}).returns(updatedPackages);
        sut.bulkAfterUpdate(oldSos, newSosMap);
        mockProductPackageFactory.verify('updatePackages', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockDataProvider.verify('save', new List<Object>{savedObjects}, Times.Once);
    }

    private static List<Account> buildEntities(List<String> stateCodes){
        List<Account> returnList = new List<Account>();
        for(Integer i=0; i < stateCodes.size(); i++){
            Account a = new Account();
            a.Id = ObjectFactory.getFakeId(Account.SObjectType, String.valueOf(i));
            a.BillingState = stateCodes[i];
            returnList.add(a);
        }
        return returnList;
    }

    private static List<LLC_BI__Loan__c> buildSos(List<Account> accts){
        List<LLC_BI__Loan__c> returnList = new List<LLC_BI__Loan__c>();
        for(Account a : accts){
            LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
            loan.LLC_BI__Account__c = a.Id;
            loan.LLC_BI__Account__r = a;
            loan.Niche_Products_fx__c = 'N/A';
            loan.LLC_BI__isRenewal__c = false;
            loan.LLC_BI__Is_Modification__c = false;
            loan.Use_of_Funds_State__c = null;
            returnList.add(loan);
        }
        return returnList;
    }

    private static List<LLC_BI__Loan__c> buildSosForPPP(List<Account> accts){
        List<LLC_BI__Loan__c> returnList = new List<LLC_BI__Loan__c>();
        for(Account a : accts){
            LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
            loan.LLC_BI__Account__c = a.Id;
            loan.LLC_BI__Account__r = a;
            loan.Niche_Products_fx__c = 'SBA Paycheck Protection Program';
            loan.LLC_BI__isRenewal__c = false;
            loan.LLC_BI__Is_Modification__c = false;
            loan.Use_of_Funds_State__c = null;
            returnList.add(loan);
        }
        return returnList;
    }

    private static Set<id> buildAcctIds(List<Account> accts){
        Set<id> returnSet = new Set<Id>();
        for(Account a : accts){
            returnSet.add(a.Id);
        }
        return returnSet;
    }

    @IsTest
    static void code_coverage_instantiate_with_the_default_constructor() {
        LLCBI_LoanTriggerHandler xsut = new LLCBI_LoanTriggerHandler();
    }
    
	public class MockOfILLCBI_LoanTriggerHandlerDataProvider extends Mock.ofIDataProvider implements LLCBI_LoanTriggerHandler.ILLCBI_LoanTriggerHandlerDataProvider {
        public List<LLC_BI__Loan_Collateral2__c> getPledges(List<LLC_BI__Loan__c> loans) {
			return (List<LLC_BI__Loan_Collateral2__c>)handleMethodInvocation('getPledges', new List<Object>{loans});
		}
        public List<Conditions__c> getAllRelatedConditions(Set<Id> packageIds) {
            return (List<Conditions__c>)handleMethodInvocation('getAllRelatedConditions', new List<Object>{packageIds});
		}
        public List<Account> gatherRelatedEntities(Set<Id> entityIds) {
            return (List<Account>)handleMethodInvocation('gatherRelatedEntities', new List<Object>{entityIds});
		}
	}

	public class MockofILMS_SubstageCalculator extends ApexMoq implements LMS_LoanMetricSubstage.ILMS_SubstageCalculator {
        public String calculateSubstage(LLC_BI__Loan__c loan) {
			return (String)handleMethodInvocation('calculateSubstage', new List<Object>{loan});
		}
    }
    
    public class MockofILLCBI_LoanTriggerHandlerHelper extends ApexMoq implements LLCBI_LoanTriggerHandler.ILLCBI_LoanTriggerHandlerHelper {
        public Set<Id> gatherPackageIds(List<SObject> sos) {
			return (Set<Id>)handleMethodInvocation('gatherPackageIds', new List<Object>{sos});
		}
        public Map<Id, List<Conditions__c>> mapConditions(List<Conditions__c> allRelatedConditions) {
			return (Map<Id, List<Conditions__c>>)handleMethodInvocation('mapConditions', new List<Object>{allRelatedConditions});
		}
        public Set<Id> gatherEntityIds(List<SObject> sos) {
			return (Set<Id>)handleMethodInvocation('gatherEntityIds', new List<Object>{sos});
		}
        public Map<Id, Account> mapEntities(List<Account> relatedEntities) {
			return (Map<Id, Account>)handleMethodInvocation('mapEntities', new List<Object>{relatedEntities});
		}
        public List<Account> gatherEntitiesToUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap, List<Account> relatedEntities) {
			return (List<Account>)handleMethodInvocation('gatherEntitiesToUpdate', new List<Object>{oldSos, newSosMap, relatedEntities});
		}
        
    }

    public class MockOfILoanDefaultAppFieldCalculator extends ApexMoq implements LoanDefaultAppFieldCalculator.ILoanDefaultAppFieldCalculator {
        public void calculate(List<LLC_BI__Loan__c> loans) {
            handleMethodInvocation('calculate', new List<Object>{loans});
        }
        public void calculate(LLC_BI__Loan__c loan) {
            handleMethodInvocation('calculate', new List<Object>{loan});
        }
    }

    private class MockOfClosingDisclosureFieldCalculator extends ApexMoq implements ClosingDisclosureFieldCalculator.IClosingDisclosureFieldCalculator {
        public void calculate(List<LLC_BI__Loan__c> loans) {
            handleMethodInvocation('calculate', new List<Object>{loans});
        }
    }

    private class MockOfCheckbackDateFieldCalculator extends ApexMoq implements CheckbackDateFieldCalculator.ICheckbackDateFieldCalculator {
        public void calculate(List<LLC_BI__Loan__c> loans) {
            handleMethodInvocation('calculate', new List<Object>{loans});
        }
        public void calculate(List<LLC_BI__Loan__c> oldLoans, Map<Id, SObject> newLoans) {
            handleMethodInvocation('calculate', new List<Object>{oldLoans, newLoans});
        }
    }

    private class MockOfHasRealEstateColFieldCalculator extends ApexMoq implements HasRealEstateColFieldCalculator.IHasRealEstateColFieldCalculator {
        public void calculate(List<LLC_BI__Loan__c> loans, List<LLC_BI__Loan_Collateral2__c> pledges) {
            handleMethodInvocation('calculate', new List<Object>{loans, pledges});
        }
    }

    private class MockOfPolicyExceptionsFieldCalculator extends ApexMoq implements PolicyExceptionsFieldCalculator.IPolicyExceptionsFieldCalculator {
        public void calculate(List<LLC_BI__Loan__c> loans) {
            handleMethodInvocation('calculate', new List<Object>{loans});
        }
    }

    private class MockOfMoreLoanObjectFactory extends ApexMoq implements MoreLoanObjectFactory.IMoreLoanObjectFactory {
        public List<More_Loan__c> create(List<LLC_BI__Loan__c> loans) {
			return (List<More_Loan__c>)handleMethodInvocation('create', new List<Object>{loans}); 
		}
    }
    private class MockOfProductPackageObjectFactory extends ApexMoq implements LLCBI_ProductPackageObjectFactory.IProductPackageFactory {
        public List<LLC_BI__Product_Package__c> updatePackages(List<SObject> oldSos, Map<Id, SObject> newSosMap) {
			return (List<LLC_BI__Product_Package__c>)handleMethodInvocation('updatePackages', new List<Object>{oldSos, newSosMap}); 
		}
        public void updatePackageApprovers(List<SObject> oldSos, Map<Id, SObject> newSosMap) {
			handleMethodInvocation('updatePackageApprovers', new List<Object>{oldSos, newSosMap}); 
		}
        public void setGuidanceLineTakedownApproval(List<SObject> oldSos, Map<Id, SObject> newSosMap) {
			handleMethodInvocation('setGuidanceLineTakedownApproval', new List<Object>{oldSos, newSosMap}); 
		}
        public void setAllFacilitiesApproved(Map<Id, SObject> newSosMap) {
			handleMethodInvocation('setAllFacilitiesApproved', new List<Object>{newSosMap}); 
		}
        public List<Approval.ProcessSubmitRequest> gatherPackagesAndLoansThatNeedAutoApproval(List<SObject> oldSos, Map<Id, SObject> newSosMap) {
			return (List<Approval.ProcessSubmitRequest>)handleMethodInvocation('gatherPackagesAndLoansThatNeedAutoApproval', new List<Object>{oldSos, newSosMap}); 
		}
    }
}