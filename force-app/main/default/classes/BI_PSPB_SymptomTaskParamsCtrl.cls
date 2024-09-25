/**
* @description  Manages parameters to create tasks for symptoms.
* History
* Version	Author			Date		Detail		Description
* 1.0		Niyas		24-07-2024		Created		Refactored Version
*/
public with sharing class BI_PSPB_SymptomTaskParamsCtrl {
public List<Id> enrollees;
public List<Id> caregiverIds;
public String notificationType;
public String category;
public String treatmentType;
public String status;
public String userType;
public String subject;

/**
* @description Task parameters for the symptom notification
* @param builder Builder for the params
*/
public BI_PSPB_SymptomTaskParamsCtrl(Builder builder) {
	this.enrollees = builder.enrollees;
	this.caregiverIds = builder.caregiverIds;
	this.notificationType = builder.notificationType;
	this.category = builder.category;
	this.treatmentType = builder.treatmentType;
	this.status = builder.status;
	this.userType = builder.userType;
	this.subject = builder.subject;
}
/**
* @description Builder for task parameters
*/
public class Builder {
	private List<Id> enrollees = new List<Id>();
	private List<Id> caregiverIds = new List<Id>();
	private String notificationType;
	private String category;
	private String treatmentType = '';
	private String status;
	private String userType;
	private String subject;

	/** @description Sets the enrollees list and returns the builder for chaining.
	* @param enrollees List of enrollee ids.
	* @return Returns the builder for chaining.
	*/
	public Builder setEnrollees(List<Id> enrollees) {
		this.enrollees = enrollees;
		return this;
	}
	/** @description Sets the caregiver IDs list and returns the builder for chaining.
	* @param caregiverIds List of caregiver Ids.
	* @return Returns the builder for chaining.
	*/
	public Builder setCaregiverIds(List<Id> caregiverIds) {
		this.caregiverIds = caregiverIds;
		return this;
	}
	/** @description Sets the notification type and returns the builder for chaining. 
	* @param notificationType Type of notification
	* @return Returns the builder for chaining.
	*/
	public Builder setNotificationType(String notificationType) {
		this.notificationType = notificationType;
		return this;
	}
	/** @description Sets the category and returns the builder for chaining.
	* @param category Category of the task.
	* @return Returns the builder for chaining.
	*/
	public Builder setCategory(String category) {
		this.category = category;
		return this;
	}
	/** @description Sets the treatment type and returns the builder for chaining.
	* @param treatmentType Type of treatment for the task
	* @return Returns the builder for chaining.
	*/
	public Builder setTreatmentType(String treatmentType) {
		this.treatmentType = treatmentType;
		return this;
	}
	/**
	* @description Sets the status and returns the builder for chaining.
	* @param status Status of the task
	* @return Returns the builder for chaining.
	*/
	public Builder setStatus(String status) {
		this.status = status;
		return this;
	}
	/**
	* @description Sets the user type and returns the builder for chaining
	* @param userType Type of the user.
	* @return Returns the builder for chaining.
	*/
	public Builder setUserType(String userType) {
		this.userType = userType;
		return this;
	}
	/**
	* @description Sets the subject and returns the builder for chaining.
	* @param subject Subject of the task.
	* @return Returns the builder for chaining.
	*/
	public Builder setSubject(String subject) {
		this.subject = subject;
		return this;
	}

	/** 
	* @description  Method to build and return the TaskCreationParams object
	* @return Returns thesymptom task parameters.
	*/
	public BI_PSPB_SymptomTaskParamsCtrl build() {
		return new BI_PSPB_SymptomTaskParamsCtrl(this);
	}
}
}