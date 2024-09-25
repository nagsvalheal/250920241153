/**
 * @description This class provides functionality for getLastCareTemplate  getLastEntryDate for Symptom Tracker module.
 * @history
 * Version    Author           Date           Detail    Description
 * 1.0        Karthikeyan      23-Jul-2024    Created   Initial development.
 */
public with sharing class BI_PSP_SymptomTrackerOperationsCtrl {
	/**            
    @description    Retrieves the last 10 CarePlanTemplate records
    USER_MODE cannot be implemented here, as it is querying health cloud object.         
    @return         last 10 record return .This return values pass to bipspbiPspbSymptomTracker this components              
  */

	@AuraEnabled(cacheable=true)
	public static List<HealthCloudGA__CarePlanTemplate__c> getLastCareTemplate() {
		try {
			// Convert the variable to a string
			String symptomRecordTypeValue = String.valueOf(
				BI_PSP_SymptomTrackerConstant.symptomRecordType
			);

			// Construct the dynamic query string
			String queryString =
				'SELECT Id, BI_PSP_Symptom_image__c, Name, RecordTypeId ' +
				'FROM HealthCloudGA__CarePlanTemplate__c ' +
				'WHERE RecordType.Name = \'' +
				symptomRecordTypeValue +
				'\' ' +
				'ORDER BY CreatedDate DESC ' +
				'LIMIT 10';

			// Execute the query

			List<HealthCloudGA__CarePlanTemplate__c> results = BI_PSP_CommonQueryUtility.executeComplexQuery(
				queryString,
				false
			);

			if (results.isEmpty()) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSP_SymptomTrackerConstant.error,
					BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
					true,
					BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
				);
			}
			return results;
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				BI_PSP_SymptomTrackerConstant.error,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				ex
			);
		}
		return new List<HealthCloudGA__CarePlanTemplate__c>();
	}

	/**
                
    @description    Deletes ContentDocumentLink records linked to Symptom Tracker records.
    @param         symptomTrackerId  details based on the provided user ID
  */

	@AuraEnabled
	public static void deleteContentDocumentLinks(Id symptomTrackerId) {
		try {
			if (String.isBlank(symptomTrackerId)) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
					BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
					true,
					BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
				);
			}
			// Query for the first ContentDocumentLink related to the symptomTrackerId
			String queryString =
				'SELECT Id ' +
				'FROM ContentDocumentLink ' +
				'WHERE LinkedEntityId = \'' +
				symptomTrackerId +
				'\' ' +
				'LIMIT 1';

			// Execute the query using the common query utility
			List<ContentDocumentLink> linksToDelete = BI_PSP_CommonQueryUtility.executeComplexQuery(
				queryString,
				false
			);

			BI_PSP_DatabaseOperationsUtility.deleteOperation(
				linksToDelete,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				false
			);
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				BI_PSP_SymptomTrackerConstant.applicationPhotoMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				ex
			);
		}
	}

	/**
    @description   fetchAccountDetails Person Gender Identity.
    @param         careProgramEnrolleeId
    @return        enrollees Person Gender Identity.This return values pass to bipspbiPspbSymptomTracker this components 
      */

	@AuraEnabled(cacheable=true)
	public static List<CareProgramEnrollee> fetchAccountDetails(
		String careProgramEnrolleeId
	) {
		List<CareProgramEnrollee> enrollees = new List<CareProgramEnrollee>();
		try {
			if (String.isBlank(careProgramEnrolleeId)) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSP_SymptomTrackerConstant.careProgramErrorMsg,
					BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
					true,
					BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
				);
			}
			// Perform SOQL query to fetch CareProgramEnrollee and related Account fields
			String queryString =
				'SELECT Id, AccountId, Account.Name, Account.HealthCloudGA__Gender__pc FROM CareProgramEnrollee WHERE Id = \'' +
				careProgramEnrolleeId +
				'\' LIMIT 1';

			enrollees = BI_PSP_CommonQueryUtility.executeComplexQuery(
				queryString,
				false
			);
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				BI_PSP_SymptomTrackerConstant.patientErrorMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				ex
			);
		}
		return enrollees;
	}
	/**
	 * @description This method extracts the file type from a base64-encoded content string by checking the MIME type.
	 *
	 * @param base64Content The base64-encoded content string, which includes the MIME type and encoded file data.
	 * @return String The file type based on the MIME type (e.g., 'png', 'jpeg', 'pdf'), or null if the format is invalid or unsupported.
	 */
	@AuraEnabled
	public static String getFileTypeFromBase64(String base64Content) {
		if (String.isBlank(base64Content)) {
			logError(BI_PSP_SymptomTrackerConstant.symptomErrorMsg);
			return null;
		}

		// Find the position of the comma
		Integer commaIndex = base64Content.indexOf(',');
		if (commaIndex == -1) {
			// No comma found, invalid format
			logError(BI_PSP_SymptomTrackerConstant.symptomErrorMsg);
			return null;
		}

		// Extract MIME type from the part before the comma
		String dataUriPrefix = base64Content.substring(0, commaIndex);
		Integer colonIndex = dataUriPrefix.indexOf(':');
		Integer semicolonIndex = dataUriPrefix.indexOf(';');

		if (
			colonIndex == -1 ||
			semicolonIndex == -1 ||
			semicolonIndex <= colonIndex
		) {
			// Invalid format for MIME type
			logError(BI_PSP_SymptomTrackerConstant.symptomErrorMsg);
			return null;
		}

		String mimeType = dataUriPrefix.substring(
			colonIndex + 1,
			semicolonIndex
		);

		if (mimeType == 'image/png') {
			return 'png';
		} else if (mimeType == 'image/jpeg') {
			return 'jpeg';
		} else if (mimeType == 'application/pdf') {
			return 'pdf';
		}

		return null;
	}

	/**
	 * @description This method takes a list of Base64-encoded file contents, associated file names,
	 *              and a parent record ID, saves them as `ContentVersion` records,
	 *              and returns the corresponding `ContentDocumentId`s.
	 *
	 * @param fileContents A list of Base64-encoded strings representing the files to be uploaded.
	 *                     The format of each string should follow the standard data URI format: 'data:[mimeType];base64,[data]'.
	 * @param parentId The ID of the record (e.g., Case, Account) where the files will be associated (FirstPublishLocationId).
	 * @param fileNames A list of names to be used for the files being uploaded (without the extension).
	 *
	 * @return A list of `ContentDocumentId`s for the successfully inserted files.
	 **/

	@AuraEnabled
	public static List<Id> saveFiles(
		List<String> fileContents,
		Id parentId,
		List<String> fileNames
	) {
		if (isInvalidInput(parentId)) {
			logError(BI_PSP_SymptomTrackerConstant.symptomErrorMsg);
		}
		List<ContentVersion> contentVersions = new List<ContentVersion>();
		List<Id> contentDocumentIds = new List<Id>();

		for (Integer i = 0; i < fileContents.size(); i++) {
			String fileContent = fileContents[i];
			String fileName = fileNames[i];

			ContentVersion cv = createContentVersion(
				fileContent,
				fileName,
				parentId
			);
			if (cv != null) {
				contentVersions.add(cv);
				contentDocumentIds.add(cv.ContentDocumentId);
			}
		}

		if (!contentVersions.isEmpty()) {
			BI_PSP_DatabaseOperationsUtility.insertOperation(
				contentVersions,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				false
			);
		}

		return contentDocumentIds;
	}

	private static Boolean isInvalidInput(String parentId) {
		return String.isBlank(parentId);
	}

	private static void logError(String errorMsg) {
		BI_PSP_LogMessagesUtility.logError(
			errorMsg,
			BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
			true,
			BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
		);
	}

	private static ContentVersion createContentVersion(
		String fileContent,
		String fileName,
		String parentId
	) {
		// Ensure the fileContent contains a comma
		Integer commaIndex = fileContent.indexOf(',');
		if (commaIndex == -1) {
			logError(BI_PSP_SymptomTrackerConstant.symptomErrorMsg);
			return null;
		}

		// Extract Base64 data and file type
		String base64Data = fileContent.substring(commaIndex + 1);
		Blob fileBlob = EncodingUtil.base64Decode(base64Data);
		String fileType = getFileTypeFromBase64(fileContent);

		if (fileType == null) {
			logError(BI_PSP_SymptomTrackerConstant.symptomErrorMsg);
			return null;
		}
		// Append file type to fileName only if it's not already part of the file name
		if (!fileName.toLowerCase().endsWith('.' + fileType.toLowerCase())) {
			fileName += '.' + fileType; // Append the file type if it's not already part of the file name
		}

		// Create ContentVersion record
		ContentVersion contentVersion = new ContentVersion();
		contentVersion.VersionData = fileBlob;
		contentVersion.Title = fileName; // Only use the fileName here, without appending fileType again
		contentVersion.PathOnClient = 'File.' + fileType;
		contentVersion.FirstPublishLocationId = parentId;

		return contentVersion;
	}

	/**
	 * @description This method creates `ContentDocumentLink` records to associate files with a symptom tracker record.
	 *              It links each file (via `ContentDocumentId`) to the specified `symptomTrackerId`.
	 *
	 * @param fileIds A list of file `ContentDocumentId`s that need to be linked to the symptom tracker.
	 * @param symptomTrackerId The ID of the symptom tracker record (LinkedEntityId) to which the files will be linked.
	 * */

	@AuraEnabled(cacheable=true)
	public static void createContentDocumentLinks(
		List<String> fileIds,
		Id symptomTrackerId
	) {
		try {
			if (
				fileIds == null ||
				fileIds.isEmpty() ||
				String.isBlank(symptomTrackerId)
			) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
					BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
					true,
					BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
				);
			}

			List<ContentDocumentLink> fileLinks = new List<ContentDocumentLink>();

			for (String fileId : fileIds) {
				ContentDocumentLink link = new ContentDocumentLink();
				link.ContentDocumentId = fileId;
				link.LinkedEntityId = symptomTrackerId;
				link.ShareType = 'I';
				fileLinks.add(link);
			}
			BI_PSP_DatabaseOperationsUtility.insertOperation(
				fileLinks,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				false
			);
		} catch (Exception e) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				BI_PSP_SymptomTrackerConstant.patientErrorMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				e
			);
		}
	}
}