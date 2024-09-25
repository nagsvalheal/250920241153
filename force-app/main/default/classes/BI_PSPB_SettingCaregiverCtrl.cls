/**
* @description  Manages notification settings, including creating tasks
*                when videos are uploaded, and sending SMS and email
*                notifications.
* History
* Version	Author			Date		Detail		Description
* 1.0		Niyas		24-07-2024		Created		Refactored Version
*/
public with sharing class BI_PSPB_SettingCaregiverCtrl {
	/**
	 * @description Handles to add contacts to send notification.
	 * @param accountToNotificationsMap To get notification setting
	 * @param enrollees For the enrollees to send.
	 * @param emailList List of ids to send email.
	 * @param smsList List of ids to send sms.
	 */
public static void addContactsToSendCaregiver(
		Map<Id, List<BI_PSP_Notification_Setting__c>> accountToNotificationsMap,
		List<CareProgramEnrollee> enrollees,
		List<Id> emailList,
		List<Id> smsList
	) {
		try {
			Set<Id> careids = new Set<Id>();
			for (CareProgramEnrollee enrollee : enrollees) {
				careids.add(enrollee.Id);
			}

			// Formulate SOQL query conditions
			String fields = 'Id, BI_PSPB_Care_Program_Enrollee__r.Id, BI_PSPB_Patient__r.BI_PSP_Birthdate__c, BI_PSPB_Patient__r.PersonContactId, BI_PSPB_Caregiver__r.PersonContactId, BI_PSPB_Caregiver__c';
			String conditionIds =
				'(\'' +
				String.join(careids, '\', \'') +
				'\')';
			String conditions =
				'BI_PSPB_Care_Program_Enrollee__c IN ' + conditionIds;

			// Execute the query
			List<SObject> caregivers = BI_PSP_CommonQueryUtility.executeQuery(
				'BI_PSPB_Enrollee_Caregiver__c',
				fields,
				conditions,
				false
			);

			// Process caregivers
			for (SObject caregiver : caregivers) {
				Id patientId = (Id) caregiver.getSObject('BI_PSPB_Caregiver__r')
					.get('Id');
				processCaregiverNotifications(
					accountToNotificationsMap.get(patientId),
					(Id) caregiver.getSObject('BI_PSPB_Caregiver__r')
						.get('PersonContactId'),
					emailList,
					smsList
				);
			}
		} catch (Exception ex) {
			logException(ex);
		}
	}
	/**
	 * @description Handles to add contacts to send notification.
	 * @param notifications To get notification setting
	 * @param personContactId For the contacts to send.
	 * @param emailList List of ids to send email.
	 * @param smsList List of ids to send sms.
	 */
    public static void processCaregiverNotifications(
		List<BI_PSP_Notification_Setting__c> notifications,
		Id personContactId,
		List<Id> emailList,
		List<Id> smsList
	) {
		try {
			if (notifications.isEmpty()) {
				logError(BI_PSPB_NotificationConstant.errorMsgRecordNotFound);
				return;
			}

			for (BI_PSP_Notification_Setting__c notification : notifications) {
				processIndividualCaregiverNotification(
					notification,
					personContactId,
					emailList,
					smsList
				);
			}
		} catch (Exception ex) {
			logError(BI_PSPB_NotificationConstant.errorMsgRecordNotFound);
		}
	}

	private static void processIndividualCaregiverNotification(
		BI_PSP_Notification_Setting__c notification,
		Id personContactId,
		List<Id> emailList,
		List<Id> smsList
	) {
		try {
			if (notification == null) {
				logError(BI_PSPB_NotificationConstant.errorMsgRecordNotFound);
				return;
			}

			if (notification.BI_PSP_Email__c) {
				emailList.add(personContactId);
			}
			if (notification.BI_PSP_SMS__c) {
				smsList.add(personContactId);
			}
		} catch (Exception ex) {
			logException(ex);
		}
	}

	private static void logException(Exception ex) {
		BI_PSP_LogMessagesUtility.exceptionLogMessage(
			ex.getMessage(),
			BI_PSPB_SettingCaregiverCtrl.class.getName(),
			ex
		);
	}
    private static void logError(String errorMessage) {
		BI_PSP_LogMessagesUtility.logError(
			errorMessage,
			BI_PSPB_SettingCaregiverCtrl.class.toString(),
			false,
			BI_PSPB_NotificationConstant.severityError
		);
	}
    	/**
	 * @description  Retrieves a map of caregiver IDs to their associated notification settings based on
	 *                the specified notification type. This method queries the notification settings for
	 *                caregivers related to the provided accounts and returns a map where each key is a
	 *                caregiver ID and each value is a list of BI_PSP_Notification_Setting__c records relevant
	 *                to that caregiver.
	 * @param accountRec A list of account IDs associated with caregivers for which the notification settings
	 *                   are to be retrieved.
	 * @param notificationType A string specifying the type of notifications to filter by. This determines
	 *                         which settings are included in the results for each caregiver.
	 * @return Map<Id, List<BI_PSP_Notification_Setting__c>> A map where each key is a caregiver ID, and each value is a list of BI_PSP_Notification_Setting__c
	 *         records representing the notification settings associated with that caregiver for the specified
	 *         notification type.
	 */
	public static Map<Id, List<BI_PSP_Notification_Setting__c>> getCaregiverToNotificationsMap(
    List<Id> accountRec,
    String notificationType
) {
    Map<Id, List<BI_PSP_Notification_Setting__c>> accountToNotificationsMap = new Map<Id, List<BI_PSP_Notification_Setting__c>>();
    
    if (accountRec.isEmpty()) {
        return accountToNotificationsMap; // Return an empty map if input list is empty
    }
    
    try {
        String conditionIds = buildConditionIds(accountRec);
        List<BI_PSP_Notification_Setting__c> results = queryNotificationSettings(conditionIds, notificationType);
        
        if (results.isEmpty()) {
            logRecordNotFound();
        } else {
            processNotificationSettings(results, accountToNotificationsMap);
        }
    } catch (Exception ex) {
        BI_PSP_LogMessagesUtility.exceptionLogMessage(
            ex.getMessage(),
            BI_PSPB_SettingCaregiverCtrl.class.getName(),
            ex
        );
    }
    
    return accountToNotificationsMap;
}

// Helper Method to build condition string for the query
private static String buildConditionIds(List<Id> accountRec) {
    return '(\'' + String.join(accountRec, '\', \'') + '\')';
}

// Helper Method to query notification settings
private static List<BI_PSP_Notification_Setting__c> queryNotificationSettings(
    String conditionIds, String notificationType
) {
    String fields = 'Id, BI_PSP_Enrollee__c, BI_PSP_Patient__c, BI_PSP_Patient__r.BI_PSP_Birthdate__c, BI_PSP_Patient__r.PersonContactId, BI_PSP_SMS__c, BI_PSP_Email__c, BI_PSP_Notification_Type__c, BI_PSPB_Caregiver__c';
    String conditions = 'BI_PSPB_Caregiver__c IN ' + conditionIds + ' AND BI_PSP_Notification_Type__c = \'' + notificationType + '\'';
    
    return (List<BI_PSP_Notification_Setting__c>) BI_PSP_CommonQueryUtility.executeQuery(
        'BI_PSP_Notification_Setting__c',
        fields,
        conditions,
        false
    );
}

// Helper Method to process notification settings and populate the map
private static void processNotificationSettings(
    List<BI_PSP_Notification_Setting__c> settings,
    Map<Id, List<BI_PSP_Notification_Setting__c>> accountToNotificationsMap
) {
    for (BI_PSP_Notification_Setting__c setting : settings) {
        try {
            if (setting.BI_PSPB_Caregiver__c != null) {
                if (!accountToNotificationsMap.containsKey(setting.BI_PSPB_Caregiver__c)) {
                    accountToNotificationsMap.put(setting.BI_PSPB_Caregiver__c, new List<BI_PSP_Notification_Setting__c>());
                }
                accountToNotificationsMap.get(setting.BI_PSPB_Caregiver__c).add(setting);
            } else {
                logRecordNotFound();
            }
        } catch (Exception ex) {
            BI_PSP_LogMessagesUtility.exceptionLogMessage(
                ex.getMessage(),
                BI_PSPB_SettingCaregiverCtrl.class.getName(),
                ex
            );
        }
    }
}

// Helper Method to log error for record not found
private static void logRecordNotFound() {
    BI_PSP_LogMessagesUtility.logError(
        BI_PSPB_NotificationConstant.errorMsgRecordNotFound,
        BI_PSPB_SettingCaregiverCtrl.class.toString(),
        false,
        BI_PSPB_NotificationConstant.severityError
    );
}
}