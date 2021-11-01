@isTest(seealldata=true)

public with sharing class SL_InnerDocuments_Test
{
    private static ContentWorkspace testLib; 
	private static ContentVersion testDoc;
	
	@isTest
    static void testData()
    {
        Profile prof = [select id from profile where name = 'System Administrator'];
        User u = new User(alias = 'standt', email = 'testFeedItemDelete@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedItemDelete@testorg.com');

        System.runAs(u) {
        
            for(ContentWorkspace item:[SELECT Id,Name FROM ContentWorkspace limit 1])
            {
                testLib = item;
            } 
    	
            testDoc = new ContentVersion(); 
            testDoc.ContentURL = 'http://www.google.com/'; 
            testDoc.Title ='Google';
            //testDoc.SharingOption = 'Publish to a shared library';
            database.insert(testDoc,false); 

            ContentVersion testContent = null;
            if(testDoc.Id==null)
            {
                testContent = [SELECT ID, ContentDocumentId FROM ContentVersion where ContentDocumentId!=null limit 1];
            }
            else
            {
                testContent = [SELECT ID, ContentDocumentId FROM ContentVersion where Id = :testDoc.Id];
            }
            testDoc = testContent; 

            System.assert(testLib!=null, 'No Library is existed or user does not have access to use library, please create Library or give user access to continue');
            
            ContentWorkspaceDoc newWorkspaceDoc = new ContentWorkspaceDoc(); 
            newWorkspaceDoc.ContentWorkspaceId = testLib.Id; 
            newWorkspaceDoc.ContentDocumentId = testContent.ContentDocumentId; 
            insert newWorkspaceDoc;
            
            List<String> lstIDs = new List<String>();
            lstIDs.add(''+testDoc.ID);
		
            Boolean testFlag = SL_InnerDocuments.updateFiles(JSON.serialize(lstIDs),'ContentVersion', 'SharingOption', 'SharingOption', 'SharingOption', 
                                'SharingOption', 'Publish to a shared library', 'Publish to a shared library', 'Publish to a shared library', 'Publish to a shared library');
                                
            List<SL_InnerDocuments.cusDocItem> lstDocs = SL_InnerDocuments.getDocItems('ContentVersion', 'ContentDocumentId', 'Title', 'SharingOption', 'SharingOption', 'SharingOption', 
                                                'SharingOption', 'Publish to a shared library', 'Publish to a shared library', 'Publish to a shared library', 'Publish to a shared library', 'File Name', 'desc', '', ''+testLib.Id,'');
            lstDocs = SL_InnerDocuments.getDocItems('ContentVersion', 'ContentDocumentId', 'Title', 'SharingOption', 'SharingOption', 'SharingOption', 'SharingOption', 'Publish to a shared library', 'Publish to a shared library', 'Publish to a shared library', 'Publish to a shared library', 'Modified Date', 'asc', 'Go', ''+testLib.Id,'');
            
            List<SL_InnerDocuments.ResultsWrapper> lstTree = SL_InnerDocuments.getDocumentTreeJSON('ContentVersion', 'SharingOption', 'SharingOption', 'SharingOption', 'SharingOption', true);
            
            testFlag = SL_InnerDocuments.deleteFile(''+testDoc.ID, 'ContentVersion');
		
            SL_PickListUtils plCntr = new SL_PickListUtils();
            SL_PickListUtils.PicklistDetails plDetCntr = new SL_PickListUtils.PicklistDetails();
            plDetCntr.active = '1';
            plDetCntr.defaultValue = '2';
            plDetCntr.label = '3';
            plDetCntr.value = '4';
            plDetCntr.validFor = '5';
            
            SL_InnerDocuments.cusDocItem oDocItem = new SL_InnerDocuments.cusDocItem(1,'Test', datetime.now(), datetime.now(), UserInfo.getUserId(), UserInfo.getUserId());
        }
		
    }
}