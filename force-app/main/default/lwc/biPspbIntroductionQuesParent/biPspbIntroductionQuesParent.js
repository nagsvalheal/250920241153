//	This is Consolidate Component(LWC) this contains Avatar and Introduction Questionnaire to achieve mobile responsive.
//To import Libraries
import { LightningElement, wire } from 'lwc';
//To import Apex classes
import GET_ASSESSMENT_COUNT from '@salesforce/apex/BI_PSP_AssessmentCtrl.getAssessmentCountsByCurrentUserName';
import GET_ASSESSMENT_BY_CURRENT_USER from '@salesforce/apex/BI_PSP_CaregiverAndPatientCtrl.getAssessmentsByCurrentUserName';
import GET_PATIENT_ENROLL_DATE from '@salesforce/apex/BI_PSP_QualitativeSatisfactionCtrl.getPatientEnrolleeDateAfterTwoMonthsAndFourteenWeeks';
//To import Custom labels
import * as labels from 'c/biPspbLabelAndResourceForQuestionnaire';
export default class BiPspbIntroductionQuesParent extends LightningElement {
	//Global variables(without @track does not trigger automatic re-renders)
	count;
	status;
	assessmentId;
	categoryname = labels.QUALITATIVE_LABEL;
	urlq;
	patientStatus;
	desiredComponent;
	showTabMenuSummary = false;
	showTabMenu = false;
	globalthis = window;
	outStandingLabel = labels.OUT_STANDING
	summaryTxt = labels.SUMMARY;
	completedTxt = labels.COMPLETED_TXT;
	letPersonalizeTxt = labels.LET_PERSONALIZE
	showSpinner = true;
	values = []; // Initialize as an empty array
	finalPartOfUrl = labels.LETSPERSONLIZE_URL;

	//To get site url
	handleUrlChange(event) {
		// Access the value from the event detail
		this.urlq = event.detail.value;
	}

	handleValueChange(event) {
		const { value } = event.detail;
		this.values.push(value);
		if (this.values.length >= 1) {
			this.showSpinner = false;
		}
	}

	//To get total completed Questionnaire count for the particular user
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(GET_ASSESSMENT_COUNT)
	wiredAssessmentResponsesqsq({ data, error }) {
		try {
			if (error) {
				this.showToast(error.body.message, labels.ERROR_VARIANT); // Catching Potential Error from Apex
			} else if (data) {
				this.count = data;
				//Checking data of index contains 0;
				this.showTabMenu = this.count.some(count => count !== 0);
				//assigning data values to the variables 
				[this.stwai, this.stpss, this.stdlq, this.stqsq] = this.count;
				//Checking 1st 3 index values contains 0;
				this.showTabMenuSummary = this.count.slice(0, 3).some(count => count !== 0);
			}
		} catch (err) {
			this.showToast(err.message, labels.ERROR_VARIANT); // Catching Potential Error from LWC
		}
	}
	//To get assessment and status by current User
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(GET_ASSESSMENT_BY_CURRENT_USER, { categoryname: '$categoryname' })
	wiredAssessments({ error, data }) {
		try {
			if (error) {
				this.showToast(error.body.message, labels.ERROR_VARIANT); // Catching Potential Error from Apex
			} else if (data) {
				this.assessmentId = data.length > 0 ? data[0].Id : null;
				this.status = data.length > 0 ? data[0].AssessmentStatus : null;
				this.qulitativeStatus = data.length > 0 ? data[0].BI_PSP_StatusForPersonalization__c : null;
			}
		} catch (err) {
			this.showToast(err.message, labels.ERROR_VARIANT); // Catching Potential Error from LWC
		}
	}
	//Qualitative Date for topbar navigation
	@wire(GET_PATIENT_ENROLL_DATE)
	wiredResult({ error, data }) {
		try {
			if (error) {
				this.showToast(error.body.message, labels.ERROR_VARIANT); // Catching Potential Error from Apex
			} else if (data) {
				this.threeMonthsVar = data.threeMonthsVar;
				this.forteenWeeks = data.forteenWeeks;
				this.targetDateTwoMonths = data.targetTwoMonthsDate ?? null;
				this.targetDateFourteenWks = data.targetFourteenWeeksDate ?? null;
			}
		} catch (err) {
			this.showToast(err.message, labels.ERROR_VARIANT); // Catching Potential Error from LWC
		}
	}

	//Navigation methods to navigate to other Questionnaire

	openOutQuestionnaires() {
		window.location.assign(this.urlq + labels.OUT_STANDING_URL);
	}
	openSummary() {
		window.location.assign(this.urlq + labels.SUMMARY_URL);
	}
	//Completed Questionnaire Navigation
	openComQuestionnaires() {
		if (this.stdlq > 0) {
			window.location.assign(this.urlq + labels.DLQI_COMPLETED_URL);
		} else if (this.stpss > 0) {
			window.location.assign(this.urlq + labels.PSS_COMPLETED_QUESTIONNAIRE_URL);
		} else if (this.stwai > 0) {
			window.location.assign(this.urlq + labels.WPAI_COMPLETED_QUESTIONNAIRE);
		} else if (this.stqsq > 0) {
			window.location.assign(this.urlq + labels.QUALITATIVE_COMPLETED_FOURTEEN_WEEKS);
		}
	}
	openPersonalize() {
		window.location.assign(this.urlq + labels.LETSPERSONLIZE_URL);
	}
	// showToast used for all the error messages caught
	showToast(message, variant) {
		let messageList = message + ' ' + variant;
		let globalThis = window;
		globalThis.sessionStorage.setItem('errorMessage', messageList);
		globalThis.location.assign(this.urlq + labels.ERROR_PAGE);
	}
}