@IsTest
private class DocumentDmBuilderTests {
    
    private final static DocumentDmBuilder sut;

    static {
        sut = new DocumentDmBuilder();
    }

    private static testMethod void it_should_build_a_dm_from_a_document_pm() {
        Document pm = new Document();
        pm.Name = 'test document';
        pm.id = Objectfactory.getFakeId(Document.SObjectType, '1');
        
        DmDocument result = sut.build(pm);

        System.assertEquals(pm.Id, result.id);
        System.assertEquals(pm.Name, result.name);
        System.assertEquals(pm.LastModifiedDate, result.lastModifiedDate);
    }

    private static testMEthod void it_should_build_a_pm_from_a_document_dm() {
        DmDocument dm = new DmDocument();
        dm.Id = Objectfactory.getFakeId(Document.SObjectType, '1');
        dm.AuthorId = Objectfactory.getFakeId(User.SObjectType, '1');
        dm.Name = 'test document';
        dm.IsInternalUseOnly = true;
        //dm.Body = Utility.getBase64('ax');
        dm.ContentType = 'text';
        dm.Type = 'test';
        dm.Description = 'test desc';
        dm.Keywords = 'k';

        Document result = sut.build(dm);

        System.assertEquals(dm.id, result.Id);
        System.assertEquals(dm.name, result.Name);
        System.assertEquals(dm.isInternalUseOnly, result.IsInternalUseOnly);
        System.assertEquals(dm.body, result.Body);
        System.assertEquals(dm.contentType, result.ContentType);
        System.assertEquals(dm.type, result.Type);
        System.assertEquals(dm.description, result.Description);
        System.assertEquals(dm.keywords, result.Keywords);
    }
}