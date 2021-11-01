public with sharing class LoanApplicationViewController {
    public EB_Loan_Application__c loan{get;set;}
    private EB_Loan_Application__c loanprivate{get;set;}
    Id AppId;
    String url = '';
    public String tester{get;set;}
  
    
    //Specific to Loan number generation
    public String HasGenerateNumberPermission{
        get{
            Profile p = [select name from Profile where id =: UserInfo.getProfileId()];
            //Put Permissionset SOQLs here.
            
            if(p.Name == 'System Administrator' || p.Name == 'Data Administrator') 
             return 'true';
          return 'false';
        }
        set;

    }
    public LoanApplicationViewController(EB_Loan_Application__c LoanApp){
          this.loan = LoanApp;
    }
    public LoanApplicationViewController(ApexPages.StandardController controller) {
           if(url == '') url = getServerUrl();
                    
            AppId = apexpages.currentpage().getparameters().get('id');
            loan = [SELECT Id, Name,NAICS_Code__c ,recordtypeid,Record_Type_Description__c , Purpose_of_Loan__c,Loan_Type_For_Number_Generation__c, Account_Number_Assigned__c  FROM EB_Loan_Application__c WHERE Id =:AppId];
           
    }
  
    //Related List Hide/Show for Mini modifications     
    public string RenderRelatedEntity{
        get{           
            if( IsSubstituteCollateral==true || IsSubordination==true || IsParticipation==true || IsRateFloor==true || IsCovenant==true  ) return 'false';           
            return 'true';
        }
    }
    
    public string RenderCollateral{
        get{
            
            if(IsSubordination==true || IsParticipation==true || IsRateFloor==true ||  IsChangeGuarantor==true   ) return 'false';
            return 'true';
        }
    }
    public string RenderRateStream{
        get{
            if(IsSubordination==true || IsParticipation==true ||  IsChangeGuarantor==true || IsSubstituteCollateral==true) return 'false';
            return 'true';
        }
    }
    public string RenderPaymentStream{
        get{
            if(IsSubordination==true || IsParticipation==true || IsRateFloor==true || IsChangeGuarantor==true || IsSubstituteCollateral==true) return 'false';
            return 'true';
        }
    }
    public string RenderParticipation{
        get{
            if(IsSubordination==true ||  IsRateFloor==true || IsChangeGuarantor==true || IsSubstituteCollateral==true ) return 'false';
            return 'true';
        }
    }
    public string RenderLoanFee{
        get{
            return 'true';
        }
    }
    public string RenderLoanAgreement{
        get{
            if(IsParticipation==true || IsRateFloor==true){
            	return 'false';
            }
            return 'true';
        }
    }
    //Modification - Subordination
    public boolean IsSubordination{
        get{
            if( RecordTypeLoanAppMap.get(loan.recordtypeid) == null) return false;
            if( RecordTypeLoanAppMap.get(loan.recordtypeid).name == 'Modification - Subordination' ) return true;
            
            return false;
        }
    }
    //Modification - Participation
    public boolean IsParticipation{
        get{
            if( RecordTypeLoanAppMap.get(loan.recordtypeid) == null) return false;
            if( RecordTypeLoanAppMap.get(loan.recordtypeid).name == 'Modification - Change Participation' ) return true;
            return false;
        }
    }
    //Modification - Change Guarantor
    public boolean IsChangeGuarantor{
        get{
            if( RecordTypeLoanAppMap.get(loan.recordtypeid) == null) return false;
            if( RecordTypeLoanAppMap.get(loan.recordtypeid).name == 'Modification - Change Guarantor' ) return true;
            return false;
        }
    }
    //Modification - Change Rate Floor
    public boolean IsRateFloor{
        get{
            if( RecordTypeLoanAppMap.get(loan.recordtypeid) == null) return false;
            if( RecordTypeLoanAppMap.get(loan.recordtypeid).name == 'Modification - Rate Floor' ) return true;
            return false;
        }
    }
    //Modification - Substitute Collateral
    public boolean IsSubstituteCollateral{
        get{
            if( RecordTypeLoanAppMap.get(loan.recordtypeid) == null) return false;
            if( RecordTypeLoanAppMap.get(loan.recordtypeid).name == 'Modification - Substitute Collateral' ) return true;
            return false;
        }
    }
     //Modification - Covenant
    public boolean IsCovenant{
        get{
            if( RecordTypeLoanAppMap.get(loan.recordtypeid) == null) return false;
            if( RecordTypeLoanAppMap.get(loan.recordtypeid).name == 'Modification - Covenant' ) return true;
            return false;
        }
    }
    //New - Guidance Line Advance
    public boolean IsNewGuidanceLineAdvance{
        get{
            if( RecordTypeLoanAppMap.get(loan.recordtypeid) == null) return false;
            if( RecordTypeLoanAppMap.get(loan.recordtypeid).name == utility.NewGuidanceLineAdvance() ) return true;
            return false;
        }
    }
    @TestVisible
    private Map<id,RecordType> RecordTypeLoanAppMap{
        get{
            if(RecordTypeLoanAppMap == null) 
            {                    
                RecordTypeLoanAppMap =  new Map<id,Recordtype>([SELECT Id, Name FROM RecordType WHERE SobjectType =: 'EB_Loan_Application__c']);
            }
            return RecordTypeLoanAppMap;
        }
        set;
    }
           
    public static void GenerateNumberFromId(Id LoanId){
        if(loanId != '' || loanId != null ){
            List<EB_Loan_Application__c> loanlist = [SELECT Id, Name,Record_Type_Description__c , Purpose_of_Loan__c,Loan_Type_For_Number_Generation__c, Account_Number_Assigned__c  FROM EB_Loan_Application__c WHERE Id =:LoanId];
            if(loanlist.size() > 0){
                EB_Loan_Application__c ln = loanlist.get(0);
                
                GenerateNumberHelper(ln);
            }
        }
    }

    public static void GenerateNumberHelper(EB_Loan_Application__c loan ){
        String RESTNoun = Loan.Loan_Type_For_Number_Generation__c;
        
        if(ValidateRequest(RESTNoun,loan)){
            loan.Account_Number_Assigned__c = GetNumber(RESTNoun);
            update loan;
        }
    }
    public static string GetNewLoanNumber(EB_Loan_Application__c loan ){
        String RESTNoun = Loan.Loan_Type_For_Number_Generation__c;
        
        if(ValidateRequest(RESTNoun,loan)){
            return GetNumber(RESTNoun);
        }
        return '';
    }
    public static boolean ValidateRequest(String RESTNoun,EB_Loan_Application__c loan){
        if(RESTNoun == ''  ) return false;
        if((loan.Account_Number_Assigned__c == '' || loan.Account_Number_Assigned__c == null) && loan.Record_Type_Description__c != null && (loan.Record_Type_Description__c =='New' || loan.Record_Type_Description__c==utility.NewGuidanceLineAdvance() ))
         {return true;}
                  
        return false;
        
    }
    public static String GetNumber(String RESTNoun){      
        AccountNumberGenerator generator = new AccountNumberGenerator();
        String response = generator.getNewAccountNumber(RESTNoun);
        return generator.generatedNumber;
    }
    private static String  getServerUrl(){           
        return Utility.getServerUrl() + '/';
    }

    public String HasPermissionToReadWriteAgreement{
        get{
                Profile pr = [select name from Profile where id =: UserInfo.getProfileId()];
                if(pr.Name == 'System Administrator' || pr.Name == 'Data Administrator') return 'true';
                List<PermissionSet> permissionsetList = [select id from PermissionSet where Label=:'Function - Agreement System Read/Write'];
                        if(permissionsetList.size()>0){
                                List<PermissionSetAssignment> permissionsetassignList  = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() and PermissionSetId = :permissionsetList.get(0).id];
                                return 'true';
                        }
          		return 'false';
        }

    }
    
}