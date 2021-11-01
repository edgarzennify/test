public  class LoanAppRenewalController {
 
    @TestVisible EB_Account__c EBAccount;
    EB_Loan_Application__c app;
    String url = '';
    List<RecordType> recordTypeList = null;
    Id LoanRecTypeId ;
    Id LoanPacket;
    Agreements.IAgreementLoanAppLink m_agreementLoanAppLink;
    
    private  static String  getServerUrl(){
            String serverurl = utility.getServerUrl() + '/' ;
            return serverurl; 
    }
   
    public LoanAppRenewalController(ApexPages.StandardController controller) {        
        if(url == '') url = getServerUrl();
        m_agreementLoanAppLink = new AgreementLoanAppLink(new AgreementLoanAppLinkDataProvider());
        initialize();       
    }
    
    public Map<id,RecordType> RenewalsAndModMapByIdKey{
        get{
            if(RenewalsAndModMapByIdKey == null){
                 RenewalsAndModMapByIdKey = new  Map<id,RecordType>();
                 for (RecordType r : utility.recordTypeObjects('EB_Loan_Application__c')){
                    if (r.name.tolowercase().contains('modification -') || r.name.tolowercase().contains('renewal')) RenewalsAndModMapByIdKey.put(r.id,r);              
                    system.debug('###' + r.name);
                 }
            }
            return RenewalsAndModMapByIdKey;
        }
        set;
   }
   
   public Map<id,RecordType> minimodMap{
        get{
            if(minimodMap == null){
                minimodMap = new Map<id,RecordType>();
                for(recordtype r : RenewalsAndModMapByIdKey.values()){
                    if (r.name.tolowercase().contains('modification -') && ! r.name.tolowercase().contains('modification - full'))
                    minimodMap.put(r.id,r);
                }
            }
            return minimodMap;
        }
        set;
   }
   
   public Map<id,RecordType> RenewalsAndModMapByIdKeyWithoutAdminRenewal{
        get{
            if(RenewalsAndModMapByIdKeyWithoutAdminRenewal == null){
                 RenewalsAndModMapByIdKeyWithoutAdminRenewal = new  Map<id,RecordType>();
                 for (RecordType r : RenewalsAndModMapByIdKey.values()){
                    if (r.name != 'Admin Renewal') RenewalsAndModMapByIdKeyWithoutAdminRenewal.put(r.id,r);             
                 }
            }
            return RenewalsAndModMapByIdKeyWithoutAdminRenewal;
        }
        set;
   } 
   
   public Map<String,RecordType> RenewalsAndModMapByNameKey{
        get{
            if(RenewalsAndModMapByNameKey == null){
                 RenewalsAndModMapByNameKey = new  Map<String,RecordType>();
                 for(RecordType r : RenewalsAndModMapByIdKey.values()){
                     RenewalsAndModMapByNameKey.put(r.name,r);
                 }
            }
            return RenewalsAndModMapByNameKey;
        }
        set;
   }
   @TestVisible
   private Boolean CheckExistingRenewalCount(){
        Integer RenewalCount = 0;
        Integer AdminRenewalCount = 0;
         
        Map<String, EB_Loan_App_Stage__c> stageMap = new  Map<String, EB_Loan_App_Stage__c>();
        for(EB_Loan_App_Stage__c stage : [Select Name, Id From EB_Loan_App_Stage__c WHERE Name =: 'Withdrawn' or Name =: 'Booking' or Name =: 'Archived']){
            stageMap.put(stage.Name , stage);
        }
        system.debug('##test1');
                
        RecordType recAdminRenewal = utility.RecordTypeObject('EB_Loan_Application__c','Admin Renewal');
         
        try{
	        for(EB_Loan_Application__c  l : [SELECT Id, Name  FROM EB_Loan_Application__c WHERE Account_Number__c =: EBAccount.Id and Application_Stage__c !=:  stageMap.get('Withdrawn').Id and Application_Stage__c !=:  stageMap.get('Booking').Id and Application_Stage__c !=:  stageMap.get('Archived').Id and RecordtypeId in : RenewalsAndModMapByIdKeyWithoutAdminRenewal.KeySet() ]){
	            RenewalCount = RenewalCount + 1;    
	        }
	        for(EB_Loan_Application__c l : [SELECT Id, Name  FROM EB_Loan_Application__c WHERE Account_Number__c =: EBAccount.Id and Application_Stage__c !=:  stageMap.get('Withdrawn').Id and Application_Stage__c !=:  stageMap.get('Booking').Id and Application_Stage__c !=:  stageMap.get('Archived').Id and recordtypeid =: recAdminRenewal.Id ]){
	            AdminRenewalCount = AdminRenewalCount + 1;
	        }
        }catch(exception ex){
        }
     
        system.debug('##test2');
        if(RenewalCount == 0 && RenewalsAndModMapByIdKeyWithoutAdminRenewal.containskey(LoanRecTypeId)){
            return false;
        }
        system.debug('##test3');
        RecordType loanRecType = RenewalsAndModMapByIdKey.get(LoanRecTypeId);
        if(AdminRenewalCount == 0 && RenewalCount < 2 && (loanRecType <> null && loanRecType.Name == 'Admin Renewal')){
            return false;
        }
         
        return true;
   }
   
   //public Id getParam{set;get;}
   @TestVisible
   private void initialize(){
         try{
            ///// EB Account Id
            Id EBAccountId = apexpages.currentpage().getparameters().get('id');
            /////Retrive type of Renewal.
            LoanRecTypeId = apexpages.currentpage().getparameters().get('t');
            try{
            this.LoanPacket = apexpages.currentpage().getparameters().get('p');
            }catch(exception ex){
                this.LoanPacket = null;
            }

            if (LoanRecTypeId == null) return;
            
            for(EB_Account__c a : [SELECT Id, Loss_Share__c, Account_Status__c, Interest_Rate__c ,
                                    EB_Account_Type__c, Revolve_Code__c, Interest_Rate_Type_Description__c, 
                                    Account_Industry_Code__c, Application__c, Rate_Subject_to_Change__c,  
                                    Interest_Rate_Ceiling__c, Interest_Rate_Floor__c, Interest_Rate_Variance__c, 
                                    Index_Variance_Code__c, Rate_Index__c, User_Code_1__c, Unadvanced_Loan_Amount__c,
                                    Current_Balance__c, Name, Maturity_Date__c, Account_Type__c, Primary_Owner_Id__r.Id, 
                                    Primary_Owner_Id__r.Name 
                                    /*,(SELECT Accounts_to_Monitor__c,Age_of_Eligable_Accounts__c,Agreement_Summary__c,
                                        Step_Down_RLOC_Amount__c,Average_Collected_Deposit_Amount__c,Comments__c,Covenant_Definition__c,
                                        Covenant_Measures__c,Interest_Reserve_Dollar_Amount__c,Eligable_Account_Percentage__c,
                                        Equipment_Percentage__c,Frequency__c,Include_on_Loan_Agreement__c,Inventory_Percentage__c,
                                        Loan_Application__c,Other_Restrictions__c,Unused_Line_Fee_Percentage__c,Standard_Covenant__c,
                                        Start_Date__c,Testing_Frequency__c FROM Loan_Agreements_Special_Instructions__r)*/
                                    FROM EB_Account__c WHERE Id =: EBAccountId limit 1] ){
                EBAccount = a;
            }

        }catch(exception ex){
            this.EBAccount = null;
        }        
    }
    @TestVisible
    private void CreateRenewalProcess(){
        if(EBAccount != null ){
                EB_Loan_Packet__c packet = new EB_Loan_Packet__c();
                if(this.LoanPacket == null ){
                     packet = CreateLoanPacket();
                }else{
                     packet = [SELECT Id, Name, Lead_Entity__c FROM EB_Loan_Packet__c WHERE id =:loanpacket];
                }
                if(packet != null) {
                    try{
                        CreateLoanApplication(packet);
                        system.debug('%% packet');
                        //Filter the remaining if the recordtype is minimod
                        LoanApplicationViewController newObj = new LoanApplicationViewController(app);
                        
                        CreateLoanEntityRelationships();
                        system.debug('%% CreateLoanEntityRelationships');
                        if(newObj.RenderCollateral == 'true' ) CreateLoanCollateralRelationship();
                        system.debug('%% CreateLoanCollateralRelationship');
                                                   
                        if(newObj.RenderParticipation == 'true' )   CreateParticipation();
                        system.debug('%% CreateParticipation');
                        if(newObj.RenderPaymentStream == 'true' )   CreatePaymentStream();
                        system.debug('%% CreatePaymentStream');
                        
                        if(newObj.RenderRateStream == 'true' ) CreateRateStream();
                        system.debug('%% CreateRateStream');
                        if(newObj.RenderLoanAgreement == 'true' ) CreateLoanAgreement();
                        system.debug('%% CreateLoanAgreement');
                    }catch(Exception ex){
                        system.debug('##### error:' + ex.getMessage());
                    }                   
                }
        }
    }
    @TestVisible
    private EB_Loan_Packet__c CreateLoanPacket(){        
             EB_Loan_Packet__c packet = new EB_Loan_Packet__c(
                                            Name = 'Packet - ' +  EBAccount.Primary_Owner_Id__r.Name,
                                            Lead_Entity__c = EBAccount.Primary_Owner_Id__r.Id
                                            
                                           );
              List<EB_Loan_Packet__c> packetList = [SELECT Id, Name, Actual_Approval_Path__c,Lead_Entity__c FROM EB_Loan_Packet__c WHERE Lead_Entity__c =: EBAccount.Primary_Owner_Id__r.Id and Actual_Approval_Path__c <> null order by createddate desc limit 1 ];
              if(packetList.size() > 0) packet.Actual_Approval_Path__c = packetList[0].Actual_Approval_Path__c;
              Datetime dT = System.now();
              Date d = date.newinstance(dT.year(), dT.month(), dT.day());
              if(packet.Actual_Approval_Path__c != null){
                if(packet.Actual_Approval_Path__c.tolowercase().contains('committee')) packet.Committee_Date__c = d;    
              }                    
              insert packet;
              return packet;
    }
    
    @TestVisible
    private void CreateLoanApplication(EB_Loan_Packet__c packet){
            
            app = new EB_Loan_Application__c();
            
            Datetime dateTimeNow = System.now();
            Date dateNow = date.newinstance(dateTimeNow.year(), dateTimeNow.month(), dateTimeNow.day());
                                            
            app.EB_Loan_Packet__c = packet.Id;
            String bpurpose = 'No';
            if(ebaccount.Application__c == 15  || ebaccount.Application__c == 35){
                bpurpose = 'Yes';
            }else if(ebaccount.Application__c == 13){
                Map<String,String> consumerAccountTypes = new Map<String,String>{
                                                            '40'=>'40 - Redi-Reserve--Unsecured'
                                                            ,'41'=>'41 - O/D Protection--Unsecured'
                                                            ,'70'=>'70 - Home Equity Loans'
                                                            ,'71'=>'71 - Personal Revolving Line-Non-Res R/E'
                                                            ,'72'=>'72 - Personal Revolving Non RE'};
                if(ebaccount.Account_Type__c != null){
                    List<String> parsedAccountType = ebaccount.Account_Type__c.split('-'); // account type is a composite field, parse to evaluate on acct type code only...
                    String acctType = parsedAccountType[0].trim();
                    if(!consumerAccountTypes.containsKey(acctType)){
                        bpurpose = 'Yes';
                    }
                }
            }
            app.Business_Purpose__c = bpurpose;
            app.Approved_by_SFDC_Approval_Process__c = false;
            app.Rejected_by_SFDC_Approval_Process__c = false;
            app.Original_Credit_Requested_Date__c=dateNow ;
            if(LoanRecTypeId != null) app.RecordTypeId = this.LoanRecTypeId;
            if(utility.RecordTypeObject('EB_Loan_Application__c', LoanRecTypeId) != null && utility.RecordTypeObject('EB_Loan_Application__c', LoanRecTypeId).Name == utility.NewGuidanceLineAdvance()){
                app.Account_Number_Guidance_Line__c = EBAccount.Id;
            }else{
                app.Account_Number__c = EBAccount.Id;
            }
            
            decimal curbal = 0;
            if(ebaccount.Current_Balance__c != null) curbal = ebaccount.Current_Balance__c;
            decimal curunadvanced = 0;
            if(ebaccount.Unadvanced_Loan_Amount__c != null) curunadvanced = ebaccount.Unadvanced_Loan_Amount__c;
            if(utility.RecordTypeObject('EB_Loan_Application__c', LoanRecTypeId) != null && utility.RecordTypeObject('EB_Loan_Application__c', LoanRecTypeId).Name == utility.NewGuidanceLineAdvance()){}
            else app.Bank_Owned_Loan_Amount__c = curbal + curunadvanced;
            if(ebaccount.User_Code_1__c != null)
            app.Credit_Rating__c = getCreditRating(ebaccount.User_Code_1__c.trim());
            
            //app.EB_Account_Industry_Code__c = ebaccount.Account_Industry_Code__c;
            app.Original_Maturity_Date__c = ebaccount.Maturity_Date__c;
            
            List<EB_Account_Type__c> actType = [SELECT Id, Loan_Type_Mapping__c, revolve_code__c FROM EB_Account_Type__c WHERE id =: ebaccount.EB_Account_Type__c and Revolve_Code__c =:ebaccount.Revolve_Code__c limit 1];
            if(actType.size() > 0) app.Loan_Type__c = actType[0].Loan_Type_Mapping__c;
    
             
            //For Loss Share approval process
            if(ebaccount.Loss_Share__c == 'Yes') app.Loss_Share__c = 1;
            
            
            insert app;
    }
    
    private String getCreditRating(String rating){
        if (rating == null) rating = '';
        if(rating == '01') return 'RR1 - Enterprise Bank CD Secured';
        if(rating == '02') return 'RR2 - Marketable Securities / National Rated Credits';
        if(rating == '03') return 'RR3 - Strong Credit';
        if(rating == '04') return 'RR4 - Satisfactory Credit';
        if(rating == '05') return 'RR5 - Average Credit';
        if(rating == '06') return 'RR6 - Acceptable Credit, but merits attention';
        if(rating == '07') return 'RR7 - Watch Credit';
        if(rating == '08') return 'RR8 - Substandard Credit';
        if(rating == '09') return 'RR9 - Doubtful Credit';
        return rating;
        
    }
    @TestVisible
    private List<EB_Collateral__c> getCollaterals(){
        return [SELECT Id  FROM EB_Collateral__c WHERE Id in (SELECT EB_Collateral_ID__c FROM EB_Collateral_Account_Relationship__c WHERE EB_Account_ID__c =: ebaccount.id and Inactive__c = false) and Import_Source__c != 'Vintage - Treev' ];
    }
    
    public String getEError{set;get;}
    @TestVisible
    private List<EB_Account_Relationship__c> getAccountRelationships(){
        List<EB_Account_Relationship__c> accts = [SELECT Id, Client_ID__c, Relationship__c FROM EB_Account_Relationship__c WHERE EB_Account_Id__c =: ebaccount.Id];
        return accts;
    }
    @TestVisible
    private List< Account> getPledgors(List<EB_Account_Relationship__c> relList){
        
        Map<Id,String> relMap = new Map<Id, String>();
        
        for(EB_Account_Relationship__c r : relList){
            relMap.put(r.Client_ID__c,r.Relationship__c);
        }        
        
        Map<Id,EB_Collateral__c> colMap = new Map<Id,EB_Collateral__c>();
        for(EB_Collateral__c col : getCollaterals()){
            colMap.put(col.Id, col);
        }        
        
        List<EB_Collateral_Client_Relationship__c> clientrels = [SELECT Id, Client_ID__c FROM EB_Collateral_Client_Relationship__c WHERE EB_Collateral_ID__c in : colMap.KeySet()];
        Map<Id, EB_Collateral_Client_Relationship__c> clientMap = new Map<Id,EB_Collateral_Client_Relationship__c>();
        for(EB_Collateral_Client_Relationship__c c : clientrels){
            clientMap.put(c.Client_ID__c, c);
        }        
        
        List<Account> accts = [SELECT Id, Name FROM Account WHERE Id in : clientMap.KeySet() and Id not in :relMap.KeySet()];
        return accts;
    }
    
    private String ConvertRelationshipType(String relationship){
        if(relationship.toLowerCase() == 'primary owner') return 'Primary Borrower';
        if(relationship.toLowerCase() == 'pledged') return 'Pledgor';
        if(relationship.toLowerCase() == 'co-signer') return 'Co-Borrower';
        if(relationship.toLowerCase() == 'guarantor') return 'Guarantor';
        if(relationship.toLowerCase() == 'secondary owner') return 'Co-Borrower';
        return relationship;
    }

    @TestVisible 
    private void CreateLoanEntityRelationships(){        
        //load account relationships to app  
        List<EB_Loan_App_Entity_Relationship__c> insertTempRelList = new List<EB_Loan_App_Entity_Relationship__c>();
        List<EB_Loan_App_Entity_Relationship__c> insertRelList = new List<EB_Loan_App_Entity_Relationship__c>();
        Map<Id,String> clientMap = new Map<Id,String>();
        
        List<EB_Account_Relationship__c> rels =  getAccountRelationships();
        for(EB_Account_Relationship__c rel : rels){
            EB_Loan_App_Entity_Relationship__c appRel = new EB_Loan_App_Entity_Relationship__c();
            appRel.Entity_Name__c = rel.Client_Id__c;
            appRel.Loan_Application_ID__c = app.Id;
            appRel.Relationship_Type__c =  ConvertRelationshipType(rel.Relationship__c);
            if(appRel.Relationship_Type__c != 'Pledgor') clientMap.put( rel.Client_Id__c,appRel.Relationship_Type__c );
            if(appRel.Relationship_Type__c =='Primary Borrower' || appRel.Relationship_Type__c=='Pledgor' || appRel.Relationship_Type__c == 'Co-Borrower' || appRel.Relationship_Type__c == 'Guarantor' ){//||  appRel.Relationship_Type__c == 'Secondary Owner'){
                //insert appRel;
                if(appRel.Relationship_Type__c != 'Pledgor') clientMap.put( rel.Client_Id__c,appRel.Relationship_Type__c );
                insertTempRelList.add(appRel);
                
            }
            
        }
        
        //load pledgors (collateral owners that were not added above)
        List<Account> accts = getPledgors(rels);
        for(Account a : accts){
            EB_Loan_App_Entity_Relationship__c appRel = new EB_Loan_App_Entity_Relationship__c();
            appRel.Entity_Name__c = a.Id;
            appRel.Loan_Application_ID__c = app.Id;
            appRel.Relationship_Type__c = 'Pledgor';
            insertTempRelList.add(appRel);
        }
        
        for(EB_Loan_App_Entity_Relationship__c rel : insertTempRelList){
            if(rel.Relationship_Type__c == 'Pledgor'){
                if(!clientMap.containskey(rel.Entity_Name__c)){
                    insertRelList.add(rel);
                }
            }else{insertRelList.add(rel);}
        }
        if(insertRelList.size() > 0) {
            insert insertRelList;
            update insertRelList; //Create Primary Borrower by trigger
        }
        
        
    }
    @TestVisible
    private void CreateLoanCollateralRelationship(){
        List<EB_Loan_App_Collateral_Relationship__c> insertList = new List<EB_Loan_App_Collateral_Relationship__c>();
        for(EB_Collateral__c col : getCollaterals()){
            EB_Loan_App_Collateral_Relationship__c rel = new EB_Loan_App_Collateral_Relationship__c();
            rel.EB_Collateral_ID__c = col.id;
            rel.EB_Loan_Application_ID__c = app.id;
            rel.Purpose_of_Collateral__c = 'n/a';
            insertList.add(rel);
            
        }
        if(insertList.size() > 0) insert insertList;
    }

    private void CreatePaymentStream(){
        List<EB_Loan_Application_Payment_Stream__c> insertList = new List<EB_Loan_Application_Payment_Stream__c>();
        for(EB_Account_Payment_Stream__c s : [SELECT Id, Amount__c, Name, Amount_Years__c, Duration__c, EB_Account__c, Frequency__c, RecordTypeId, Start_Date__c, Stream_Number__c, Type__c FROM EB_Account_Payment_Stream__c WHERE EB_Account__c =: ebaccount.Id ]){
             EB_Loan_Application_Payment_Stream__c ls = new EB_Loan_Application_Payment_Stream__c();
            ls.Amount__c = s.Amount__c;
            ls.Duration_in_Months__c = 0;
            ls.EB_Loan_Application__c = app.Id;
            RecordType rec = utility.RecordTypeObject('EB_Account_Payment_Stream__c',s.RecordTypeId);
            String recDesc = rec.name;
            ls.RecordTypeId = utility.RecordTypeObject('EB_Loan_Application_Payment_Stream__c',recDesc).Id;
            ls.Stream_Number__c = s.Stream_Number__c;
            ls.Frequency__c = s.Frequency__c;
        
            insertList.add(ls);
             
        }
        if(insertList.size() > 0) insert insertList;
    }
    private void CreateParticipation(){
        system.debug('%%Participation1 ' );
        List<EB_Loan_Participation__c> insertList = new List<EB_Loan_Participation__c>();
        for(EB_Account_Participation__c p : [SELECT Address__c, IsPurchasedParticipation__c, Lead_Bank__c, Name_Of_Signer__c, Name, Participated_Amount__c, Participating_Institution__c, RecordTypeId, Special_Participation_Instructions__c, Status__c, Title_of_Signer__c FROM EB_Account_Participation__c WHERE EB_Account__c =: ebaccount.Id]){
            EB_Loan_Participation__c lp = new EB_Loan_Participation__c();
            lp.IsPurchasedparticipation__c = p.IsPurchasedparticipation__c;
            lp.Lead_bank__c = p.Lead_Bank__c;
            lp.Loan_Application_ID__c = app.Id;
            lp.Name_of_Signer__c = p.Name_Of_Signer__c;
            lp.Participated_Amount__c = p.Participated_Amount__c;
            lp.Participating_Institution__c = p.Participating_Institution__c;
            try{
                RecordType rec = utility.RecordTypeObject('EB_Account_Participation__c', p.RecordTypeId);
                lp.RecordTypeId = utility.RecordTypeObject('EB_Loan_Participation__c', rec.Name).Id;
                lp.Special_Participation_Instructions__c = p.Special_Participation_Instructions__c;
                lp.Title_of_Signer__c = p.Title_of_Signer__c;
                lp.Address__c = p.Address__c;
            
                if(p.Status__c == 'Active' || p.Status__c == 'Unadvanced') insertList.add(lp);

            }catch(exception ex){
                system.debug('%%Participation1 Error' );
            }
        }
        if(insertList.size() > 0 ) insert insertList;
    }
    @TestVisible
    private void CreateRateStream(){
            EB_Loan_App_Rate_Stream__c ratestream = new EB_Loan_App_Rate_Stream__c();
            ratestream.EB_Loan_Application__c = app.Id;
            ratestream.EB_Floating_Rate__c = ebaccount.Rate_Index__c;

            ratestream.Index_Variance_Code__c = ebaccount.Index_Variance_Code__c; 
            ratestream.Interest_Rate_Ceiling__c = ebaccount.Interest_Rate_Ceiling__c;
            ratestream.Interest_Rate_Floor__c = ebaccount.Interest_Rate_Floor__c;
            ratestream.Rate_Index_Variance__c = ebaccount.Interest_Rate_Variance__c;
            ratestream.Rate_Subject_To_Change__c =  ebaccount.Rate_Subject_to_Change__c;
            
            
            String ratetype = 'Floating';
            
            Pattern cpattern = Pattern.compile('fixed');
            if(ebaccount.Interest_Rate_Type_Description__c != null){ // null case could be Guidence line / incomple info from ebaccount
                Matcher cmatcher = cpattern.matcher(ebaccount.Interest_Rate_Type_Description__c.toLowerCase());
                if  (cmatcher.find() == true) ratetype = 'Fixed';
                ratestream.recordtypeId = utility.RecordTypeObject('EB_Loan_App_Rate_Stream__c',ratetype).Id;
                
                if(ratetype == 'Fixed') ratestream.Fixed_Interest_Rate__c = ebaccount.Interest_Rate__c;
                
                //Special case for floating
                if(ratestream.Index_Variance_Code__c == 'Equal to Index Rate' && ratetype == 'Floating')
                ratestream.Rate_Index_Variance__c = null;
                
                ratestream.Stream_Number__c = '1';          
                insert ratestream; 
            }

    }
      
    @TestVisible
    private void CreateLoanAgreement(){
    	linkLoanAppsToAgreementsForGivenEbaccount(ebaccount, app);
    }
    
    @TestVisible
    private void linkLoanAppsToAgreementsForGivenEbaccount(EB_Account__c ebaccount, EB_Loan_Application__c app){
        for(Agreement__c agmt : m_agreementLoanAppLink.GetActiveAgreementsForEbAccount(ebaccount.Id)){
            m_agreementLoanAppLink.ConnectLoanAppToAgreement(app.Id,agmt.Id);
        }
	}
    
    public PageReference RedirectToRenewalApp(){
        //determine if there is already a renewal or admin renewal for this account
        Boolean check = false;
        if(utility.RecordTypeObject('EB_Loan_Application__c', LoanRecTypeId) != null && utility.RecordTypeObject('EB_Loan_Application__c', LoanRecTypeId).Name == utility.NewGuidanceLineAdvance()){
        }else{
            check = CheckExistingRenewalCount();
           
        }
        
        //determine if the account we are trying to renew is closed (c,r,p)
        Boolean IsAccountClosed = false;
        String currentStatus = 'c';
        if(EBAccount != null && EBAccount.Account_Status__c != null){
            currentStatus = EBAccount.Account_Status__c.tolowercase();
        }
        if(EBAccount != null && (currentStatus == 'c' || currentStatus == 'r' || currentStatus == 'p')){
            IsAccountClosed = true;
        }
        if(EBAccount != null && check == false && IsAccountClosed == false){
            CreateRenewalProcess();
            String newPageUrl = this.url  + app.Id;  
            PageReference newPage = new PageReference(newPageUrl);
            newPage.setRedirect(true);      
            return newPage;
        }
        if(check == true){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A renewal already exists for this account. Only one Renewal and one Admin Renewal is allowed on an account');
            ApexPages.addMessage(myMsg);
        }
        if(IsAccountClosed == true){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'This Account is not active. A renewal cannot be processed at this time.');
            ApexPages.addMessage(myMsg);
        }
        if(check == false){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'The system encountered an error attempting to create the application.');
            ApexPages.addMessage(myMsg1);
        }
        return null; 
    }
 
   
}