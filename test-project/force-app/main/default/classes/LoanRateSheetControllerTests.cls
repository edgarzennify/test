@IsTest
public  class LoanRateSheetControllerTests {
    private static testMethod void it_should_call_the_contructor(){
        MockDataProvider mockDataProvider = new MockDataProvider();
        
        LoanRateSheetController sut = new LoanRateSheetController(mockDataProvider);
               
    }
      
    private static testMethod void it_should_return_a_loacalized_date_as_string(){
    	MockDataProvider mockDataProvider = new MockDataProvider();
        LoanRateSheetController sut = new LoanRateSheetController(mockDataProvider);
        String currentYear = String.ValueOf(System.now().year());

        String localeDate = sut.LocalizedDate;
        
        system.assertEquals(true , localeDate.contains(currentYear));
    }
    
    private static testMethod void it_should_return_a_list_of_rates_that_is_approved_by_finance(){
    	MockDataProvider mockDataProvider = new MockDataProvider();
        Date dt = Date.newInstance(2014, 1, 3);
        Eb_Floating_Rate__c testRate1 = TestUtilities.getLoanIndexRates('Wall Street Journal Prime', 'Daily', dt, 3.2345);
        testRate1.Name = 'Wall Street Journal Prime';
        testRate1.Rate_Type__c = 'Approved By Finance';
        insert testRate1;
        mockDataProvider.getLoanIndexRates_Return = new List<Eb_Floating_Rate__c>{testRate1};
        
        LoanRateSheetController sut = new LoanRateSheetController(mockDataProvider);
         
        List<Eb_floating_rate__c> aRates = sut.ApprovedRates;
        
        system.assertEquals(1, aRates.size());
    }
    
    private static testMethod void it_should_return_a_list_of_rates_that_is_only_for_reference(){
    	MockDataProvider mockDataProvider = new MockDataProvider();
        Date dt = Date.newInstance(2014, 1, 3);
        Eb_Floating_Rate__c testRate1 = TestUtilities.getLoanIndexRates('Wall Street Journal Prime', 'Daily', dt, 3.2345);
        testRate1.Name = 'Wall Street Journal Prime';
        testRate1.Rate_Type__c = 'Reference Only';
        insert testRate1;
        mockDataProvider.getLoanIndexRates_Return = new List<Eb_Floating_Rate__c>{testRate1};
        LoanRateSheetController sut = new LoanRateSheetController(mockDataProvider);
        
        List<Eb_floating_rate__c> referenceRates = sut.ReferencedRates;
        
        system.assertEquals(1, referenceRates.size());
    }
    
    private static testMethod void it_should_call_the_default_contructor_intergration_test(){
        
        LoanRateSheetController sut = new LoanRateSheetController();
        
    }
    
    private class MockDataProvider implements LoanRateSheetController.ILoanRateSheetDataProvider{
        
        public Boolean getLoanIndexRates_Called{get; private set;}
        public List<Eb_Floating_Rate__c> getLoanIndexRates_Return{get; private set;}
        
 
        public List<Eb_Floating_Rate__c> getLoanIndexRates(){
            getLoanIndexRates_Called = true;
            return getLoanIndexRates_Return;
        }

    }
}