/**
 * @description Batch class for sending email notifications to a list of contacts.
 * This batch class retrieves contact information and sends email notifications using a specified API endpoint.
 * It logs the status of each email sent and handles exceptions gracefully.
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		29-Apr-2024		Created		This was an initial development.
 * 1.1		Rajaa		03-May-2024		Updated		Code Review Changes.
 */
public with sharing class BI_PSPB_EmailBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    private List<Id> contactIds;
    private String notificationDeveloperName = '';
    private String destUrl = '';
    private String notificationDate = '';
    private List<String> userNames;
    private List<String> patientName;

    /**
     * @description Constructs a new instance of the BI_PSPB_EmailBatch class with the provided parameters.
     *
     * @param params An instance of EmailBatchParams containing the parameters for the email batch.
     *                - contactIds: List of contact IDs to whom the email will be sent.
     *                - notificationDeveloperName: The developer name for the notification.
     *                - destUrl: The destination URL for the notification.
     *                - notificationDate: The date of the notification.
     *                - userNames: List of user names associated with the notification.
     *@param          patientName The name of the patient related to the notification.
     */
	public BI_PSPB_EmailBatch(EmailBatchParams params,List<String> patientName) {
		
		if (validateInputs(params.contactIds, params.notificationDeveloperName, params.destUrl)) {
			this.contactIds = params.contactIds;
			this.notificationDeveloperName = params.notificationDeveloperName;
			this.destUrl = params.destUrl;
			this.notificationDate = params.notificationDate;
			this.userNames = params.userNames;
			this.patientName = patientName;
		} else {
			BI_PSP_LogMessagesUtility.logError(
				BI_PSPB_NotificationConstant.parameterError,
				BI_PSPB_EmailBatch.class.toString(),
				false,
				BI_PSPB_NotificationConstant.logInfo
			);
		}
	}
    /**
     *@description This method checks that the list of contact IDs is not empty and that both the notification developer name and destination URL are not blank.
     *
     * @param contactIds A list of contact IDs that should be checked to ensure it is not empty.
     * @param notificationDeveloperName The notification developer name that should be checked to ensure it is not blank.
     * @param destUrl The destination URL that should be checked to ensure it is not blank.
     * @return A Boolean value indicating whether all input parameters are valid. Returns `true` if all parameters meet the criteria, otherwise returns `false`.
     */
    public Boolean validateInputs(
        List<Id> contactIds,
        String notificationDeveloperName,
        String destUrl
    ) {
        return !contactIds.isEmpty() &&
            !String.isBlank(notificationDeveloperName) &&
            !String.isBlank(destUrl);
    }

    /**
     * @description Returns a Database.QueryLocator instance containing the contacts specified by their IDs.
     *
     * @param context The Database.BatchableContext object containing the execution context.
     * @return A Database.QueryLocator instance containing the contacts to be processed.
     */
    public Iterable<Contact> start(Database.BatchableContext context) {
        try {
          

            // Step 1: Remove duplicate IDs for the SOQL query
            Set<Id> uniqueContactIds = new Set<Id>(contactIds);

            // Query unique records from the database
            List<Contact> contactRecords = [
                SELECT Id, Name, Email
                FROM Contact
                WHERE Id IN :uniqueContactIds
            ];

            

            // Step 2: Map the contacts by their Id
            Map<Id, Contact> contactMap = new Map<Id, Contact>(contactRecords);

            // Step 3: Rebuild the list including duplicates based on original contactIds list
            List<Contact> orderedContacts = new List<Contact>();
            for (Id contactId : contactIds) {
                if (contactMap.containsKey(contactId)) {
                    // Add the contact to the ordered list as many times as it appears in contactIds
                    orderedContacts.add(contactMap.get(contactId));
                } 
            }

      

            // Return the ordered list of contacts including duplicates
            return orderedContacts;
        } catch (Exception ex) {
            BI_PSP_LogMessagesUtility.logError(
                BI_PSPB_NotificationConstant.contactError,
                BI_PSPB_EmailBatch.class.toString(),
                false,
                BI_PSPB_NotificationConstant.severityError
            );
            return null;
        }
    }

    /**
     * @description Executes the batch job processing for sending emails to a list of contacts.
     *
     * @param context The Database.BatchableContext object containing the execution context.
     * @param scope   A list of Contact records representing the contacts to which emails will be sent.
     */
    
	public void execute(
		Database.BatchableContext context,
		List<Contact> scope
	) {
		if (scope.isEmpty()) {
			logError(BI_PSPB_NotificationConstant.errorReturning);
			return;
		}
	
		List<BI_PSPB_OmnichannelLog__c> emailLogList = new List<BI_PSPB_OmnichannelLog__c>();
	
		try {
			BI_PSPB_Notification__mdt filteredNotifications = getFilteredNotifications();
			BI_PSPB_PrivacyPolicy__mdt privacyPolicyList = getPrivacyPolicyList();
	
			List<Map<Contact, Map<String, String>>> contactPatientMapList = prepareContactPatientMap(scope);
	
			processContacts(contactPatientMapList, filteredNotifications, privacyPolicyList, emailLogList);
	
			if (!emailLogList.isEmpty()) {
				saveEmailLogs(emailLogList);
			} else {
				logError(BI_PSPB_NotificationConstant.errorReturning);
			}
		} catch (Exception ex) {
			logError(BI_PSPB_NotificationConstant.httpResponseError);
		}
	}
	
	private void logError(String errorMessage) {
		BI_PSP_LogMessagesUtility.logError(
			errorMessage,
			BI_PSPB_EmailBatch.class.toString(),
			false,
			BI_PSPB_NotificationConstant.severityError
		);
	}
	
	private BI_PSPB_Notification__mdt getFilteredNotifications() {
		return BI_PSPB_Notification__mdt.getInstance(notificationDeveloperName);
	}
	
	private BI_PSPB_PrivacyPolicy__mdt getPrivacyPolicyList() {
		return BI_PSPB_PrivacyPolicy__mdt.getInstance(BI_PSPB_NotificationConstant.privacyPolicyUrl);
	}
	
	private List<Map<Contact, Map<String, String>>> prepareContactPatientMap(List<Contact> scope) {
		List<Map<Contact, Map<String, String>>> contactPatientMapList = new List<Map<Contact, Map<String, String>>>();
		Integer userNameIndex = 0;
		Integer patientNameIndex = 0;
	
		for (Contact targetContact : scope) {
			Map<Contact, Map<String, String>> contactMap = new Map<Contact, Map<String, String>>();
			Map<String, String> nameMapping = new Map<String, String>();
	
			if (userNameIndex < userNames.size()) {
				nameMapping.put('UserName', userNames[userNameIndex]);
				userNameIndex++;
			}
	
			if (patientNameIndex < patientName.size()) {
				nameMapping.put('PatientName', patientName[patientNameIndex]);
				patientNameIndex++;
			}
	
			contactMap.put(targetContact, nameMapping);
			contactPatientMapList.add(contactMap);
		}
		return contactPatientMapList;
	}
	
	private void processContacts(
		List<Map<Contact, Map<String, String>>> contactPatientMapList,
		BI_PSPB_Notification__mdt filteredNotifications,
		BI_PSPB_PrivacyPolicy__mdt privacyPolicyList,
		List<BI_PSPB_OmnichannelLog__c> emailLogList
	) {
		for (Map<Contact, Map<String, String>> contactMap : contactPatientMapList) {
			for (Contact contact : contactMap.keySet()) {
				Map<String, String> nameMapping = contactMap.get(contact);
	
				String userName = nameMapping.containsKey('UserName') ? nameMapping.get('UserName') : null;
				String patientName = nameMapping.containsKey('PatientName') ? nameMapping.get('PatientName') : null;
	
				String payload = createEmailPayload(contact, patientName, userName, filteredNotifications, privacyPolicyList);
				sendEmailAndLogResult(payload, contact, filteredNotifications, emailLogList);
			}
		}
	}
	
    /**
     * @description Creates the email payload JSON string for the specified contact and notification settings.
     *
     * @param targetContact The Contact object that contains the recipient's name and email.
     * @param patientName The name of the patient associated with the notification.
	 * @param userNameCom  The use of Community User Name .
     * @param notifications The BI_PSPB_Notification__mdt custom metadata type that contains notification details such as subject and template ID.
     * @param privacyPolicy The BI_PSPB_PrivacyPolicy__mdt custom metadata type that contains privacy policy URLs.
	 
     * @return A JSON string representing the email payload, including recipient details and notification content.
     */
    public String createEmailPayload(
        Contact targetContact,
        string patientName,
        String userNameCom,
        BI_PSPB_Notification__mdt notifications,
        BI_PSPB_PrivacyPolicy__mdt privacyPolicy
    ) {
        String userName = targetContact.Name;
        String userEmail = targetContact.Email;
        
        return '{' +
            '"emailId": "' +
            userEmail +
            '",' +
            '"body": {' +
            '"firstname": "' +
            userName +
            '",' +
            (!String.isEmpty(patientName) // Check if patientName is not empty
                ? '"patientname": "' + patientName + '",'
                : '') +
            '"ubi-pspb-unsubscribe": "' +
            privacyPolicy.BI_PSPB_Url__c +
            '",' +
            '"ubi-pspb-termsofuse": "' +
            privacyPolicy.BI_PSPB_TermsofuseUrlEndPoint__c +
            '",' +
            '"ubi-pspb-privacynotice": "' +
            privacyPolicy.BI_PSPB_PrivacyPolicyUrlEndpoint__c +
            '",' +
            '"Username": "' +
            userNameCom +
            '",' +
            (!String.isEmpty(notificationDate) // Check if notificationDate is not empty
                ? '"date": "' + notificationDate + '",'
                : '') +
            '"url": "' +
            destUrl +
            '"' +
            '},' +
            '"subject": "' +
            notifications.BI_PSPB_Subject__c +
            '",' +
            '"templateID": "' +
            notifications.BI_PSPB_TemplateId__c +
            '"' +
            '}';
    }

    /**
     * @description Sends an email using the provided payload and logs the result in the Omnichannel email log.
     *
     * @param payload The JSON string containing the email payload to be sent.
     * @param contact The Contact object representing the recipient of the email.
     * @param notifications The BI_PSPB_Notification__mdt custom metadata type containing notification settings.
     * @param emailLogList A list of BI_PSPB_OmnichannelLog__c objects for logging the result of the email send operation.
     */
    public static void sendEmailAndLogResult(
        String payload,
        Contact contact,
        BI_PSPB_Notification__mdt notifications,
        List<BI_PSPB_OmnichannelLog__c> emailLogList
    ) {
        BI_PSPB_OmnichannelSetting__mdt filteredSettings = BI_PSPB_OmnichannelSetting__mdt.getInstance(
            BI_PSPB_NotificationConstant.endPoint
        );
        String omnichannel = filteredSettings.BI_PSPB_omnichannelentapi__c;
        String country = filteredSettings.BI_PSPB_Country__c;
        String configItem = filteredSettings.BI_PSPB_configItem__c;

        HttpRequest request = new HttpRequest();
        request.setEndpoint(
            'callout:BI_PSPB_OmnichannelEndpoint' +
                omnichannel +
                country +
                configItem
        );
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        request.setBody(payload);

        Http http = new Http();
        HttpResponse response = http.send(request);

        handleEmailResponse(response, contact, notifications, emailLogList);
    }

    /**
     * @description Handles the HTTP response from the email send request, logs the email result, and captures any errors.
     *
     * @param response The HttpResponse object received from the email send request.
     * @param contact The Contact object representing the recipient of the email.
     * @param notifications The BI_PSPB_Notification__mdt custom metadata type containing notification settings.
     * @param emailLogList A list of BI_PSPB_OmnichannelLog__c objects for logging the result of the email send operation.
     */
    public static void handleEmailResponse(
        HttpResponse response,
        Contact contact,
        BI_PSPB_Notification__mdt notifications,
        List<BI_PSPB_OmnichannelLog__c> emailLogList
    ) {
        Integer responseCode = response.getStatusCode();
        Boolean emailResponse = responseCode == 200;

        Map<String, Object> jsonResponse = emailResponse
            ? (Map<String, Object>) JSON.deserializeUntyped(response.getBody())
            : null;
        String status = jsonResponse != null
            ? (String) jsonResponse.get('status')
            : 'Failed';
        String messageId = jsonResponse != null
            ? (String) jsonResponse.get('messageId')
            : '';

        EmailLogWrapper logWrapper = new EmailLogWrapper(
            contact,
            notifications,
            status,
            messageId,
            responseCode
        );

        // Use createEmailLog to create the log record and add it to the list
        BI_PSPB_OmnichannelLog__c emailLog = createEmailLog(logWrapper);
        if (emailLog != null) {
            emailLogList.add(emailLog);
        }

        if (!emailResponse) {
            BI_PSP_LogMessagesUtility.logError(
                BI_PSPB_NotificationConstant.httpResponseError,
                BI_PSPB_EmailBatch.class.toString(),
                false,
                BI_PSPB_NotificationConstant.severityError
            );
        }
    }

    /**
     * @description Creates a BI_PSPB_OmnichannelLog__c record from the EmailLogWrapper instance.
     *
     * @param logWrapper The EmailLogWrapper instance containing the log details.
     * @return A BI_PSPB_OmnichannelLog__c record with the log details.
     */
    public static BI_PSPB_OmnichannelLog__c createEmailLog(
        EmailLogWrapper logWrapper
    ) {
        BI_PSPB_OmnichannelLog__c emailLog = new BI_PSPB_OmnichannelLog__c();
        emailLog.BI_PSPB_ContactName__c = logWrapper.contact.Id;
        emailLog.BI_PSPB_UserEmail__c = logWrapper.contact.Email;
        emailLog.BI_PSPB_Subject__c = logWrapper.notifications.BI_PSPB_Subject__c;
        emailLog.BI_PSPB_Body__c = logWrapper.notifications.BI_PSPB_EmailBody__c;
        emailLog.BI_PSPB_EventName__c = logWrapper.notifications.BI_PSPB_EventName__c;
        emailLog.BI_PSPB_EventType__c = logWrapper.notifications.BI_PSPB_EventType__c;
        emailLog.BI_PSPB_TemplateId__c = logWrapper.notifications.BI_PSPB_TemplateId__c;
        emailLog.BI_PSPB_Status__c = logWrapper.status;
        emailLog.BI_PSPB_EmailMessageId__c = logWrapper.messageId;
        emailLog.BI_PSPB_StatusResponse__c = String.valueOf(
            logWrapper.responseCode
        );
        return emailLog;
    }

    /**
     * @description Saves a list of BI_PSPB_OmnichannelLog__c records to the database.
     *
     * @param emailLogList A list of BI_PSPB_OmnichannelLog__c objects to be inserted.
     */
    public static void saveEmailLogs(
        List<BI_PSPB_OmnichannelLog__c> emailLogList
    ) {
        try {
            BI_PSP_DatabaseOperationsUtility.insertOperation(
                emailLogList,
                BI_PSPB_EmailBatch.class.toString(),
                false
            );
        } catch (Exception ex) {
            BI_PSP_LogMessagesUtility.logError(
                BI_PSPB_NotificationConstant.httpResponseError,
                BI_PSPB_EmailBatch.class.toString(),
                false,
                BI_PSPB_NotificationConstant.severityError
            );
        }
    }

    /**
     * @description The finish method is called after all the batch processes are complete.
     *
     * @param context The Database.BatchableContext object containing the execution context.
     */
    public void finish(Database.BatchableContext context) {
        BI_PSP_LogMessagesUtility.logError(
            BI_PSPB_NotificationConstant.finish,
            BI_PSPB_EmailBatch.class.toString(),
            false,
            BI_PSPB_NotificationConstant.logInfo
        );
    }

    /**
     * @description A wrapper class to encapsulate email log details.
     */
    public class EmailLogWrapper {
        public Contact contact;
        public BI_PSPB_Notification__mdt notifications;
        public String status;
        public String messageId;
        public Integer responseCode;
        /**
         * @description Constructs a new instance of the EmailLogWrapper class.
         *
         * @param contact The contact associated with the email log.
         * @param notifications The notification settings used for the email.
         * @param status The status of the email.
         * @param messageId The message ID of the email.
         * @param responseCode The response code from the email service.
         */

        public EmailLogWrapper(
            Contact contact,
            BI_PSPB_Notification__mdt notifications,
            String status,
            String messageId,
            Integer responseCode
        ) {
            this.contact = contact;
            this.notifications = notifications;
            this.status = status;
            this.messageId = messageId;
            this.responseCode = responseCode;
        }
    }

    /**
     * Parameters for configuring an email batch.
     *
     * @description This class encapsulates the details required for creating an email batch, including contact IDs, notification details, and associated user and patient information.
     */
    public class EmailBatchParams {
        /**
         *@description  List of contact IDs to whom the email will be sent.
         */
        @AuraEnabled
        public List<Id> contactIds { get; set; }
        /**
         *@description  The developer name for the notification.
         */
        @AuraEnabled
        public String notificationDeveloperName { get; set; }
        /**
         *@description  The destination URL for the notification.
         */
        @AuraEnabled
        public String destUrl { get; set; }
        /**
         *@description  The date of the notification.
         */
        @AuraEnabled
        public String notificationDate { get; set; }
        /**
         *@description  List of user names associated with the notification.
         */
        @AuraEnabled
        public List<String> userNames { get; set; }
        
        /**
         *@description Constructor to initialize EmailBatchParams with the given values.
         *
         * @param contactIds List of contact IDs to whom the email will be sent.
         * @param notificationDeveloperName The developer name for the notification.
         * @param destUrl The destination URL for the notification.
         * @param notificationDate The date of the notification.
         * @param userNames List of user names associated with the notification.
         */
        public EmailBatchParams(
            List<Id> contactIds,
            String notificationDeveloperName,
            String destUrl,
            String notificationDate,
            List<String> userNames
        ) {
            this.contactIds = contactIds;
            this.notificationDeveloperName = notificationDeveloperName;
            this.destUrl = destUrl;
            this.notificationDate = notificationDate;
            this.userNames = userNames;
           
        }
    }
}