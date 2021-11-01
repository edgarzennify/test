@IsTest
private class TmBoardingPermissionTests {
    
    private static final Mock.ofIUserInfoService mockUserService;
    private static final Mock.ofIConfigurations mockConfigs;
    
    private static TmBoardingPermission sut;
    
    static {
        mockUserService = new Mock.ofIUserInfoService();
        mockConfigs = new Mock.ofIConfigurations();
        sut = new TmBoardingPermission(mockUserService, mockConfigs);
    }
    
    @IsTest
    static void it_should_use_user_service() {
        String stage = 'stage';
        String stageType = 'stage-type';
        Id userId = null;
        DmTmRequestStage stageDm = new DmTmRequestStage();
        stageDm.name = stage;
        stageDm.type = stageType;
        mockConfigs.setup('get', new List<object>{'TmboardingViewPermissionSet'}).returns('view');
        mockConfigs.setup('get', new List<object>{'TmboardingEditPermissionSet'}).returns('edit');
        mockUserService.setup('getCurrentUserId').returns(userId);
        mockUserService.setup('hasPermissionSet', new List<Object>{userId, 'view'}).returns(true);
        mockUserService.setup('hasPermissionSet', new List<Object>{userId, 'edit'}).returns(false);
        
        TmBoarding.LayoutComponentPermission result = sut.getPermissionByRequestStage(stageDm);
        
        mockUserService.verify('hasPermissionSet', new List<Object>{userId, 'view'}, Times.Once);
        mockUserService.verify('hasPermissionSet', new List<Object>{userId, 'edit'}, Times.Once);
    }

    @IsTest
    static void it_should_return_a_false_edit_and_true_view_when_stage_type_is_end() {
        String stage = 'stage';
        String stageType = 'End';
        Id userId = null;
        DmTmRequestStage stageDm = new DmTmRequestStage();
        stageDm.name = stage;
        stageDm.type = stageType;
        mockConfigs.setup('get', new List<object>{'TmboardingViewPermissionSet'}).returns('view');
        mockConfigs.setup('get', new List<object>{'TmboardingEditPermissionSet'}).returns('edit');
        mockUserService.setup('getCurrentUserId').returns(userId);
        mockUserService.setup('hasPermissionSet', new List<Object>{userId, 'view'}).returns(true);
        mockUserService.setup('hasPermissionSet', new List<Object>{userId, 'edit'}).returns(false);
        
        TmBoarding.LayoutComponentPermission result = sut.getPermissionByRequestStage(stageDm);
        
        System.assertEquals(true, result.View);
        System.assertEquals(false, result.Edit);
    }

    @IsTest
    static void it_should_allow_edit_when_stage_permission_matches_user_permission_set_and_user_has_edit_permission() {
        String stage = 'stage';
        String stageType = 'New';
        String stagePermission = 'Function - Permission to edit new';
        Id userId = null;
        DmTmRequestStage stageDm = new DmTmRequestStage();
        stageDm.name = stage;
        stageDm.type = stageType;
        stageDm.permission = stagePermission;
        mockConfigs.setup('get', new List<object>{'TmboardingViewPermissionSet'}).returns('view');
        mockConfigs.setup('get', new List<object>{'TmboardingEditPermissionSet'}).returns('edit');
        mockUserService.setup('getCurrentUserId').returns(userId);
        mockUserService.setup('hasPermissionSet', new List<Object>{userId, 'view'}).returns(false);
        mockUserService.setup('hasPermissionSet', new List<Object>{userId, 'edit'}).returns(true);
        mockUserService.setup('hasPermissionSet', new List<Object>{userId, stagePermission}).returns(true);
        
        TmBoarding.LayoutComponentPermission result = sut.getPermissionByRequestStage(stageDm);
        
        System.assertEquals(true, result.View);
        System.assertEquals(true, result.Edit);
    }

    @IsTest
    static void it_should_not_allow_edit_when_stage_permission_does_not_matache_user_permission_set() {
        String stage = 'stage';
        String stageType = 'New';
        String stagePermission = 'Function - Permission to edit new';
        Id userId = null;
        DmTmRequestStage stageDm = new DmTmRequestStage();
        stageDm.name = stage;
        stageDm.type = stageType;
        stageDm.permission = stagePermission;
        mockConfigs.setup('get', new List<object>{'TmboardingViewPermissionSet'}).returns('view');
        mockConfigs.setup('get', new List<object>{'TmboardingEditPermissionSet'}).returns('edit');
        mockUserService.setup('getCurrentUserId').returns(userId);
        mockUserService.setup('hasPermissionSet', new List<Object>{userId, 'view'}).returns(false);
        mockUserService.setup('hasPermissionSet', new List<Object>{userId, 'edit'}).returns(false);
        mockUserService.setup('hasPermissionSet', new List<Object>{userId, stagePermission}).returns(false);
        
        TmBoarding.LayoutComponentPermission result = sut.getPermissionByRequestStage(stageDm);
        
        System.assertEquals(false, result.View);
        System.assertEquals(false, result.Edit);
    }
}