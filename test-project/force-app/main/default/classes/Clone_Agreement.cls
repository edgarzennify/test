public class Clone_Agreement implements Agreements.IClone_Agreement{
    
    private Agreements.IClone_AgreementDataProvider m_dataProvider;
    private Agreements.IClone_AgreementRelationships m_cloneRelationships;
    private Agreements.IAgreementValidator m_agreementValidator;
    
    public Clone_Agreement(Agreements.IClone_AgreementDataProvider dataProvider, Agreements.IClone_AgreementRelationships relCloner, Agreements.IAgreementValidator agreementValidator){
        m_dataProvider = dataProvider;
        m_cloneRelationships = relCloner;
        m_agreementValidator = agreementValidator;
    }
    
    public Agreement__c Clone(Id origId){    	
    	m_agreementValidator.disableValidateFromTrigger(true);
        Agreement__c orig = m_dataProvider.GetAgreementById(origId);
        Agreement__c copy = orig.clone(false,false,false,false);
        copy.Agreement_Sub_Status__c = 'Modification';
        insert copy;
        
        addReferenceToSourceAgreement(orig,copy);
        addRevisionNumberToCopyName(orig,copy);
        addPendingStatusToSourceAgreement(copy);
                 
        List<List<SObject>> clonedChildren = new List<List<SObject>>();
                
        CloneBorrowingBaseRelationships(orig,copy);
        CloneFinancialCovenants(orig,copy);
        CloneClientRelationships(orig,copy);
        cloneSubordinateRelationships(orig,copy);
        clonedChildren.add(ClonedEBAccountRelationships(orig,copy));
        clonedChildren.add(ClonedLoanApplicationRelationships(orig,copy));
        
        update copy;
        insertFromListOfLists(clonedChildren);        
        
        m_agreementValidator.ValidateAndSave(copy);
        
        return copy;
    }
    
    public Agreement__c CloneAndRemoveLoanApps(Id origId){
        Agreement__c originalAgreement = m_dataProvider.GetAgreementById(origId);
        List<Agreement_Loan_Application_Relationship__c> deleteAgmtLoanAppList = m_dataProvider.GetAgreementLoanApplicationRelationships(origId);
        Agreement__c copy = Clone(origId);
        m_dataprovider.RemoveAgreementLoanApps(deleteAgmtLoanAppList,originalAgreement);        
        return copy;
    }
    
    private void addReferenceToSourceAgreement(Agreement__c orig, Agreement__c copy){
        copy.Source_Agreement__c = orig.Id;
    }
    
    private void addRevisionNumberToCopyName(Agreement__c orig, Agreement__c copy){
    	String nextRevisionString = '';
    	String origRevisionName = orig.Name;
        Decimal nextRevision = 1;
        Integer revLen = 0;
        if(orig.Revision_Number__c <> null){
            nextRevision = orig.Revision_Number__c + 1;
            nextRevisionString = String.valueOf(nextRevision);
        }
        copy.Revision_Number__c = nextRevision;
        if(orig.Name.indexOf('rev') >= 0){
            origRevisionName = orig.Name.subString(0,orig.Name.indexOf('rev'));
        }
        revLen = nextRevisionString.length();
        if(revLen == 0){nextRevisionString = '00';}
        if(revLen == 1){nextRevisionString = '0' + nextRevisionString;}
        if(revLen >  2){nextRevisionString = nextRevisionString.substring(revLen - 2, revLen);}
        copy.Name = origRevisionName.trim();
        copy.Name = origRevisionName + ' rev ' + nextRevisionString;
    }
    
    private void addPendingStatusToSourceAgreement(Agreement__C copy){
        copy.Agreement_Status__c = 'Pending';
        copy.RecordTypeId = utility.RecordTypeObject('Agreement__c', 'Pending').Id;
            
    }
    
    private void insertFromListOfLists(List<List<SObject>> sobjectLists){
        List<SObject> toBeInserted = new List<SObject>();
        for(List<SObject> currList : sobjectLists){
            if(currList <> null){
                for(SObject listItem : currList){
                    if(listItem <> null){
                    	toBeInserted.add(listItem);
                    }
                }
            }
        }
        insert toBeInserted;
    }
    
    private void CloneBorrowingBaseRelationships(Agreement__c orig, Agreement__c copy){
        List<Agreement_Borrowing_Base_Relationship__c> origBBs = m_dataProvider.GetAgreementBorrowingBaseRelationships(orig.Id);
        if(origBBs == null || origBBs.size() == 0) return;
        Map<SObject,List<SObject>> cloneMap = m_cloneRelationships.Clone(origBBs,copy.Id);
        List<Agreement_Borrowing_Base_Relationship__c> bbsToInsert = new List<Agreement_Borrowing_Base_Relationship__c>();
        List<List<SObject>> bbsToInsertChildren = new List<List<SObject>>();
        Set<SObject> keyset = cloneMap.keyset();
        List<SObject> keys = new List<SObject>();
        keys.addAll(keyset);
        for(SObject o : keys){
            bbsToInsert.add((Agreement_Borrowing_Base_Relationship__c)o);
            bbsToInsertChildren.add(cloneMap.get(o));
        }  
        
        insert bbsToInsert;
        
        List<Agreement_Borrowing_Base_Entity_Rel__c> relsToInsert = new List<Agreement_Borrowing_Base_Entity_Rel__c>();
        for(Integer i=0; i < bbsToInsert.size(); ++i){
            List<SObject> children = bbsToInsertChildren[i];
            List<Agreement_Borrowing_Base_Entity_Rel__c> bbRels = new List<Agreement_Borrowing_Base_Entity_Rel__c>();
            if(children <> null){
                for(SObject o : children){
                    bbRels.add((Agreement_Borrowing_Base_Entity_Rel__c)o);
                }
                for(Agreement_Borrowing_Base_Entity_Rel__c newRel : bbRels){
                    newRel.Agreement_Related_Borrowing_Base__c = bbsToInsert[i].Id;
                    relsToInsert.add(newRel);
                }
            }
        }
        /*for(Agreement_Borrowing_Base_Relationship__c newBB : bbsToInsert){
            List<SObject> children = cloneMap.get(newBB);
            
            List<Agreement_Borrowing_Base_Entity_Rel__c> bbRels = new List<Agreement_Borrowing_Base_Entity_Rel__c>();
            if(children <> null){
                for(SObject o : children){
                    bbRels.add((Agreement_Borrowing_Base_Entity_Rel__c)o);
                }
                for(Agreement_Borrowing_Base_Entity_Rel__c newRel : bbRels){
                    newRel.Agreement_Related_Borrowing_Base__c = newBB.Id;
                    relsToInsert.add(newRel);
                }
            }
        }*/
        insert relsToInsert;        
    }
    
    private void CloneFinancialCovenants(Agreement__c orig, Agreement__c copy){
        List<Agreement_Financial_Covenant__c> origCovs = m_dataProvider.GetAgreementFinancialCovenants(orig.id);
        if(origCovs == null || origCovs.size() ==0) return;
        Map<SObject,List<SObject>> cloneMap = m_cloneRelationships.Clone(origCovs,copy.Id);
        List<Agreement_Financial_Covenant__c> covToInsert = new List<Agreement_Financial_Covenant__c>();
        List<List<SObject>> covToInsertChildren = new List<List<SObject>>();
        Set<SObject> keyset = cloneMap.keyset();
        List<SObject> keys = new List<SObject>();
        keys.addAll(keyset);
        for(SObject o : keys){
            covToInsert.add((Agreement_Financial_Covenant__c)o);
            covToInsertChildren.add(cloneMap.get(o));
        }
        
        insert covToInsert;
       
        List<Agreement_Financial_Covenant_Entity_Rel__c> relsToInsert = new List<Agreement_Financial_Covenant_Entity_Rel__c>();
        for(Integer i=0; i < covToInsert.size(); ++i){
            List<SObject> children = covToInsertChildren[i];
            List<Agreement_Financial_Covenant_Entity_Rel__c> covRels = new List<Agreement_Financial_Covenant_Entity_Rel__c>();
            if(children <> null){
                for(SObject o : children){
                    covRels.add((Agreement_Financial_Covenant_Entity_Rel__c)o);
                }
                for(Agreement_Financial_Covenant_Entity_Rel__c newRel : covRels){
                    newRel.Agreement_Financial_Covenant__c = covToInsert[i].Id;
                    relsToInsert.add(newRel);
                }
            }
        }
        /*for(Agreement_Financial_Covenant__c newCov : covToInsert){
            List<SObject> children = cloneMap.get(newCov);
            
            List<Agreement_Financial_Covenant_Entity_Rel__c> covRels = new List<Agreement_Financial_Covenant_Entity_Rel__c>();
            if(children <> null){
                for(SObject o : children){
                    covRels.add((Agreement_Financial_Covenant_Entity_Rel__c)o);
                }
                for(Agreement_Financial_Covenant_Entity_Rel__c newRel : covRels){
                    newRel.Agreement_Financial_Covenant__c = newCov.Id;
                    relsToInsert.add(newRel);
                }
            }
        }*/
        insert relsToInsert;        
    }
    
    private void cloneSubordinateRelationships(Agreement__c orig, Agreement__c copy){
        List<Agreement_Subordination__c> origSubordinates = m_dataProvider.getAgreementSubordinationRelationships(orig.Id);
        if(origSubordinates == null || origSubordinates.size() == 0) return;
        Map<SObject,List<SObject>> cloneMap = m_cloneRelationships.Clone(origSubordinates,copy.Id);
        List<Agreement_Subordination__c> subordinateToInsert = new List<Agreement_Subordination__c>();
        List<List<SObject>> subordinateToInsertChildren = new List<List<SObject>>();
        Set<SObject> keyset = cloneMap.keyset();
        List<SObject> keys = new List<SObject>();
        keys.addAll(keyset);
        for(SObject o : keys){
            subordinateToInsert.add((Agreement_Subordination__c)o);
            subordinateToInsertChildren.add(cloneMap.get(o));
        }
        
        insert subordinateToInsert;
        
        List<Agreement_Subordination_Entity_Rel__c> relsToInsert = new List<Agreement_Subordination_Entity_Rel__c>();
        for(Integer i=0; i < subordinateToInsert.size(); ++i){
            List<SObject> children = subordinateToInsertChildren[i];
            List<Agreement_Subordination_Entity_Rel__c> subordinateRels = new List<Agreement_Subordination_Entity_Rel__c>();
            if(children <> null){
                for(SObject o : children){
                    subordinateRels.add((Agreement_Subordination_Entity_Rel__c)o);
                }
                for(Agreement_Subordination_Entity_Rel__c newRel : subordinateRels){
                    newRel.Agreement_Subordination__c = subordinateToInsert[i].Id;
                    relsToInsert.add(newRel);
                }
            }
        }
        /*for(Agreement_Subordination__c newSubordinate : subordinateToInsert){
            List<SObject> children = cloneMap.get(newSubordinate);
                        
            List<Agreement_Subordination_Entity_Rel__c> subordinateRels = new List<Agreement_Subordination_Entity_Rel__c>();
            if(children <> null){
                for(SObject o : children){
                    subordinateRels.add((Agreement_Subordination_Entity_Rel__c)o);
                }
                for(Agreement_Subordination_Entity_Rel__c newRel : subordinateRels){
                    newRel.Agreement_Subordination__c = newSubordinate.Id;
                    relsToInsert.add(newRel);
                }
            }
        }*/
        insert relsToInsert;  
    }
    
    private void CloneClientRelationships(Agreement__c orig, Agreement__c copy){
        List<Agreement_Client_Relationships__c> origRels = m_dataProvider.GetAgreementClientRelationships(orig.id);
        if(origRels == null || origRels.size() == 0) return;        
        Map<SObject,List<SObject>> cloneMap = m_cloneRelationships.Clone(origRels,copy.Id);
        List<Agreement_Client_Relationships__c> relsToInsert = new List<Agreement_Client_Relationships__c>();
        List<List<SObject>> relsToInsertChildren = new List<List<SObject>>();
        Set<SObject> keyset = cloneMap.keyset();
        List<SObject> keys = new List<SObject>();
        keys.addAll(keyset);
        for(SObject o : keys){
            relsToInsert.add((Agreement_Client_Relationships__c)o);
            relsToInsertChildren.add(cloneMap.get(o));
        }               
        
        insert relsToInsert;
        
        List<Agreement_Financial_Documents__c> docsToInsert = new List<Agreement_Financial_Documents__c>();
        for(Integer i=0; i < relsToInsert.size(); ++i){
        	List<SObject> children = relsToInsertChildren[i];
        	List<Agreement_Financial_Documents__c> docs = new List<Agreement_Financial_Documents__c>();
            if(children <> null){
                for(SObject o : children){
                    docs.add((Agreement_Financial_Documents__c)o);
                }
                for(Agreement_Financial_Documents__c doc : docs){
                    doc.Agreement_Client_Relationship__c = relsToInsert[i].Id;
                    doc.Agreement__c = relsToInsert[i].Agreement__c;
                    docsToInsert.add(doc);
                }
            }
        }
         /*for(Agreement_Client_Relationships__c newRel : relsToInsert){
            List<SObject> children = cloneMap.get(newRel);
            //insert newRel;
            
            List<Agreement_Financial_Documents__c> docs = new List<Agreement_Financial_Documents__c>();
            if(children <> null){
                for(SObject o : children){
                    docs.add((Agreement_Financial_Documents__c)o);
                }
                for(Agreement_Financial_Documents__c doc : docs){
                	doc.Agreement_Client_Relationship__c = newRel.Id;
                    docsToInsert.add(doc);
                }
            }
        }*/
        insert docsToInsert;
    }
    
    private List<SObject> ClonedEBAccountRelationships(Agreement__c orig, Agreement__c copy){
        List<Agreement_EB_Account_Relationship__c> rels = m_dataProvider.GetAgreementEBAccountRelationships(orig.id);
        return (List<SObject>)m_cloneRelationships.Clone(rels,copy.Id);
    }
    
    private List<SObject> ClonedLoanApplicationRelationships(Agreement__c orig, Agreement__c copy){
        List<Agreement_Loan_Application_Relationship__c> rels = m_dataProvider.GetAgreementLoanApplicationRelationships(orig.id);
        return (List<SObject>)m_cloneRelationships.Clone(rels,copy.Id);
    }
    
    public Integer GetPendingAgreementCount(Agreement__c orig){
        String revisionName = orig.Name;
        Integer curNameIndex = orig.Name.indexOf('rev');
        if(curNameIndex > 0){revisionName = orig.Name.subString(0,orig.Name.indexOf('rev'));}
        return m_dataProvider.GetPendingAgreementCountByName(revisionName.trim());
    }
    
    public Agreement__c GetAgreementById(Id agmtId){
        return m_dataProvider.GetAgreementById(agmtId);
    }
}