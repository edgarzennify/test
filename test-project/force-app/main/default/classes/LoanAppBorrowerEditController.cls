public  class LoanAppBorrowerEditController {
        String url = Utility.getServerUrl() + '/';
   
         Id LoanAppId;
         Id EntityId;
         Id LoanAppEntityRelId;
         Id LoanPacketId;
         Id LoanPacketEntityId;
         
         EB_Loan_Application__c loanApp ;
         EB_Loan_Packet__c loanPacket;
         Account entity;
         EB_Loan_App_Entity_Relationship__c loanAppEntityRel;
         
         List<RecordType> recordTypeList = null;
         String retURL; 
         CurrentMode Mode;
         public String err{get;set;}
         public Account a{get;set;}
         public EB_Loan_App_Entity_Relationship__c r{get;set;}
         enum CurrentMode {Edit_Entity_And_Relationship, Save_Relationship, Save_Entity_And_Relationship, None}
         
         public ApexPages.standardcontroller Controller {get;set;}
          
         public LoanAppBorrowerEditController(ApexPages.StandardController controller) {
                getQueryParameters();
                setMode();
                initialize();
                resetFields();
                if(Mode == CurrentMode.Edit_Entity_And_Relationship ){
                         setPageFieldsForEntity();
                         setPageFieldsForLoanAppEntityRelationship();
            }else if(Mode == CurrentMode.Save_Relationship){
                         setPageFieldsForEntity();
            }else{      
            }

         }
         
         public String getQuotes(){
             return '"';
         }
                
         public void getQueryParameters(){
                        try{
                                this.LoanAppEntityRelId = apexpages.currentpage().getparameters().get('id');
                                
                                
                        }catch(exception ex){
                                this.LoanAppEntityRelId = null;
                        }
                        try{
                                this.retURL = apexpages.currentpage().getparameters().get('retURL');
                        }catch(exception ex){
                                this.retURL = '';
                        }
                        if(this.LoanAppEntityRelId != null) return; //Found an edit request
                        
                        
                        try{
                                
                                 this.LoanAppId = apexpages.currentpage().getparameters().get('aid');
                                 
                        }catch(exception ex){
                                this.LoanAppId = null;
                        }
                       
                        try{
                                this.EntityId = apexpages.currentpage().getparameters().get('eid');
                                
                        }catch(exception ex){
                                this.EntityId = null;
                        }
                        try{
                                this.LoanAppEntityRelId = apexpages.currentpage().getparameters().get('aeid');
                        }catch(exception ex){
                                 this.LoanAppEntityRelId = null;
                        }
                
        }
         public void initialize(){
                a = new Account();
                r = new EB_Loan_App_Entity_Relationship__c();
                
                    if(this.LoanAppEntityRelId !=null){
                try{
                                        loanAppEntityRel = [SELECT Id, Guaranty_Specification__c, Entity_Name__r.SSN_TIN_Has_Value__c, Entity_Name__c, Loan_Application_ID__c, Net_Worth__c, Liquid_Assets__c, Relationship_Type__c, Limited_or_Unlimited__c, Limitation__c, Loan_App_Net_Worth__c , Loan_App_Liquid_Assets__c , GuaranteeExists__c  FROM EB_Loan_App_Entity_Relationship__c WHERE Id =: this.LoanAppEntityRelId limit 1 ];
                }catch(exception ex){
                        LoanAppEntityRelId = null;
                }
                        }else{this.LoanAppEntityRelId = null;}
                        
                        if(this.Mode == CurrentMode.Edit_Entity_And_Relationship){
                                 this.entityId = loanAppEntityRel.Entity_Name__c;
                                 this.loanAppId = loanAppEntityRel.Loan_Application_ID__c;
                        }
                         
                        if(this.LoanAppId != null){
                                try{
                                                
                                        this.loanApp = [SELECT Id, Account_Number__c, Name, RecordtypeId, Closing_Date__c, EB_Loan_Packet__c   FROM EB_Loan_Application__c WHERE Id =: this.LoanAppId limit 1 ];
                                        LoanPacketId = loanApp.EB_Loan_Packet__c;
                                        loanPacket = [SELECT Id, Lead_Entity__c, Name FROM EB_Loan_Packet__c WHERE Id =:LoanPacketId];
                                        LoanPacketEntityId = loanPacket.Lead_Entity__c;
                                        getLoanApplicationName =loanApp.Name;
                                       
                                               
                                }catch(exception ex){
                                        loanApp = null;
                                        getLoanApplicationName = ' error';
                                }
                        }
                     
                        if(this.EntityId !=null){
                                
                                try{
                                        entity = [SELECT Id,SSN_TIN_Has_Value__c, Referral_Source__c,Referral_Source_LU__c,  Tax_Include_in_Loan_Agreement__c,Annual_Stmt_Include_in_Loan_Agreement__c,Interim_Stmt_Include_in_Loan_Agreement__c, EB_UnitID__c ,Interim_stm_prepared_by__c, Name , Sub_Type__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, Phone, Team_Relationship_Manager__c, Net_Worth__c, Liquid_Assets__c, Last_Financial_Statement__c, Sic, OFAC_Verified__c, Reg_O_Foreign_Insitution__c, Reg_O_Foreign_Insitution_Title__c, Reg_O_Qualifications__c, Industry, EB_Client_Name__c, Tax_Returns__c, Tax_Return_Days_Due_After_Filing__c, Annual_Financial_Statements__c, Annual_Statement_Quality__c, Annual_Stmt_Days_Due_After_Fiscal_Y_E__c , Interim_Statements__c, Interim_Stmt_Days_Due_After_Period_End__c, Other_Reporting_Requirements__c ,SSNTIN_Encrypted__c ,State_Of_Incorporation__c ,Financial_Monitoring_Special_Req__c,  isPersonAccount FROM Account WHERE Id =: this.EntityId limit 1 ];
                                }catch(exception ex){
                                        entity = null;
                                        
                                }
                        }else{this.EntityId = null;}
                
         }
         
         
         
         public String getLoanApplicationName{get;set;}
         public String dropdownRelationshipTypeId{get;set;}
         public List<SelectOption> getRelTypes(){
                 List<SelectOption> options = new List<SelectOption>();
                 options.add(new SelectOption('0', '--None--'));
                 if(PrimaryOwnerExistsOnLoanApp() != true || r.Relationship_Type__c == 'Primary Borrower') options.add(new SelectOption('Primary Borrower', 'Primary Borrower'));
                 options.add(new SelectOption('Co-Borrower', 'Co-Borrower'));
                 options.add(new SelectOption('Guarantor', 'Guarantor'));
                 options.add(new SelectOption('Pledgor', 'Pledgor'));
                 
                 return options;
         }
         public Boolean PrimaryOwnerExistsOnLoanApp(){
        
                        List<EB_Loan_App_Entity_Relationship__c> loanappent = [SELECT Id FROM EB_Loan_App_Entity_Relationship__c WHERE Loan_Application_ID__c =: loanAppId and Relationship_Type__c =: 'Primary Borrower' limit 1];
                        if(loanappent.size() == 0) return false;
                
                return true;
        }
        public void setMode(){
       
                        this.Mode = CurrentMode.None;
                        if(this.LoanAppEntityRelId != null && this.retURL != ''){
                                this.Mode = CurrentMode.Edit_Entity_And_Relationship;
                               
                        }
                        if(this.LoanAppId != null && this.EntityId != null && this.LoanAppEntityRelId == null && this.retURL == null){
                                this.Mode = CurrentMode.Save_Relationship;
                        }
                        if(this.LoanAppId != null && this.EntityId == null && this.LoanAppEntityRelId == null && this.retURL == null){
                                
                                this.Mode = CurrentMode.Save_Entity_And_Relationship;
                        }
                        
        }
        private void resetFields(){
                
        }
        public void setPageFieldsForEntity(){
                if(this.entity != null){
                   a = this.entity;
                   dropdownSubTypeId = a.Sub_Type__c;
                   dropdownTaxReturnId = a.Tax_Returns__c;
                   dropdownOfacVerifiedId = a.OFAC_Verified__c;
                   dropdownRegOQId = a.Reg_O_Qualifications__c ;
                   dropdownAnnualFStmtId = a.Annual_Financial_Statements__c ; 
                   dropdownstmQtyId = a.Annual_Statement_Quality__c ;
                   dropdownInterimStmId = a.Interim_Statements__c ;
                   dropdownInterimStmPreparedById = a.Interim_stm_prepared_by__c;
                   dropdownStateOfIncorporationId  = a.State_Of_Incorporation__c ; 
                   dropdownTaxReturnDaysId = string.valueof(a.Tax_Return_Days_Due_After_Filing__c);
                   dropdownAnnualStatementYEId = string.valueof(a.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c);
                   dropdownInterimStatementEndId = string.valueof(a.Interim_Stmt_Days_Due_After_Period_End__c);
                   dropdownTaxIncludeInLoanAgreementId = a.Tax_Include_in_Loan_Agreement__c;
                   dropdownAnnualStatementIncludeLoanAgreementId = a.Annual_Stmt_Include_in_Loan_Agreement__c;
                   dropdownInterimStatementIncludeLoanAgreementId =  a.Interim_Stmt_Include_in_Loan_Agreement__c ;
                   
                   
                }
        }
        private void  setPageFieldsForLoanAppEntityRelationship(){
                   r = this.loanAppEntityRel;
               dropdownRelationshipTypeId = r.Relationship_Type__c;
                
               dropdownLimitedUnlimitedId = r.Limited_or_Unlimited__c;
                
               dropdownGuaranteeExistsId = r.GuaranteeExists__c;
               //added 7/24/2012 KM
               dropdownGuarantySpecificationid= r.Guaranty_Specification__c;
                  
               
                
          }
          public String getReadonlyRelationshipType(){
                
                   if(this.Mode == CurrentMode.Edit_Entity_And_Relationship || this.Mode == CurrentMode.Save_Relationship){
                                if(r.Relationship_Type__c != 'Primary Borrower') return 'true';
                   }
                   
                   return 'false';
          }
                  public String getIsGarantorAndLimited(){
                           if(dropdownRelationshipTypeId == 'Guarantor' && dropdownLimitedUnlimitedId == 'Limited') return 'true';
                        return 'false';
                  }
                  public String getReadonlyStatus(){
                          
                           if (this.Mode == CurrentMode.Save_Relationship || this.Mode == CurrentMode.Edit_Entity_And_Relationship){
                                    Id ClientRecordType = this.getRecordTypeIdForName('Client');
                                    if(a.RecordTypeId == ClientRecordType) return 'true';
                           } 
                           
                           return 'false';
                           
                  }
                   
                  public String getLimitedUnlimitedVisibility(){
                          if(dropdownRelationshipTypeId == 'Guarantor') return 'true';
                          return 'false';
                  }
                  public String dropdownSubTypeId{set;get;}
                  public List<SelectOption> getSubType(){
                                List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.Sub_Type__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                    if(p.getLabel() == 'Business' || p.getLabel() == 'Personal' || p.getLabel() == 'Trust' )
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  
                  public String dropdownLimitedUnlimitedId{get;set;}
                  public List<SelectOption> getLimitedUnlimitedTypes(){
                        List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = EB_Loan_App_Entity_Relationship__c.Limited_or_Unlimited__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
       
                        return options;
                  }
                  //added on 7/24/2012 KM
                  
                   public String getGuarantySpecificationVisibility(){
                          if(dropdownLimitedUnlimitedId == 'Limited') return 'true';
                          return 'false';
                  }
                  
                  public String dropdownGuarantySpecificationId{get;set;}
                  public List<SelectOption> getGuarantySpecification(){
                        List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = EB_Loan_App_Entity_Relationship__c.Guaranty_Specification__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
       
                        return options;
                  }
                  //------end ---
                  
                  public String dropdownTaxReturnId{get;set;}
                  public List<SelectOption> getTaxReturns(){
                                List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.Tax_Returns__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  
                  public String dropdownOfacVerifiedId{get;set;}
                  public List<SelectOption> getOfacVerified(){
                                List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.OFAC_Verified__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  
                  public String dropdownRegOQId{get;set;}
                  public List<SelectOption> getRegOQ(){
                            List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.Reg_O_Qualifications__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  public String dropdownAnnualFStmtId{get;set;}
                  public List<SelectOption> getAnnualFStmt(){
                           List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.Annual_Financial_Statements__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  public String dropdownstmQtyId{get;set;}
                  public List<SelectOption> getstmQty(){
                           List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.Annual_Statement_Quality__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  public String dropdownInterimStmId{get;set;}
                  public List<SelectOption> getInterimStm(){
                         List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.Interim_Statements__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  public String dropdownInterimStmPreparedById{get;set;}
                  public List<SelectOption> getInterimStmPreparedBy(){
                              List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.Interim_stm_prepared_by__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                        return options;
                  }
                  public String dropdownGuaranteeExistsId{get;set;}
                  public List<SelectOption> getGuaranteeExists(){
                        List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = EB_Loan_App_Entity_Relationship__c.GuaranteeExists__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  
                  public String dropdownStateOfIncorporationId{get;set;}
                  public List<SelectOption> getStateOfIncorporation(){
                        List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.State_Of_Incorporation__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  public String dropdownTaxReturnDaysId{set;get;}
                  public List<SelectOption> getTaxReturnDays(){
                                List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         options.add(new SelectOption('30','30'));
                         options.add(new SelectOption('45','45')); 
                         options.add(new SelectOption('60','60'));
                         options.add(new SelectOption('90','90'));
                         options.add(new SelectOption('120','120')); 

                        return options;
                  }
                  public String dropdownAnnualStatementYEId{set;get;}
                  public List<SelectOption> getAnnualStatementYE(){
                                List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         options.add(new SelectOption('30','30'));
                         options.add(new SelectOption('45','45')); 
                         options.add(new SelectOption('60','60'));
                         options.add(new SelectOption('90','90'));
                         options.add(new SelectOption('120','120'));

                        return options;
                  }
                  public String dropdownInterimStatementEndId{set;get;}
                  public List<SelectOption> getInterimStatementEnd(){
                                List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         options.add(new SelectOption('15','15'));
                         options.add(new SelectOption('20','20'));
                         options.add(new SelectOption('30','30'));
               
                        return options;
                  }
                  
                  //New Additions
                  public String dropdownTaxIncludeInLoanAgreementId{get;set;}
                  public List<SelectOption> getTaxIncludeInLoanAgreement(){
                        List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.Tax_Include_in_Loan_Agreement__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  public String dropdownAnnualStatementIncludeLoanAgreementId{get;set;}
                  public List<SelectOption> getAnnualStatementIncludeLoanAgreement(){
                        List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.Annual_Stmt_Include_in_Loan_Agreement__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  public String dropdownInterimStatementIncludeLoanAgreementId{get;set;}
                  public List<SelectOption> getInterimStatementIncludeLoanAgreement(){
                        List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('', '--None--'));
                         Schema.Describefieldresult fieldResult = Account.Interim_Stmt_Include_in_Loan_Agreement__c.getDescribe();
                                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                         for(Schema.Picklistentry p : plist){
                                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                         }
        
                         
                        return options;
                  }
                  
                  public PageReference CancelBorrower(){
                          Id retId;
                          if(this.loanapp.id != null){
                                retId = this.loanapp.id;
                          }else if(this.entity.id != null){
                                  retId = this.entity.id;
                          }else if(this.LoanAppEntityRel.Id != null){
                                  retId = this.LoanAppEntityRel.Id;
                          }else{
                                
                          }                       
                          String newPageUrl = this.url +  retId;
                          PageReference newPage = new PageReference(newPageUrl);
                          newPage.setRedirect(true);
                          return newPage;
                  }
                  private boolean IsModificationSubstituteCollateral{
                    get{
                        if(IsModificationSubstituteCollateral == null){
                            
                            RecordType loanAppType = Utility.recordTypeObject('EB_Loan_Application__c',loanApp.recordTypeId);                            
                        
                            if(loanAppType.Name == 'Modification - Substitute Collateral'){
                              IsModificationSubstituteCollateral = true;
                            }
                            else{
                              IsModificationSubstituteCollateral = false;
                            }
                        }
         
                        return IsModificationSubstituteCollateral;
                    }
                    set;
                  }
                  public PageReference SaveQuickBorrower(){
                           
                        try{
                            if(this.LoanAppId == null){ 
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                                                    ApexPages.addMessage(myMsg);
                            }else{
                                     if (IsModificationSubstituteCollateral){
                                        
                                         ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Save not allowed on Entity for Modification - Substitute Collateral');
                                         ApexPages.addMessage(Msg);
                                         //return null;
                                    
                                     }
                                     if(this.Mode == CurrentMode.Save_Entity_And_Relationship) InsertEntityAndRelationshipData();
                                     if(this.Mode == CurrentMode.Save_Relationship) InsertRelationshipData();
                                     if(this.Mode == CurrentMode.Edit_Entity_And_Relationship )  updateEntityBorrowerData();
                                     ApexPages.Message[] msgs = ApexPages.getMessages();
                                             if (msgs.size() > 0){
                                             }else{
                                                            
                                             }
                            }
                    }catch(exception ex){
                             ApexPages.addMessages(ex);
                             
                    }
                     
                    return null;
                  }
                 
                  public PageReference SaveBorrower(){
                            
                                try{
                                if(this.LoanAppId == null){ 
                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                                                        ApexPages.addMessage(myMsg);
                                }else{
                                         if (IsModificationSubstituteCollateral){                                       
                                             ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Update not allowed on Entity for Modification - Substitute Collateral');
                                             ApexPages.addMessage(Msg);
                                             //return null;                             
                                         }
                                         if(this.Mode == CurrentMode.Save_Entity_And_Relationship) InsertEntityAndRelationshipData();
                                         if(this.Mode == CurrentMode.Save_Relationship) InsertRelationshipData();
                                         if(this.Mode == CurrentMode.Edit_Entity_And_Relationship )  updateEntityBorrowerData();
                                         ApexPages.Message[] msgs = ApexPages.getMessages();
                                                 if (msgs.size() > 0){
                                                 }else{
                                                              controller = new ApexPages.standardController(this.loanApp);
                                                              return Controller.view();
                                                              
                                                        
                                                 }
                                }
                        }catch(exception ex){
                                 ApexPages.addMessages(ex);
                               
                        }
                        return null;
                  }
                  private void updateEntityBorrowerData(){
                             
                                 try{
                                ValidateBorrower();
                                ValidateRelationship();
                                if(this.EntityId == null){
                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Retriving Entity Info.');
                                        ApexPages.addMessage(myMsg);
                                }
                                if(this.LoanAppEntityRelId == null){
                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Retriving Entity  and Loan App Relationship Info.');
                                        ApexPages.addMessage(myMsg);
                                }
                                ApexPages.Message[] msgs = ApexPages.getMessages();
                                
                                if (msgs.size() > 0){
                                        
                                }else{
                                                
                                               
                                                 update r;
                                             
                                                 update a;
                                }
                
                                 }catch(DmlException dex){
                                                ApexPages.addMessages(dex);
                                }catch(exception ex){
                                        ApexPages.addMessages(ex);
                                   
                                }
                  }
                  private void InsertEntityAndRelationshipData(){
                            
                        
                                try{

                                ValidateBorrower();
                                ValidateRelationship();
        
                                ApexPages.Message[] msgs = ApexPages.getMessages();
                                
                                if (msgs.size() > 0){
                                        
                                }else{
                                              
                                                upsert a;
                                                r.Entity_Name__c = a.Id;
                                              
                                                upsert r;
                                       
                                       
                                }
        
                                }catch(exception ex){
                        
                                  ApexPages.addMessages(ex);
                                 
                                }
                  }
                  private void InsertRelationshipData(){
                              
                       try{

                            ValidateBorrower();
                            ValidateRelationship();
                                if(this.EntityId == null){
                                       

                                }
                                ApexPages.Message[] msgs = ApexPages.getMessages();
                                
                                if (msgs.size() > 0){
                                        
                                }else{
                                                update entity;
                                                r.Entity_Name__c = this.EntityId;
                                                upsert r;
                                }
                
                    }catch(exception ex){
                            ApexPages.addMessages(ex);
                           
                    }
        
                  }
                  public String validateString(String str, String fieldname){
                                if(str == '' || str == null)
                                {
                                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation Error: ' + fieldname + ' is not valid');
                                 ApexPages.addMessage(myMsg);
                                }
                                return str;
                  }
                  private void validateBorrower(){
                    
                            
                           
                            if(this.mode == CurrentMode.Save_Entity_And_Relationship){
                                a.RecordTypeId = getRecordTypeIdForName('Prospect');
                                setEBUnitAndRM(a);      
                                a.LCS_Stage__c = 'Target';
                                a.Import_Source__c = 'Loan Application';
                                
                            }
                            a.Sub_Type__c =  dropdownSubTypeId ;//validateString(dropdownSubTypeId, 'SubType') ;       
                            a.Tax_Returns__c = dropdownTaxReturnId ;
                                a.OFAC_Verified__c = dropdownOfacVerifiedId ;
                                a.Reg_O_Qualifications__c = dropdownRegOQId;
                                a.Annual_Financial_Statements__c = dropdownAnnualFStmtId;
                                a.Annual_Statement_Quality__c = dropdownstmQtyId;
                                a.Interim_Statements__c = dropdownInterimStmId;
                                a.Interim_stm_prepared_by__c = dropdownInterimStmPreparedById; 
                                if(a.Sub_Type__c == 'Personal') a.State_Of_Incorporation__c = '';
                                else a.State_Of_Incorporation__c = dropdownStateOfIncorporationId   ;
                                a.Tax_Include_in_Loan_Agreement__c = dropdownTaxIncludeInLoanAgreementId;
                                a.Annual_Stmt_Include_in_Loan_Agreement__c = dropdownAnnualStatementIncludeLoanAgreementId;
                                a.Interim_Stmt_Include_in_Loan_Agreement__c = dropdownInterimStatementIncludeLoanAgreementId;
                                try{
                                
                                    a.Tax_Return_Days_Due_After_Filing__c = double.valueOf(dropdownTaxReturnDaysId);
                                }
                                catch(exception ex){
                                                a.Tax_Return_Days_Due_After_Filing__c = 0;
                                }
                                try{
                                           a.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = double.valueOf(dropdownAnnualStatementYEId);
                  
                                }catch(exception ex){
                                        a.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = 0;
                                }
                                try{
                                          a.Interim_Stmt_Days_Due_After_Period_End__c = double.valueOf(dropdownInterimStatementEndId);
                                }catch(exception ex){
                                        a.Interim_Stmt_Days_Due_After_Period_End__c = 0;
                                }
                                
              
          }
          private void validateRelationship(){
                    if(this.Mode == CurrentMode.Save_Relationship ||  this.Mode == CurrentMode.Save_Entity_And_Relationship)
                        r.Loan_Application_ID__c = this.LoanAppId;
                    if (dropdownRelationshipTypeId == '0'){
                        r.Relationship_Type__c = null;
                    }else{
                        r.Relationship_Type__c = dropdownRelationshipTypeId; //ValidateString('Relationship Type',dropdownRelationshipTypeId , true);
                    }
                                     
                        r.Limited_or_Unlimited__c = dropdownLimitedUnlimitedId ;//ValidateString('Limited or Unlimited' , dropdownLimitedUnlimitedId , true);
                        r.GuaranteeExists__c = dropdownGuaranteeExistsId ;
                    if(r.Limited_or_Unlimited__c == 'Limited'){
                        
                        
                        //added 7/24/2012 KM
                         r.Guaranty_Specification__c=dropdownGuarantySpecificationId;
                    }else
                    {
                        
                        r.Limitation__c = null;
                        r.Guaranty_Specification__c = null;
                    }
                    
                    
          }

          public void setEBUnitAndRM(Account Borrower){
                        try{
                                Account acct = [SELECT Id ,EB_UnitID__c, Team_Relationship_Manager__c FROM Account WHERE Id =:LoanPacketEntityId ];
                            Borrower.EB_UnitID__c = acct.EB_UnitID__c;
                            Borrower.Team_Relationship_Manager__c = acct.Team_Relationship_Manager__c;
                        }catch(exception ex){
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error setting Relationship Manager or EB Unit.');
                            ApexPages.addMessage(myMsg);
                        }
         }
          public Id getRecordTypeIdForName(String RecordTypeName){
                                                        
                if(recordTypeList == null){
                         
                        this.recordTypeList = [SELECT  Name, Id FROM RecordType];
                }
                
                if(this.recordTypeList != null){
                        for (RecordType r : this.recordTypeList){
                                if(r != null){
                                        if(r.Name == RecordTypeName) return r.Id;
                                }       
                        }
                }
                return null;
          }
                  public PageReference SetSearch(){
                    return null;
       }
                 
}