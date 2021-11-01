public class TmBoardingPermission implements TmBoarding.IPermission {
	
    private final String LAST_STAGE_TYPE = 'end';
    private final String VIEW_PERMISSION_LABEL = 'TmboardingViewPermissionSet';
    private final String EDIT_PERMISSION_LABEL = 'TmboardingEditPermissionSet';

    private final IUserInfoService m_userSvc;
    private final Configurations.IConfigurations m_configs;
    
    public TmBoardingPermission(IUserInfoService userSvc, Configurations.IConfigurations configs) {
        m_userSvc = userSvc;
        m_configs = configs;
    }

    public TmBoarding.LayoutComponentPermission getPermissionByRequestStage(DmTmRequestStage stage) {
    	TmBoarding.LayoutComponentPermission permission = new TmBoarding.LayoutComponentPermission();
        if(stage != null && String.isNotBlank(stage.type) && stage.type.tolowercase() == LAST_STAGE_TYPE){
            permission.View = true;
            permission.Edit = false;
            return permission;
        }
        Id currentUserId = m_userSvc.getCurrentUserId();
        String permissionSetViewLabel = m_configs.get(VIEW_PERMISSION_LABEL);
        String permissionSetEditLabel = m_configs.get(EDIT_PERMISSION_LABEL);
        boolean isSysAdmin = m_userSvc.isSystemAdministrator(currentUserId);
        boolean hasViewPermission = m_userSvc.hasPermissionSet(currentUserId, permissionSetViewLabel);
        boolean hasEditPermission = m_userSvc.hasPermissionSet(currentUserId, permissionSetEditLabel);
        boolean hasStageBasedPermission = String.isBlank(stage.permission)?false: m_userSvc.hasPermissionSet(currentUserId, stage.permission);

        if(isSysAdmin == true) {
            permission.View = true;
            permission.Edit = true;
        } else if(hasEditPermission == true && hasStageBasedPermission == true){
            permission.View = true;
            permission.Edit = true;
        } else if(hasViewPermission) {
            permission.View = true;
            permission.Edit = false;
        } else{
            permission.View = false;
            permission.Edit = false;
        }

    	return permission;
    }
}