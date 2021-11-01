public class LoanRateSheetDataProvider implements LoanRateSheetController.ILoanRateSheetDataProvider {

    public List<EB_Floating_Rate__c> getLoanIndexRates(){
        return [
            SELECT 
                Id, 
                Name, 
                Floating_Rate__c, 
                Floating_Rate_Code__c, 
                Rate_Type__c, 
                Prior_Rate__c, 
                Rate_Change_Frequency__c, 
                Updated_On__c, 
                Website__c, 
                Is_Website_Available__c, 
                Sort_Order__c, 
                Effective_Date__c,
                Source__c
            FROM 
                Eb_Floating_Rate__c 
            WHERE 
                Rate_Type__c in ('Approved By Finance' , 'Reference Only') 
            ORDER BY  
                Rate_Type__c,
                Sort_Order__c,
                Name
        ];
    }
    
}