@IsTest
public class CPDocsRelatedObjectsProviderTests {
    
    private static CPDocsMock.ofINcinoRepository mockRepo;

    private static CPDocsRelatedObjectsProvider sut;

    static{
        mockRepo = new  CPDocsMock.ofINcinoRepository();
        sut = new CPDocsRelatedObjectsProvider(mockRepo);
    }

    @IsTest 
    private static void it_should_call_the_ncino_repo_to_get_relationship_dms(){
        DmUser userDm = new DmUser();
        userDm.Entity = new DmEntity();

        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> result = sut.getRelatedObjects(userDm);

        mockRepo.verify('getLoanEntityRelationship', new List<Object>{userDm.Entity.Id}, Times.once);
    }

    @IsTest 
    private static void it_should_call_the_ncino_repo_to_get_relationship_dms_when_objectName_is_provided(){
        String objectName = 'obj';
        String entityId = 'ent-123';
        String loanId = 'loan-123';
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = entityId;
        dmEntity.name = objectName;
        DmLoanEntityRelationship dmLoanEntity = new DmLoanEntityRelationship();
 
        DmLoan loanDm = new DmLoan();
        loanDm.id = loanId;
        DmUser userDm = new DmUser();
        userDm.Entity = dmEntity;
  
        dmLoanEntity.Entity = dmEntity;
        dmLoanEntity.Loan = loanDm;
        List<DmLoanEntityRelationship> entityRels = new List<DmLoanEntityRelationship>{dmLoanEntity};
        List<DmLoan> loanDms = new List<DmLoan>{loanDm};
        mockRepo.setup('getLoanEntityRelationship', new List<Object>{userDm.Entity.Id}).returns(entityRels);
        mockRepo.setup('getLoans', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(loanDms);

        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> result =  sut.getRelatedObjectsByObjectName( userDm,  objectName);
        
        System.assertEquals(1, result.keyset().size());
    }
}