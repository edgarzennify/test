public class CPDocsObjectTypeBuilder implements CPDocs.IObjectTypeBuilder{

    private final Utility.IUtility m_util;
    public CPDocsObjectTypeBuilder(Utility.IUtility util){
        m_util = util;
    }

    public CPDocs.ObjectType GetObjectType(string objectType){
        switch on objectType.toLowercase() {
            when 'entity' {		
                return CPDocs.ObjectType.Entity;
            }
            when 'account' {		
                return CPDocs.ObjectType.Account;
            }
            when 'collateral' {		
                return CPDocs.ObjectType.Collateral;
            }
            when 'loan' {		
                return CPDocs.ObjectType.Loan;
            }	
            when else {		  
                return null;
            }
        }
    }

    public String GetObjectType(CPDocs.ObjectType o){       
        if(o== CPDocs.ObjectType.Entity)  return 'Entity';
        
        if(o==CPDocs.ObjectType.Account) return 'Account';
        if(o==CPDocs.ObjectType.Collateral)	return 'Collateral';
        
        if(o==CPDocs.ObjectType.Loan) return 'Loan';
                
        return '';     
    }
    public CPDocs.ObjectType GetObjectTypeFromObjectId(string recordId){
        string objectName = m_util.getObjectNameFromId(recordId);

        switch on objectName.toLowercase() {
            when 'account' {		
                return CPDocs.ObjectType.Entity;
            }
            when 'eb_account__c' {		
                return CPDocs.ObjectType.Account;
            }
            when 'eb_collateral__c' {		
                return CPDocs.ObjectType.Collateral;
            }
            when 'llc_bi__loan__c' {		
                return CPDocs.ObjectType.Loan;
            }	
            when else {		  
                return null;
            }
        }
    }
}