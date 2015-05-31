global class COM_IntegrationBatch extends COM_BatchQueueable implements Database.AllowsCallouts,Database.Stateful {

    private static final String CLASSNAME = 'COM_IntegrationBatch';
    private static final COM_Logger LOGGER = new COM_Logger(CLASSNAME);
    
    global Integer totalRecords;
    //Service execution/invocation results are captured
    global List<COM_ServiceResult> results;
    
    //Result of this query will be batched & will define the scope for execute method
    //private String query;
    //API name for sObjType to be integrated
    private String sObjType;
    //Integration system name
    private String intSystem; 
    private COM_IIntegrationService service;
    private String emailRecipients;
    
    public String getQuery() {
        return this.query;
    }
    public String getSObjType() {
        return this.sObjType;
    }
    public String getIntSystem() {
        return this.intSystem;
    }
    public COM_IIntegrationService getService() {
        return this.service;
    }
    public List<COM_ServiceResult> getResults() {
        return this.results;
    }
    public String getEmailRecipients() {
        return this.emailRecipients;
    }
    public Integer getTotalRecords() {
        return this.totalRecords;
    }
    
    global override void setBatchParameters(String parametersJSON){
        String methodName = 'setBatchParameters';
        LOGGER.entry(methodName);
        List<String> params = (List<String>) Json.deserialize(parametersJSON, List<String>.class);
        this.intSystem = params.get(0);     
        this.sObjType = params.get(1);
        this.emailRecipients = params.get(2);
        this.service = COM_IntegrationFactory.getIntegrationService(getIntSystem(), getSObjType());
        this.query = getService().getProcessingQuery();
        this.totalRecords = 0;
        this.results = new List<COM_ServiceResult>();
        LOGGER.info('Integration system:'+getIntSystem());
        LOGGER.info('sObjType :'+getSObjType());
        LOGGER.info('service:'+getService());
        LOGGER.info('query:'+getQuery());
        LOGGER.info('emailRecipients:'+getEmailRecipients());
        LOGGER.info('totalRecords:'+getTotalRecords());
        LOGGER.info('results:'+getResults());
        LOGGER.exit(methodName);
     }
    
    global override Database.QueryLocator start(Database.BatchableContext BC) {
    	LOGGER.info('Batch:'+BC.getJobId()+' started with query:'+query);
    	getService().prepare();
        return Database.getQueryLocator(query);
    }
    
    global override void execute(Database.BatchableContext BC, List<sObject> scope) {
        String methodName = 'execute';
        LOGGER.entry(methodName);
        LOGGER.info('Executing batch:'+BC.getJobId()+' with record scope:'+scope.size());
        LOGGER.info('scope:'+scope);
        totalRecords += scope.size();
        getResults().add(getService().invoke(scope));
        LOGGER.exit(methodName);
    }
    
    global override void finish(Database.BatchableContext BC) {
        String methodName = 'finish';
        LOGGER.entry(methodName);
        LOGGER.info('Total records processed by batch:'+BC.getJobId()+' : '+getTotalRecords());
        getService().processResult(getResults());
        sendEmail(BC, getResults());
        LOGGER.exit(methodName);
    }
    
    /*
    	Sends email to the job submitter, current user & optionally any configured extra recipients
    */
    private void sendEmail(final Database.BatchableContext BC, final List<COM_ServiceResult> results) {
    	// Get the ID of the AsyncApexJob representing this batch job 
        // from Database.BatchableContext. 
        // Query the AsyncApexJob object to retrieve the current job's information. 
        AsyncApexJob job = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
          TotalJobItems, CreatedBy.Email, ApexClass.Name
          from AsyncApexJob where Id =:BC.getJobId()];
        
        List<String> recipients = getRecipients(job.CreatedBy.Email);
        if(COM_Utils.isNotEmpty(recipients)) {
        	List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		    String emailSubject = 'Job:'+job.Id+' for class:'+job.ApexClass.Name+' and service:'+getService()+' finished with status:'+job.Status;
	        // Send an email notifying of job completion.
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        mail.setToAddresses(recipients);
	        mail.setSaveAsActivity(false);
	        mail.setUseSignature(false);
	        mail.setSubject(emailSubject);
	        mail.setHtmlBody(getEmailBody(results));
	        mails.add(mail);
	        Messaging.sendEmail(mails);
        } else {
        	LOGGER.info('No email recipients found.');
        }
        
    }
    
    /*
    	Email recipients can be set by the scheduler.
    	Additionally, service could also specify additional recipients.
    	recipients could be delimited by comma or semicolon.
    */
    private List<String> getRecipients(final String jobEmail) {
    	List<String> recipients = new List<String>();
    	if(COM_Utils.isNotEmpty(getEmailRecipients())) {
    		if(COM_Utils.isNotEmpty(getEmailRecipients().split(','))) {
        	recipients.addAll(getEmailRecipients().split(','));
	        }
	        if(COM_Utils.isNotEmpty(getEmailRecipients().split(';'))) {
	        	recipients.addAll(getEmailRecipients().split(';'));
	        }
    	}
    	
        if(COM_Utils.isNotEmpty(getService().getEmailRecipients())) {
    		if(COM_Utils.isNotEmpty(getService().getEmailRecipients().split(','))) {
        	recipients.addAll(getService().getEmailRecipients().split(','));
	        }
	        if(COM_Utils.isNotEmpty(getService().getEmailRecipients().split(';'))) {
	        	recipients.addAll(getService().getEmailRecipients().split(';'));
	        }
    	}
        if(COM_Utils.isEmpty(recipients)) {
        	LOGGER.warn('Either no email recipients found or could not parse recipient email. Please verify that emails are separated by comma or semicolon');
        }
        if(COM_Utils.isNotEmpty(Userinfo.getUserEmail())) {
        	recipients.add(Userinfo.getUserEmail());
        }
        if(COM_Utils.isNotEmpty(jobEmail)) {
        	recipients.add(jobEmail);
        }
        LOGGER.info('Sending email to:'+recipients);
    	return recipients;
    }
    
    /*	Generates the Html body
    */
    private String getEmailBody(final List<COM_ServiceResult> results) {
    	String emailBody = '<html><body>';
    	if(COM_Utils.isNotEmpty(results)) {
    		for(COM_ServiceResult result: results) {
    			emailBody += '<br/><br/>';
    			if(COM_Utils.isNotEmpty(result.getErrors())) {
    				emailBody += 'Errors:</br>'+String.valueOf(result.getErrors())+'<br/><br/>';
	    		}
	    		if(COM_Utils.isNotEmpty(result.getRequest())) {
	    			emailBody += 'Request:</br>'+String.valueOf(result.getRequest())+'<br/><br/>';
	    		}
	    		if(COM_Utils.isNotEmpty(result.getResponse())) {
	    			emailBody += 'Response:</br>'+String.valueOf(result.getResponse())+'<br/><br/>';
	    		}
	    		emailBody += '*****************************************';
    		}
    	}
    	emailBody += '<br/><br/>';
    	emailBody += '</body></html>';
    	return emailBody;
    }

}