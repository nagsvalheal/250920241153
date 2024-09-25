/**
 * @description  This class is used to create tasks when a video is uploaded.
 * It also handles calling methods to send SMS and email notifications.
 * History
 * Version	Author			Date		Detail		Description
 * 1.0		Niyas		24-07-2024		Created		Refactored Version
 */
public class BI_PSPB_SendTreatmentNotifyCtrl {
	/**
	 * @description  Sends notifications based on the provided list of treatment reminders and the
	 *                configured reminder days. This method processes each reminder, determines the
	 *                appropriate timing and recipients for the notifications, and sends the notifications
	 *                accordingly.
	 * @param reminders A list of BI_PSPB_Treatment_Reminder__c records representing the treatment reminders
	 *                  for which notifications need to be sent. Each reminder contains details that determine
	 *                  the content and recipients of the notifications.
	 * @param daysCount An instance of BI_PSPB_TreatmentReminderDaysCtrl that defines the configuration for
	 *                  reminder days, including how many days in advance or past due the notifications
	 *                  should be sent.
	 */
	public static void sendNotifications(
		List<BI_PSPB_Treatment_Reminder__c> reminders,
		BI_PSPB_TreatmentReminderDaysCtrl daysCount
	) {
		try {
			if (reminders.isEmpty() || daysCount == null) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSPB_NotificationConstant.errorMsgRecordNotFound,
					BI_PSPB_SendTreatmentNotifyCtrl.class.toString(),
					false,
					BI_PSPB_NotificationConstant.severityError
				);
				return;
			}
			Map<Integer, List<Id>> enrolleeIdMap = new Map<Integer, List<Id>>{
				daysCount.before1Day => new List<Id>(),
				daysCount.before3Day => new List<Id>(),
				daysCount.before7Day => new List<Id>(),
				daysCount.before10Day => new List<Id>(),
				daysCount.before14Day => new List<Id>()
			};
			String formattedDate;
			Datetime treatmentDate;
			for (BI_PSPB_Treatment_Reminder__c reminder : reminders) {
				Integer daysDifference = reminder.BI_PSPB_Reminder_Date__c.daysBetween(
					reminder.BI_PSPB_Date_of_Treatment__c
				);
				if (enrolleeIdMap.containsKey(daysDifference)) {
					treatmentDate = Date.today().addDays(3);
					formattedDate = treatmentDate.format('dd/MM/yyyy');
					enrolleeIdMap.get(daysDifference)
						.add(reminder.BI_PSPB_Care_Program_Enrollee__c);
				}
			}

			handleTriggers(enrolleeIdMap, daysCount, formattedDate);
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				ex.getMessage(), BI_PSPB_SendTreatmentNotifyCtrl.class.toString(), ex
			);
		}
	}
	/**
	 * @description Triggering another method for each dates.
	 * @param enrolleeIdMap Map of dates and enrollee ids.
	 * @param daysCount Count of days to send notifications.
	 * @param formattedDate Date to be sent for notification.
	 */
	public static void handleTriggers(
		Map<Integer, List<Id>> enrolleeIdMap,
		BI_PSPB_TreatmentReminderDaysCtrl daysCount,
		String formattedDate
	) {
		try {
			if (enrolleeIdMap == null || daysCount == null) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSPB_NotificationConstant.errorMsgRecordNotFound, BI_PSPB_SendTreatmentNotifyCtrl.class.toString(),
					true, BI_PSPB_NotificationConstant.severityError
				);
				return;
			}
            String formattedDateOne;
			Datetime treatmentDateOne;
            String formattedDateThree;
			Datetime treatmentDateThree;
            treatmentDateOne = Date.today().addDays(1);
			formattedDateOne = treatmentDateOne.format('dd/MM/yyyy');
            treatmentDateThree = Date.today().addDays(3);
			formattedDateThree = treatmentDateThree.format('dd/MM/yyyy');
			triggerNotification(
				enrolleeIdMap.get(daysCount.before1Day),
				BI_PSPB_NotificationConstant.treatmentOne,
				formattedDateOne
			);
			triggerNotification(
				enrolleeIdMap.get(daysCount.before3Day),
				BI_PSPB_NotificationConstant.treatmentThree,
				formattedDateThree
			);
			triggerNotification(
				enrolleeIdMap.get(daysCount.before7Day),
				BI_PSPB_NotificationConstant.treatmentSeven,
				''
			);
			triggerNotification(
				enrolleeIdMap.get(daysCount.before10Day),
				BI_PSPB_NotificationConstant.treatmentTen,
				''
			);
			triggerNotification(
				enrolleeIdMap.get(daysCount.before14Day),
				BI_PSPB_NotificationConstant.treatmentFourteen,
				''
			);
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				ex.getMessage(), BI_PSPB_SendTreatmentNotifyCtrl.class.getName(), ex
			);
		}
	}
	/**
	 * @description Triggers methods for each notification based on days count.
	 * @param enrolleeIds Enrollee Ids to send notifications.
	 * @param treatmentType Type of the treatment to trigger.
	 * @param formattedDate Date to be sent for notification.
	 */
	public static void triggerNotification(
		List<Id> enrolleeIds,
		String treatmentType,
		String formattedDate
	) {
			if (!enrolleeIds.isEmpty()) {
				BI_PSPB_NotificationTemplatesCtrl.handleTrigger(
					enrolleeIds,
					treatmentType,
					new List<String>{ '' },
					formattedDate
				);
				return;
			}
	}
}