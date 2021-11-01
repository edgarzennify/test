@IsTest
public class LoanAppraisalOrderControllerTests{
     public static testMethod void verifyAppraisalPageReference(){
             String serverurl = utility.getServerUrl();
                 String url = serverurl + '/apex/AppraisalOrder?id=';
                
             //EB_Appraisal_Order__c appraisal = [SELECT Id, Submitted_Flag__c, Relationship_Manager__c, App_Rec_d__c, contact_email__c ,contact_relation__c,Last_Appraisal_Company__c,Last_Appraisal_Date__c, Name,County__c ,Is_Forclosure_or_OREO__c, Prior_Appraisal_Company__c, Prior_Appraisal_Date__c, Appraisal_Company__r.Id, Appraisal_Company__r.Name ,  Appraisal_Company__r.Comment__c, Appraisal_Order_Status__c, Appraisal_Scope__c, Appraiser__r.EB_Appraisal_Company__r.Name, Appraiser__r.Email__c, Appraiser__r.Fax__c, Appraiser__r.Phone_Number__c, Collateral_Description__c, Comments__c, Contact_Address__c, Contact_Name__c, Contact_Phone__c,Engagement_Date__c,Estimated_Completion_Date__c,    Fee__c,Improvements_by_Owner_or_Previous_Owner__c,Order_By__r.User__r.Name, Order_By__r.User__r.Id, Order_Status__c,    Property_Ownership__c,  Related_Collateral__r.Name, Related_Collateral__r.Collateral_Description__c, Related_Collateral__r.Collateral_Number__c, Related_Collateral__r.Collateral_Code__c,Related_Collateral__r.Collateral_Code__r.Name ,Related_Collateral__r.Collateral_Code__r.Appraisal_Category__c,Related_Collateral__r.EB_Appraisal_County__c ,Related_Collateral__r.EB_Appraisal_County__r.Id,Related_Collateral__r.EB_Appraisal_County__r.Name,Related_Collateral__r.EB_Appraisal_County__r.State__c,Related_Collateral__r.Appraised_Value__c, Required_Attachments__c , Special_Instructions_to_Appraiser__c, Verbal_Needed_By__c  FROM EB_Appraisal_Order__c WHERE Collateral_Description__c <>: null limit 1 ];  
             EB_Appraisal_Order__c appraisal = new EB_Appraisal_Order__c();
             EB_Collateral__c  testCollateral = ObjectFactory.getCollateral('testcollateral', false);
        	 appraisal.Related_Collateral__r = testCollateral;
        	 appraisal.Related_Collateral__c = testCollateral.Id;
        	 INSERT appraisal;
             PageReference pr = utility.testhelper(url +  appraisal.Id  );
             test.setCurrentPage(pr);
             ApexPages.StandardController sc = new Apexpages.Standardcontroller(appraisal);
             LoanAppraisalOrderController testcontroller = new LoanAppraisalOrderController(sc);
             PageReference psave = testcontroller.SaveAppraisalOrder();
             psave = testcontroller.SaveQuickAppraisalOrder();
             psave = testcontroller.CancelAppraisalOrder();
             psave = testcontroller.GenerateEngagementLetter();
             psave = testcontroller.submitOrder();
             PageReference p = utility.testhelper('www.google.com');                
                                 
    }
    public static testMethod void verifyAppraisalMethods(){
            String serverurl = Utility.getServerUrl() ;
                String url = serverurl + '/apex/AppraisalOrder?id=';
                
            //EB_Appraisal_Order__c appraisal = [SELECT Id,Submitted_Flag__c, Relationship_Manager__c,Name, Is_Forclosure_or_OREO__c,Prior_Appraisal_Company__c, Prior_Appraisal_Date__c, Appraisal_Company__r.Id, Appraisal_Company__r.Name ,  Appraisal_Company__r.Comment__c, Appraisal_Order_Status__c, Appraisal_Scope__c, Appraiser__r.EB_Appraisal_Company__r.Name, Appraiser__r.Email__c, Appraiser__r.Fax__c, Appraiser__r.Phone_Number__c, Collateral_Description__c, Comments__c, Contact_Address__c, Contact_Name__c, Contact_Phone__c,Engagement_Date__c,Estimated_Completion_Date__c,  Fee__c,Improvements_by_Owner_or_Previous_Owner__c,Order_By__r.User__r.Name, Order_By__r.User__r.Id, Order_Status__c,    Property_Ownership__c,  Related_Collateral__r.Name, Related_Collateral__r.Collateral_Description__c, Related_Collateral__r.Collateral_Number__c, Related_Collateral__r.Collateral_Code__c, Required_Attachments__c , Special_Instructions_to_Appraiser__c, Verbal_Needed_By__c  FROM EB_Appraisal_Order__c   limit 1 ];  
        	EB_Appraisal_Order__c appraisal = new EB_Appraisal_Order__c();
            EB_Collateral__c  testCollateral = ObjectFactory.getCollateral('testcollateral', false);
        	appraisal.Related_Collateral__r = testCollateral;
        	appraisal.Related_Collateral__c = testCollateral.Id;
        	INSERT appraisal;
        	
        	PageReference pr = utility.testhelper(url +  appraisal.Id + '&aid='+ testcollateral.id );
            test.setCurrentPage(pr);
            ApexPages.StandardController sc = new Apexpages.Standardcontroller(appraisal);
            LoanAppraisalOrderController testcontroller = new LoanAppraisalOrderController(sc);
                testcontroller.getQueryParameters();
                testcontroller.Initialize();
                testcontroller.setMode();
               // List<selectoption> s1 = testcontroller.getAppraisalScopes();
                List<SelectOption> s2 = testcontroller.getOrderStatus();
                List<SelectOption> s3 = testcontroller.getPropertyOwnerships();
                s3 = testcontroller.getAppraisalCompany();
                s3 = testcontroller.getAppraisers();
                string s = testcontroller.getCollateralName();
                testcontroller.getQuotes();
                String status = testcontroller.getAppraisalCoStatus();
                status = testcontroller.getAppraiserStatus();
                status = testcontroller.getIsUpdatableOrderStatus();
                status = testcontroller.getLetterURL();
                                              
    }



}