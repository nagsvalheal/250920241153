/**
 * @description  This class is used to create tasks when a video is uploaded.
 * It also handles calling methods to send SMS and email notifications.
 * History
 * Version	Author			Date		Detail		Description
 * 1.0		Niyas		24-07-2024		Created		Refactored Version
 */
public class BI_PSPB_TreatmentTaskCreateCtrl {
	/**
	 * @description  Creates a task for a patient based on a treatment reminder, the difference in days
	 *                from the target date, and the reminder configuration. This method generates a task
	 *                with details tailored to the patient, including the specific reminder, time frame,
	 *                and user type information.
	 * @param reminder A BI_PSPB_Treatment_Reminder__c record representing the treatment reminder for which
	 *                 the patient task is being created. This record provides the necessary information
	 *                 about the reminder details.
	 * @param daysDifference An integer representing the difference in days between the reminder's target
	 *                       date and the current date, used to calculate the timing of the task.
	 * @param daysCount An instance of BI_PSPB_TreatmentReminderDaysCtrl that defines the configuration
	 *                  for reminder days, which helps determine the due dates and priority of the created task.
	 * @param userType A string indicating the user type (e.g., 'Patient') for whom the task is being created,
	 *                 used to customize the task details accordingly.
	 * @return A Task object that represents the created patient task, including all necessary fields populated
	 *         based on the reminder, days difference, and other parameters.
	 */
	public static Task createPatientTask(
		BI_PSPB_Treatment_Reminder__c reminder,
		Integer daysDifference,
		BI_PSPB_TreatmentReminderDaysCtrl daysCount,
		String userType
	) {
		String subject;
		String category;
		String notificationType;
		String status;
		String formattedDate;
		Datetime treatmentDate;

		if (daysDifference == daysCount.before1Day) {
			treatmentDate = reminder.BI_PSPB_Date_of_Treatment__c;
			formattedDate = treatmentDate.format('dd/MM/yyyy');
			subject =
				BI_PSPB_NotificationConstant.oneDayBeforeSubject +
				' ' +
				formattedDate +
				'.';
			notificationType = BI_PSPB_NotificationConstant.actionTypeGeneral;
			status = BI_PSPB_NotificationConstant.actionTypeUnRead;
			category = BI_PSPB_NotificationConstant.actionTypeTreatment;
		} else if (daysDifference == daysCount.before3Day) {
			treatmentDate = reminder.BI_PSPB_Date_of_Treatment__c;
			formattedDate = treatmentDate.format('dd/MM/yyyy');
			subject =
				BI_PSPB_NotificationConstant.threeDayBeforeSubject +
				' ' +
				formattedDate +
				'.';
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

		// Create a new Task record
		Task newTask = new Task();
		newTask.Subject = subject;
		newTask.Status = status;
		newTask.BI_PSP_Notification_Type__c = notificationType;
		newTask.BI_PSP_Category__c = category; // Custom field for category
		newTask.WhatId = reminder.Id; // Link task to the reminder record
		newTask.BI_PSPB_Notification_User_Type__c = BI_PSPB_NotificationConstant.patient;
		Id caregiverId = BI_PSPB_CaregiverProcessorCtrl.fetchCaregiverId(
			reminder.BI_PSPB_Care_Program_Enrollee__c
		);
		if (userType == BI_PSPB_NotificationConstant.patient && caregiverId != null) {
			newTask.BI_PSPB_Caregiver__c = caregiverId;
		}

		return newTask;
	}
	/**
	 * @description  Creates a task for a caregiver based on a treatment reminder, the difference in days
	 *                from the target date, and the reminder configuration. This method generates a task
	 *                tailored to the caregiver, incorporating the specific reminder details, time frame,
	 *                and user type information.
	 * @param reminder A BI_PSPB_Treatment_Reminder__c record representing the treatment reminder for which
	 *                 the caregiver task is being created. This record provides necessary details about
	 *                 the reminder.
	 * @param daysDifference An integer representing the difference in days between the reminder's target
	 *                       date and the current date, which helps determine the timing and due date of the task.
	 * @param daysCount An instance of BI_PSPB_TreatmentReminderDaysCtrl that outlines the configuration
	 *                  for reminder days, used to set the due dates, frequency, and priority of the created task.
	 * @param userType A string indicating the user type (e.g., 'Caregiver') for whom the task is being created,
	 *                 allowing the task details to be tailored specifically to caregivers.
	 * @return A Task object representing the created caregiver task, with fields populated according to
	 *         the reminder, days difference, user type, and other provided parameters.
	 */
	public static Task createCaregiverTask(
		BI_PSPB_Treatment_Reminder__c reminder,
		Integer daysDifference,
		BI_PSPB_TreatmentReminderDaysCtrl daysCount,
		String userType
	) {
		String subject;
		String category;
		String notificationType;
		String status;
		String formattedDate;
		Datetime treatmentDate;
		String patientName = reminder.BI_PSPB_Care_Program_Enrollee__r.Account.Name;

		if (daysDifference == daysCount.before1Day) {
			treatmentDate = reminder.BI_PSPB_Date_of_Treatment__c;
			formattedDate = treatmentDate.format('dd/MM/yyyy');
			subject =
				BI_PSPB_NotificationConstant.ensure +
				' ' +
				patientName +
				' ' +
				BI_PSPB_NotificationConstant.treatmentOneDayCaregiver +
				' ' +
				formattedDate +
				'.';
			notificationType = BI_PSPB_NotificationConstant.actionTypeGeneral;
			status = BI_PSPB_NotificationConstant.actionTypeUnRead;
			category = BI_PSPB_NotificationConstant.actionTypeTreatment;
		} else if (daysDifference == daysCount.before3Day) {
			treatmentDate = reminder.BI_PSPB_Date_of_Treatment__c;
			formattedDate = treatmentDate.format('dd/MM/yyyy');
			subject =
				BI_PSPB_NotificationConstant.pleaseEnsure +
				' ' +
				patientName +
				' ' +
				BI_PSPB_NotificationConstant.treatmentThreeCaregiver +
				' ' +
				formattedDate +
				'.';
			notificationType = BI_PSPB_NotificationConstant.actionTypeGeneral;
			status = BI_PSPB_NotificationConstant.actionTypeUnRead;
			category = BI_PSPB_NotificationConstant.actionTypeTreatment;
		} else if (daysDifference == daysCount.before7Day) {
			subject =
				BI_PSPB_NotificationConstant.recieved +
				' ' +
				patientName +
				BI_PSPB_NotificationConstant.sevenDayCaregiver;
			notificationType = BI_PSPB_NotificationConstant.actionTypeAction;
			status = BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction;
			category = BI_PSPB_NotificationConstant.actionTypePrescription;
		} else if (daysDifference == daysCount.before10Day) {
			subject =
				BI_PSPB_NotificationConstant.recieved +
				' ' +
				patientName +
				BI_PSPB_NotificationConstant.tenDayCaregiver;
			notificationType = BI_PSPB_NotificationConstant.actionTypeAction;
			status = BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction;
			category = BI_PSPB_NotificationConstant.actionTypePrescription;
		} else if (daysDifference == daysCount.before14Day) {
			subject =
				BI_PSPB_NotificationConstant.recieved +
				' ' +
				patientName +
				BI_PSPB_NotificationConstant.fourteenDayCaregiver;
			notificationType = BI_PSPB_NotificationConstant.actionTypeAction;
			status = BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction;
			category = BI_PSPB_NotificationConstant.actionTypePrescription;
		} else {
			return null;
		}

		// Create a new Task record
		Task newTask = new Task();
		newTask.Subject = subject;
		newTask.Status = status;
		newTask.BI_PSP_Category__c = category;
		newTask.WhatId = reminder.Id;
		newTask.BI_PSP_Notification_Type__c = notificationType;
		Id caregiverId = BI_PSPB_CaregiverProcessorCtrl.fetchCaregiverId(
			reminder.BI_PSPB_Care_Program_Enrollee__c
		);
		newTask.BI_PSPB_Caregiver__c = caregiverId;
		newTask.BI_PSPB_Notification_User_Type__c = BI_PSPB_NotificationConstant.caregiver;
		return newTask;
	}
}