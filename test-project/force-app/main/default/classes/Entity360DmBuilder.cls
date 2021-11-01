public class Entity360DmBuilder implements Entity360.IEntity360DmBuilder
{      
    public List<DmEntity> buildDmEntities(List<Account> pms)
    {
        List<DmEntity> dms = new List<DmEntity>();
        for(Account pm : pms){
            dms.add(buildDmEntity(pm));
        }
        return dms;
    }

    private DmEntity buildDmEntity(Account pm)
    {
        DmEntity dm = new DmEntity();
        dm.id = pm.Id;
        dm.name = pm.Name;
        dm.parent = new DmEntity();
        dm.parent.id = pm.ParentId;
        dm.primaryRelationship = getParentRelationship(pm);
        dm.roe = pm.ROE__c != null ? pm.ROE__c / 100 : 0.0;
        dm.opportunities = new List<DmOpportunity>();
        if(pm.Opportunities != null){
            for(Opportunity pmOpp : pm.Opportunities){
                dm.opportunities.add(buildDmOpportunity(pmOpp));
            }
        }
        dm.ownedAccounts = new List<DmEbAccount>();
        if(pm.EB_Account_Relationships__r != null){
            for(EB_Account_Relationship__c pmRel : pm.EB_Account_Relationships__r ){
                if(pmRel.Relationship__c.toUpperCase().Contains('PRIMARY OWNER')){                   
                    dm.ownedAccounts.add(buildDmEbAccount(pmRel.EB_Account_Id__r));
                }
            }   
        }
        dm.treasuryServices = new List<DmTreasuryService>();
        if(pm.Treasury_Management_Details__r != null){
            for(Treasury_Management__c pmTmSvc : pm.Treasury_Management_Details__r){                
                dm.treasuryServices.add(buildDmTreasuryService(pmTmSvc));
            }
        }
        return dm;
    }
    
    private DmEntity getParentRelationship(Account pm)
    {
        DmEntity primaryRelationship = new DmEntity();
        if(pm.Primary_Relationship__c == null)
        {
            primaryRelationship.id = pm.Id;
            primaryRelationship.name = pm.Entity_Name__c;
        }
        else
        {
            primaryRelationship.id = pm.Primary_Relationship__c;
            primaryRelationship.name = pm.Primary_Relationship__r.Entity_Name__c;
        }
        return primaryRelationship;
    }

    private DmOpportunity buildDmOpportunity(Opportunity pm){
        DmOpportunity dm = new DmOpportunity();
        dm.id = pm.Id;
        dm.recordType = new DmRecordType();
        dm.recordType.description = pm.RecordType.Description;
        dm.type = pm.Type;
        dm.committedAmount = pm.Committed_Amount__c;
        dm.potentialDeposits = pm.Potential_Deposits__c;
        dm.potentialFeeIncome = pm.Potential_Fee_Income__c;
        dm.stageName = pm.StageName;
        dm.forecastCategoryName = pm.ForecastCategoryName;
        dm.probability = pm.Probability != null ? pm.Probability / 100 : 0.0;
        dm.products = pm.Products__c;
        return dm;
    }

    private DmEbAccount buildDmEbAccount(EB_Account__c pm){
        DmEbAccount dm = new DmEbAccount();
        dm.currentBalance = pm.Current_Balance__c;
        dm.coreCurrentBalance = pm.Core_Current_Balance__c;
        dm.averageBalance = pm.Average_Balance__c;
        dm.ytdBalance = pm.YTD_Balance__c;
        dm.accountFees = (pm.Application__c == 1) ? pm.Account_Fees_Fx__c : pm.Account_Fees__c;
        dm.application = Integer.valueOf(pm.Application__c);
        if(pm.Account_Type__c != null && pm.Account_Type__c.length() >= 2){
            dm.accountType = pm.Account_Type__c.left(2);
        }
        dm.employeeCurrentBalance = pm.Employee_Current_Balance__c;
        dm.employeeAccountFlag = pm.Employee_Account_Flag__c;
        dm.ytdContributionMargin = pm.YTD_Contribution_Margin__c;

        return dm;
    }

    private DmTreasuryService buildDmTreasuryService(Treasury_Management__c pm){
        DmTreasuryService dm = new DmTreasuryService();
        dm.id = pm.Id;
        dm.name = pm.Name;
        return dm;
    }
}