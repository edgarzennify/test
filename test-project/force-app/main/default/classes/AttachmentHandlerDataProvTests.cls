@isTest
private class AttachmentHandlerDataProvTests {
	
	private static final AttachmentHandlerDataProv sut = new AttachmentHandlerDataProv();

	private static testMethod void it_should_insert_the_attachment() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Attachment attach = new Attachment();
                attach.Body = Blob.valueOf('Test File');
                attach.Name = 'attach1';
                attach.ParentId = testAcct.Id;
                List<Attachment> attachPriorToInsert = [SELECT Name FROM Attachment WHERE ParentId =: testAcct.Id];

                sut.insertAttachment(attach);

                List<Attachment> attachAfterInsert = [SELECT Name FROM Attachment WHERE ParentId =: testAcct.Id];
                System.assertEquals(0, attachPriorToInsert.size());
                System.assertEquals(1, attachAfterInsert.size());
                System.assertEquals('attach1', attachAfterInsert[0].Name);
        }

        private static testMethod void it_should_get_all_attachments_for_the_parent() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Attachment attach1 = new Attachment();
                attach1.Body = Blob.valueOf('Test File');
                attach1.Name = 'attach1';
                attach1.ParentId = testAcct.Id;
                insert attach1;
        		Attachment attach2 = new Attachment();
                attach2.Body = Blob.valueOf('Test File');
                attach2.Name = 'attach2';
                attach2.ParentId = testAcct.Id;
                insert attach2;

                List<Attachment> attachForParent = sut.getAllAttachmentsForParent(testAcct.Id);

        	System.assertEquals(2, attachForParent.size());
	}

        private static testMethod void it_should_get_all_attachments_for_the_parents() {
                Account testAcct = ObjectFactory.getValidEntity('name');
                Attachment attach1 = new Attachment();
                attach1.Body = Blob.valueOf('Test File');
                attach1.Name = 'attach1';
                attach1.ParentId = testAcct.Id;
                insert attach1;
                        Attachment attach2 = new Attachment();
                attach2.Body = Blob.valueOf('Test File');
                attach2.Name = 'attach2';
                attach2.ParentId = testAcct.Id;
                insert attach2;

                List<Attachment> attachForParent = sut.getAllAttachmentsForParents(new List<Id>{testAcct.Id});

                System.assertEquals(2, attachForParent.size());
        }

        private static testMethod void it_should_get_all_attachments_for_the_parents_when_max_attachments_provided() {
                Account testAcct = ObjectFactory.getValidEntity('name');
                Attachment attach1 = new Attachment();
                attach1.Body = Blob.valueOf('Test File');
                attach1.Name = 'attach1';
                attach1.ParentId = testAcct.Id;
                insert attach1;
                Attachment attach2 = new Attachment();
                attach2.Body = Blob.valueOf('Test File');
                attach2.Name = 'attach2';
                attach2.ParentId = testAcct.Id;
                insert attach2;

                List<Attachment> attachForParent = sut.getAllAttachmentsForParent(testAcct.Id, 2);

                System.assertEquals(2, attachForParent.size());
        }
}