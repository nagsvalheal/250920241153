/**
* @description	Schedule class responsible for executing a job when a
*				community post is created.This class implements the
*				Schedulable interface and triggers a reminder processing
*				service upon execution.
* History
* Version	Author			Date		Detail		Description
* 1.0		Niyas		24-07-2024		Created		Refactored Version
*/
public with sharing class BI_PSPB_TreatmentRemindersSched implements Schedulable {
/**
*@description	Executes the scheduled job to process treatment reminders
*				when a community post is created.
*				This method is invoked by the Salesforce scheduler. 
* @param ctx	The context in which the job is executed. 
*/
public void execute(SchedulableContext ctx) {
		BI_PSPB_TreatmentNotificationCtrl.processReminders();
	}
}