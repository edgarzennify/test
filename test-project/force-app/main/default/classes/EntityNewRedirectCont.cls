/************************************************************************
** CLIENT
**   Enterprise Bank & Trust
**
** MODULE
**   EntityNewRedirectCont (Class)
**
** PURPOSE
**   Supports the EntityNewRedirect Visualforce page, which allows some
**   users to use the New button on the Entity detail page to create 
**   Entity records.
**
** NOTES
**
************************************************************************/

public class EntityNewRedirectCont {
    
    public final Account acct{get;set;}
    
    //____________
    // constructor
    public EntityNewRedirectCont (ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
        system.debug('constructor');
    }


    //___________________________________________________________________
    // decide whether to prevent user from using the New button on Entity
    public PageReference notAllowedToCreateEntities () {
        Boolean divert = true;
        
        // determine the name of this user's assigned Profile
        Profile uProfile = [ SELECT Name 
                               FROM Profile 
                              WHERE id = :UserInfo.getProfileId() ];
                              
        if (uProfile.Name.contains('System Administrator'))
            divert = false;
        system.debug('Profile Name: ' + uProfile.Name + ', ' + divert);
        
        // look up the target Permission Set's name
        PermissionSet[] permSet = [ SELECT Id
                                      FROM PermissionSet 
                                     WHERE Label = 'Function - Entity Create from Entity Tab' ];
        system.debug('permSet: ' + permSet);
                                    
        // found it?
        if (permSet.size() > 0) {
            // is this Permission Set among this user's assignments?
            PermissionSetAssignment[] userPermSets = [ SELECT PermissionSetId
                                                         FROM PermissionSetAssignment
                                                        WHERE AssigneeId = :UserInfo.getUserId()
                                                          AND PermissionSetId = :permSet.get(0).Id ];
            
            // found it?
            system.debug('Permission Sets: ' + userPermSets);
            if (userPermSets.size() > 0) {
                divert = false;
                system.debug('Permission Set found');
            }
        }                                                
                   
        if (divert) {     
            // divert user to "thou cannot" page
            PageReference haltPage = Page.EntityNewRestricted;
            haltPage.setRedirect(true);
            system.debug('Diverting..., haltPage: ' + haltPage);
            return haltPage;                   
        }
        else {
            // alow user to proceed to New page, preserving selected Record Type
            Schema.DescribeSObjectResult describeResult = Account.getSObjectType().getDescribe();           
            PageReference proceedPage = new PageReference('/' + describeResult.getKeyPrefix() + 
                '/e?RecordType=' + ApexPages.currentPage().getParameters().get('RecordType') + '&nooverride=1');            
            proceedPage.setRedirect(true);
            system.debug('Proceed..., proceedPage: ' + proceedPage);
            return proceedPage;
        }
    }

} // EntityNewRedirectCont