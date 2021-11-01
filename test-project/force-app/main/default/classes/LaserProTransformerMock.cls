public class LaserProTransformerMock {
	public class MockOfIService extends ApexMoq implements LaserProTransformer.IService {
		public LaserProTransformer.LpLoan trialExport(DmLoan dm) {
			return (LaserProTransformer.LpLoan)handleMethodInvocation('trialExport', new List<Object>{dm} );
		}

		public LaserProTransformer.ExportResponse export(DmLoan dm) {
			return (LaserProTransformer.ExportResponse)handleMethodInvocation('export', new List<Object>{dm});
		}
	}
}