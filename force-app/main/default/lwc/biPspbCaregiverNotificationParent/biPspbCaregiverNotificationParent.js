// This consolidated component is used to show avatar, message and caregiver notification setting
// To import Libraries
import { LightningElement } from 'lwc';

import {resources} from 'c/biPspbResourceProfileManager';

export default class BiPspbCaregiverNotificationParent extends LightningElement {
	showSpinner=true;
	notificationSetting=resources.My_Notification;
	selectAvatar=resources.SELECT_AVATAR;
	patientInfo=resources.PATIENT_INFO;
	myProfile=resources.MY_PROFILE;
	//this method is used to navigating a user unassigned and branded
	finalPartOfUrl = resources.CAREGIVER_NOTIFICATION;

	//To get site url
	handleUrlChange(event) {
		// Access the value from the event detail
		this.urlq = event.detail.value;
	}
	
	// navigation for caregiver
	openCarMyProfile() {
		window.location.assign(this.urlq + resources.CAREGIVER_PROFILE_URL);
	}

	openCarNotSettings() {
		window.location.assign(
			this.urlq + resources.CAREGIVER_NOTIFY_URL
		);
	}
 handleComponentLoad() {
    // Once the child component has finished loading, hide the spinner
    this.showSpinner = false;
  }
}