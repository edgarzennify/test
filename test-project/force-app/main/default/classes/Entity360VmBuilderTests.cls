@IsTest
private class Entity360VmBuilderTests {

    private static Entity360VmBuilder sut;
    private static MockOfIEntity360VmDisplayCalc mockDisplayCalcLoan;
    private static MockOfIEntity360VmDisplayCalc mockDisplayCalcDeposit;
    private static MockOfIEntity360VmDisplayCalc mockDisplayCalcCm;
    private static MockOfIEntity360VmDisplayCalc mockDisplayCalcRoe;

    static {
        mockDisplayCalcLoan = new MockOfIEntity360VmDisplayCalc();
        mockDisplayCalcDeposit = new MockOfIEntity360VmDisplayCalc();
        mockDisplayCalcCm = new MockOfIEntity360VmDisplayCalc();
        mockDisplayCalcRoe = new MockOfIEntity360VmDisplayCalc();

        mockDisplayCalcLoan.setup('GetSymbol').returns('LN');
        mockDisplayCalcLoan.setup('GetElementType', new List<object> { 10000.00, 4500.00 }).returns('active');
        mockDisplayCalcLoan.setup('GetDisplayValue', new List<object> {10000.00 }).returns('10K');
        mockDisplayCalcLoan.setup('GetDisplayValue', new List<object> {4500.00 }).returns('4.5K');
        mockDisplayCalcLoan.setup('GetDisplayPercent', new List<object> { .69 }).returns('70');
        mockDisplayCalcLoan.setup('GetDisplayPercent', new List<object> { .31 }).returns('30');
        mockDisplayCalcLoan.setup('CalculatePercent', new List<object> {  4500.00, 10000.00 }).returns(.31);
        mockDisplayCalcLoan.setup('GetDisplayPercent', new List<object> { .76 }).returns('80');

        mockDisplayCalcDeposit.setup('GetSymbol').returns('DP');
        mockDisplayCalcDeposit.setup('GetDisplayValue', new List<object> {10000.00 }).returns('10K');
        mockDisplayCalcDeposit.setup('GetDisplayValue', new List<object> {4500.00 }).returns('4.5K');
        mockDisplayCalcDeposit.setup('GetDisplayPercent', new List<object> { .69 }).returns('70');
        mockDisplayCalcDeposit.setup('GetDisplayPercent', new List<object> { .31 }).returns('30');
        mockDisplayCalcDeposit.setup('CalculatePercent', new List<object> {  4500.00, 10000.00 }).returns(.31);
        mockDisplayCalcDeposit.setup('GetDisplayPercent', new List<object> { .76 }).returns('80');

        List<Entity360.IEntity360VmDisplayCalc> mockCalcs = new List<Entity360.IEntity360VmDisplayCalc>{mockDisplayCalcLoan,mockDisplayCalcDeposit,mockDisplayCalcCm,mockDisplayCalcRoe};
        
        sut = new Entity360VmBuilder(mockCalcs);
    }

    @IsTest
    static void it_should_build_an_entity_vm_with_the_correct_top_level_info() {
        DmEntity dm = new DmEntity();
        dm.id = 'abc';
        dm.name = 'test entity';
        List<DmEntity> entityDms = new List<DmEntity>{dm};
        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);

        List<Entity360.EntityViewModel> result = sut.buildEntityVms(entityDms);

