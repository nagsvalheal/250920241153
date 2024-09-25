//This  consolidates component the functionality for caregivers to view patient information and perform updates when logged in
//To import Libraries
import { LightningElement , wire} from "lwc";
import GET_USER_ACCOUNT_ID from '@salesforce/apex/BI_PSP_CurrentUser.returnTheAccounts';


import {resources} from 'c/biPspbResourceProfileManager';

export default class BiPspbCaregiverPatientParent extends LightningElement {
	notificationSetting=resources.Patient_Notification;
	selectAvatar=resources.SELECT_AVATAR;
	patientInfo=resources.PATIENT_INFO;
	myProfile=resources.MY_PROFILE;
	showSpinner=true;
	Adult = false;

	siteUrlq;

	finalPartOfUrl = resources.CAREGIVER_PATIENT_URL;

	//To get site url
	handleUrlChange(event) {
		// Access the value from the event detail
		this.siteUrlq = event.detail.value;
	}
	
@wire(GET_USER_ACCOUNT_ID)
wiredAccId({ data, error }) {
    try {
        if (data) {
            
            // Check if the age is 18 or older
            if (data[0].BI_PSP_Age__c >= resources.MINOR_AGE) {
                this.Adult = true;
            }
        } else if (error) {
            
            // Handle the error case
            let globalThis = window;
            this.error = 'Record Not Found'; // Example error message
            globalThis.sessionStorage.setItem('errorMessage', this.error);
            globalThis.location.href = 'errorPage.html'; // Example error page
        }
    } catch (err) {
        
        // Handle the exception
        let globalThis = window;
        this.error = 'Record Not Found'; // Example error message
        globalThis.sessionStorage.setItem('errorMessage', this.error);
        globalThis.location.href = 'errorPage.html'; // Example error page
    }
}

	//These are caregiver account manager Navigation

	openCarMyCaregiver() {
		window.location.assign(resources.CAREGIVER_PATIENT_URL);
	}
	openCarSelectAvatar() {
		window.location.assign(resources.CAREGIVER_SELECT_URL);
	}
	openCarNotSettings() {
	
		if(this.siteUrlq === resources.BRANDED_SITE_URL){
			window.location.assign(resources.PATIENT_NOTIFICATION );
		}else{
			window.location.assign(resources.CAREGIVER_NOTIFICATIONS );
		}
		
	}
	handleComponentLoad() {
    // Once the child component has finished loading, hide the spinner
    this.showSpinner = false;
  }

}