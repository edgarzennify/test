@IsTest
public class CPDocsAdminPresenterTests {
    private static  CPDocsMock.ofINcinoRepository mockNcinoRepo;
    private static  CPDocsAdminMock.ofIRelatedNcinoLoans mockLoanRelated;
    private static  CPDocsAdminMock.ofIRepository mockAdminRepo;
    private static  CPDocsAdminMock.ofIVmBuilder mockVmBuilder;
    private static CPDocsAdminPresenter sut;

    static{
        mockNcinoRepo = new CPDocsMock.ofINcinoRepository();
        mockAdminRepo = new CPDocsAdminMock.ofIRepository();
        mockLoanRelated = new CPDocsAdminMock.ofIRelatedNcinoLoans();
        mockVmBuilder = new CPDocsAdminMock.ofIVmBuilder();
        sut = new CPDocsAdminPresenter(mockNcinoRepo,mockAdminRepo,mockLoanRelated,mockVmBuilder);
    }

    @IsTest 
    private static void it_should_call_the_ncino_repository_to_build_vms(){
        string contactId = 'co-1234';
        DmUser userDm = new DmUser();
        userDm.id = 'usr-1234';
        userDm.Entity = new DmEntity();
        userDm.Entity.id = 'e-1234';
        userDm.Entity.Name = 'e-name-123';
        mockAdminRepo.setup('getUserFromContact', new List<Object>{contactId}).returns(userDm);

        List<CPDocsAdmin.DocumentAdminRequest> result =  sut.getRequests(contactId);

        mockNcinoRepo.verify('getLoanEntityRelationship', new List<Object>{userDm.Entity.Id}, Times.Once);

    }
}