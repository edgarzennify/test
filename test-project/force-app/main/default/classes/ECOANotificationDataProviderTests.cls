@IsTest
private class ECOANotificationDataProviderTests {

        private final static ECOANotificationDataProvider sut;

        static{
                sut = new ECOANotificationDataProvider();
        }

        private static testMethod void it_should_return_a_list_of_loan_that_are_ecoa_date_flaged() {
                Date startDate = Date.newInstance(2000,1,2);
                Date endDate = Date.newInstance(2000,2,3);
                Date flagDate = Date.newInstance(2000,2,3);
                Date printDate = Date.newInstance(2000,2,3);
                LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
                loan.ECOA_Date_Flagged__c = flagDate;
                loan.ECOA_Date_Printed__c = printDate;
                insert loan;

                List<LLC_BI__Loan__c> result = sut.getLoansForNotification(startDate, endDate);

                System.assertEquals(1, result.size());
                Object fillWithField = result[0].Id;
                fillWithField = result[0].Name;
                fillWithField = result[0].ECOA_Date_Flagged__c;
                fillWithField = result[0].ECOA_Date_Printed__c;
                fillWithField = result[0].LLC_BI__Product__c;
                fillWithField = result[0].LLC_BI__Product_Line__c;
                fillWithField = result[0].LLC_BI__Account__r.Name;
                fillWithField = result[0].LLC_BI__Account__c;
                fillWithField = result[0].ECOA_URL__c;
                fillWithField = result[0].LLC_BI__Product_Type__c;
        }

        private static testMethod void it_should_return_a_list_of_loan_apps_that_are_ecoa_date_flagged() {
                Date startDate = Date.newInstance(2000,1,2);
                Date endDate = Date.newInstance(2000,2,3);
                Date flagDate = Date.newInstance(2000,2,3);
                Date printDate = Date.newInstance(2000,2,3);
                TestUtilities.createLoanAppStages();                  
                Account entity = ObjectFactory.getValidEntity('TestEntity');
                EB_Account__c ebaccount = ObjectFactory.getEBAccount('loanaccount', '1234', entity);
                EB_Loan_Packet__c packet = ObjectFactory.getLoanPacket(entity);                  
                EB_Loan_Application__c loanapp = ObjectFactory.getLoanApplication(packet, ebAccount, '1234');
                loanapp.Account_Number_Assigned__c = '';
                loanapp.Business_Purpose__c = 'Yes';
                loanapp.ECOA_Date_Flagged__c = flagDate;
                loanapp.ECOA_Date_Printed__c = printDate;
                update loanapp;  

                List<EB_Loan_Application__c> result = sut.getLoanAppsForNotification(startDate, endDate);

                System.assertEquals(1, result.size());
                Object fillWithField = result[0].Id;
                fillWithField = result[0].Name;
                fillWithField = result[0].ECOA_Date_Flagged__c;
                fillWithField = result[0].ECOA_Date_Printed__c;
                fillWithField = result[0].Business_Purpose__c;
                fillWithField = result[0].EB_Loan_Packet__r.Lead_Entity__r.Name;
                fillWithField = result[0].EB_Loan_Packet__r.Lead_Entity__c;
                fillWithField = result[0].ECOA_Document_URL__c;
                fillWithField = result[0].Loan_Type__c;
        }

        private static testMethod void it_should_save_sobjects() {
                Date flagDate = Date.newInstance(2000,2,3);
                Date printDate = Date.newInstance(2000,2,3);
                LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
                insert loan;
                loan.ECOA_Date_Flagged__c = flagDate;
                loan.ECOA_Date_Printed__c = printDate;
                List<SObject> saves = new List<SObject>{loan};

                sut.save(saves);

                LLC_BI__Loan__c requeryLoan = [SELECT Id, ECOA_Date_Flagged__c, ECOA_Date_Printed__c FROM LLC_BI__Loan__c WHERE id =: loan.Id];
                System.assertEquals(flagDate, requeryLoan.ECOA_Date_Flagged__c);
                System.assertEquals(printDate, requeryLoan.ECOA_Date_Printed__c);
        }
}