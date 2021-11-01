@IsTest
private class AttachmentHandlerTests {

	private static final MockofIAttachmentHandlerDataProv mockDataProv;
	private static final AttachmentHandler sut;

	static {
		mockDataProv = new MockofIAttachmentHandlerDataProv();
		sut = new AttachmentHandler(mockDataProv);
	}

	@IsTest
    static void it_should_send_the_attachment_to_the_data_provider_for_saving() {
		PageReference pgRef = new PageReference('url');
		String attachName = 'name';
		Id idOfParent = ObjectFactory.getFakeId(Account.SObjectType, '1');

		sut.generateAttachmentFromPageRef(pgRef, attachName, idOfParent);

		mockDataProv.verify('insertAttachment', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
    static void it_should_call_the_default_constructor_without_error() {
		AttachmentHandler sutDef = new AttachmentHandler();
	}

	@IsTest
    static void it_should_return_all_attachments_for_parent_from_data_provider() {
		Id idOfParent = ObjectFactory.getFakeId(Account.SObjectType, '1');
		Id attachId = ObjectFactory.getFakeId(Attachment.SObjectType, '1');
		Attachment attach1 = new Attachment(Id=attachId);
		List<Attachment> expectedReturned = new List<Attachment>{attach1};
		mockDataProv.setup('getAllAttachmentsForParent', new List<Object>{idOfParent}).returns(expectedReturned);

		List<Attachment> actualReturned = sut.getAllAttachmentsForParent(idOfParent);

		System.assertEquals(1, actualReturned.size());
		System.assertEquals(attachId, actualReturned[0].Id);
	}

	@IsTest
    static void it_should_return_all_attachments_for_parent_from_data_provider_when_max_attachment_is_provided() {
		Integer maxAttachments = 1;
		Id idOfParent = ObjectFactory.getFakeId(Account.SObjectType, '1');
		Id attachId = ObjectFactory.getFakeId(Attachment.SObjectType, '1');
		Attachment attach1 = new Attachment(Id=attachId);
		List<Attachment> expectedReturned = new List<Attachment>{attach1};
		mockDataProv.setup('getAllAttachmentsForParent', new List<Object>{idOfParent, maxAttachments}).returns(expectedReturned);

		List<Attachment> actualReturned = sut.getAllAttachmentsForParent(idOfParent, maxAttachments);

		System.assertEquals(1, actualReturned.size());
		System.assertEquals(attachId, actualReturned[0].Id);
	}

	private class MockofIAttachmentHandlerDataProv extends ApexMoq implements AttachmentHandlerDataProv.IAttachmentHandlerDataProv{
		public void insertAttachment(Attachment attach){
			handleMethodInvocation('insertAttachment', new List<Object>{attach});
		}
		public List<Attachment> getAllAttachmentsForParent(Id parentId){
			return (List<Attachment>)handleMethodInvocation('getAllAttachmentsForParent', new List<Object>{parentId});
		}
		public List<Attachment> getAllAttachmentsForParents(List<Id> parentIds) {
			return (List<Attachment>)handleMethodInvocation('getAllAttachmentsForParents', new List<Object>{parentIds});
		}
		public List<Attachment> getAllAttachmentsForParent(Id parentId, Integer maxAttachments) {
			return (List<Attachment>)handleMethodInvocation('getAllAttachmentsForParent', new List<Object>{parentId, maxAttachments});
		}
	}
}