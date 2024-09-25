/**
 * @description  This class handles the creation of tasks when a video is uploaded.
 * It also includes methods for sending SMS and email notifications.
 * History
 * Version	Author			Date		Detail		Description
 * 1.0		Niyas		24-07-2024		Created		Refactored Version
 */
public with sharing class BI_PSPB_QsqQuestionnaireActionCtrl {
	/**
	* @description  Processes the creation of tasks for enrollees when questionnaires
	* are uploaded. It also handles the invocation of methods to send SMS and email
	* notifications based on the processed questionnaire data.
	*/
	public static void processQsqQuestionnaires() {
		try {
			Integer qsqCount = BI_PSPB_QuestionsDaysCountQueryCtrl.fetchQsqCount();
			Integer qsqTwoCount = BI_PSPB_QuestionsDaysCountQueryCtrl.fetchQsqTwoCount();
			List<Id> enrolleeQsqOneIds = processEnrollees(
				qsqCount
			);
			if (!enrolleeQsqOneIds.isEmpty()) {
				processQsq(
					enrolleeQsqOneIds,
					BI_PSPB_NotificationConstant.qsqQuestionName,
					BI_PSPB_NotificationConstant.qsq,
					BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction
				);
			}
			List<Id> enrolleeQsqTwoIds = processEnrollees(
				qsqTwoCount
			);

			if (!enrolleeQsqTwoIds.isEmpty()) {
				processQsq(
					enrolleeQsqTwoIds, BI_PSPB_NotificationConstant.qsqQuestionName,
                    BI_PSPB_NotificationConstant.qsq,
					BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction
				);
			}
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.logError(
				ex.getMessage(),
				BI_PSPB_QsqQuestionnaireActionCtrl.class.toString(),
				false,
				BI_PSPB_NotificationConstant.severityError
			);
		}
	}

	/**
	 * @description    Creates tasks for the provided list of enrollee IDs and initiates
	 * methods to send SMS and email notifications. Handles the creation of tasks and
	 * logging if no records are found or if an error occurs.
	 * @param enrolleeQsqIds A list of enrollee IDs that need to be processed. This list should not be null or empty.
	 * @param questionName The name of the question related to the assessment. This is used for fetching due assessments.
	 * @param notificationType The type of notification to be sent (e.g., SMS, email). This determines the type of notification that will be sent.
	 * @param actionType The type of action being performed. This is used to categorize or specify the nature of the action.
	 */
	public static void processQsq(
		List<Id> enrolleeQsqIds,
		String questionName,
		String notificationType,
		String actionType
	) {
		try {
            Date today = Date.today();
            List<Task> newTaskList = new List<Task>();
            List<Id> patientEnrolleeIds = new List<Id>();
    		List<Id> caregiverEnrolleeIds = new List<Id>();
             List<Id> patientTaskId = new List<Id>();
    		List<Id> caregiverTaskId = new List<Id>();
            List<Id> enrolleeSendQsqIds = new List<Id>();
            List<Id> caregiverSendIds = new List<Id>();
            Integer legalAge = Integer.valueOf(BI_PSPB_NotificationConstant.legalAge);
			if (enrolleeQsqIds.isEmpty()) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSPB_NotificationConstant.errorMsgRecordNotFound,BI_PSPB_QsqQuestionnaireActionCtrl.class.toString(),
					true, BI_PSPB_NotificationConstant.severityError
				);
			}
                List<CareProgramEnrollee> enrolleeRecords = BI_PSPB_EnrolleeProcessorCtrl.fetchEnrolleeRecords(enrolleeQsqIds);
                for (CareProgramEnrollee enrollee : enrolleeRecords) {
                    Integer age = BI_PSPB_EnrolleeProcessorCtrl.calculateAge(enrollee.Account.BI_PSP_Birthdate__c, today);
                    Id enrolleeId = enrollee.Id;
                    Id caregiverId = BI_PSPB_CaregiverProcessorCtrl.fetchCaregiverId(enrolleeId);
					String patientName = enrollee.Account.Name;
                    
                    if (age > legalAge && caregiverId == null) {
                        patientEnrolleeIds = new List<Id>{enrolleeId};
                        patientTaskId = BI_PSPB_AssessmentProcessorCtrl.fetchDueAssessments(
							patientEnrolleeIds,
							questionName
						);
                        enrolleeSendQsqIds.addAll(patientTaskId);
                        BI_PSPB_TaskParameterCtrl params = new BI_PSPB_TaskParameterCtrl(
						BI_PSPB_NotificationConstant.qsqQuestionSubject,
						BI_PSPB_NotificationConstant.actionTypeAction,
						BI_PSPB_NotificationConstant.qsq,
						'',
						BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction
					);

						newTaskList.addAll(BI_PSPB_TaskCreatorCtrl.createPatientTasks(
							patientTaskId,
							params,
                            BI_PSPB_NotificationConstant.patient,
                            caregiverId
						));
                    } else if (age > legalAge && caregiverId != null){
                        patientEnrolleeIds = new List<Id>{enrolleeId};
                        patientTaskId = BI_PSPB_AssessmentProcessorCtrl.fetchDueAssessments(
							patientEnrolleeIds,questionName);
                        enrolleeSendQsqIds.addAll(patientTaskId);
                        BI_PSPB_TaskParameterCtrl params = new BI_PSPB_TaskParameterCtrl(
                                BI_PSPB_NotificationConstant.qsqQuestionSubject,
                                BI_PSPB_NotificationConstant.actionTypeAction,BI_PSPB_NotificationConstant.qsq,
                                '',BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction);

						newTaskList.addAll(BI_PSPB_TaskCreatorCtrl.createPatientTasks(
							patientTaskId,params,BI_PSPB_NotificationConstant.patient,caregiverId
						));
                        
                         BI_PSPB_TaskParameterCtrl params1 = new BI_PSPB_TaskParameterCtrl(
						BI_PSPB_NotificationConstant.qsqCaregiverOne + ' ' + patientName + 
						BI_PSPB_NotificationConstant.qsqCaregiverTwo,
						BI_PSPB_NotificationConstant.actionTypeAction,BI_PSPB_NotificationConstant.qsq,
						'',BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction);

						newTaskList.addAll(BI_PSPB_TaskCreatorCtrl.createCaregiverTasks(
							patientTaskId,params1,BI_PSPB_NotificationConstant.caregiver,
							caregiverId));
                    } else {
                        caregiverEnrolleeIds = new List<Id>{enrolleeId};
                        caregiverTaskId = BI_PSPB_AssessmentProcessorCtrl.fetchDueAssessments(
							caregiverEnrolleeIds,
							questionName
						);
                        caregiverSendIds.addAll(caregiverTaskId);
                    BI_PSPB_TaskParameterCtrl params = new BI_PSPB_TaskParameterCtrl(
						BI_PSPB_NotificationConstant.qsqCaregiverOne + ' ' + patientName + 
							BI_PSPB_NotificationConstant.qsqCaregiverTwo,
						BI_PSPB_NotificationConstant.actionTypeAction,
						BI_PSPB_NotificationConstant.qsq,
						'',
						BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction
					);

						newTaskList.addAll(BI_PSPB_TaskCreatorCtrl.createCaregiverTasks(
							caregiverEnrolleeIds,
							params,
                            BI_PSPB_NotificationConstant.caregiver,
                            caregiverId
						));
                        
                }
                }
				BI_PSP_DatabaseOperationsUtility.insertOperation(
					newTaskList,
					BI_PSPB_QsqQuestionnaireActionCtrl.class.toString(),
					false
				);
				sendNotifications(
					enrolleeSendQsqIds,
					notificationType,
					new List<String>{ '' }
				);
                sendNotifications(
					caregiverSendIds,
					notificationType,
					new List<String>{ '' }
				);
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.logError(
				ex.getMessage(),
				BI_PSPB_QsqQuestionnaireActionCtrl.class.toString(),
				true,
				BI_PSPB_NotificationConstant.severityError
			);
		}
	}
	/**
	* @description This method processes list of enrollees and create tasks.
	* @param qsqCount Count of the day the notification to be sent.
	* @return List<Id> List of care program enrollees.
    */
    private static List<Id> processEnrollees(Integer qsqCount) {
	List<Id> enrolleeRecIds = new List<Id>();
		// Fetch CareProgramEnrollee objects
		List<CareProgramEnrollee> enrollees = fetchEnrollees();
		for (CareProgramEnrollee enrollee : enrollees) {
			Date enrolleeCreatedDate = enrollee.BI_PSPB_FirstLoginDate__c;
			if (enrolleeCreatedDate == System.today().addDays(-qsqCount)) {
				enrolleeRecIds.add(enrollee.Id);
			}
		}
	return enrolleeRecIds;
}
	/**
	* @description  Fetches CareProgramEnrollee records from the database. 
	* @return A list of CareProgramEnrollee objects.
	*/
