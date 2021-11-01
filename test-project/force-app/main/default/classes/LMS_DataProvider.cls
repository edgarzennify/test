public class LMS_DataProvider implements LMS_LoanMetricSubstage.ILMS_DataProvider {
    
    public List<LMS_LoanMetricSubstage.LMS_Definition> getDefinitions() {
            List<LMS_Definition__c> allDefinitions = [
                                                        SELECT 
                                                            LMS_Substage__r.Name
                                                            ,Loan_Stage__c
                                                            ,Loan_Status__c
                                                            ,Details_Required__c
                                                            ,(
                                                                SELECT
                                                                    Field_Reference__c
                                                                    ,Operand__c
                                                                    ,Operator__c
                                                                FROM
                                                                    LMS_Definition_Details__r
                                                            )
                                                        FROM
                                                            LMS_Definition__c
                                                        WHERE
                                                            IsActive__c = true
                                                        ORDER BY
                                                            LMS_Substage__r.Sort_Order__c ASC
                                                    ];
            List<LMS_LoanMetricSubstage.LMS_Definition> dmDefinitions = new List<LMS_LoanMetricSubstage.LMS_Definition>();
            for (LMS_Definition__c def : allDefinitions) {
                dmDefinitions.add(assembleDm(def));
            }
        return dmDefinitions;
    }

    private LMS_LoanMetricSubstage.LMS_Definition assembleDm(LMS_Definition__c def) {
        LMS_LoanMetricSubstage.LMS_Definition dm = buildDefinition(def);

        for (LMS_Definition_Detail__c d : def.LMS_Definition_Details__r) {
            dm.Details.add(buildDetail(d));
        }
        return dm;
    }

    private LMS_LoanMetricSubstage.LMS_Definition buildDefinition(LMS_Definition__c def) {
        LMS_LoanMetricSubstage.LMS_Definition dm = new LMS_LoanMetricSubstage.LMS_Definition();
        dm.Substage = def.LMS_Substage__r.Name;
        dm.LoanStage = def.Loan_Stage__c;
        dm.LoanStatus = def.Loan_Status__c;
        dm.DetailsRequired = def.Details_Required__c;
        dm.Details = new List<LMS_LoanMetricSubstage.LMS_Definition_Detail>();
        return dm;
    }

    private LMS_LoanMetricSubstage.LMS_Definition_Detail buildDetail(LMS_Definition_Detail__c d) {
        LMS_LoanMetricSubstage.LMS_Definition_Detail dmDetail = new LMS_LoanMetricSubstage.LMS_Definition_Detail();
        dmDetail.FieldReference = d.Field_Reference__c;
        dmDetail.Operand = d.Operand__c;
        dmDetail.Operator = d.Operator__c;
        return dmDetail;
    }
}