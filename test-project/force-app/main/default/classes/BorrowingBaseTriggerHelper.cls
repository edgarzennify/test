public  class BorrowingBaseTriggerHelper {

    /*
    This trigger will populate the fields of a new borrowing base report from the most recent 
    borrowing base report that was saved. If no borrowing base reports exist, no fields will be
    populated. This will mimic the response doc functionality in the old Lotus Notes application.
    */
    
    public void CreateBorrowingBaseColl(List<Borrowing_Base__c> newList){
        
        Boolean match=false;
        List<id> acctList = new List<id>();     
        List<id> bbList = new List<id>();
        for(Borrowing_Base__c bb : newList ){
            acctList.add(bb.Loan_Number__c);
            bbList.add(bb.Id);
        }
        
        List<Borrowing_Base__c> searchBB = new List<Borrowing_Base__c>();
        
        searchBB = [SELECT Id,Name, Archived__c , loan_number__c              
                     FROM Borrowing_Base__c
                     WHERE Loan_Number__c in: acctList and Archived__c = true
                     ORDER BY Loan_Number__c, CreatedDate Desc
                    ];
                    
        List<Borrowing_Base_Collateral__c> searchBBC = new List<Borrowing_Base_Collateral__c>();     
              
        searchBBC = [SELECT 
                    RecordTypeId,
                    Advance_Rate__c,
                    Availability__c,
                    Borrowing_Base_Report__c,
                    Details__c,
                    Eligible_Amount__c
                    FROM Borrowing_Base_Collateral__c
                    WHERE Borrowing_Base_Report__c in: searchBB
        ];             
        
        List<Borrowing_Base_Collateral__c> NewBBCs = new List<Borrowing_Base_Collateral__c>();
        
        //loop through each of the new bb records we just inserted
        for(Borrowing_Base__c newBB: newList){
            //loop through the list of existing bb records where the loan # matches and grab the first one
            match=false;
            for(Borrowing_Base__c extantBB: searchBB) {
                if (match==false){
                    if ( extantBB.Loan_Number__c == newBB.Loan_Number__c) {
                        match=true;
                        //loop through the list of existing bbc records and copy all of them that match the id of the extantBB
                        for (Borrowing_Base_Collateral__c extantBBC: searchBBC) {
                            if (extantBBC.Borrowing_Base_Report__c == extantBB.id){
                                Borrowing_Base_Collateral__c  newBBC = new  Borrowing_Base_Collateral__c();
                                newBBC.RecordTypeId = extantBBC.RecordTypeID;
                                newBBC.Advance_Rate__c = extantBBC.Advance_Rate__c;                         
                                newBBC.Borrowing_Base_Report__c = newBB.id;
                                newBBC.Eligible_Amount__c = extantBBC.Eligible_Amount__c;
                                newBBC.Details__c = extantBBC.Details__c;
                                newBBCs.Add(newBBC);
                            }
                        }
                    }
                } 
            }
        }
        if(newBBCs.size()> 0) insert newBBCs;
    }
    
    public void NewBorrowingBaseReport(List<Borrowing_Base__c> newList){
        
        try{
        List<Borrowing_Base__c> updateList = new List<Borrowing_Base__c>();
        List<id> acctList = new List<id>();     
        for(Borrowing_Base__c bb : newList ){
            acctList.add(bb.Loan_Number__c);
        }
        
        List<EB_Account__c> Accts = new List<EB_Account__c>();
        Accts = [SELECT Id,
                        Name,
                        Current_Balance__c,
                        Core_Current_Balance__c,
                        Unadvanced_Loan_Amount__c,
                        EB_Team_Member__c,
                        EB_Unit__c,
                        Primary_Owner_Id__c,
                        EB_Team_Member__r.Officer_Code__c
                        From EB_Account__c
                        WHERE Id in: acctList
        ];
        List<Borrowing_Base__c> searchBBs = new List<Borrowing_Base__c>();
        searchBBs = [SELECT Id,
                            Name,                            
                            A_R_Aging_Sel__c,
                            Adv_Rate_1__c,
                            Adv_Rate_2__c,
                            Adv_Rate_3__c,
                            Adv_Rate_4__c,
                            Adv_Rate_5__c,
                            ARA1__c,
                            ARA2__c,
                            ARA3__c,
                            ARA4__c,
                            ARA5__c,
                            Col_Other__c,
                            Collateral__c,
                            Comments__c,
                            Contact_Name__c,
                            E_Fixed__c,
                            E_Inv__c,
                            E_Mark__c,
                            E_Other__c,
                            Eligible_A_R__c,
                            Email__c,
                            Last_A_R_Aging__c,
                            Last_BBC_Date__c,
                            Last_Brok_Report__c,
                            Last_Inv_Aging__c,
                            Loan_Agree__c,
                            Loan_Number__c,
                            Schedule__c,
                            Schedule_Other__c,
                            Sweep_Agree__c                          
                             
                     FROM Borrowing_Base__c
                     WHERE Loan_Number__c in: acctList
                     ORDER BY Last_BBC_Date__c
                     //LIMIT 1
                    ];
        
       
        
        Double curBal;
        Double unadvAmt;
        String officercode;
        Id officer;
        Id entityname;
        Id unit;
       // Id owner;   
        String entity;
        //iterate through all of the borrowing base objects we are creating
        for(Borrowing_Base__c bb: newList){
            //get the Current Balance and the Unadvanced Loan Amount associated with the EB_Account__c for each one
            for (EB_Account__c acct: accts){
                if (bb.Loan_Number__c == acct.id){
                    curBal = acct.Core_Current_Balance__c;
                    unadvAmt = acct.Unadvanced_Loan_Amount__c;
                   officercode = acct.EB_Team_Member__r.Officer_Code__c;
                   // entity = acct.Primary_Owner_Id__r.name;
                   officer = acct.EB_Team_Member__c;
                  // owner = 
                   unit = acct.EB_Unit__c;
                   entityname = acct.Primary_Owner_Id__c;
                }
                
            }           
            bb.Cur_Loan_Bal__c = curBal;
            bb.Unadvanced_Amount__c = unadvAmt;
            bb.Officer__c = officercode;
            bb.Primary_Owner_Id__c = entity;
            
            bb.Associate_Director__c = officer;
            bb.Unit_Lookup__c = unit;
            bb.Primary_Owner_Id__c = entityname;
            
            //Added by JB - 2013-07-02 to set the other schedule to zero when blank to satisfy the 2 new validation rules.
            if(bb.Schedule__c == 'Other' && bb.Schedule_Other__c == null){bb.Schedule_Other__c = 0;}
            if(bb.Schedule__c == '' && bb.Schedule_Other__c != null){bb.Schedule_Other__c = null;}
            
      
           
            
            //make sure we have prior borrowing base results to search through
            if (searchBBs.size()> 0) {
                //iterate through the historical borrowing base data
                for(Borrowing_Base__c testbb: searchBBs){
                    
                    if (bb.Loan_Number__c == testbb.Loan_Number__c){
                        

                        //match
                        bb.A_R_Aging_Sel__c = testbb.A_R_Aging_Sel__c;
                        bb.Adv_Rate_1__c = testbb.Adv_Rate_1__c;
                        bb.Adv_Rate_2__c = testbb.Adv_Rate_2__c;
                        bb.Adv_Rate_3__c = testbb.Adv_Rate_3__c;
                        bb.Adv_Rate_4__c = testbb.Adv_Rate_4__c;
                        bb.Adv_Rate_5__c = testbb.Adv_Rate_5__c;
                        bb.ARA1__c = testbb.ARA1__c;
                        bb.ARA2__c = testbb.ARA2__c;
                        bb.ARA3__c = testbb.ARA3__c;
                        bb.ARA4__c = testbb.ARA4__c;
                        bb.ARA5__c = testbb.ARA5__c;
                        bb.Col_Other__c = testbb.Col_Other__c;
                        bb.Collateral__c = testbb.Collateral__c;
                        bb.Comments__c = testbb.Comments__c;
                        bb.Contact_Name__c = testbb.Contact_Name__c;
                        //Wipe the Transition data loaded on 5/14/2012 here on before insert/update    
                        bb.Eligible_A_R__c = 0; //testbb.Eligible_A_R__c;                    
                        bb.E_Fixed__c = 0;//testbb.E_Fixed__c;
                        bb.E_Inv__c = 0;//testbb.E_Inv__c;
                        bb.E_Mark__c = 0;//testbb.E_Mark__c;
                        bb.E_Other__c = 0;//testbb.E_Other__c;
                        bb.Email__c = testbb.Email__c;
                        bb.Last_A_R_Aging__c = testbb.Last_A_R_Aging__c;
                        bb.Last_BBC_Date__c = testbb.Last_BBC_Date__c;
                        bb.Last_Brok_Report__c = testbb.Last_Brok_Report__c;
                        bb.Last_Inv_Aging__c = testbb.Last_Inv_Aging__c;
                        bb.Loan_Agree__c = testbb.Loan_Agree__c;
                        bb.Schedule__c = testbb.Schedule__c;
                        bb.Schedule_Other__c = testbb.Schedule_Other__c;
                        bb.Sweep_Agree__c = testbb.Sweep_Agree__c;
                        
                        //Added by JB - 2013-07-02 to set the other schedule to zero when blank to satisfy the 2 new validation rules.
                        if(testbb.Schedule__c == 'Other' && testbb.Schedule_Other__c == null){
                            testbb.Schedule_Other__c = 0;
                            bb.Schedule_Other__c = 0;}
                        
                        //copy all of the borrowing_Base_Collateral__c objects related to testbb
                        //to the bb object
                        
                        
                        //set the archive flag on the old borrowing base report
                        testbb.Archived__c = true;
                        updateList.add( testbb);
                    }
                }
            }
        }
        if(updateList.size()> 0)  update updateList;                 
     }catch(exception ex){
        ApexPages.addMessages(ex);
    }
    
    }
    public void BeforeUpdate(){
        
    }
    
     public static testMethod void verifyNewBorrowingBaseReport(){  
        

            EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);      
            EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
            Integer numEntities = 1;
            //Integer numCollateral = 50;           
            Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
            Id ProspectRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');
            //Id LoanAppCollateralRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('All', 'EB_Loan_App_Collateral_Relationship__c');
            Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
            List<EB_Account__c> accounts = new List<EB_Account__c>();
            List<Charge_Off_Recovery__c> cors = new List<Charge_Off_Recovery__c>();            
            List<String> acc = new List<String>();
            acc.add('1B');
            acc.add('1A');
            acc.add('CA');
            acc.add('5');
            acc.add('3');
            acc.add('99');
            List<eb_Account__c> accts = new List<eb_Account__c>();
            for(integer i = 0; i < 1; i++ ){
                String title = 'test';
                String accnum = '999';
                title += i.format();
                accnum += i.format();
                System.debug('title='+title + 'accnum='+accnum);
                EB_Account__c account = objectFactory.getEBAccount(title, accnum, leadEntity);
                account.EB_Unit__c = branch.Id;
                Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '999' + String.valueof(i) );
                account.Collateral_Code__c = CollateralCode.Collateral_Code_ID__c;
                account.Account_Class_Code__c = acc[i];     
                accts.add(account);     
                //update account;
                System.assert(account!=null);
                accounts.add(account);
            }
            update accts;
            System.debug('Number of accounts: ' + accounts.size());

            for (EB_Account__c a: accounts){
                Borrowing_Base__c bb = new Borrowing_Base__c();
                bb.Loan_Number__c = a.id;
                insert bb;
                System.assert(bb!=null);
                
                //insert a borrowing_base_collateral object
                Borrowing_Base_Collateral__c bbc = new Borrowing_Base_Collateral__c();
                bbc.Borrowing_Base_Report__c = bb.id;
                bbc.RecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Marketable Securities', 'Borrowing_Base_Collateral__c');
                bbc.Advance_Rate__c = 70;
                bbc.Eligible_Amount__c=100000;
                bbc.Details__c = 'This is only a test.';
                
                
                //insert another borrowing base report for the same object to test the "lookup" algorithm
                Borrowing_Base__c bb2 = new Borrowing_Base__c();
                bb2.Loan_Number__c = a.id;
                insert bb2;
                

                
                System.assert(bb2!=null);
                
            }
        
     }  
     
     public void UpdateCreatedDateMinus45Minutes (List <Borrowing_Base__c> newList){
        for (Borrowing_Base__c bb: newlist){
            datetime dt45MinutesAgo = system.now().addMinutes(-45);
            bb.Created_Date_Minus_45_Minutes__c=dt45MinutesAgo;
        }       
     }

      public static testMethod void verifyUpdateCreatedDateMinus45Minutes(){
        // setup the test
        Borrowing_Base__c bb = new Borrowing_Base__c();
        insert bb;
        Borrowing_Base__c bb0 = (Borrowing_Base__c) [SELECT id,Created_Date_Minus_45_Minutes__c FROM Borrowing_Base__c WHERE Id=:bb.Id limit 1];
        
        // confirm fieldvalue is not empty
        system.assertNotEquals(bb0.Created_Date_Minus_45_Minutes__c, null);
                
        Double minutesDiff = Math.Floor(Decimal.valueOf(system.now().getTime() - bb0.Created_Date_Minus_45_Minutes__c.getTime())/(1000*60));
                
        // confirm field value is within 5 minutes of 45 minutes ago
        system.assert((45 - minutesDiff) < 5);
        
        //system.debug('######bb0 Delayed 15:' + string.valueOf(bb0.Delayed_Created_Date_15Min__c));
        //system.debug('######now:' + string.valueOf(system.now()));
        //system.debug('######minutesDiff:' + string.valueOf(minutesDiff));
      }
    
}