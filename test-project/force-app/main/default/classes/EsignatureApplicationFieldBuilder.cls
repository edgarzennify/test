public class EsignatureApplicationFieldBuilder implements EsignatureApplication.IFieldBuilder{

    private final EsignatureApplication.IFieldHelper m_fieldHelper;
    private final string AUTO = 'auto';

    public EsignatureApplicationFieldBuilder(EsignatureApplication.IFieldHelper fieldHelper){
        m_fieldHelper = fieldHelper;
    }

    public Boolean handle(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm){
        return String.isBlank(dm.referenceIdType) || dm.referenceIdType.toLowerCase() == AUTO;
    }

    public EsignatureApplication.FieldData buildFields(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm){
        return m_fieldHelper.buildFields(dm, false);
    }
}