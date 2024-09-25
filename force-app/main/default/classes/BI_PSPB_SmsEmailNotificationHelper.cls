/**
 * @description  Handles SMS and email notifications based on different
 *                notification types. Provides methods to get notification
 *                details, add contacts for sending notifications, and get
 *                the notification URL.
 * History
 * Version	Author			Date		Detail		Description
 * 1.0		Niyas		24-07-2024		Created		Refactored Version
 */
public with sharing class BI_PSPB_SmsEmailNotificationHelper {
	/**
	 * @description  Retrieves notification details based on the givenhttps://bi-patient-eu--ubrpspdev2.sandbox.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage?sdtd=1#
	 *                notification type and community user names.
	 * @param notificationTypes The ID of the record related to the treatment reminders.
	 * @param communityUserName The type of reminder to filter by.
	 * @param treatmentDate Date to be sent for notification.
	 * @return A list of BI_PSPB_Treatment_Reminder__c objects that match the criteria.
	 */
	public static BI_PSPB_SmsAndEmailNotificationCtrl getNotificationDetails(
		String notificationTypes,
		List<String> communityUserName,
		String treatmentDate
	) {
		// Map to handle notification types
		Map<String, BI_PSPB_SmsAndEmailNotificationCtrl> notificationMap = new Map<String, BI_PSPB_SmsAndEmailNotificationCtrl>{
			BI_PSPB_NotificationConstant.generalSymptomTracker => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.generalSymptomSms,
				BI_PSPB_NotificationConstant.generalSymptomEmail,
				BI_PSPB_NotificationConstant.urlSymptomTracker,
				BI_PSPB_NotificationConstant.actionTypeSymptomTracker,
				communityUserName
			),
			BI_PSPB_NotificationConstant.generalChallenges => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.generalChallengesSms,
				BI_PSPB_NotificationConstant.generalChallengesEmail,
				BI_PSPB_NotificationConstant.urlChallenges,
				BI_PSPB_NotificationConstant.actionTypeChallenges,
				communityUserName
			),
			BI_PSPB_NotificationConstant.generalComment => new BI_PSPB_SmsAndEmailNotificationCtrl(
				'',
				BI_PSPB_NotificationConstant.generalCommentEmail,
				BI_PSPB_NotificationConstant.urlMyPost,
				BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
				communityUserName
			),
			BI_PSPB_NotificationConstant.generalCreatePost => new BI_PSPB_SmsAndEmailNotificationCtrl(
				'',
				BI_PSPB_NotificationConstant.generalPostEmail,
				BI_PSPB_NotificationConstant.urlAllPost,
				BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
				communityUserName
			),
			BI_PSPB_NotificationConstant.generalReaction => new BI_PSPB_SmsAndEmailNotificationCtrl(
				'',
				BI_PSPB_NotificationConstant.generalReactionEmail,
				BI_PSPB_NotificationConstant.urlMyPost,
				BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
				communityUserName
			),
			BI_PSPB_NotificationConstant.generalFollow => new BI_PSPB_SmsAndEmailNotificationCtrl(
				'',
				BI_PSPB_NotificationConstant.generalFollowEmail,
				BI_PSPB_NotificationConstant.urlFollower,
				BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
				communityUserName
			),
			BI_PSPB_NotificationConstant.video => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.generalVideoSms,
				BI_PSPB_NotificationConstant.generalVideoEmail,
				BI_PSPB_NotificationConstant.urlFollower,
				BI_PSPB_NotificationConstant.notificationQuestionaries,
				communityUserName
			),
			BI_PSPB_NotificationConstant.actionSymptomTracker => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionSymptomSms,
				BI_PSPB_NotificationConstant.actionSymptomEmail,
				BI_PSPB_NotificationConstant.urlSymptomTracker,
				BI_PSPB_NotificationConstant.actionTypeSymptomTracker,
				communityUserName
			),
			BI_PSPB_NotificationConstant.treatmentOne => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionTreatmentOneSms +
					' ' +
					treatmentDate,
				BI_PSPB_NotificationConstant.actionTreatmentOneEmail,
				BI_PSPB_NotificationConstant.urlDashboard,
				BI_PSPB_NotificationConstant.treatmentAndRx,
				communityUserName
			),
			BI_PSPB_NotificationConstant.treatmentThree => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionTreatmentThreeSms +
					' ' +
					treatmentDate,
				BI_PSPB_NotificationConstant.actionTreatmentThreeEmail,
				BI_PSPB_NotificationConstant.urlDashboard,
				BI_PSPB_NotificationConstant.treatmentAndRx,
				communityUserName
			),
			BI_PSPB_NotificationConstant.treatmentSeven => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionTreatmentSevenSms,
				BI_PSPB_NotificationConstant.actionTreatmentSevenEmail,
				BI_PSPB_NotificationConstant.urlDashboard,
				BI_PSPB_NotificationConstant.treatmentAndRx,
				communityUserName
			),
			BI_PSPB_NotificationConstant.treatmentTen => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionTreatmentTenSms,
				BI_PSPB_NotificationConstant.actionTreatmentTenEmail,
				BI_PSPB_NotificationConstant.urlDashboard,
				BI_PSPB_NotificationConstant.treatmentAndRx,
				communityUserName
			),
			BI_PSPB_NotificationConstant.treatmentFourteen => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionTreatmentFourteenSms,
				BI_PSPB_NotificationConstant.actionTreatmentFourteenEmail,
				BI_PSPB_NotificationConstant.urlDashboard,
				BI_PSPB_NotificationConstant.treatmentAndRx,
				communityUserName
			),
			BI_PSPB_NotificationConstant.pastDueDateZero => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionPastDueSms,
				BI_PSPB_NotificationConstant.actionPastDueEmail,
				BI_PSPB_NotificationConstant.urlDashboard,
				BI_PSPB_NotificationConstant.treatmentAndRx,
				communityUserName
			),
			BI_PSPB_NotificationConstant.pastDueDateOne => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionPastDueOneSms,
				BI_PSPB_NotificationConstant.actionPastDueOneEmail,
				BI_PSPB_NotificationConstant.urlDashboard,
				BI_PSPB_NotificationConstant.treatmentAndRx,
				communityUserName
			),
			BI_PSPB_NotificationConstant.pastDueDateThree => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionTreatmentDueSeventyTwo +
					' ' +
					treatmentDate +
					' ' +
					BI_PSPB_NotificationConstant.pastTwentySubject,
				BI_PSPB_NotificationConstant.actionPastDueThreeEmail,
				BI_PSPB_NotificationConstant.urlDashboard,
				BI_PSPB_NotificationConstant.treatmentAndRx,
				communityUserName
			),
			BI_PSPB_NotificationConstant.dlqi => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionDlqiSms,
				BI_PSPB_NotificationConstant.actionDlqiEmail,
				BI_PSPB_NotificationConstant.urlDlqiQuestionnaires,
				BI_PSPB_NotificationConstant.notificationQuestionaries,
				communityUserName
			),
			BI_PSPB_NotificationConstant.pss => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionPssSms,
				BI_PSPB_NotificationConstant.actionPssEmail,
				BI_PSPB_NotificationConstant.urlPssQuestionnaires,
				BI_PSPB_NotificationConstant.notificationQuestionaries,
				communityUserName
			),
			BI_PSPB_NotificationConstant.wpai => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionWpaiSms,
				BI_PSPB_NotificationConstant.actionWpaiEmail,
				BI_PSPB_NotificationConstant.urlWpaiQuestionnaires,
				BI_PSPB_NotificationConstant.notificationQuestionaries,
				communityUserName
			),
			BI_PSPB_NotificationConstant.qsq => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionQsqSms,
				BI_PSPB_NotificationConstant.actionQsqEmail,
				BI_PSPB_NotificationConstant.urlQsqQuestionnaires,
				BI_PSPB_NotificationConstant.notificationQuestionaries,
				communityUserName
			),
			BI_PSPB_NotificationConstant.qsqTwo => new BI_PSPB_SmsAndEmailNotificationCtrl(
				BI_PSPB_NotificationConstant.actionQsqSms,
				BI_PSPB_NotificationConstant.actionQsqEmail,
				BI_PSPB_NotificationConstant.urlQsqTwoQuestionnaires,
				BI_PSPB_NotificationConstant.notificationQuestionaries,
				communityUserName
			)
		};
		try {
			// Handle special cases
			Set<String> specialTypes = new Set<String>{
				'TR1333',
				'TR7333',
				'TR100',
				'TR1466'
			};
			if (specialTypes.contains(notificationTypes)) {
				return new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.actionQsqSms,
					BI_PSPB_NotificationConstant.actionQsqEmail,
					BI_PSPB_NotificationConstant.urlFollower,
					BI_PSPB_NotificationConstant.actionTypeSymptomTracker,
					communityUserName
				);
			}
			// Return the details based on notification type
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				ex.getMessage(),
				BI_PSPB_SmsEmailNotificationHelper.class.getName(),
				ex
			);
		}
		return notificationMap.get(notificationTypes);
	}
	/**
	 * @description  Retrieves notification details based on the given
	 *                notification type and community user names.
	 * @param notificationTypes The ID of the record related to the treatment reminders.
	 * @param communityUserName The type of reminder to filter by.
	 * @param treatmentDate Date to be sent for notification.
	 * @param patientName Date to be sent for notification.
	 * @return A list of BI_PSPB_Treatment_Reminder__c objects that match the criteria.
	 */
	public static BI_PSPB_SmsAndEmailNotificationCtrl getCaregiverNotificationDetails(
		String notificationTypes,
		List<String> communityUserName,
		String treatmentDate,
		List<String> patientName
	) {
		for (String pn : patientName) {
			// Map to handle notification types
			Map<String, BI_PSPB_SmsAndEmailNotificationCtrl> notificationMap = new Map<String, BI_PSPB_SmsAndEmailNotificationCtrl>{
				BI_PSPB_NotificationConstant.generalSymptomTracker => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.symtomTrackerCaregiverOne +
						' ' +
						pn + ' ' +
						BI_PSPB_NotificationConstant.symtomTrackerCaregiverTwo,
					BI_PSPB_NotificationConstant.symtomTrackerCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlSymptomTracker,
					BI_PSPB_NotificationConstant.actionTypeSymptomTracker,
					communityUserName
				),
				BI_PSPB_NotificationConstant.generalChallenges => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.challengesCaregiverOne +
						' ' +
						pn + ' ' +
						BI_PSPB_NotificationConstant.challengesCaregiverTwo,
					BI_PSPB_NotificationConstant.challengesCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlChallenges,
					BI_PSPB_NotificationConstant.actionTypeChallenges,
					communityUserName
				),
				BI_PSPB_NotificationConstant.generalComment => new BI_PSPB_SmsAndEmailNotificationCtrl(
					'',
					BI_PSPB_NotificationConstant.commentCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlMyPost,
					BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
					communityUserName
				),
				BI_PSPB_NotificationConstant.generalCreatePost => new BI_PSPB_SmsAndEmailNotificationCtrl(
					'',
					BI_PSPB_NotificationConstant.createPostCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlAllPost,
					BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
					communityUserName
				),
				BI_PSPB_NotificationConstant.generalReaction => new BI_PSPB_SmsAndEmailNotificationCtrl(
					'',
					BI_PSPB_NotificationConstant.reactionCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlMyPost,
					BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
					communityUserName
				),
				BI_PSPB_NotificationConstant.generalFollow => new BI_PSPB_SmsAndEmailNotificationCtrl(
					'',
					BI_PSPB_NotificationConstant.followCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlFollower,
					BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
					communityUserName
				),
				BI_PSPB_NotificationConstant.video => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.generalVideoSms,
					BI_PSPB_NotificationConstant.treatmentVideoCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlFollower,
					BI_PSPB_NotificationConstant.notificationQuestionaries,
					communityUserName
				),
				BI_PSPB_NotificationConstant.actionSymptomTracker => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.actionSymptomCaregiver +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.actionSymptomCaregiverTwo,
					BI_PSPB_NotificationConstant.actionSymptomCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlSymptomTracker,
					BI_PSPB_NotificationConstant.actionTypeSymptomTracker,
					communityUserName
				),
				BI_PSPB_NotificationConstant.treatmentOne => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.ensure +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.treatmentOneDayCaregiver +
						' ' +
						treatmentDate,
					BI_PSPB_NotificationConstant.oneDayTreatmentCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlDashboard,
					BI_PSPB_NotificationConstant.treatmentAndRx,
					communityUserName
				),
				BI_PSPB_NotificationConstant.treatmentThree => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.pleaseEnsure +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.treatmentThreeCaregiver +
						' ' +
						treatmentDate,
					BI_PSPB_NotificationConstant.threeDayTreatmentCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlDashboard,
					BI_PSPB_NotificationConstant.treatmentAndRx,
					communityUserName
				),
				BI_PSPB_NotificationConstant.treatmentSeven => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.recieved +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.sevenDayCaregiver,
					BI_PSPB_NotificationConstant.sevenDayPrescriptionCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlDashboard,
					BI_PSPB_NotificationConstant.treatmentAndRx,
					communityUserName
				),
				BI_PSPB_NotificationConstant.treatmentTen => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.recieved +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.tenDayCaregiver,
					BI_PSPB_NotificationConstant.tenDayPrescriptionCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlDashboard,
					BI_PSPB_NotificationConstant.treatmentAndRx,
					communityUserName
				),
				BI_PSPB_NotificationConstant.treatmentFourteen => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.recieved +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.fourteenDayCaregiver,
					BI_PSPB_NotificationConstant.fourteenDayPrescriptionCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlDashboard,
					BI_PSPB_NotificationConstant.treatmentAndRx,
					communityUserName
				),
				BI_PSPB_NotificationConstant.pastDueDateZero => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.dateTreatCaregiverOne +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.dateTreatCaregiverTwo,
					BI_PSPB_NotificationConstant.dateOfTreatmentCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlDashboard,
					BI_PSPB_NotificationConstant.treatmentAndRx,
					communityUserName
				),
				BI_PSPB_NotificationConstant.pastDueDateOne => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.twentyFourCaregiverOne +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.twentyFourCaregiverTwo,
					BI_PSPB_NotificationConstant.pastTwentyFourCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlDashboard,
					BI_PSPB_NotificationConstant.treatmentAndRx,
					communityUserName
				),
				BI_PSPB_NotificationConstant.pastDueDateThree => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.twentyFourCaregiverOne +
						' ' +
						pn +
						' ' +
						BI_PSPB_NotificationConstant.seventyTwoCaregiverTwo +
						' ' +
						treatmentDate +
						' ' +
						BI_PSPB_NotificationConstant.pastTwentySubject,
					BI_PSPB_NotificationConstant.pastSeventyTwoCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlDashboard,
					BI_PSPB_NotificationConstant.treatmentAndRx,
					communityUserName
				),
				BI_PSPB_NotificationConstant.dlqi => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.dlqiCaregiverOne +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.dlqiCaregiverTwo,
					BI_PSPB_NotificationConstant.dlqiCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlDlqiQuestionnaires,
					BI_PSPB_NotificationConstant.notificationQuestionaries,
					communityUserName
				),
				BI_PSPB_NotificationConstant.pss => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.pssCaregiverOne +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.pssCaregiverTwo,
					BI_PSPB_NotificationConstant.pssCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlPssQuestionnaires,
					BI_PSPB_NotificationConstant.notificationQuestionaries,
					communityUserName
				),
				BI_PSPB_NotificationConstant.wpai => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.wpaiCaregiverOne +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.wpaiCaregiverTwo,
					BI_PSPB_NotificationConstant.wpaiCaregiverEmailTemplate,
					BI_PSPB_NotificationConstant.urlWpaiQuestionnaires,
					BI_PSPB_NotificationConstant.notificationQuestionaries,
					communityUserName
				),
				BI_PSPB_NotificationConstant.qsq => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.qsqCaregiverOne +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.qsqCaregiverTwo,
					BI_PSPB_NotificationConstant.actionQsqEmail,
					BI_PSPB_NotificationConstant.urlQsqQuestionnaires,
					BI_PSPB_NotificationConstant.notificationQuestionaries,
					communityUserName
				),
				BI_PSPB_NotificationConstant.qsqTwo => new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.qsqCaregiverOne +
						' ' +
						pn +
						BI_PSPB_NotificationConstant.qsqCaregiverTwo,
					BI_PSPB_NotificationConstant.actionQsqEmail,
					BI_PSPB_NotificationConstant.urlQsqTwoQuestionnaires,
					BI_PSPB_NotificationConstant.notificationQuestionaries,
					communityUserName
				)
			};
			return notificationMap.get(notificationTypes);
		}
		try {
			// Handle special cases
			Set<String> specialTypes = new Set<String>{
				'TR1333',
				'TR7333',
				'TR100',
				'TR1466'
			};
			if (specialTypes.contains(notificationTypes)) {
				return new BI_PSPB_SmsAndEmailNotificationCtrl(
					BI_PSPB_NotificationConstant.actionQsqSms,
					BI_PSPB_NotificationConstant.actionQsqEmail,
					BI_PSPB_NotificationConstant.urlFollower,
					BI_PSPB_NotificationConstant.actionTypeSymptomTracker,
					communityUserName
				);
			}
			// Return the details based on notification type
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				ex.getMessage(),
				BI_PSPB_SmsEmailNotificationHelper.class.getName(),
				ex
			);
		}
		return null;
	}

	/**
	 * @description  Adds contacts to be notified via email or SMS based on
	 *                the notification settings for the enrollees and caregivers.
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

			// Formulate SOQL query conditions
			String fields = 'Id, BI_PSPB_Care_Program_Enrollee__r.Id, BI_PSPB_Patient__r.BI_PSP_Birthdate__c, BI_PSPB_Patient__r.PersonContactId, BI_PSPB_Caregiver__r.PersonContactId';
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
				Date birthdate = (Date) caregiver.getSObject(
						'BI_PSPB_Patient__r'
					)
					.get('BI_PSP_Birthdate__c');
				Integer age = BI_PSPB_EnrolleeQueryHelper.getAge(birthdate);
				if (!BI_PSPB_EnrolleeQueryHelper.isLegalAge(age)) {
					Id patientId = (Id) caregiver.getSObject(
							'BI_PSPB_Care_Program_Enrollee__r'
						)
						.get('Id');
					processNotifications(
						accountToNotificationsMap.get(patientId),
						(Id) caregiver.getSObject('BI_PSPB_Caregiver__r')
							.get('PersonContactId'),
						emailList,
						smsList
					);
				}
			}

			// Process caregivers
			for (SObject caregiver : caregivers) {
				Date birthdate = (Date) caregiver.getSObject(
						'BI_PSPB_Patient__r'
					)
					.get('BI_PSP_Birthdate__c');
				Integer age = BI_PSPB_EnrolleeQueryHelper.getAge(birthdate);
				if (BI_PSPB_EnrolleeQueryHelper.isLegalAge(age)) {
					Id patientId = (Id) caregiver.getSObject(
							'BI_PSPB_Care_Program_Enrollee__r'
						)
						.get('Id');
					processNotifications(
						accountToNotificationsMap.get(patientId),
						(Id) caregiver.getSObject('BI_PSPB_Caregiver__r')
							.get('PersonContactId'),
						emailList,
						smsList
					);
				}
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
	private static void processNotifications(
		List<BI_PSP_Notification_Setting__c> notifications,
		Id personContactId,
		List<Id> emailList,
		List<Id> smsList
	) {
		try {
			if (!notifications.isEmpty()) {
				for (
					BI_PSP_Notification_Setting__c notification : notifications
				) {
					if (notification.BI_PSP_Email__c) {
						emailList.add(personContactId);
					}
					if (notification.BI_PSP_SMS__c) {
						smsList.add(personContactId);
					}
				}
			} else {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSPB_NotificationConstant.errorMsgRecordNotFound,
					BI_PSPB_SmsEmailNotificationHelper.class.toString(),
					false,
					BI_PSPB_NotificationConstant.severityError
				);
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
}