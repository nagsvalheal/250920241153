/**
 * @description    This class is used to update the avatar for an enrollee, 
 *                  when an enrollee record is updated, and handle any errors that occur during these operations.
 * 
 * History:
 * Version    Author        Date         Detail              Description
 * 1.0        Ashif         20-07-2024   Created             Initial development
 */
public with sharing class BI_PSPB_EnrolleeAvatarCtrl {
    private static Integer loginAttemptValue = 1;

    /**
     * @description This method updates the avatar URL of an enrollee record identified by the provided enrollee ID. 
     *              It also sets default values for login attempts and the first login date if they are not already set.
     * @param enrolleeId The ID of the enrollee record to update.
     * @param avatarSrc The URL of the new avatar image to set for the enrollee.
     */
    @AuraEnabled
    public static void updateEnrolleeAvatar(String enrolleeId, String avatarSrc) {
        try {
            if (String.isBlank(enrolleeId) || String.isBlank(avatarSrc)) {
                BI_PSP_LogMessagesUtility.logError(
                    BI_PSPB_EnrollmentConstant.getLabel('ERROR_GETTING_CPE'),
                    BI_PSPB_EnrolleeAvatarCtrl.class.getName(),
                    true,
                    BI_PSPB_EnrollmentConstant.getLabel('LOG_SEVERITY_ERROR')
                );
                return; 
            }
            
            String sObjectType = 'CareProgramEnrollee';
            String fields = 'Id, BI_PSP_AvatarUrl__c, BI_PSP_Loginattempt__c, BI_PSPB_FirstLoginDate__c';
            String conditions = 'Id = \'' + enrolleeId + '\'';

            List<SObject> results = BI_PSP_CommonQueryUtility.executeQuery(
                sObjectType,
                fields,
                conditions,
                BI_PSP_QuestionnaireConstant.withSharingKeywrd
            );

            List<CareProgramEnrollee> enrollees = (List<CareProgramEnrollee>) results;

            if (!enrollees.isEmpty()) {
                CareProgramEnrollee enrollee = enrollees[0];
                enrollee.BI_PSP_AvatarUrl__c = avatarSrc;
                
                if (enrollee.BI_PSP_Loginattempt__c == 0) {
                    enrollee.BI_PSP_Loginattempt__c = loginAttemptValue;
                } 

                if (enrollee.BI_PSPB_FirstLoginDate__c == null) {
                    enrollee.BI_PSPB_FirstLoginDate__c = Date.today();
                }

                // Perform the update operation
                BI_PSP_DatabaseOperationsUtility.updateOperation(
                    new List<CareProgramEnrollee>{enrollee},
                    BI_PSPB_EnrolleeAvatarCtrl.class.getName(),
                    Boolean.valueOf(BI_PSPB_EnrollmentConstant.getLabel('USER_MODE_FALSE'))
                );
            }
        } catch (Exception ex) {
            BI_PSP_LogMessagesUtility.exceptionLogMessage(
                ex.getMessage(),
                BI_PSPB_EnrolleeAvatarCtrl.class.getName(),
                ex
            );
        }
    }
}