/**
 * @description   Handles the creation of tasks when a video is uploaded,
 *                and calls methods to send SMS and email notifications.
 * History
 * Version	Author			Date		Detail		Description
 * 1.0		Niyas		24-07-2024		Created		Refactored Version
 */
public with sharing class BI_PSPB_NotificationSettingsCtrl {
	/**
	 * @description  Handles the trigger to send notifications based on the
	 *                provided criteria. Retrieves notification details,
	 *                filters and adds contacts, and sends SMS and emails.
	 * @param accountToNotificationsMap The ID of the record related to the treatment reminders.
	 * @param enrollees The type of reminder to filter by.
	 * @param emailList The type of reminder to filter by.
	 * @param smsList The type of reminder to filter by.
	 */
	public static void addContactsToSend(
		Map<Id, List<BI_PSP_Notification_Setting__c>> accountToNotificationsMap,
		List<CareProgramEnrollee> enrollees,
		List<Id> emailList,
		List<Id> smsList
	) {
		try {
			Set<Id> careids = new Set<Id>();
			for (CareProgramEnrollee enrollee : enrollees) {
				Date birthdate = enrollee.Account.BI_PSP_Birthdate__c;
				Integer age = BI_PSPB_EnrolleeQueryHelper.getAge(birthdate);
				if (BI_PSPB_EnrolleeQueryHelper.isLegalAge(age)) {
					processNotifications(
						accountToNotificationsMap.get(enrollee.Id),
						enrollee.Account.PersonContactId,
						emailList,
						smsList
					);
				}
				careids.add(enrollee.Id);
			}
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				ex.getMessage(),
				BI_PSPB_SmsEmailNotificationHelper.class.getName(),
				ex
			);
		}
	}

	/**
	 * @description  Retrieves treatment reminders based on the given criteria.
	 * @param notifications The ID of the record related to the treatment reminders.
	 * @param personContactId The type of reminder to filter by.
	 * @param emailList The type of reminder to filter by.
	 * @param smsList The type of reminder to filter by.
	 */
	public static void processNotifications(
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
				processIndividualNotification(
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

	private static void processIndividualNotification(
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
			logError(BI_PSPB_NotificationConstant.errorMsgRecordNotFound);
		}
	}

	private static void logError(String errorMessage) {
		BI_PSP_LogMessagesUtility.logError(
			errorMessage,
			BI_PSPB_SmsEmailNotificationHelper.class.toString(),
			false,
			BI_PSPB_NotificationConstant.severityError
		);
	}

	private static void logException(Exception ex) {
		BI_PSP_LogMessagesUtility.exceptionLogMessage(
			ex.getMessage(),
			BI_PSPB_SmsEmailNotificationHelper.class.getName(),
			ex
		);
	}

	/**
	 * @description  Retrieves the URL for the given notification details.
	 * @param notificationDetails The ID of the record related to the treatment reminders.
	 * @return A list of BI_PSPB_Treatment_Reminder__c objects that match the criteria.
	 */
	public static String getNotificationUrl(
		BI_PSPB_SmsAndEmailNotificationCtrl notificationDetails
	) {
		BI_PSPB_Notification__mdt filteredNotifications = BI_PSPB_Notification__mdt.getInstance(
			BI_PSPB_NotificationConstant.siteUrl
		);
		String bDestUrl = filteredNotifications.BI_PSPB_BrandedUrl__c;
		return bDestUrl + notificationDetails.urlPage;
	}
	/**
	 * @description  Retrieves a map of account IDs to their associated notification settings based on
	 *                the specified notification type. This method queries the notification settings for
	 *                each account and returns a map where each key is an account ID and each value is a
	 *                list of BI_PSP_Notification_Setting__c records relevant to that account.
	 * @param accountRec A list of account IDs for which the notification settings are to be retrieved.
	 * @param notificationType A string specifying the type of notifications to filter by. This determines
	 *                         which settings are included in the results.
	 * @return A map where each key is an account ID from the accountRec list, and each value is a list
	 *         of BI_PSP_Notification_Setting__c records representing the notification settings associated
	 *         with that account for the specified notification type.
	 */
	public static Map<Id, List<BI_PSP_Notification_Setting__c>> getAccountToNotificationsMap(
    List<Id> accountRec,
    String notificationType
) {
    Map<Id, List<BI_PSP_Notification_Setting__c>> accountToNotificationsMap = new Map<Id, List<BI_PSP_Notification_Setting__c>>();

    if (accountRec.isEmpty()) {
        return accountToNotificationsMap; // Return an empty map if input list is empty
    }

    try {
        // Build condition string for the query
        String conditionIds = buildPatientConditionIds(accountRec);

        // Query notification settings
        List<BI_PSP_Notification_Setting__c> results = queryPatientNotificationSettings(conditionIds, notificationType);

        if (results.isEmpty()) {
            logRecordNotFound();
        } else {
            // Process notification settings
            processPatientNotificationSettings(results, accountToNotificationsMap);
        }
    } catch (Exception ex) {
        logException(ex);
    }

    return accountToNotificationsMap;
}

// Helper method to build condition string for the query
private static String buildPatientConditionIds(List<Id> accountRec) {
    return '(\'' + String.join(accountRec, '\', \'') + '\')';
}
// Helper method to query notification settings
private static List<BI_PSP_Notification_Setting__c> queryPatientNotificationSettings(
    String conditionIds, String notificationType
) {
    String fields = 'Id, BI_PSP_Enrollee__c, BI_PSP_Patient__c, BI_PSP_Patient__r.BI_PSP_Birthdate__c, BI_PSP_Patient__r.PersonContactId, BI_PSP_SMS__c, BI_PSP_Email__c, BI_PSP_Notification_Type__c';
    String conditions = 'BI_PSP_Enrollee__c IN ' + conditionIds + ' AND BI_PSP_Notification_Type__c = \'' + notificationType + '\'';

    return (List<BI_PSP_Notification_Setting__c>) BI_PSP_CommonQueryUtility.executeQuery(
        'BI_PSP_Notification_Setting__c',
        fields,
        conditions,
        false
    );
}

// Helper method to process notification settings and populate the map
private static void processPatientNotificationSettings(
    List<BI_PSP_Notification_Setting__c> settings,
    Map<Id, List<BI_PSP_Notification_Setting__c>> accountToNotificationsMap
) {
    for (BI_PSP_Notification_Setting__c setting : settings) {
        try {
            if (setting.BI_PSP_Enrollee__c != null) {
                if (!accountToNotificationsMap.containsKey(setting.BI_PSP_Enrollee__c)) {
                    accountToNotificationsMap.put(setting.BI_PSP_Enrollee__c, new List<BI_PSP_Notification_Setting__c>());
                }
                accountToNotificationsMap.get(setting.BI_PSP_Enrollee__c).add(setting);
            } else {
                logRecordNotFound();
            }
        } catch (Exception ex) {
            logException(ex);
        }
    }
}

	
// Helper Method to log error for record not found
private static void logRecordNotFound() {
    BI_PSP_LogMessagesUtility.logError(
        BI_PSPB_NotificationConstant.errorMsgRecordNotFound,
        BI_PSPB_NotificationSettingsCtrl.class.toString(),
        false,
        BI_PSPB_NotificationConstant.severityError
    );
}

}