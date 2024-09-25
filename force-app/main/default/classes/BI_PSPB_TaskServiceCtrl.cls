/**
 * @description Service class used to trigger and send notifications for
 * treatment reminders.
 * History
 * Version	Author		Date		Detail		Description
 * 1.0		Niyas		24-07-2024	Created		Refactored Version
 */
public with sharing class BI_PSPB_TaskServiceCtrl {
/**
 * @description  Creates a Task for treatment reminders based on the
 * specified criteria.
 * @param reminder The ID of the record related to the treatment reminders.
 * @param daysDifference The type of reminder to filter by.
 * @param daysCount The type of reminder to filter by.
 * @return A list of BI_PSPB_Treatment_Reminder__c objects that match the criteria.
 */
public static Task createTask(
	BI_PSPB_Treatment_Reminder__c reminder,
	Integer daysDifference,
	BI_PSPB_TreatmentReminderDaysCtrl daysCount
) {
	List<Task> tasks = new List<Task>();
		String subject;
		String category;
		String notificationType;
		String status;
		String formattedDate;
		Datetime treatmentDate;

		if (daysDifference == daysCount.before1Day) {
			treatmentDate = reminder.BI_PSPB_Date_of_Treatment__c;
			formattedDate = treatmentDate.format('MM/dd/yyyy');
			subject =
				BI_PSPB_NotificationConstant.oneDayBeforeSubject +
				' ' +
				formattedDate;
			notificationType = BI_PSPB_NotificationConstant.actionTypeGeneral;
			status = BI_PSPB_NotificationConstant.actionTypeUnRead;
			category = BI_PSPB_NotificationConstant.actionTypeTreatment;
		} else if (daysDifference == daysCount.before3Day) {
			treatmentDate = reminder.BI_PSPB_Date_of_Treatment__c;
			formattedDate = treatmentDate.format('MM/dd/yyyy');
			subject =
				BI_PSPB_NotificationConstant.threeDayBeforeSubject +
				' ' +
				formattedDate;
			notificationType = BI_PSPB_NotificationConstant.actionTypeGeneral;
			status = BI_PSPB_NotificationConstant.actionTypeUnRead;
			category = BI_PSPB_NotificationConstant.actionTypeTreatment;
		} else if (daysDifference == daysCount.before7Day) {
			subject = BI_PSPB_NotificationConstant.sevenDayBeforeSubject;
			notificationType = BI_PSPB_NotificationConstant.actionTypeAction;
			status = BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction;
			category = BI_PSPB_NotificationConstant.actionTypePrescription;
		} else if (daysDifference == daysCount.before10Day) {
			subject = BI_PSPB_NotificationConstant.tenDayBeforeSubject;
			notificationType = BI_PSPB_NotificationConstant.actionTypeAction;
			status = BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction;
			category = BI_PSPB_NotificationConstant.actionTypePrescription;
		} else if (daysDifference == daysCount.before14Day) {
			subject = BI_PSPB_NotificationConstant.fourteenDayBeforeSubject;
			notificationType = BI_PSPB_NotificationConstant.actionTypeAction;
			status = BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction;
			category = BI_PSPB_NotificationConstant.actionTypePrescription;
		} else {
			return null;
		}

		BI_PSPB_TaskParameters params = new BI_PSPB_TaskParameters(
			subject,
			notificationType,
			category,
			'',
			status
		);
		tasks = BI_PSPB_TaskCreationCtrl.createTasks(
			new List<Id>{ reminder.Id },
			params
		);
	return tasks.isEmpty() ? null : tasks[0];
}
}