public static List<CareProgramEnrollee> fetchEnrollees() {
	List<CareProgramEnrollee> enrolleeRecords = new List<CareProgramEnrollee>();
		// Query CareProgramEnrollee objects
		String fields = 'Id, BI_PSPB_FirstLoginDate__c';
		enrolleeRecords = BI_PSP_CommonQueryUtility.executeQuery(
		'CareProgramEnrollee',
		fields,
		null,
		false
	);
	return enrolleeRecords;
}
	/**
	* @description This method processes list of enrollees and create tasks.
	* @param enrolleeIds Ids of enrollees.
	* @param notificationType Type of the notification in task.
	* @param communityUserNames Username of the user.
    */
    private static void sendNotifications(
    List<Id> enrolleeIds,
    String notificationType, 
    List<String> communityUserNames
) {
    try {
        // Check if enrolleeIds is not empty and notificationType is not blank
        if (!enrolleeIds.isEmpty() && !String.isBlank(notificationType)) {
            BI_PSPB_NotificationTemplatesCtrl.handleTrigger(
                enrolleeIds,
                notificationType,
                communityUserNames,
                ''
            );
        } else {
            BI_PSP_LogMessagesUtility.logError(
                BI_PSPB_NotificationConstant.errorMsgRecordNotFound,
                BI_PSPB_QsqQuestionnaireActionCtrl.class.toString(),
                false,
                BI_PSPB_NotificationConstant.severityError
            );
        }
    } catch (Exception ex) {
        BI_PSP_LogMessagesUtility.exceptionLogMessage(
            ex.getMessage(),
            BI_PSPB_QsqQuestionnaireActionCtrl.class.getName(),
            ex
        );
    }
}
}