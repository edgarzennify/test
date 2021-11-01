public class LMS_LoanMetricSubstage {
    
    public interface ILMS_SubstageCalculator{
        String calculateSubstage(LLC_BI__Loan__c loan);
    }

    public interface ILMS_SubstageCalculatorHelper{
        Boolean definitionMatchesLoanState(LLC_BI__Loan__c loan, LMS_Definition definition);
        Boolean definitionAndDetailsMatchLoanState(LLC_BI__Loan__c loan, LMS_Definition definition);
    }

    public interface ILMS_DataProvider {
        List<LMS_Definition> getDefinitions();
    }

    public interface ILMS_ConfigurationLoader {
        List<ISObjectField> buildSObjectFields(List<LMS_LoanMetricSubstage.LMS_Definition_Detail> details);
        List<DmField> buildDmFields(List<ISObjectField> fields);
        void loadDefinitionDetailDmFields(List<DmField> dmFields);
    }

    public interface ILMS_ConfigurationRepository {
        List<LMS_LoanMetricSubstage.LMS_Definition> getDefinitionsWithDetails();
        List<LMS_LoanMetricSubstage.LMS_Definition> getDefinitionsWithoutDetails();
    }

    public class LMS_Definition{
        public String Substage {get;set;}
        public String LoanStage {get;set;}
        public String LoanStatus {get;set;}
        public Boolean DetailsRequired {get;set;}
        public List<LMS_Definition_Detail> Details {get;set;}
    }

    public class LMS_Definition_Detail{
        public String FieldReference {get;set;}
        public String Operand {get;set;}
        public String Operator {get;set;}
    }
}