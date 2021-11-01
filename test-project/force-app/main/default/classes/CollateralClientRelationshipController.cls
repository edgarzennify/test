public with sharing class CollateralClientRelationshipController {

    String url = Utility.getServerUrl();
    public Id ColClientId{get;set;}
    
    public EB_Collateral_Client_Relationship__c  ColClient{get;set;}
    public EB_Collateral__c col{get;set;}
    public Account client{get;set;}
    public string test{get;set;}
    public CollateralClientRelationshipController(ApexPages.StandardController controller) {
    
          try{
               ColClient = new EB_Collateral_Client_Relationship__c();
               col = new EB_Collateral__c();
               client = new Account();
               test = '';
               if(apexpages.currentpage().getparameters().get('Id') != null){
                this.ColClientId= apexpages.currentpage().getparameters().get('Id');
                test = test + colclientid;
               }else{
                ColClient = (EB_Collateral_Client_Relationship__c )controller.getrecord();
                test = test + ColClient.Client_ID__c;
                }
                
            }catch(exception ex){
               this.ColClientId= null;
            }
           
            if(ColClientId != null){
               
                for(EB_Collateral_Client_Relationship__c  ccr : [SELECT Client_ID__c, EB_Collateral_ID__c, id, name FROM EB_Collateral_Client_Relationship__c WHERE id=: ColClientId  limit 1 ]){
                                  
                                  ColClient = ccr;
                                  test = test + ' ccr Here';
                }
               
                for(EB_Collateral__c c : [SELECT id, Comments__c, Loan_Value__c, Total_Deed_Amount__c, Lien_Position__c, Appraised_Value__c
                                                 ,Valuation_Date__c, Existing_Debt__c, Valuation_Type__c, Market_Value__c, Advance_Rate__c, Name
                                                 ,EB_Appraisal_County__c, Collateral_Code__c, Collateral_Description__c, Collateral_Number__c
                                                 ,Street__c, City__c, State__c,Zip_Code__c,Status__c FROM EB_Collateral__c WHERE id =:ColClient.EB_Collateral_ID__c limit 1 ]){
                                 this.col = c;
                                 test = test + ' c Here';
                }
                for(Account a :[SELECT id, name FROM Account WHERE id =: ColClient.Client_ID__c limit 1 ]){              
                                 this.client = a;
                                 test = test + ' a Here';
                }
                
             }
            }
       Public PageReference SubmitButton(){
               
              save();
              if(ColClientid == null)
                url = url + '/' +ColClient.Client_ID__c;
              else
                  url = url + '/' + client.id;
              PageReference newPage = new PageReference(url);
              newPage.setRedirect(true);
              return newPage;
                            
              return null;
         
        }
       
        Public PageReference SubmitQuickButton(){
               
              save();
              
              return null;
         
        }
        Public PageReference CancelButton(){
                             
                 if(ColClientid == null)
                  url = url + '/' +ColClient.Client_ID__c;
                  else
                  url = url + '/' + client.id;
                 PageReference newPage = new PageReference(url);
                 newPage.setRedirect(true);
                 return newPage;
                    
        }
         private void save(){
         	 try{
            if(ColClientId == null){
            	
                    insert col;                
                    List<EB_Collateral__c> colls = [SELECT Id, New_Collateral_Number__c FROM EB_Collateral__c WHERE Id =: col.Id limit 1];
                    if (colls == null){
                      
                    }else{
                      for(EB_Collateral__c cl : colls){
                        col.Name = 'Prospective' + '-' + cl.New_Collateral_Number__c;
                        col.Collateral_Number__c = cl.New_Collateral_Number__c;
                      }
                       update col;
                      }
                                 
                    ColClient.EB_Collateral_ID__c = col.Id;
                    insert ColClient;
                   
                }
                else{
                
                    if(col.id == null) insert  col; else update col;                  
                    if(ColClient.Id == null) insert Colclient; else update ColClient;
                }
            }catch(exception ex){
            	
            }
        }
        public static testMethod void verifycolClientPageReference(){
                 String serverurl = Utility.getServerUrl();
                 String url = serverurl + '/apex/CollateralClientRelationship?id=';
                 //create account
                 //create collateral
                 Id rec = objectfactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');
                 EB_Team_Member__c RM = objectfactory.getTeamMember('RM');
                 Account acct = ObjectFactory.getEntity('Test', rec, RM);
                 Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9990' );
                 EB_Collateral__c col = objectfactory.getCollateral('test', CollateralCode, true);
                 EB_Collateral_Client_Relationship__c colclient = new EB_Collateral_Client_Relationship__c();
                 colclient.Client_ID__c = acct.id;
                 colclient.EB_Collateral_ID__c = col.id;
                 insert colclient;
                 PageReference pr = utility.testhelper(url +  colclient.Id  );
	             test.setCurrentPage(pr);
	             ApexPages.StandardController sc = new Apexpages.Standardcontroller(colclient);
	             CollateralClientRelationshipController testcontroller = new CollateralClientRelationshipController(sc);
	             
	             pagereference save = testcontroller.SubmitButton();
                 PageReference cancel = testcontroller.CancelButton();
          }
          public static testMethod void verifycolClientNullTest(){
                 String serverurl = Utility.getServerUrl();
                 String url = serverurl + '/apex/CollateralClientRelationship?id=';
                 //create account
                 //create collateral
                 Id rec = objectfactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');
                 EB_Team_Member__c RM = objectfactory.getTeamMember('RM');
                 Account acct = ObjectFactory.getEntity('Test', rec, RM);
                 Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9990' );
                 EB_Collateral__c col = objectfactory.getCollateral('test', CollateralCode, true);
                 EB_Collateral_Client_Relationship__c colclient = new EB_Collateral_Client_Relationship__c();
                 colclient.Client_ID__c = acct.id;
                 colclient.EB_Collateral_ID__c = col.id;
                 insert colclient;
                 PageReference pr = utility.testhelper(url    );
	             test.setCurrentPage(pr);
	             ApexPages.StandardController sc = new Apexpages.Standardcontroller(colclient);
	             CollateralClientRelationshipController testcontroller = new CollateralClientRelationshipController(sc);
	             
	             pagereference save = testcontroller.SubmitButton();
                 PageReference cancel = testcontroller.CancelButton();
          }
                   
    }