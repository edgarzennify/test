public  class AccountTeamHelper
{
    public class QueryParam{
    	public QueryParam(id iobjID,string iobjectName,string ifieldName,string ioperator,string ioperand,string iruleName){
    		objID = iobjID;
    		objectName = iobjectName;
    		fieldName = ifieldName;
    		operator = ioperator;
    		operand = ioperand;
    		ruleName = iruleName;
    	}
    	public id objID{get;set;}
    	public string objectName{get;set;}
    	public string fieldName{get;set;}
    	public string operator{get;set;}
    	public string operand{get;set;}
    	public string ruleName{get;set;}
    }

    private Map<string , QueryParam> QueryParamMap{
    	get{
	    	if(QueryParamMap == null) QueryParamMap = new Map<string , QueryParam>();
	    	return QueryParamMap;
    	}
    	set;
    }

    private Map<id,EB_Loan_App_Entity_Relationship__c> LoanAppEntityMap{
    	get{
    		if(LoanAppEntityMap == null) LoanAppEntityMap = new Map<id,EB_Loan_App_Entity_Relationship__c>();
    		return LoanAppEntityMap;
    	}
    	set;
    }

    private Map<id,EB_Loan_App_Stage_Validation_Rule__c> relatedEntityRuleMap{
        get{
            if(relatedEntityRuleMap == null){
                relatedEntityRuleMap = new Map<id,EB_Loan_App_Stage_Validation_Rule__c>([SELECT id,Name,Object_Name__c,Field_Name__c,Error_Text__c,Operation__c,Operand__c FROM EB_Loan_App_Stage_Validation_Rule__c WHERE Object_Name__c =: 'EB_Loan_App_Entity_Relationship__c']);
                system.debug('###' + string.valueof(relatedEntityRuleMap.values().size()));
            }
            return relatedEntityRuleMap;
        }
        set;
    }

    private Map<id,EB_Loan_App_Stage_Validation_Rule__c> relatedCollateralRuleMap{
        get{
            if(relatedCollateralRuleMap == null){
                relatedCollateralRuleMap = new Map<id,EB_Loan_App_Stage_Validation_Rule__c>([SELECT id,Name,Object_Name__c,Field_Name__c,Error_Text__c,Operation__c,Operand__c FROM EB_Loan_App_Stage_Validation_Rule__c WHERE Object_Name__c =: 'EB_Loan_App_Collateral_Relationship__c']);
                system.debug('###' + string.valueof(relatedCollateralRuleMap.values().size()));
            }
            return relatedCollateralRuleMap;
        }
        set;
    }

    public void updateValidationForRelatedEntities(LIST<Account> editAccounts){            
        List<EB_Loan_App_Entity_Relationship__c> updateentRels = new List<EB_Loan_App_Entity_Relationship__c>();
        
        for(Account entity : editAccounts){                
            for(EB_Loan_App_Entity_Relationship__c entrel : [Select Id, Has_Missing_required_Fields__c, Missing_Required_For_Approval_Fields__c, Missing_Required_For_Doc_Fields__c FROM EB_Loan_App_Entity_Relationship__c WHERE  Entity_Name__c =:entity.id limit 1000]){
                if(entrel.Has_Missing_required_Fields__c > 0 && entrel.Missing_Required_For_Approval_Fields__c == 0 && entrel.Missing_Required_For_Doc_Fields__c == 0){
                    entrel.Has_Missing_required_Fields__c = 0;
                    updateentRels.add(entrel);  
                }
                if(entrel.Has_Missing_required_Fields__c == 0 && (entrel.Missing_Required_For_Approval_Fields__c > 0 || entrel.Missing_Required_For_Doc_Fields__c > 0)){
                     entrel.Has_Missing_required_Fields__c = entrel.Missing_Required_For_Approval_Fields__c + entrel.Missing_Required_For_Doc_Fields__c;
                     updateentRels.add(entrel); 
                }
                LoanAppEntityMap.put(entrel.id,entrel);
            }
            
        }
        if(updateentRels.size() > 0) update updateentRels;
        
        CalculateStageValidation();
	}

    public void updateRelatedLoanPacketUnitSinceLoanAppsHaveHitformulaLimit(List<Account> accounts){
    	    List<EB_Loan_Packet__c> updatePacketList = new List<EB_Loan_Packet__c>();
    		for(eb_loan_packet__c packet :[SELECT Id, unit_text__c, Lead_Entity__r.EB_UnitID__r.Name FROM EB_Loan_Packet__c WHERE  Lead_Entity__c in:accounts]){                
                if(packet.unit_text__c != packet.Lead_Entity__r.EB_UnitID__r.Name){                    
                    packet.unit_text__c = packet.Lead_Entity__r.EB_UnitID__r.Name;
                    updatePacketList.add(packet);
                }
    		}
    		if(updatePacketList!= null && updatePacketList.size()>0) update updatePacketList;   		
    }

    private boolean isClientOrProspect(Account a){
    	Id prospectRecordTypeId = utility.RecordTypeObject('Account', 'Prospect').Id;
        Id clientRecordTypeId = utility.RecordTypeObject('Account', 'Client').Id;
		return (a.RecordTypeId == prospectRecordTypeId || a.RecordTypeId == clientRecordTypeId);
    }
    
    public void CalculateStageValidation( ){
	    
    	system.debug('%% calc' + string.valueof(LoanAppEntityMap.values().size()));
    	
    	if(LoanAppEntityMap.values().size()> 0){
    		Map<id,string> errorMap = StageActionValidation( );
	    	List<EB_Loan_App_Entity_Relationship__c> updateList = new List<EB_Loan_App_Entity_Relationship__c>();
	    	
		    	for(EB_Loan_App_Entity_Relationship__c rel : LoanAppEntityMap.values()){
		    		if(errorMap!= null){ 
		    			   system.debug('### error ' + string.valueof(errorMap.values().size()) );
			    			if(errorMap.containskey(rel.id)){
				    		rel.Stage_Validation__c = errorMap.get(rel.id);
				    		updateList.add(rel);
		    			}
		    		}else{
		    			rel.Stage_Validation__c =  '';
		    			updateList.add(rel);
		    		}
		    			
		    	}
	
	    	if(updateList.size() > 0) update updateList;
    	}
    }    
        
    public Map<id,String> StageActionValidation(){                     
	                   
        Map<id,String> errorMap = new Map<id,String>();
        
        String sReturn = '';
        String sDelimiter = ' / ';
        system.debug('%% 1' );
        for(EB_Loan_App_Entity_Relationship__c rel : LoanAppEntityMap.values()){
        	String Error = '';
            for(EB_Loan_App_Stage_Validation_Rule__c rule : relatedEntityRuleMap.values()){             
                String objectName = rule.Object_Name__c;
                String fieldName = rule.Field_Name__c;                  
                String operator = rule.Operation__c;
                String operand = rule.Operand__c;
                 system.debug('##:StageActionValidation 2');
                //Code is used to override rule name with a custom description
                String ruleName = '';
                if(rule.Error_Text__c == '' || rule.Error_Text__c == null )
                	 ruleName = rule.Name;
                else
                	ruleName = rule.Error_Text__c;
                	
                Id objID = rel.id; 
                //String isValid = IsStageActionFieldValid(objID,objectName,fieldName,operator,operand,ruleName);    
                QueryParamMap.put(ruleName , new QueryParam(objID,objectName,fieldName,operator,operand,ruleName));                     
                 system.debug('%% rule: ' +  ruleName + '/' + objectName + '/' + fieldName + '/' + operator + '/' + operand);
                /*if(isValid != ''){
                	Error = Error + isValid + ';';	                       
                        
                }*/
        	} 
        	String errors = '';
        	system.debug('%% errortrap: ' +  errors);
        	if(QueryParamMap.size() > 0){
	        	Map<String,String> results = IsStageActionFieldValid();
	        	for(string s : results.values()){
	        		errors = errors + s + '; ';
	        	}
	        	errorMap.put(rel.id,errors); 
	        	system.debug('%% errortrap2: ' +  errors);
        	}
        }

        return errorMap;
        
    }

    public Map<String,String> IsStageActionFieldValid(){
       	Id i ;
       	string queryFields = '';
       	string fldinitial = '';
       	string obj = '';
       	Map<string,string> fldMap = new Map<string,string>();
       	for(QueryParam qp : QueryParamMap.values()){
       		fldinitial = fldinitial + qp.fieldName + ',';
       		obj = qp.objectName;
       		i = qp.objID;
       	}
       	system.debug('%%fld 1 ' + fldinitial);
       	if(fldinitial.length() > 1)  queryFields = fldinitial.substring(0,fldinitial.length() - 1);
       	system.debug('%%fld 2 ' + queryFields);
        String query = 'SELECT ' + queryFields + ' FROM ' + obj + ' WHERE Id = ' + '\'' + i + '\' limit 1';
        system.debug('%%query' + query);
        sObject o = Database.query(query);
        
  		for(QueryParam qp : QueryParamMap.values()){
  			String fieldValue = '';
  			system.debug('%% fldname' + qp.fieldname);
    		if(qp.fieldname.contains('Entity_Name__r.') ){
    			SObject entity = o.getSObject('Entity_Name__r');
    			system.debug('sobjectfld' + string.valueof(entity.get(qp.fieldname.replace('Entity_Name__r.',''))));
				fieldValue = string.valueof(entity.get(qp.fieldname.replace('Entity_Name__r.','')));
				
        	}else{
        		 fieldValue = String.valueOf(o.get(qp.fieldname));
        		 system.debug('sobjectfld2' + fieldValue);
    		}
      		fldMap.put(qp.ruleName,fieldvalue); 
       }
                      
       //run through list to find rules
        Map<string,string> errorMap = new  Map<string,string>();
        
        for(string ruleName : fldMap.keyset()){
        	QueryParam param = QueryParamMap.get(ruleName);
        	string fieldvalue = fldMap.get(param.ruleName);
        	string operand = param.operand;   
        	system.debug('%%%queryparam' + param.ruleName);            	 
            if(fieldValue==null) fieldValue='';
            if(operand==null) operand='';
            if(utility.EvaluateExpression(fieldValue, param.operator, operand)){
                    system.debug('%% allgood: ' + param.ruleName); 
            }else{
                    errorMap.put(ruleName, param.ruleName);
                    system.debug('%% errortrap1a: ' + param.ruleName); 
            }  
           
        }
        
 		system.debug('%% errortrap1b: ' + string.valueOf(errorMap.values().size())); 
       return errorMap;          
    }

}