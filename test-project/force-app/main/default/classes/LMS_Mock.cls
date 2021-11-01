@IsTest
public class LMS_Mock {
    
    public class OfILMS_DataProvider extends ApexMoq implements LMS_LoanMetricSubstage.ILMS_DataProvider{
        public List<LMS_LoanMetricSubstage.LMS_Definition> getDefinitions(){
            return (List<LMS_LoanMetricSubstage.LMS_Definition>)handleMethodInvocation('getDefinitions');
        }
        public List<LMS_LoanMetricSubstage.LMS_Definition_Detail> getDefinitionDetails(){
            return (List<LMS_LoanMetricSubstage.LMS_Definition_Detail>)handleMethodInvocation('getDefinitionDetails');
        }
    }

    public class OfILMS_ConfigurationLoader extends ApexMoq implements LMS_LoanMetricSubstage.ILMS_ConfigurationLoader{
        public List<ISObjectField> buildSObjectFields(List<LMS_LoanMetricSubstage.LMS_Definition_Detail> details){
            return (List<ISObjectField>)handleMethodInvocation('buildSObjectFields', new List<Object>{details});
        }
        public List<DmField> buildDmFields(List<ISObjectField> fields){
            return (List<DmField>)handleMethodInvocation('buildDmFields', new List<Object>{fields});
        }
        public void loadDefinitionDetailDmFields(List<DmField> fields){
            handleMethodInvocation('loadDefinitionDetailDmFields', new List<Object>{fields});
        }
    }

    public class OfILMS_ConfigurationRepository extends ApexMoq implements LMS_LoanMetricSubstage.ILMS_ConfigurationRepository{
        public List<LMS_LoanMetricSubstage.LMS_Definition> getDefinitionsWithDetails(){
            return (List<LMS_LoanMetricSubstage.LMS_Definition>)handleMethodInvocation('getDefinitionsWithDetails');
        }
        public List<LMS_LoanMetricSubstage.LMS_Definition> getDefinitionsWithoutDetails(){
            return (List<LMS_LoanMetricSubstage.LMS_Definition>)handleMethodInvocation('getDefinitionsWithoutDetails');
        }
        public DmField getDmField(String fieldName){
            return (DmField)handleMethodInvocation('getDmField', new List<Object>{fieldName});
        }
    }

    public class OfLMS_SubstageCalculatorHelper extends ApexMoq implements LMS_LoanMetricSubstage.ILMS_SubstageCalculatorHelper{
        public Boolean definitionMatchesLoanState(LLC_BI__Loan__c loan, LMS_LoanMetricSubstage.LMS_Definition definition){
            return (Boolean)handleMethodInvocation('definitionMatchesLoanState', new List<Object>{loan,definition});
        }
        
        public Boolean definitionAndDetailsMatchLoanState(LLC_BI__Loan__c loan, LMS_LoanMetricSubstage.LMS_Definition definition){
            return (Boolean)handleMethodInvocation('definitionAndDetailsMatchLoanState', new List<Object>{loan,definition});
        }
    }
}