        Entity360.EntityViewModel vm = result[0];
        System.assertEquals(dm.id, vm.EntityId);
        System.assertEquals(dm.name, vm.EntityName);
    }

    @IsTest
    static void it_should_build_an_entity_vm_with_the_correct_loan_element_vm() {
        DmEntity entityDm = new DmEntity();
        DmProductOverview loanOverview = new DmProductOverview();
        loanOverview.type = Entity360.ElementType.LOAN;
        loanOverview.existingValue = 51234.48;
        loanOverview.opportunityValue = 23456.78;
        loanOverview.opportunityProbability = 0.634578;
        entityDm.productOverviews = new List<DmProductOverview> { loanOverview };

        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockDisplayCalcLoan.setup('GetElementType', new List<object> { loanOverview.existingValue, loanOverview.opportunityValue }).returns('type');
        mockDisplayCalcLoan.setup('GetDisplayValue', new List<object> { 51234.48 }).returns('51K');
        mockDisplayCalcLoan.setup('GetDisplayValue', new List<object> { 23456.78 }).returns('23K');
        mockDisplayCalcLoan.setup('CalculatePercent', new List<object> { 51234.48, 23456.78 }).returns(0.71);
        mockDisplayCalcLoan.setup('CalculatePercent', new List<object> { 23456.78, 51234.48 }).returns(0.29);
        mockDisplayCalcLoan.setup('GetDisplayPercent', new List<object> { 0.634578 }).returns('60');
        mockDisplayCalcLoan.setup('GetDisplayPercent', new List<object> { 0.71 }).returns('70');
        mockDisplayCalcLoan.setup('GetDisplayPercent', new List<object> { 0.29 }).returns('30');

        List<Entity360.EntityViewModel> result = sut.buildEntityVms(new List<DmEntity> { entityDm });

        Entity360.ElementViewModel ln = result[0].Elements[0];
        System.assertEquals('LN', ln.elementSymbol);
        System.assertEquals('type', ln.elementType);
        System.assertEquals('51K', ln.existingValue);
        System.assertEquals('70', ln.existingPercent);
        System.assertEquals('23K', ln.opportunityValue);
        System.assertEquals('30', ln.opportunityPercent);
        System.assertEquals('60', ln.opportunityProbability);
    }

    @IsTest
    static void it_should_build_an_entity_vm_with_the_correct_loan_element_vm_with_summary_fields() {
        DmEntity entityDm = new DmEntity();
        DmProductOverview loanOverview = new DmProductOverview();
        loanOverview.type = Entity360.ElementType.LOAN;
        loanOverview.existingValue = 10000.00;
        loanOverview.opportunityValue = 4500.00;
        loanOverview.opportunityProbability = 0.76;
        entityDm.productOverviews = new List<DmProductOverview> { loanOverview };

        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockDisplayCalcLoan.setup('GetElementSummary').returns('Loan');
        mockDisplayCalcLoan.setup('GetExistingSummary', new List<object> { 10000.00 }).returns('Loan Accounts (Prev Month Avg Bal): 10K');
        mockDisplayCalcLoan.setup('GetOpportunitySummary', new List<object> { 4500.00, 0.76 }).returns('Loan Opportunities: 4.5K / 80% weighted probability');

        List<Entity360.EntityViewModel> result = sut.buildEntityVms(new List<DmEntity> { entityDm });

        Entity360.ElementViewModel ln = result[0].Elements[0];
        System.assertEquals('Loan', ln.elementSummary);
        System.assertEquals('Loan Accounts (Prev Month Avg Bal): 10K', ln.existingSummary);
        System.assertEquals('Loan Opportunities: 4.5K / 80% weighted probability', ln.opportunitySummary);
    }

    @IsTest
    static void it_should_build_an_entity_vm_with_the_correct_deposit_element_vm() {
        DmEntity entityDm = new DmEntity();
        DmProductOverview depositOverview = new DmProductOverview();
        depositOverview.type = Entity360.ElementType.DEPOSIT;
        depositOverview.existingValue = 51234.48;
        depositOverview.opportunityValue = 23456.78;
        depositOverview.opportunityProbability = 0.634578;
        entityDm.productOverviews = new List<DmProductOverview> { depositOverview };

        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcDeposit.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockDisplayCalcDeposit.setup('GetElementType', new List<object> { depositOverview.existingValue, depositOverview.opportunityValue }).returns('type');
        mockDisplayCalcDeposit.setup('GetDisplayValue', new List<object> { 51234.48 }).returns('51K');
        mockDisplayCalcDeposit.setup('GetDisplayValue', new List<object> { 23456.78 }).returns('23K');
        mockDisplayCalcDeposit.setup('CalculatePercent', new List<object> { 51234.48, 23456.78 }).returns(0.71);
        mockDisplayCalcDeposit.setup('CalculatePercent', new List<object> { 23456.78, 51234.48 }).returns(0.29);
        mockDisplayCalcDeposit.setup('GetDisplayPercent', new List<object> { 0.634578 }).returns('60');
        mockDisplayCalcDeposit.setup('GetDisplayPercent', new List<object> { 0.71 }).returns('70');
        mockDisplayCalcDeposit.setup('GetDisplayPercent', new List<object> { 0.29 }).returns('30');

        List<Entity360.EntityViewModel> result = sut.buildEntityVms(new List<DmEntity> { entityDm });

        Entity360.ElementViewModel dp = result[0].Elements[0];
        System.assertEquals('DP', dp.elementSymbol);
        System.assertEquals('type', dp.elementType);
        System.assertEquals('51K', dp.existingValue);
        System.assertEquals('70', dp.existingPercent);
        System.assertEquals('23K', dp.opportunityValue);
        System.assertEquals('30', dp.opportunityPercent);
        System.assertEquals('60', dp.opportunityProbability);
    }

    @IsTest
    static void it_should_build_an_entity_vm_with_the_correct_deposit_element_vm_with_summary_fields() {
        DmEntity entityDm = new DmEntity();
        DmProductOverview depositOverview = new DmProductOverview();
        depositOverview.type = Entity360.ElementType.DEPOSIT;
        depositOverview.existingValue = 10000.00;
        depositOverview.opportunityValue = 4500.00;
        depositOverview.opportunityProbability = 0.76;
        entityDm.productOverviews = new List<DmProductOverview> { depositOverview };

        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcDeposit.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockDisplayCalcDeposit.setup('GetElementSummary').returns('Deposit');
        mockDisplayCalcDeposit.setup('GetExistingSummary', new List<object> { 10000.00 }).returns('Deposit Accounts (Prev Month Avg Bal): 10K');
        mockDisplayCalcDeposit.setup('GetOpportunitySummary', new List<object> { 4500.00, 0.76 }).returns('Deposit Opportunities: 4.5K / 80% weighted probability');

        List<Entity360.EntityViewModel> result = sut.buildEntityVms(new List<DmEntity> { entityDm });

        Entity360.ElementViewModel dp = result[0].Elements[0];
        System.assertEquals('Deposit', dp.elementSummary);
        System.assertEquals('Deposit Accounts (Prev Month Avg Bal): 10K', dp.existingSummary);
        System.assertEquals('Deposit Opportunities: 4.5K / 80% weighted probability', dp.opportunitySummary);
    }

   
    @IsTest
    static void it_should_build_an_entity_vm_with_the_correct_cm_element_vm() {
        DmEntity entityDm = new DmEntity();
        entityDm.cm = 32715.18;
        entityDm.roe = 15.1;

        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcDeposit.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcCm.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockDisplayCalcCm.setup('GetSymbol').returns('CM');
        mockDisplayCalcCm.setup('GetDisplayValue', new List<object> { 32715.18 }).returns('$32,715');

        List<Entity360.EntityViewModel> result = sut.buildEntityVms(new List<DmEntity> { entityDm });

        Entity360.ElementViewModel cm = result[0].Elements[0];
        System.assertEquals('CM', cm.elementSymbol);
        System.assertEquals('cm', cm.elementType);
        System.assertEquals('$32,715', cm.existingValue);
        System.assertEquals('100', cm.existingPercent);
        System.assertEquals('0', cm.opportunityValue);
        System.assertEquals('0', cm.opportunityPercent);
        System.assertEquals('0', cm.opportunityProbability);
    }
    
    @IsTest
    static void it_should_set_the_entity_primary_relationship_name_for_aggregate() {
        DmEntity primaryRelationship = new DmEntity();
        primaryRelationship.id = '00000000000b';
        primaryRelationship.name  = 'Bob';
        DmEntity dmEntity1 = new DmEntity();
        dmEntity1.roe=0.15;
        dmEntity1.cm = 0.0;     
        dmEntity1.primaryRelationship = primaryRelationship;
        dmEntity1.productOverviews = new List<DmProductOverview>();
        DmEntity dmEntity2 = new DmEntity();
        dmEntity2.primaryRelationship = primaryRelationship;
        dmEntity2.roe=0.15;
        dmEntity2.cm=0.0;
        dmEntity2.productOverviews = new List<DmProductOverview>();
        List<DmEntity> entities = new List<DmEntity>{dmEntity1,dmEntity2};

        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);

        Entity360.EntityViewModel result = sut.buildAggregateEntityVm(entities);
        
        system.assertEquals('Bob', result.EntityName);
        System.assertEquals('00000000000b', result.EntityId);
    }
    
    @IsTest
    static void it_should_call_the_vm_display_calc_for_aggregate_roe() {
        DmEntity dmEntity1 = new DmEntity();
        dmEntity1.roe=.15;
        dmEntity1.cm = 0.0;
        dmEntity1.primaryRelationship = new DmEntity();
        dmEntity1.productOverviews = new List<DmProductOverview>();
        DmEntity dmEntity2 = new DmEntity();
        dmEntity2.roe=.15;
        dmEntity2.cm=0.0;
        dmEntity2.primaryRelationship = new DmEntity();
        dmEntity2.productOverviews = new List<DmProductOverview>();
        List<DmEntity> entities = new List<DmEntity>{dmEntity1,dmEntity2};

        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcDeposit.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcCm.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcRoe.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockDisplayCalcRoe.setup('GetElementSummary').returns('Return on Equity (Previous Month)');
        mockDisplayCalcRoe.setup('GetDisplayValue', new List<object> { .15 }).returns('15%');

        Entity360.EntityViewModel result = sut.buildAggregateEntityVm(entities);

        mockDisplayCalcRoe.verify('GetDisplayValue', new List<object> { .15 }, Times.Once);
        System.assertEquals('15%', result.Elements[1].existingValue);
        System.assertEquals('Return on Equity (Previous Month)', result.Elements[1].existingSummary);
    }

    @IsTest
    static void it_should_call_the_vm_display_calc_for_aggregate_cm() {
        DmEntity dmEntity1 = new DmEntity();
        dmEntity1.roe=0.15;
        dmEntity1.cm=111.11;
        dmEntity1.productOverviews = new List<DmProductOverview>();
        dmEntity1.primaryRelationship = new DmEntity();
        DmEntity dmEntity2 = new DmEntity();
        dmEntity2.roe=0.15;
        dmEntity2.cm=222.22;
        dmEntity2.productOverviews = new List<DmProductOverview>();
        dmEntity2.primaryRelationship = new DmEntity();
        List<DmEntity> entities = new List<DmEntity>{dmEntity1,dmEntity2};

        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcDeposit.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcCm.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockDisplayCalcCm.setup('GetElementSummary').returns('Contribution Margin (YTD)');
        mockDisplayCalcCm.setup('GetDisplayValue', new List<object> { 333.33 }).returns('$333');

        Entity360.EntityViewModel result = sut.buildAggregateEntityVm(entities);

        mockDisplayCalcCm.verify('GetDisplayValue', new List<object> { 333.33 }, Times.Once);
        System.assertEquals('$333', result.Elements[0].existingValue);
        System.assertEquals('Contribution Margin (YTD)', result.Elements[0].existingSummary);
    }
    
    @IsTest
    static void it_should_call_the_vm_display_calc_for_aggregate_loan_with_proper_probability() {
        DmEntity dmEntity1 = new DmEntity();
        dmEntity1.productOverviews = new List<DmProductOverview>();
        DmProductOverview loanOverview = new DmProductOverview();
        loanOverview.type = Entity360.ElementType.LOAN;
        loanOverview.existingValue = 1000.00;
        loanOverview.opportunityValue = 500.00;
        loanOverview.opportunityProbability = .40;
        dmEntity1.productOverviews.Add(loanOverview);
        dmEntity1.roe=.15;
        dmEntity1.cm=111.11;
        dmEntity1.primaryRelationship = new DmEntity();

        DmEntity dmEntity2 = new DmEntity();
        dmEntity2.productOverviews = new List<DmProductOverview>();
        DmProductOverview loanOverview2 = new DmProductOverview();
        loanOverview2.type = Entity360.ElementType.LOAN;
        loanOverview2.existingValue = 9000.00;
        loanOverview2.opportunityValue = 4000.00;
        loanOverview2.opportunityProbability = .80;
        dmEntity2.productOverviews.Add(loanOverview2);
        dmEntity2.roe=.15;
        dmEntity2.cm=222.22;
        dmEntity2.primaryRelationship = new DmEntity();
        List<DmEntity> entities = new List<DmEntity>{dmEntity1,dmEntity2};

        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockDisplayCalcLoan.setup('GetElementSummary').returns('Loan');
        mockDisplayCalcLoan.setup('GetExistingSummary', new List<object> { 10000.00 }).returns('Loan Accounts (Prev Month Avg Bal): 10K');
        mockDisplayCalcLoan.setup('GetOpportunitySummary', new List<object> { 4500.00, 0.76 }).returns('Loan Opportunities: 4.5K / 80% weighted probability');
        mockDisplayCalcLoan.setup('GetElementSummary').returns('Loan');
        mockDisplayCalcLoan.setup('GetExistingSummary', new List<object> {10000.00 }).returns('Loan Accounts (Prev Month Avg Bal): 10K');
        mockDisplayCalcLoan.setup('GetOpportunitySummary', new List<object> { 4500.00, 0.76 }).returns('Loan Opportunities: 4.5K / 80% weighted probability');

        Entity360.EntityViewModel result = sut.buildAggregateEntityVm(entities);

        System.assertEquals('80',result.Elements[0].opportunityProbability);
        System.assertEquals('LN',result.Elements[0].elementSymbol);
        System.assertEquals('Loan',result.Elements[0].elementSummary);
        System.assertEquals('10K',result.Elements[0].existingValue);
        System.assertEquals('Loan Accounts (Prev Month Avg Bal): 10K',result.Elements[0].existingSummary);
        System.assertEquals('4.5K',result.Elements[0].opportunityValue);  
        System.assertEquals('Loan Opportunities: 4.5K / 80% weighted probability',result.Elements[0].opportunitySummary);
    }
    
    @IsTest
    static void it_should_call_the_vm_display_calc_for_aggregate_deposit() {
        DmEntity dmEntity1 = new DmEntity();
        dmEntity1.productOverviews = new List<DmProductOverview>();
        DmProductOverview depOverview1 = new DmProductOverview();
        depOverview1.type = Entity360.ElementType.DEPOSIT;
        depOverview1.existingValue = 1000.00;
        depOverview1.opportunityValue = 500.00;
        depOverview1.opportunityProbability = .40;
        dmEntity1.productOverviews.Add(depOverview1);
        dmEntity1.primaryRelationship = new DmEntity();
        dmEntity1.roe=.15;
        dmEntity1.cm=111.11;

        DmEntity dmEntity2 = new DmEntity();
        dmEntity2.productOverviews = new List<DmProductOverview>();
        DmProductOverview depOverview2 = new DmProductOverview();
        depOverview2.type = Entity360.ElementType.DEPOSIT;
        depOverview2.existingValue = 9000.00;
        depOverview2.opportunityValue = 4000.00;
        depOverview2.opportunityProbability = .80;
        dmEntity2.productOverviews.Add(depOverview2);
        dmEntity2.primaryRelationship = new DmEntity();
        dmEntity2.roe=.15;
        dmEntity2.cm=222.22;
        List<DmEntity> entities = new List<DmEntity>{dmEntity1,dmEntity2};

        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcDeposit.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockDisplayCalcDeposit.setup('GetElementSummary').returns('Deposit');
        mockDisplayCalcDeposit.setup('GetExistingSummary', new List<object> { 10000.00 }).returns('Deposit Accounts (Prev Mon Avg Bal): 10K');
        mockDisplayCalcDeposit.setup('GetOpportunitySummary', new List<object> { 4500.00, 0.76 }).returns('Deposit Opportunities: 4.5K / 80% weighted probability');

        Entity360.EntityViewModel result = sut.buildAggregateEntityVm(entities);

        System.assertEquals('80',result.Elements[0].opportunityProbability);
        System.assertEquals('DP',result.Elements[0].elementSymbol);
        System.assertEquals('Deposit',result.Elements[0].elementSummary);
        System.assertEquals('10K',result.Elements[0].existingValue);
        System.assertEquals('Deposit Accounts (Prev Mon Avg Bal): 10K',result.Elements[0].existingSummary);
        System.assertEquals('4.5K',result.Elements[0].opportunityValue);  
        System.assertEquals('Deposit Opportunities: 4.5K / 80% weighted probability',result.Elements[0].opportunitySummary);
    }

    @IsTest
    static void it_should_throw_an_exception_when_delegate_does_not_have_a_correcsponding_display() {
        DmEntity entityDm = new DmEntity();
        DmProductOverview TMOverview = new DmProductOverview();
        TMOverview.type = Entity360.ElementType.TREASURY;
        TMOverview.existingValue = 51234.48;
        TMOverview.opportunityValue = 23456.78;
        TMOverview.opportunityProbability = 0.634578;
        entityDm.productOverviews = new List<DmProductOverview> { TMOverview };
        List<DmEntity> entityDms = new List<DmEntity>();
        entityDms.add(entityDm);
        
        mockDisplayCalcLoan.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcDeposit.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcCm.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDisplayCalcRoe.setup('IsType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);

        Boolean hasException = false;
        try {
            List<Entity360.EntityViewModel> result = sut.buildEntityVms(entityDms);
        } catch (exception e) {
            hasException = true;
        }

        system.assertEquals(true, hasException);
    }

    public class MockOfIEntity360VmDisplayCalc extends ApexMoq implements Entity360.IEntity360VmDisplayCalc {
        public Boolean IsType(Entity360.ElementType type){
            return (Boolean)handleMethodInvocation('IsType', new List<Object>{type});
        }
        public String GetDisplayValue(Decimal rawAmount){
            return (String)handleMethodInvocation('GetDisplayValue', new List<Object>{rawAmount});
        }
        public String GetDisplayPercent(Decimal percentAsDecimal){
            return (String)handleMethodInvocation('GetDisplayPercent', new List<Object>{percentAsDecimal});
        }
        public Decimal CalculatePercent(Decimal thisPart, Decimal theRest){
            return (Decimal)handleMethodInvocation('CalculatePercent', new List<Object>{thisPart, theRest});
        }
        public String GetSymbol(){
            return (String)handleMethodInvocation('GetSymbol');
        }
        public String GetElementType(Decimal existingValue, Decimal opportunityValue){
            return (String)handleMethodInvocation('GetElementType', new List<Object>{existingValue, opportunityValue});
        }
        public String GetElementSummary(){
            return (String)handleMethodInvocation('GetElementSummary');
        }
        public String GetExistingSummary(Decimal existingValue){
            return (String)handleMethodInvocation('GetExistingSummary', new List<Object>{existingValue});
        }
        public String GetOpportunitySummary(Decimal opportunityValue, Decimal opportunityProbability){
            return (String)handleMethodInvocation('GetOpportunitySummary', new List<Object>{opportunityValue, opportunityProbability});
        }
    }
}