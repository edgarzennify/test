public class TmBoardingEditVmBuilder implements TmBoarding.IVmMetadataTypeBuilder {

	public TmConfiguration.Placement getType(){return TmConfiguration.Placement.Edit;} 

	public List<TmBoarding.Field> build(List<DmField> fields, TmBoarding.IVmFieldBuilder fieldBuilder) {
		List<TmBoarding.Field> vms = new List<TmBoarding.Field>();

		for(DmField dm : fields) {
			if(dm!=null && dm.IsAccessible == true && dm.Edit == true && dm.IsUpdatable == true) {
				vms.add(fieldBuilder.build(dm, dm.EditPlacement));
			}
		}
		return vms;
	}
}