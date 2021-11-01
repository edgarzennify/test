@isTest
public class FileDeconstructorTests {
	private static FileDeconstructor sut;
    static{
        sut = new FileDeconstructor();
    }
    private static testMethod void it_should_deconstruct_a_blob_into_a_list_of_string(){
        Blob fileBody;
        fileBody = Blob.valueOf('User Type  ,FirstName  ,LastName  ,Email \n Attendee,Chris,Davis,cdavis@enterprisebank.com\n Attendee,Lloyd,Christmas,lloyd@muttcutts.com');
        List<String> results = sut.getCsvLineItems(fileBody);
        system.assertEquals(3, results.size());
        system.assertEquals('User Type  ,FirstName  ,LastName  ,Email ', results[0]);
    }
}