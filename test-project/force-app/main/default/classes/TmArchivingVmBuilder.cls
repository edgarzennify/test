public class TmArchivingVmBuilder implements TmArchiving.IVmBuilder{
    
    public List<TmArchiving.ArchiveLayout> build(List<DmTmArchive> dms){
        List<TmArchiving.ArchiveLayout> layouts = new List<TmArchiving.ArchiveLayout>();

        for(DmTmArchive dm : dms){
            TmArchiving.ArchiveLayout l = new TmArchiving.ArchiveLayout();
            l.TMService = new TmArchiving.LayoutComponent();
            l.TMService.label = dm.TreasuryService.name;
            l.TMService.value = dm.TreasuryService.id;
            l.TMRequest = new TmArchiving.LayoutComponent();
            l.TMRequest.label = dm.TmRequest.name;
            l.TMRequest.value = dm.TmRequest.id;
            l.CreatedBy = new TmArchiving.LayoutComponent();
            l.CreatedBy.label = dm.CreatedBy.name;
            l.CreatedBy.value = dm.CreatedBy.id;
            l.CreatedDate = dm.CreatedDate;
            l.Description = string.format('{0} ({1})', new List<string>{dm.TreasuryService.recordType.name, dm.TreasuryService.product}); 
            layouts.add(l);
        }

        return layouts;
    }
}