public with sharing class CreditRelationshipDmBuilder implements CreditRelationship.IDataModelBuilder{

        public DmCreditRelationship buildDmCreditRelationship(Credit_Relationship__c pm){
            DmCreditRelationship dm = new DmCreditRelationship();
            dm.id = pm.Id;
            dm.recordtype = new DmRecordType();
            dm.recordType.name = pm.RecordType.Name;
            dm.recordType.Id = pm.RecordType.Id;
            
            dm.archivedReports = new List<DmArchivedReport>();
            for(Archived_Report__c report : pm.Archived_Reports__r)
            {
                dm.archivedReports.add(buildDmArchiveReport(report));
            }


            dm.relatedEntities = new List<DmCreditRelationshipRelatedEntity>();
            for(Credit_Relationship_Related_Client__c pmRelClient : pm.Credit_Relationship_Related_Clients__r)
            {
                dm.relatedEntities.add(buildDmCreditRelationshipRelatedEntity(pmRelClient));
            }

            dm.notes = new List<DmCreditRelationshipNote>();
            for(Credit_Relationship_Note__c note : pm.Credit_Relationship_Notes__r)
            {
                dm.notes.add(buildDmCreditRelationshipNote(note));
            }

            dm.excludedAccounts = new List<DmCreditRelationshipExcludedAccount>();
            for(Credit_Relationship_Excluded_Account__c excludedEbAccount : pm.Credit_Relationship_Excluded_Accounts__r){
                dm.excludedAccounts.add(buildExcludedAccount(excludedEbAccount));
            }

            return dm;
        }
        
        public List<DmEbAccount> buildDmEbAccounts(List<EB_Account__c> pms){
            List<DmEbAccount> dmEbAccounts = new List<DmEbAccount>();
            for(EB_Account__c pm : pms)
            {
                dmEbAccounts.add(buildDmEbAccount(pm));
            }
            return dmEbAccounts;
        }

        public List<DmCreditRelationshipExcludedAccount> buildDmCreditRelationshipExcludedAccounts(List<Credit_Relationship_Excluded_Account__c> pms){
            List<DmCreditRelationshipExcludedAccount> dmExcludedAccounts = new List<DmCreditRelationshipExcludedAccount>();
            for(Credit_Relationship_Excluded_Account__c pm : pms)
            {
                dmExcludedAccounts.add(buildExcludedAccount(pm));
            }
            return dmExcludedAccounts;
        }
        public List<DmArchivedReport> buildDmArchivedReports(List<Archived_Report__c> pms){
            List<DmArchivedReport> dmReports = new List<DmArchivedReport>();
            for(Archived_Report__c pm : pms)
            {
                dmReports.add(buildDmArchiveReport(pm));
            }
            return dmReports;
        }

        public List<DmCreditRelationshipRelatedEntity> buildDmCreditRelationshipRelatedEntities(List<Credit_Relationship_Related_Client__c> pms){
            List<DmCreditRelationshipRelatedEntity> dmRelatedEntities = new List<DmCreditRelationshipRelatedEntity>();
            for(Credit_Relationship_Related_Client__c pm : pms)
            {
                dmRelatedEntities.add(buildDmCreditRelationshipRelatedEntity(pm));
            }

            return dmRelatedEntities;
        }

        public List<DmCreditRelationshipNote> buildDmCreditRelationshipNotes(List<Credit_Relationship_Note__c> pms){
            List<DmCreditRelationshipNote> dmNotes = new List<DmCreditRelationshipNote>();
            for(Credit_Relationship_Note__c pm : pms){

                dmNotes.add(buildDmCreditRelationshipNote(pm));
            }
            return dmNotes;
        }

        public List<DmEntity> buildDmEntities(List<Account> pms){
            List<DmEntity> dmAccounts = new List<DmEntity>();
            for(Account pm : pms){
                dmAccounts.add(buildDmEntity(pm));
            }
            return dmAccounts;
        }

        private DmArchivedReport buildDmArchiveReport(Archived_Report__c report)
        {
            DmArchivedReport dmReport = new DmArchivedReport();
            dmReport.id = report.Id;
            dmReport.name = report.Name;
            dmReport.url = report.Url__c;
            dmReport.creditRelationship = new DmCreditRelationship();
            dmReport.creditRelationship.Id = report.Credit_Relationship__c;
            dmReport.createdDate = report.CreatedDate;
            dmReport.createdBy = new DmUser();
            dmReport.createdBy.Id = report.OwnerId;
            dmReport.createdBy.Name = report.CreatedBy.Name;

            return dmReport;            
        }

        private DmCreditRelationshipRelatedEntity buildDmCreditRelationshipRelatedEntity(Credit_Relationship_Related_Client__c pmRelClient)
        {
            DmCreditRelationshipRelatedEntity dmRelEntity = new DmCreditRelationshipRelatedEntity();
            dmRelEntity.id = pmRelClient.Id;
            dmRelEntity.name = pmRelClient.Name;
            dmRelEntity.creditRelationship = new DmCreditRelationship();
            dmRelEntity.creditRelationship.id = pmRelClient.Credit_Relationship__c;
            if(pmRelClient.Related_Entity_del__r != null)
            {
                dmRelEntity.entity = buildDmEntity(pmRelClient.Related_Entity_del__r);
            }

            return dmRelEntity;
        }

        private DmCreditRelationshipNote buildDmCreditRelationshipNote(Credit_Relationship_Note__c pmNote)
        {
            DmCreditRelationshipNote dmNote = new DmCreditRelationshipNote();
            dmNote.id = pmNote.Id;
            dmNote.name = pmNote.Name;
            dmNote.recordType = new DmRecordType();
            dmNote.recordType.id = pmNote.RecordType.Id;
            dmNote.recordType.name = pmNote.RecordType.Name;
            dmNote.creditRelationship = new DmCreditRelationship();
            dmNote.creditRelationship.Id = pmNote.Credit_Relationship__c;
            dmNote.diary = pmNote.Diary__c;
            dmNote.SituationFlag = pmNote.Situation_Flag__c;
            dmNote.createdBy = new DmUser();
            dmNote.createdBy.Id = pmNote.OwnerId;
            dmNote.createdBy.Name = pmNote.CreatedBy.Name;
            dmNote.CreatedDate = pmNote.CreatedDate;

            return dmNote;
        }

        private DmCreditRelationshipExcludedAccount buildExcludedAccount(Credit_Relationship_Excluded_Account__c pmExcludedAccount)
        {
            DmCreditRelationshipExcludedAccount dmExcludedAccount = new DmCreditRelationshipExcludedAccount();
            dmExcludedAccount.id = pmExcludedAccount.id;
            dmExcludedAccount.creditRelationship = new DmCreditRelationship();
            dmExcludedAccount.creditRelationship.id = pmExcludedAccount.Credit_Relationship_Id__c;
            dmExcludedAccount.name = pmExcludedAccount.Name;
            if(pmExcludedAccount.EB_Account_Id__r != null)
            {
                dmExcludedAccount.ebAccount =  buildDmEbAccount(pmExcludedAccount.EB_Account_Id__r);
            }

            return dmExcludedAccount;
        }

        private DmEbAccount buildDmEbAccount(EB_Account__c pm)
        {

            DmEbAccount dm = new DmEbAccount();
            dm.id = pm.Id;
            dm.name = pm.Name;
            dm.application = Integer.valueOf(pm.Application__c);
            dm.accountNumber = pm.Account_Number__c;
            dm.accountLine1 = pm.Account_Line_1__c;
            dm.status = pm.Account_Status__c;
            dm.riskRating = pm.User_Code_1__c;
            dm.contributionMargin = pm.YTD_Contribution_Margin__c;
            dm.coreCurrentBalance = pm.Core_Current_Balance__c;
            dm.currentBalance = pm.Current_Balance__c;
            dm.currentCommitment = pm.Current_Commitment__c;
            dm.unadvancedLoanAmount = pm.Unadvanced_Loan_Amount__c;
            dm.primaryOwner = new DmEntity();
            dm.primaryOwner.name = pm.Primary_Owner_Id__r.Name;

            return dm;
        }

        private DmEntity buildDmEntity(Account pm){
            DmEntity dm = new DmEntity();
            dm.id = pm.Id;
            dm.name = pm.Name;
            dm.billingStreet = pm.billingStreet;
            dm.billingCity = pm.billingCity;
            dm.billingState = pm.billingState;
            dm.billingPostalCode = pm.billingPostalCode;

            return dm;
        }
    }