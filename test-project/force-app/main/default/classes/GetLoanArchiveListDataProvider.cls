public class GetLoanArchiveListDataProvider{ //implements GetLoanArchiveListDataProvider.IGetLoanArchiveListDataProvider{

    public interface IGetLoanArchiveListDataProvider {
        void updateManualKPIDetails(integer NumberOfItems);  
        void fixWorkflowValidationIssueForEntityandCollateral(integer NumberOfItems);
        void PurgeOrphanCollateralClientRelationships(integer NumberOfItems);
        void WithdrawOldApprovedApps(integer NumberOfItems);
        void WithdrawOldDocumentationApps(integer NumberOfItems);  
    }
      
    @future
    public static void updateManualKPIDetails(integer NumberOfItems){
      //Get all the name and id form manual KPI
      List<Manual_KPIs__c> mList = [Select  id,Name  From Manual_KPIs__c ];       
      Map<String,Id> newMapManualKPI = new Map<String,Id>();
      for(Manual_KPIs__c m : mList){
          newMapManualKPI.put(m.name , m.id);
      }
      List<Manual_KPI_Detail__c> updateList = new List<Manual_KPI_Detail__c>();
      
      try{
          //find the manual kpi detail records that have empty lookup and update them.
          for(List<Manual_KPI_Detail__c> newList : [SELECT Id, Name,  KPI_Description_for_Trigger__c, Manual_KPI__c FROM Manual_KPI_Detail__c limit :NumberOfItems]){
            
              for(Manual_KPI_Detail__c k : newList){
                  if(k.KPI_Description_for_Trigger__c != '' || k.KPI_Description_for_Trigger__c != null) {
                      Id tmpKPImanualId = newMapManualKPI.get(k.KPI_Description_for_Trigger__c);
                      if(tmpKPImanualId != null) k.Manual_KPI__c = tmpKPImanualId;
                      updateList.add(k);
                  }
                  
              }
              update updateList;
          }
          
      }catch(exception ex){
          
      }
    }
      
    @future
    public static void fixWorkflowValidationIssueForEntityandCollateral(integer NumberOfItems){
      List<SObject> updateRelObjects = new List<SObject>();

      List<EB_Loan_App_Entity_Relationship__c> updateentRels = new List<EB_Loan_App_Entity_Relationship__c>();      
      List<EB_Loan_App_Collateral_Relationship__c> updatecolRels = new List<EB_Loan_App_Collateral_Relationship__c>();
         for(List<EB_Loan_App_Entity_Relationship__c> entrels : [Select Id, Has_Missing_required_Fields__c, Missing_Required_For_Approval_Fields__c, Missing_Required_For_Doc_Fields__c FROM EB_Loan_App_Entity_Relationship__c WHERE Has_Missing_required_Fields__c >: 0 and Missing_Required_For_Approval_Fields__c =: 0 and Missing_Required_For_Doc_Fields__c =: 0 limit :NumberOfItems]){
              for(EB_Loan_App_Entity_Relationship__c entrel : entrels){
                  entrel.Has_Missing_required_Fields__c = 0;
                  //updateentRels.add(entrel);
                  updateRelObjects.add(entrel);
              }
              
         }
         for(List<EB_Loan_App_Entity_Relationship__c> entrels : [Select Id, Has_Missing_required_Fields__c, Missing_Required_For_Approval_Fields__c, Missing_Required_For_Doc_Fields__c FROM EB_Loan_App_Entity_Relationship__c WHERE Has_Missing_required_Fields__c =: 0 and (Missing_Required_For_Approval_Fields__c >: 0 or Missing_Required_For_Doc_Fields__c >: 0) limit :NumberOfItems]){
              for(EB_Loan_App_Entity_Relationship__c entrel : entrels){
                  entrel.Has_Missing_required_Fields__c = entrel.Missing_Required_For_Approval_Fields__c + entrel.Missing_Required_For_Doc_Fields__c;
                  //updateentRels.add(entrel);
                  updateRelObjects.add(entrel);
              }
              
         }
         for(List<EB_Loan_App_Collateral_Relationship__c> colrels : [Select Id, Has_Missing_required_Fields__c, Missing_Required_Fields_For_Approval__c, Missing_Required_Fields_For_Doc__c FROM EB_Loan_App_Collateral_Relationship__c WHERE Has_Missing_required_Fields__c >: 0 and Missing_Required_Fields_For_Approval__c =: 0 and Missing_Required_Fields_For_Doc__c =: 0 limit :NumberOfItems]){
              for(EB_Loan_App_Collateral_Relationship__c colrel : colrels){
                  colrel.Has_Missing_required_Fields__c = 0;
                  //updatecolrels.add(colrel);
                  updateRelObjects.add(colrel);
              }
              
         }
         for(List<EB_Loan_App_Collateral_Relationship__c> colrels : [Select Id, Has_Missing_required_Fields__c, Missing_Required_Fields_For_Approval__c, Missing_Required_Fields_For_Doc__c FROM EB_Loan_App_Collateral_Relationship__c WHERE Has_Missing_required_Fields__c =: 0 and (Missing_Required_Fields_For_Approval__c >: 0 or Missing_Required_Fields_For_Doc__c >: 0) limit :NumberOfItems]){
              for(EB_Loan_App_Collateral_Relationship__c colrel : colrels){
                  colrel.Has_Missing_required_Fields__c = colrel.Missing_Required_Fields_For_Approval__c + colrel.Missing_Required_Fields_For_Doc__c;
                  updateRelObjects.add(colrel);
              }
              
         }

         if(updateRelObjects.size() > 0) update updateRelObjects;
         
    }
      
    @future
    public static void PurgeOrphanCollateralClientRelationships(integer NumberOfItems){
          List<EB_Collateral_Client_Relationship__c> purgeList = new List<EB_Collateral_Client_Relationship__c>();
          Map<id,EB_Collateral_Client_Relationship__c> purgeMap = new Map<id,EB_Collateral_Client_Relationship__c>();
          for(EB_Collateral_Client_Relationship__c cc : [SELECT id, Client_ID__c,EB_Collateral_ID__c FROM EB_Collateral_Client_Relationship__c WHERE EB_Collateral_ID__c =:null or Client_ID__c =:null limit :NumberOfItems]){
              if(purgeMap.containskey(cc.id) == false) purgeList.add(cc);
          }
          if(purgeList.size() > 0 ) delete purgeList;
    }
    
    @future
    public static void WithdrawOldApprovedApps(integer NumberOfItems){
        DateTime dtnow = System.Now();
        dtnow = dtnow.addDays(-135);
         WithdrawLoanApplicationProcess withdrawapp = new WithdrawLoanApplicationProcess();
         for( EB_Loan_Application__c app : [SELECT Id FROM EB_Loan_Application__c WHERE LastModifiedDate <: dtnow  and Application_Stage_Reportable__c=: 'Approved'  ORDER BY LastModifiedDate asc limit :NumberOfItems]){
             withdrawapp.withdraw(app.id);
         }
         
    }
    
    @future
    public static void WithdrawOldDocumentationApps(integer NumberOfItems){
        DateTime dtnow = System.Now();
        dtnow = dtnow.addDays(-45);
         WithdrawLoanApplicationProcess withdrawapp = new WithdrawLoanApplicationProcess();
         for( EB_Loan_Application__c app : [SELECT Id FROM EB_Loan_Application__c WHERE LastModifiedDate <: dtnow  and Application_Stage_Reportable__c =: 'Booking - Unassigned' ORDER BY  LastModifiedDate asc limit :NumberOfItems]){
             withdrawapp.withdraw(app.id);
         }
         
    }
    
}