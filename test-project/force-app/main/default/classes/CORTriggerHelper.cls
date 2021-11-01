public  class CORTriggerHelper {

	private Map<String,Id> CollateralCodeMap{
			get{
				if(CollateralCodeMap == null){
					CollateralCodeMap = new Map<String, Id>();
					for(collateral_code__c c : [SELECT Id, Collateral_Code_Id__c FROM collateral_code__c limit 1000]){
						CollateralCodeMap.put(c.Collateral_Code_Id__c, c.Id);
					}
				}
				return CollateralCodeMap;
			}
			set;
	}
	public void createCORDefaultValues(List<Charge_Off_Recovery__c> newList){

		String customerName;
		String LoanType;
		Id CollateralCode;
		Id Bank;
		Id Branch;
		String BranchName;
		String ClassCode;
		Double BankOwnedBalance;
		String RiskRating;
		String Grouping;	
		String CollateralDesc;			
		
		
		
		
		List<Id> acctIdList = new List<Id>();		
		for(Charge_Off_Recovery__c cor : newList ){
			acctIdList.add(cor.EB_Account__c);
		}

		//get lists
		List<Charge_Off_Recovery__c> searchCORs = new List<Charge_Off_Recovery__c>();
		searchCORs = [SELECT Id,
							 Name,
							 Date__c,
							// Customer_Name_E__c,
							 Loan_Type_E__c,
							// Collateral_Code_E__c,
							Bank__c,
							Bank_Owned_Balance__c,
							Collateral_Code__c,
							Customer_Name_E__c,
							Unit__c,
							Unit__r.Name,
							// Branch_E__c,
							// Branch_Name_E__c,
							// Class_Code_E__c,
							 //Current_Balance_E__c,
							 //Current_Balance__c,
							 EB_Account__r.Account_Class_Code__c,
							 Risk_Rating_E__c,
							 EB_Account__c,
							 EB_Account__r.Id
						FROM Charge_Off_Recovery__c
						WHERE EB_Account__r.Id in: acctIdList
						ORDER BY CreatedDate Desc
						limit 1000
						];		
								
		List<EB_Account__c> searchAccounts = new List<EB_Account__c>();
		searchAccounts = [SELECT Id,
								 Name,
								 Account_Line_1__c,
								 Account_Type__c,
								 Collateral_Code__c,
								 EB_Unit__r.EB_Bank__c,								 
								 EB_Unit__r.Branch_Number__c,
								 EB_Unit__r.id,
								 EB_Unit__r.Name,
								 Account_Class_Code__c,								 
								 Current_Balance__c,
								 User_Code_1__c
						  FROM EB_Account__c
						  WHERE Id in: acctIdList
						  limit 1000
						  ];
		
		//List<Collateral_Code__c> colCodeLookup = [SELECT Name, Collateral_Code_ID__c from Collateral_Code__c];
		
		Boolean noMatch = true;	
		Boolean quit = false;
		for (Charge_Off_Recovery__c cor : newList){	
			if(Trigger.isBefore){
				if(Trigger.isInsert){
				
		
		
				//search through existing COR objects for this one's EB_Account id
				//if match is found, pull in default values from it
				//if no match found, pull in default values from the EB_Account__c object
				if (searchCORs.size()> 0) {
					for (Charge_Off_Recovery__c searchCOR : searchCORs){
						if (searchCOR.EB_Account__c == cor.EB_Account__c){
							if (quit==false){
								//found a match
								noMatch = false;
								//populate vars with data from this object
								customerName = searchCor.Customer_Name_E__c;
								System.debug(customerName);
								LoanType = searchCor.Loan_Type_E__c;
								CollateralCode = searchCor.Collateral_Code__c;
								Bank = searchCor.Bank__c;
								Branch= searchCor.Unit__c;
								BranchName = searchCor.Unit__r.Name;
								ClassCode = searchCor.EB_Account__r.Account_Class_Code__c;
								//BankOwnedBalance = searchCor.Current_Balance_E__c;
								//always get the current bank owned balance, tied to EB_Account...this is in a formula field on the COR obj
								BankOwnedBalance = searchCor.Bank_Owned_Balance__c;
								RiskRating = searchCor.Risk_Rating_E__c;
								Grouping = calculateGrouping(classCode);
								quit = true;
							}
						}
					}
				}
				quit = false;
				if (noMatch){
					System.debug(cor.EB_Account__c);
				
					if (searchAccounts.size()> 0) {
						for(EB_Account__c searchAccount : searchAccounts){
							if (searchAccount.id == cor.EB_Account__c){
								if (quit==false){
									//found a match
									//populate vars with data from this object
									customerName = searchAccounts[0].Account_Line_1__c;
									//System.debug(customerName);
									LoanType = searchAccounts[0].Account_Type__c;
									CollateralCode = CollateralCodeMap.get(searchAccounts[0].Collateral_Code__c);
									Bank = 	searchAccounts[0].EB_Unit__r.EB_Bank__c;						 
									Branch = searchAccounts[0].EB_Unit__r.id;
									BranchName = searchAccounts[0].EB_Unit__r.Name;
									ClassCode = searchAccounts[0].Account_Class_Code__c;								 
									BankOwnedBalance = searchAccounts[0].Current_Balance__c;
									RiskRating = searchAccounts[0].User_Code_1__c;
									Grouping = calculateGrouping(classCode);
		
									quit=true;
								}
							}
						}
					}
				}
				

		
		
				//stuff the vars into the object being inserted
			
				cor.Customer_Name_E__c = customerName;
				cor.Loan_Type_E__c = LoanType;
				cor.Collateral_Code__c = CollateralCode;
				cor.Bank__c = Bank;
				cor.Unit__c = Branch;
				//cor.Branch_Name_E__c = BranchName;
				//cor.Class_Code_E__c = ClassCode;
				//cor.Bank_Owned_Balance__c = BankOwnedBalance;
				cor.Risk_Rating_E__c = RiskRating;
				cor.Grouping_E__c = Grouping;
				//lookup the collateral description based on the id
				
				/*for(Collateral_Code__c c: colCodeLookup){
					if (c.Collateral_Code_ID__c == CollateralCode){
						collateralDesc = c.Name;
					}
				}
				cor.Collateral_Desc__c = CollateralDesc;*/
				
			}
				
				if (Trigger.isUpdate) {
					//recalculate the collateral description in case the code has changed
					/*for(Collateral_Code__c c: colCodeLookup){
						if (c.Collateral_Code_ID__c == cor.Collateral_Code_E__c){
							collateralDesc = c.Name;
						}
					}
					cor.Collateral_Desc__c = CollateralDesc;
					*/
				}
				
			}	
			if (Trigger.isAfter)	{
				//automatically submit this record for approval
				//SubmitForApproval(cor);
			}
			
		}
	}
	
	 private void SubmitForApproval(Charge_Off_Recovery__c cor){
	        Approval.Processsubmitrequest req1 = new Approval.Processsubmitrequest();
	        req1.setObjectId(cor.Id);
	        Approval.Processresult result = Approval.process(req1);
    }
    
    private String calculateGrouping(String classCode){
    		String res;
 			if (classCode=='3'||classCode=='4'||classCode=='04'){
 				res =  '1';
 			} else if (classCode=='1B'|| classCode=='1E' || classCode=='1D'){
 				res = '2';
 			} else if (classCode=='1A'){
 				res = '3';
 			} else if (classCode=='CA' || classCode=='CB' || classCode=='C1' || classCode=='C2'){
 				res = '4';
 			} else if (classCode=='5' || classCode=='8' || classCode=='6A' || classCode=='6B' || classCode=='10' || classCode=='9A' || classCode=='9B' || classCode=='99'){
 				res = '5';
 			} 
 			return res;
 			
    }
    
  
    	

    
    public static testMethod void verifyCreateCORDefaultValues(){	
    	
    		//EB_Account__c acct = new EB_Account__c();
    		//Id acctId;
    		//Charge_Off_Recovery__c cor = new Charge_Off_Recovery__c();
    		//Charge_Off_Recovery__c cor2 = new Charge_Off_Recovery__c();
    		
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
			 	//Charge_Off_Recovery__c cor = new Charge_Off_Recovery__c();
			 	//cors.add(cor);
			}
			update accts;
			System.debug('Number of accounts: ' + accounts.size());
			List<Charge_Off_Recovery__c> corList = new List<Charge_Off_Recovery__c>();
			List<Charge_Off_Recovery__c> cor2List = new List<Charge_Off_Recovery__c>();
			for (EB_Account__c a: accounts){
				Charge_Off_Recovery__c cor = new Charge_Off_Recovery__c();
    			Charge_Off_Recovery__c cor2 = new Charge_Off_Recovery__c();
				cor.EB_Account__c = a.id;
    			cor.RecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Charge-Off', 'Charge_Off_Recovery__c');
    			
    			cor.Charge_Off_Amount__c = 1000;
    			cor2.EB_Account__c = a.id;
    			cor2.RecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Recovery', 'Charge_Off_Recovery__c');
    			cor2.Charge_Off_Amount__c = 1000;
    			corList.add(cor);
    			cor2List.add(cor2);
    			
    			//insert cor;
    			//insert cor2;
    			//update cor;
    			
				
			}
			insert corList;
			insert cor2List;
			update corList;
			
    	//acct = ObjectFactory.getEBAccount(accountTitle, accountNumber, leadEntity)
    	//acct = [Select name, id from EB_Account__c where Name = '8069635-15'];
    	//cor.EB_Account__c = acct.id;
    	//cor.RecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Charge-Off', 'Charge_Off_Recovery__c');
    	//cor.Charge_Off_Amount__c = 1000;
    	//cor2.EB_Account__c = acct.id;
    	//cor2.RecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Recovery', 'Charge_Off_Recovery__c');
    	//cor2.Charge_Off_Amount__c = 1000;
    	//insert cor;
    	//insert cor2;
    }
    
    
}