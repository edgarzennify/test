public  class LoanRateSheetController {
        
        public interface ILoanRateSheetDataProvider{
                List<Eb_Floating_Rate__c> getLoanIndexRates();
                
        }
        LoanRateSheetController.ILoanRateSheetDataProvider m_dataProvider;
        
        public string LocalizedDate{
        	get{
        		Datetime dt = System.now();
    			String currDate = dt.format('EEEE, MMMM d, yyyy');
    			return currDate;
        	}
        }
        
        public LoanRateSheetController(){
                m_dataProvider = new LoanRateSheetDataProvider();
        }
        
        public LoanRateSheetController(LoanRateSheetController.ILoanRateSheetDataProvider dataProvider){
                m_dataProvider = dataProvider;
        }
        
        public List<Eb_Floating_Rate__c> getLoanIndexRates(){
            return m_dataProvider.getLoanIndexRates();
        }
		
		public List<Eb_Floating_Rate__c> ApprovedRates{
			get{
				 List<Eb_Floating_Rate__c> Approved_Rates = new List<Eb_Floating_Rate__c>();
				 for(Eb_Floating_Rate__c rate :getLoanIndexRates()){
				 	if(rate.Rate_Type__c == 'Approved By Finance'){
				 		Approved_Rates.add(rate);
				 	}
				 }
				 return Approved_Rates;
			}
		}
		
		public List<Eb_Floating_Rate__c> ReferencedRates{
			get{
				List<Eb_Floating_Rate__c> Referenced_Rates = new List<Eb_Floating_Rate__c>();
				for(Eb_Floating_Rate__c rate :getLoanIndexRates()){
				 	if(rate.Rate_Type__c == 'Reference Only'){
				 		Referenced_Rates.add(rate);
				 	}
				 }
				 return Referenced_Rates;
			}
		}
		 
}