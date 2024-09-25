/**
 *@description This class holds constants for CMS-related operations, including locale, content types, time formats, and log information.
 * The values are retrieved from custom labels in Salesforce to support localization and configuration flexibility.
 * 
 * Constants include CMS news types, action types, log severities, and error messages for patient account and enrollee handling.
 * History
* Version   Author   Date         Detail          Description
* 1.0       Rajaa    20-Aug-2024  Created         Initial development.
 **/
public class BI_PSPB_CmsConstant {
 public static string usLocale = System.Label.BI_PSP_UnitedStatesLocale;//en_US
    public static string cmsNews = System.Label.BI_PSP_CmsNews;//news 
    public static STRING cmsTimeFormat = System.Label.BI_PSPB_TimeFormatCms; //'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''
    public static string cmsSubject = System.Label.BI_PSPB_NewContentSubject; //'We have a new article upload - You might find it interesting and gain insights for managing your GPP.'
    public static string actionTypeUnRead = System.Label.BI_PSPB_UnRead; //'UnRead'
    public static string actionTypeGeneralContent = System.Label.BI_PSP_NotificationNewContent; //New Content Updates
    public static string actionTypeGeneral = System.Label.BI_PSPB_General; // General
    public static string inserterror = System.Label.BI_PSPB_InsertError; // General
    public static string logInfo = System.Label.BI_PSP_InfoSeverity;
    public static string logError  = System.Label.BI_PSP_ErrorSeverity;
    public static String errorCmsChannelIdRetrieve = System.Label.BI_PSP_ErrorCmsChannelIdRetrieve;
    public static String cmsSiteName = System.Label.BI_PSP_ChannelName;
    public static String patientAccountErrorMsg = System.Label.BI_PSP_PatientAccountError;
    public static String patientEnrolleeErrorMsg = System.Label.BI_PSP_PatientEnrolleeError;
}