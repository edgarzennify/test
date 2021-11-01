@isTest
public class DocumentTreeControllerTests{
    
    private static final Mock.ofIDocumentDataService mockDocumentDataService;    
    //private static final Mock.ofIAccountLookup mockAccountLookup;
    
    static{
        mockDocumentDataService = new Mock.ofIDocumentDataService();        
        //mockAccountLookup = new Mock.ofIAccountLookup();
    }
    
    public static testMethod void verifyDocumentControllerMethods(){                
        String url = Utility.getServerUrl() + '/apex/TreeView?initialpagekey=';
                    
        PageReference pr = utility.testhelper(url + '616-4902'  );
        test.setCurrentPage(pr);
        
        ApexPages.currentPage().getParameters().put('pageKey', '616-4902');
        ApexPages.currentPage().getParameters().put('h', '616-4092:;:616-4092');
        
        List<DrawerPrivilege> mockDocs = new List<DrawerPrivilege>();
        mockDocs.add(new DrawerPrivilege());
        mockDocumentDataService.setup('BuildKey', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(url);        
        mockDocumentDataService.setup('LoadList', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(mockDocs);        
        DocumentTreeController testcontroller = new DocumentTreeController(mockDocumentDataService, null);        
           
        String hist = testcontroller.history;   
        DocumentTreeController.BreadCrumbItem bci = new DocumentTreeController.BreadCrumbItem();
        bci.Name='Test';
        bci.Key='999';
         
        testcontroller.parentType='Entity';
         
        //test the abbreviate method...string > 15 chars
        testcontroller.parentName='I AM NOT A REAL NAME';
         
        //test the abbreviate method again!  string = 15 chars
        testcontroller.parentName='I AM NOT A NAME';

        //test the bottom sort code
        String param = testcontroller.sortParameter;
        param = testcontroller.getSortDirection(); 
        testcontroller.sortParameter = 'DocTypeName';
        param = testcontroller.getSortDirection(); 
        testcontroller.setSortDirection('ASC');
        param = testcontroller.getSortDirection();    
        testcontroller.setSortDirection('DESC');
        testcontroller.sortParameter = 'DocTypeName';
        param = testcontroller.getSortDirection();            
        pagereference ptest = testcontroller.SortData();
         
        //test the top sort code
        testcontroller.topSortDirection=null;
        testcontroller.topSortParameter=null;
        ptest = testcontroller.SortTopData();
        testcontroller.topSortParameter='Name';
        ptest = testcontroller.SortTopData();
        testcontroller.topSortParameter='Name';
        ptest = testcontroller.SortTopData();
        testcontroller.topSortDirection='ASC';
        ptest = testcontroller.SortTopData();
        testcontroller.topSortDirection='DESC';
        testcontroller.topSortParameter='RelationshipName';
        ptest = testcontroller.SortTopData();
         
        //test the getBreadcrumbLinkList object
        List<DocumentTreeController.BreadCrumbItem> bcll = testcontroller.getBreadcrumbLinkList();
         
        testcontroller.parenttype = 'Entity';
        boolean chk = testcontroller.showEntityIcon;
        testcontroller.parenttype = 'Loan';
        chk = testcontroller.showAccountIcon;
        testcontroller.parenttype = 'Collateral';
        chk = testcontroller.showCollateralIcon;
        testcontroller.parenttype = '';
        chk = testcontroller.showEntityIcon;
        chk = testcontroller.showAccountIcon;
        chk = testcontroller.showCollateralIcon;
        List<String> filter = testcontroller.relatedToFilterSelectedValue;
        testcontroller.relatedToFilterSelectedValue = new List<String>();
        testcontroller.documentTypeFilterSelectedValue = new List<String>();
        testcontroller.drawerNameFilterSelectedValue = new List<String>();
        testcontroller.filterResults(); 
        testcontroller.filterDate = new Grenzsoldat__c();
        testcontroller.filterdate.Bogus_Date_1__c = date.today();
        testcontroller.filterdate.Bogus_Date_2__c =  date.today();
        testcontroller.relatedToFilterSelectedValue.add('0001');
        testcontroller.documentTypeFilterSelectedValue.add('0001');
        testcontroller.drawerNameFilterSelectedValue.add('0001');       
        testcontroller.filterResults();    
        testcontroller.nextPage();
        testcontroller.previousPage();
        testcontroller.skipToSelectedPage();  
        Integer iBogus = testcontroller.documentTypeFilterList.size();
        iBogus = testcontroller.relatedToFilterList.size();
        iBogus = testcontroller.drawerNameFilterList.size();
        testcontroller.clearfilter();  
        testcontroller.SortTopData();
        //test the edit link
        boolean sel = testController.showEditLink;
        testcontroller.pageKey='';
        String ppk = testcontroller.pageKey;
     }
     
}