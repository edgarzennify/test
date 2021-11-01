@IsTest
public  class LoanRateSheetDataProviderTests {
    
    private static testMethod void it_should_get_index_rates(){
    	LoanRateSheetDataProvider sut = new LoanRateSheetDataProvider();
        Date dt = Date.newInstance(2014, 1, 3);
        Eb_Floating_Rate__c testRate1 = TestUtilities.getLoanIndexRates('Wall Street Journal Prime', 'Daily', dt, 3.2345);
        testRate1.Name = 'Wall Street Journal Prime';
        testRate1.Rate_Type__c = 'Approved By Finance';
        insert testRate1;
        
        List<Eb_Floating_rate__c> rates = sut.getLoanIndexRates();
        
        system.assertEquals('Wall Street Journal Prime', rates[0].Name);
    }
    
}