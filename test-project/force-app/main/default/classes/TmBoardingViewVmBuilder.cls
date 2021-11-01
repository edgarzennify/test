public class TmBoardingViewVmBuilder implements TmBoarding.IVmMetadataTypeBuilder {

	public TmConfiguration.Placement getType(){return TmConfiguration.Placement.View;} 

	public List<TmBoarding.Field> build(List<DmField> fields, TmBoarding.IVmFieldBuilder fieldBuilder) {
		List<TmBoarding.Field> vms = new List<TmBoarding.Field>();

		for(DmField dm : fields) {
			if(dm!=null && dm.IsAccessible == true && dm.View) {
				TmBoarding.Field f = fieldBuilder.build(dm, dm.ViewPlacement);
				vms.add(f);
			}
		}
		return vms;
	}
}