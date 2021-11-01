public class AgreementBBaseComponentDataProvider implements Agreements.IAgreementBBaseComponentControllerDataProvider{
    
    public void SaveComponent(Agreement_Borrowing_Base_Relationship__c component){
        if(component.Id == null) 
            insert component; 
        else 
            update component;
    }
    
    public void InsertComponentEntities(List<Agreement_Borrowing_Base_Entity_Rel__c> bbEntities){
        if(bbEntities.size() > 0) insert bbEntities;       
    }
    
    public void DeleteComponent(Agreement_Borrowing_Base_Relationship__c component){
        delete component;
    }
    
    public void DeleteComponentEntities(List<Agreement_Borrowing_Base_Entity_Rel__c> bbEntities){
        if(bbEntities.size() > 0) Delete bbEntities; 
    }
    
    public List<Agreement_Borrowing_Base_Relationship__c> GetBorrowingBaseComponents(Id agreementId){
        return [
                SELECT 
                    Id,
                    Name,
                    RecordTypeId,
                    RecordTypeDescription__c,
                    Description__c,
                    Rate__c,
                    Amount__c,
                    Cap__c,
                    Other_Description__c,
                    EntitiesInText__c 
                FROM Agreement_Borrowing_Base_Relationship__c 
                WHERE Agreement__c=:agreementId
            ];
    }
    
    public Agreement_Borrowing_Base_Relationship__c GetBorrowingBaseComponent(Id componentId){
        return [
                SELECT 
                    Id,
                    Name,
                    RecordTypeId,
                    RecordTypeDescription__c,
                    Component__c,
                    Other_Description__c,
                    Description__c,
                    Rate__c,
                    Amount__c,
                    Cap__c,
                    EntitiesInText__c
                FROM Agreement_Borrowing_Base_Relationship__c 
                WHERE Id=:componentId
            ];
    }
    
    public Map<Id,Agreement_Client_Relationships__c> GetAgreementClientRelationships(Id agreementId){
        return new Map<Id,Agreement_Client_Relationships__c>(
                [
                    SELECT 
                    Name,
                    Agreement__r.Recordtype.ID,
                    Agreement__r.Recordtype.Name,
                    Agreement__r.RecordtypeId,  
                    Entity__c,
                    Entity__r.Name,
                    Entity__r.Entity_Name__c ,
                    Borrowing_Base_Certificate__c,
                    Borrowing_Base_Certificate_Period_Due__c,
                    Borrowing_Base_Frequency__c,
                    A_P_Detailed_Agings__c,
                    A_P_Detailed_Agings_Frequency__c,
                    A_P_Detailed_Agings_Period_Due__c,
                    Inventory_Report__c,
                    Inventory_Report_Frequency__c,
                    Inventory_Report_Period_Due__c,
                    Brokerage_Statement__c,
                    Brokerage_Statement_Frequency__c,
                    Brokerage_Statement_Period_Due__c,
                    Rent_Roll__c,
                    Rent_Roll_Frequency__c,
                    Rent_Roll_Period_Due__c,
                    Compliance_Certificate__c,
                    Compliance_Certificate_Frequency__c,
                    Compliance_Certificate_Period_Due__c,
                    Work_in_Process__c,
                    Work_in_Process_Frequency__c,
                    Work_In_Process_Period_Due__c 
                FROM Agreement_Client_Relationships__c 
                WHERE Agreement__c=:agreementId
            ]);
    }
    
    public List<Agreement_Borrowing_Base_Entity_Rel__c> CurrentComponentEntityRelationshipList(Id componentId){
        return [
                SELECT 
                    Id,
                    Name, 
                    Entity__c,
                    Entity__r.Entity_Name__c,
                    Agreement_Related_Borrowing_Base__c 
                FROM Agreement_Borrowing_Base_Entity_Rel__c 
                WHERE Agreement_Related_Borrowing_Base__c =:componentId
            ];
    }
}