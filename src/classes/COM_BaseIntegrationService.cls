public abstract class COM_BaseIntegrationService implements COM_IIntegrationService {

	//API name for sObjType to be integrated
	private String sObjType;
	//Integration system name
	private String intSystem; 
	
	public String getSObjectType() {
		return this.sObjType;
	}
	public String getIntSystem() {
		return this.intSystem;
	}
	
	public void setSObjectType(final String sObjType) {
		this.sObjType = sObjType;
	}
	public void setIntSystem(final String intSystem) {
		this.intSystem = intSystem;
	}
	
	protected COM_BaseIntegrationService(){}
	
	//Cannot instantiate object for this class
	protected COM_BaseIntegrationService(final String intSystem, final String sObjType) {
		if(null == intSystem || null == sObjType) {
			throw new COM_Exception(COM_ErrorCode.CANNOT_CREATE_INTEGRATION_SERVICE,
			'Cannot instantiate integration service for system:'+intSystem+', sObjType:'+sObjType);
		}
		this.sObjType = sObjType;
		this.intSystem = intSystem;
	}

}