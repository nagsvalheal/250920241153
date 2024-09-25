//This is Consolidate Component(LWC) this contains Avatar and Qualitative satisfaction questionnaire Questionnaire to achieve mobile responsive.
//To import Custom labels
import { LightningElement, wire} from 'lwc';
//To import Apex classes
import GET_ASSESSMENT_COUNT from '@salesforce/apex/BI_PSP_AssessmentCtrl.getAssessmentCountsByCurrentUserName';
import GET_PATIENT_ENROLL_DATE from '@salesforce/apex/BI_PSP_QualitativeSatisfactionCtrl.getPatientEnrolleeDateAfterTwoMonthsAndFourteenWeeks';
//To import Custom labels
import * as labels from 'c/biPspbLabelAndResourceForQuestionnaire';
export default class BiPspbQsqFourteenWeekQuesParent extends LightningElement {
	//Track variable Declarations(re-render variables)
	screenWidth;
	showTabMenu;
	count;
	urlq;
	outStandingLabel=labels.OUT_STANDING
	summaryTxt=labels.SUMMARY;
	completedTxt=labels.COMPLETED_TXT;
	letPersonalizeTxt=labels.LET_PERSONALIZE;
	showSpinner = true;
	values = []; // Initialize as an empty array
	finalPartOfUrl =labels.QUALITATIVE_TWO_MONTHS;

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

	//To get total completed assessment for particular Questionnaire
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(GET_ASSESSMENT_COUNT)
	wiredAssessmentResponsesqsq({ data, error }) {
		try {
			if (data) {
				this.count = data;
				if (
					this.count[0] !== 0 ||
					this.count[1] !== 0 ||
					this.count[2] !== 0 ||
					this.count[3] !== 0
				) {
					this.showTabMenu = true;
					this.stwai = this.count[0];
					this.stpss = this.count[1];
					this.stdlq = this.count[2];
					this.stqsq = this.count[3];
				} else {
					this.showTabMenu = false;
				}
				if (this.count[0] !== 0 ||
					this.count[1] !== 0 ||
					this.count[2] !== 0) {
					this.showTabMenuSummary = true;
				}
				else {
					this.showTabMenuSummary = false;
				}
			} else if (error) {
				this.showToast(error.body.message, labels.ERROR_VARIANT); // Catching Potential Error from Apex
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

	//To get site url
	renderedCallback() {
		try {
			let windowWidth = window.innerWidth;
			if (windowWidth <= 1200) {
				this.screenWidth = '12';
			} else {
				this.screenWidth = '4';
			}
		} catch (err) {
			this.showToast(err.message, labels.ERROR_VARIANT); // Catching Potential Error
		}
	}

	//Navigation methods for Tab

	openOutQuestionnaires() {
		window.location.assign(this.urlq + labels.OUT_STANDING_URL);
	}
	openSummary() {
		window.location.assign(this.urlq + labels.SUMMARY_URL);
	}
	//navigation for completed Questionnaire tab
	openComQuestionnaires() {
		if (this.stdlq > 0) {
			window.location.assign(this.urlq + labels.DLQI_COMPLETED_URL);
		} else if (this.stpss > 0) {
			window.location.assign(this.urlq + labels.PSS_COMPLETED_QUESTIONNAIRE_URL);
		} else if (this.stwai > 0) {
			window.location.assign(this.urlq + labels.WPAI_COMPLETED_QUESTIONNAIRE);
		} else if (this.stqsq > 0) {
			window.location.assign(
						this.urlq + labels.QUALITATIVE_COMPLETED_FOURTEEN_WEEKS
					);
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
		globalThis.location.assign(this.urlq +labels.ERROR_PAGE);
	}
}