public class ProspectToClientDataProvider implements ProspectToClient.IProspectToClientDataProvider {
    public Map<Id, Account> getEntities(List<Id> entityIds){
    	Map<Id, Account> entities = new Map<Id, Account>(
            [SELECT
                Id, Name, EB_Client_Name__c, RecordTypeId, TIN_SSN__c, SSNTIN_Encrypted__c, EB_Customer_Number__c , BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, Phone,  Import_Source__c
				/*(SELECT Id, LCS_Stage__c, Account__c FROM EB_Account_Stage_Logs__r ORDER BY Stage_Date__c desc),
				(SELECT Id, Primary_Owner_Id__c FROM EB_Accounts__r),
				(SELECT Account__c, AccountName__c, ACH_Contact_First__c, ACH_Credits__c, ACH_Credit_Limit__c, ACH_Credit_Purpose__c, ACH_Debit_Limit__c, ACH_Debits__c, ACH_Dollar_Limit__c, ACH_Purpose__c, ACH_Payments__c, ACH_Receipts__c, ACH_Review_Date__c, Annual_Fee__c, Bill_Pay__c, Comments__c, Contact__c, Contact_Email__c, Contact_Extension__c,Contact_Fax__c,Contact_Last__c,Contact_Phone__c,ConvServiceID__c,Domestic_Wires__c,EBDirect_Plus__c,EBProduct__c,File_Transfer__c,Goldleaf__c,Goldleaf_Modules__c,Goldleaf_RD_URL__c,Imaging_Client__c,Import_Source__c,Installation_Issues__c,International_Wires__c,Last_RD_Site_Visit__c,Lending_Relationship__c,LOC_Maturity_Date__c,LOC_Number__c,Monthly_Fee__c,Monthly_Volume__c,RD_Daily_Limit__c,RD_Install__c,RD_Installed_By__c,RD_Vendor__c,RecordTypeId,Risk_Rating__c,Scanner_s__c,Scanner_Warranty__c,Secondary_Contact__c,Service_Notes__c,Start_Date__c,Sweep_Number__c,Target_Balance__c,TM_Conv_Master_Account_Number__c,TM_Service_Issues__c FROM Treasury_Management_Details__r),
				(SELECT Id, Name, Account_ID__c FROM EB_Related_Account_Owners__r),
				(SELECT Id, AccountID, WhatId FROM Tasks),
				(SELECT Id, Archive__c, Amount, StageName, Products__c FROM opportunities),
				(SELECT Id, Name, Client_Id__c, EB_Account_Id__c FROM EB_Account_Relationships__r WHERE EB_Account_Id__c =: accts[0].Id)*/                
            FROM Account 
            WHERE Id IN: entityIds]);
            
        return entities;
    }
    
    public void mergeEntities(Account masterRecord, Account slaveRecord){
    	merge masterRecord slaveRecord;
    }  
    
    /*public void saveEntity(Account entity){
    	if(entity.Id == null){
    		insert entity;
    	}else{
    		update entity;
    	}
    }*/
}