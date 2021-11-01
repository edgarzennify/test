@IsTest
public class EbDocRepoProviderTests {
	private static final MockOfEbDocDataProvider mockOfDataProvider;
    private static final Mock.ofIAttachmentHandler mockOfAttachmentHandler;
    private static EbDocRepoProvider sut;
    
    static {
        mockOfDataProvider = new MockOfEbDocDataProvider();
   	 	mockOfAttachmentHandler = new Mock.ofIAttachmentHandler();
        sut = new EbDocRepoProvider(mockOfAttachmentHandler, mockOfDataProvider);
    }
    
    public static testMethod void it_should_get_file_by_doc_id_and_no_override_filename() {
        string nameId = ObjectFactory.getFakeId(EbDocRepo__c.SObjectType, '1');
        EbDocRepo__c repoFile = new EbDocRepo__c();
        repoFile.Id = nameId;
        Attachment att = new Attachment();
        att.Body = Blob.valueOf('dddd');
        
        List<Attachment> atts = new List<Attachment>{att};
        
        mockOfDataProvider.setup('GetRepoFileById', new List<Object>{nameId}).returns(repoFile);
        mockOfAttachmentHandler.setup('getAllAttachmentsForParent', new List<Object>{nameId}).returns(atts);
        
		DmDocument result = sut.GetFileByEbDocId(nameId);

        System.assertEquals(att.Body, result.Body);        
    }
    
    public static testMethod void it_should_get_file_by_doc_id_with_override_filename() {
        string nameId = ObjectFactory.getFakeId(EbDocRepo__c.SObjectType, '1');
        EbDocRepo__c repoFile = new EbDocRepo__c();
        repoFile.Id = nameId;
        repoFile.FileName__c = 'name2';
        Attachment att = new Attachment();
        att.Name = 'name1';
        att.Body = Blob.valueOf('dddd');
        
        Attachment att1 = new Attachment();
        att1.Name = 'name2';
        att1.Body = Blob.valueOf('de');
        
        List<Attachment> atts = new List<Attachment>{att, att1};
        
        mockOfDataProvider.setup('GetRepoFileById', new List<Object>{nameId}).returns(repoFile);
        mockOfAttachmentHandler.setup('getAllAttachmentsForParent', new List<Object>{nameId}).returns(atts);
        
		DmDocument result = sut.GetFileByEbDocId(nameId);

        System.assertEquals(att1.Body, result.Body);        
    }
    
    public static testMethod void it_should_return_empty_blob_when_no_file_exists() {
        string nameId = ObjectFactory.getFakeId(EbDocRepo__c.SObjectType, '1');
        EbDocRepo__c repoFile = new EbDocRepo__c();
        repoFile.Id = nameId;
        List<Attachment> atts = new List<Attachment>();
        Blob emptyFile = Blob.valueOf('');
        
        mockOfDataProvider.setup('GetRepoFileById', new List<Object>{nameId}).returns(repoFile);
        mockOfAttachmentHandler.setup('getAllAttachmentsForParent', new List<Object>{nameId}).returns(atts);
        
		DmDocument result = sut.GetFileByEbDocId(nameId);

        System.assertEquals(emptyFile, result.Body);        
    }
    
    public static testMethod void it_should_return_true_when_file_exists() {
        string nameId = ObjectFactory.getFakeId(EbDocRepo__c.SObjectType, '1');
        EbDocRepo__c repoFile = new EbDocRepo__c();
        repoFile.Id = nameId;
        Attachment att = new Attachment();
        att.Body = Blob.valueOf('dddd');
        
        List<Attachment> atts = new List<Attachment>{att};
        
        mockOfDataProvider.setup('GetRepoFileById', new List<Object>{nameId}).returns(repoFile);
        mockOfAttachmentHandler.setup('getAllAttachmentsForParent', new List<Object>{nameId}).returns(atts);
        
		boolean result = sut.FileExistsByEbDocId(nameId);

        System.assertEquals(true, result);        
    }
    
    public static testMethod void it_should_return_false_when_file_does_not_exist() {
        string nameId = ObjectFactory.getFakeId(EbDocRepo__c.SObjectType, '1');
        EbDocRepo__c repoFile = new EbDocRepo__c();
        repoFile.Id = nameId;
        
        List<Attachment> atts = new List<Attachment>();
        
        mockOfDataProvider.setup('GetRepoFileById', new List<Object>{nameId}).returns(repoFile);
        mockOfAttachmentHandler.setup('getAllAttachmentsForParent', new List<Object>{nameId}).returns(atts);
        
		boolean result = sut.FileExistsByEbDocId(nameId);

        System.assertEquals(false, result);        
    }
    
    public class MockOfEbDocDataProvider extends ApexMoq implements EbDocRepoProvider.IDataProvider {
        public EBDocRepo__c GetRepoFileByName(string fileName) {
            return (EbDocRepo__c)handleMethodInvocation('GetRepoFileByName', new List<Object>{fileName});
        }
        public EBDocRepo__c GetRepoFileById(Id fileId) {
            return (EbDocRepo__c)handleMethodInvocation('GetRepoFileById', new List<Object>{fileId});
        }
        public List<EBDocRepo__c> GetRepoFilesByNames(List<string> fileNames){
            return (List<EBDocRepo__c>)handleMethodInvocation('GetRepoFilesByNames', new List<Object>{fileNames});
        }
        public List<EBDocRepo__c> GetRepoFilesByIds(List<Id> fileIds){
            return (List<EBDocRepo__c>)handleMethodInvocation('GetRepoFilesByIds', new List<Object>{fileIds});
        }
    }
}