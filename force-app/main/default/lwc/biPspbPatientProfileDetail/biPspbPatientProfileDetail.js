// This component is used for prepopulating patient information, updating it, and creating cases based on the account settings.
// To import Libraries
import { LightningElement, api, track, wire } from "lwc";
import { loadStyle } from "lightning/platformResourceLoader";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
// To import current user ID
import Id from "@salesforce/user/Id";

//  To import Apex Classes
import CREATE_CASE from "@salesforce/apex/BI_PSPB_CaseDeletionCtrl.createCase";
import GET_EXISTING_ACCOUNTS from "@salesforce/apex/BI_PSPB_EnrollmentUtilities.getExistingAccounts";
import CREATE_ACCESS_CASE from "@salesforce/apex/BI_PSPB_CaseAccessCtrl.createAccessCase";
import GET_CHECKBOX_VALUES from "@salesforce/apex/BI_PSPB_CaseAccessCtrl.checkboxPersonalAccess";
import CHECKBOX_VALUES_REQUEST from "@salesforce/apex/BI_PSPB_CaseDeletionCtrl.checkboxAccountDeletion";
import ENROLLEE_DETAILS from "@salesforce/apex/BI_PSP_ChallengeEnrolleCtrl.getEnrolle";
import ACCOUNT_DETAILS from "@salesforce/apex/BI_PSPB_AccountDetailsCtrl.getAccDetails";
import UPDATE_PATIENT_DETAILS from "@salesforce/apex/BI_PSPB_ProfileManagerCtrl.updatePatientorCargiverInfo";
import COUNTRYS from "@salesforce/apex/BI_PSPB_EnrollmentUtilities.getCountries";
import STATES from "@salesforce/apex/BI_PSPB_EnrollmentUtilities.getStates";
import * as label from "c/biPspbLabelAndResourceSymptom";
import { resources } from "c/biPspbResourceProfileManager";

export default class BiPspbPatientProfileDetail extends LightningElement {
  //Proper naming conventions with camel case for all the variables will be followed in the future releases
  // Declaration of variables with @api
  @api isLoaded = false;
  @api caregiverForm;
  @api selectedValue;
  @api account;
  deleteButton = false;
  changeEmail = false;
  // Declaration of variables with
  patientFirstName = "";
  firstNameErrorMessageValid = false;
  lastNameErrorMessageValid = false;
  RpCityErrorMessageValid = false;
  required = false;
  showDiv = false;
  siteUrlBranded = resources.BRANDED_SITE_URL;
  siteloginBranded = resources.LOGIN;
  secureLogout = resources.SECURE_LOGOUT;
  hasEmailChanged = false;
  relationshiperrorMessage;
  showDivOne = false;
  isDOBDisabled;
  warningIcon = resources.WARNING_IMAGE;
  ticIcon = resources.TIC_IMAGE;
  isEmailDisabled = false;
  existEmail = resources.EXIST_EMAIL;
  isMobilePhoneDisabled = false;
  isGenderDisabled = true;
  isPOMDisabled = true;
  isMaillingCountryDisabled = true;
  isMaillingStateDisabled = true;
  isMaillingStreetDisabled = true;
  isMaillingPostalcodeDisabled = true;
  isMaillingCityDisabled = true;
  firstNameErrorMessag = false;
  lastNameErrorMessage = false;
  dobErrorMessage = false;
  emailErrorMessage = false;
  MobileErrorMessage = false;
  conPmcErrorMessage = false;
  genderMessage = false;
  pmcMessage = false;
  countryCodeMessage = false;
  stateCodeMessage = false;
  cityMessage = false;
  streetMessage = false;
  postalCodeMessage = false;
  isCaregiver = false;
  patientId;
  patientLastName = "";
  patientDOB = "";
  patientAge = "";
  patientGender = "";
  patientEmail = "";
  preferredCommunication = "";
  patientMobilePhone = "";
  patientCountry = "";
  patientState = "";
  patientCity = "";
  patientStreet = "";
  patientZipCode = "";
  PersonBirthDate = "";
  futureDobError;
  openModal = false;
  validErrorMessage = false;
  firstName;
  accountId;
  result;
  isDeletePopupOpen = false;
  isAccessPopupOpen = false;
  isAdult = false;
  @track relation = [];
  selectedCountryCode = "";
  selectedStateCode = "";
  country;
  state;
  relations = "";
  deletepopup;
  accesspopup;
  GenderErrorMessage = false;
  isButtonDeleteDisabled = false;
  isAccessButtonDisabled = false;
  DeleteMessage = false;
  accessMessage = false;
  colorChnage = "outlined-button"; //css class
  colorChanage = "outlined-button"; //css class
  boxedIcon = resources.BOXEDD_ICON;
  phoneNumberMandatory = false;
  @track placeholderClass = 'date-input-container'
  @track leadPmc = [
    { label: resources.MALE, value: resources.MALE },
    { label: resources.FEMALE, value: resources.FEMALE },
    { label: resources.PREFERNOT, value: resources.PREFERNOT },
    { label: resources.OTHERS, value: resources.OTHERS }
  ];
  recordId;
  updatePopup = false;
  touch = false;
  down = true;
  up = false;
  checkboxFirstValue;
  emailModifiedDate;
  checkboxSecondValue;
  @track preffer = [
    { label: resources.SMS_LABEL, value: resources.SMS_LABEL },
    { label: resources.PHONE_LABEL, value: resources.PHONE_LABEL },
    { label: resources.EMAIL_LABEL, value: resources.EMAIL_LABEL }
  ];
  ZipErrorMessageValid = false;
  pmcName = resources.PHONE_NUMBER_LABEL;
  minorerror = false;
  // Declaration of Global variables
  enrolleeids;
  countryCode = [];
  StateCode = [];
  userId = Id;
  caregiverAccountIds;
  cgpatientconfirmupNew = resources.CONFIRMUPNEW;
  rightimg = resources.RIGHT_ICON;
  firstNameError = resources.FIRST_NAMEERROR;
  lastNameError = resources.LAST_NAMEERROR;
  dobError = resources.DOB;
  minorCaregiver = resources.MINOR;
  futureDate = resources.FUTHURE_DATE;
  aboveError = resources.ABOVE_ERROR;
  emailError = resources.EMAIL_ERROR;
  genderError = resources.GENDER;
  phoneError = resources.PHONE_ERROR;
  mobileError = resources.MOBILE;
  prefferedMode = resources.PREFERRED_CONTACT_METHOD;
  countryError = resources.COUNTRY;
  stateError = resources.STATE;
  cityError = resources.CITY;
  streetError = resources.STREET;
  pincodeError = resources.PINCODE;
  validError = resources.VALIDPINCODE;
  validateLastNameError = resources.VALIDLNAME;
  validateFirstNameError = resources.VALIDFNAME;
  validCity = resources.VALIDCITY;
  Warningicon = resources.WARNING;
  deleteAccount = resources.DELETE_ACCOUNT;
  updateMsg = resources.UPDATE_MSG;
  accessPersonal = resources.ACCESS_PERSONAL;
  address = resources.ADDRESS;
  communicationDetails = resources.COMMUNICATION_DETAILS;
  personalInformation = resources.PERSONAL_INFORMATION;
  accountSettings = resources.ACCOUNT_SETTINGS;
  quickLinks = resources.QUICKLINKS;
  myProfile = resources.MYPROFILE;
  saveChanges = resources.SAVECHANGES;
  personalInfo = resources.PERSONAL_INFO;
  accessRequest = resources.ACCESS_REQUEST;
  requestAccess = resources.REQUEST_ACCESS;
  requestDelete = resources.REQUEST_DELETE;
  personalRequest = resources.PERSONAL_REQUEST;
  sendRequest = resources.SEND_REQUEST;
  firstnamelabel = resources.FIRSTNAME_LABEL;
  lastnameLabel = resources.LASTNAME_LABEL;
  dobLabel = resources.DOB_LABEL;
  genderLabel = resources.GENDER_LABEL;
  emailLabel = resources.EMAIL_HEADING;
  prefferedLabel = resources.PREFFERED_LABEL;
  countryLabel = resources.COUNTRY_LABEL;
  stateLabel = resources.STATE_LABEL;
  citylabel = resources.CITY_LABEL;
  streetAddress = resources.STREET_ADDRESS;
  zipcodeLabel = resources.ZIPCODE_LABEL;
  deleteAccountLabel = resources.DELETEACCOUNT;
  deleteRequest = resources.DELETEREQUEST;
  deleteButtonbtn = resources.DELETEACCOUNTBTN;
  requestButton = resources.REQUEST_BUTTON;
  yesButton = resources.YES_BUTTON;
  noButton = resources.NO_BUTTON;
  enterDob = resources.ENTER_DOB;
  enterLastName = resources.ENTER_LASTNAME;
  enterFirstName = resources.ENTER_FIRSTNAME;
  enterEmail = resources.ENTER_EMAIL;
  select = resources.SELECT;
  enterPhone = resources.PHONE_NUMBER;
  enterCountry = resources.ENTER_COUNTRY;
  enterState = resources.ENTER_STATE;
  enterCity = resources.ENTER_CITY;
  enterZipcode = resources.ENTER_ZIPCODE;
  enterStreet = resources.ENTER_STREET;

  //

  informationgenderboth = resources.PATIENTEMAILMSGBOTH;
  informationgendermsg = resources.PATIENTEMAILlMSG;
  informationgender = resources.INFORMATIONGENDERPATIENT;
  cgpatientconfirmchange = resources.CONFIRMCHANGES;
  cgpatientconfirmseven = resources.CONFIRSEVEN;
  cgpatientconfirmup = resources.CONFIRMUP;
  cgpatientconfirmtext = resources.CONFIRMTEXT;
  cgpatientconfirm = resources.CONFIRM;
  yesLabel = label.YES;
  noLabel = label.NO;
  //to prepopulate patient information
  @wire(ACCOUNT_DETAILS)
  wiredcurrentrecord({ error, data }) {
    // Null data is checked and AuraHandledException is thrown from the Apex
    try {
      if (data && data !== null) {
        this.placeholderClass = 'hide-placeholder';
        this.accountId = data.Id;
        this.patientFirstName = data.FirstName;
        this.patientLastName = data.LastName;
        this.patientDOB = data.BI_PSP_Birthdate__c;
        this.patientAge = data.BI_PSP_Age__c;
        this.patientEmail = data.PersonEmail;
        this.patientEmailold = data.PersonEmail;
        this.patientMobilePhone = data.Phone;
        this.relations = data.HealthCloudGA__Gender__pc;
        this.preferredCommunication =
          data.BI_PSPB_Preferred_Communication_Method__c;
        this.country = data.PersonMailingCountryCode;
        this.state = data.PersonMailingStateCode;
        this.patientCity = data.PersonMailingCity;
        this.patientStreet = data.PersonMailingStreet;
        this.patientZipCode = data.PersonMailingPostalCode;
        if (data.BI_PSP_EmailModifiedDate__c === null || data.BI_PSP_EmailModifiedDate__c === undefined) {
          this.isEmailDisabled = false
        } else {
          this.emailModifiedDate = data.BI_PSP_EmailModifiedDate__c;
          this.differenceInDays = this.dateDifference();
          this.isEmailDisabled = this.differenceInDays < resources.EmailModified;
        }
        if (this.isEmailDisabled ===true){
          this.template.querySelector('label[data-field="email"]').className = "labeldisemail";

    }
        if (this.country && this.state) {
          this.loadState();
        }
        if (
          (this.patientDOB !== null || this.patientDOB !== undefined) &&
          this.patientAge <= resources.MINOR_AGE
        ) {
          this.isDOBDisabled = true;

        }
        if (
          this.preferredCommunication === resources.SMS_LABEL ||
          this.preferredCommunication === resources.PHONE_LABEL
        ) {
          this.pmcName = resources.PHONE_MANDATORY;
        }
        // Check if running in a browser environment
        if (typeof window !== "undefined") {
          this.dispatchEvent(new CustomEvent("load"));
        }
      } else if (error) {
        let globalThis = window;
        this.error = error.body.message;
        globalThis.location.href = resources.ERROR_PAGE;
        globalThis.sessionStorage.setItem("errorMessage", this.error);
      }
    } catch (err) {
      let globalThis = window;
      globalThis.location.href = resources.ERROR_PAGE;
      globalThis.sessionStorage.setItem("errorMessage", err.body.message);
    }
  }

  //Get the checkbox values from created cases for patient in account setting (Request Access)
  @wire(GET_CHECKBOX_VALUES, { relatedAccounts: "$accountId" })
  wiredCheckboxValuesone({ data, error }) {
    try {
      /*For a null check, the error is logged. It cannot be thrown as an Aura handled Exception because there may 
      be a possibility the user has no case records. The toast message can be disruptive to the UI/UX design.*/
      if (data) {
        this.checkboxFirstValue = data.BI_PSP_Personal_Information_Request__c;

        if (this.checkboxFirstValue === true) {
          this.isAccessButtonDisabled = false;
          this.colorChnage = "outlined-button";
        } else {
          this.isAccessButtonDisabled = true;
          this.colorChnage = "button-bttn";
          this.accessMessage = true;
        }
      } else if (error) {
        let globalThis = window;
        this.error = error.body.message;
        globalThis.location.href = resources.ERROR_PAGE;
        globalThis.sessionStorage.setItem("errorMessage", this.error);
      }
    } catch (err) {
      let globalThis = window;
      globalThis.location.href = resources.ERROR_PAGE;
      globalThis.sessionStorage.setItem("errorMessage", err.body.message);
    }
  }
  //Get the checkbox values from created cases for patient in account setting (Delete Access)
  @wire(CHECKBOX_VALUES_REQUEST, { relatedAccounts: "$accountId" })
  wiredCheckboxValuestwo({ data }) {
    try {
      /*For a null check, the error is logged. It cannot be thrown as an Aura handled Exception because there may 
      be a possibility the user has no case records. The toast message can be disruptive to the UI/UX design.*/
      if (data) {
        this.checkboxSecondValue = data.BI_PSP_Account_Deletion_Request__c;
        if (this.checkboxSecondValue === true) {
          this.isButtonDeleteDisabled = false;
          this.colorChanage = "outlined-button";
        } else {
          this.isButtonDeleteDisabled = true;
          this.colorChanage = "button-bttn";
          this.DeleteMessage = true;
        }
      }
    } catch (err) {
      let globalThis = window;
      globalThis.location.href = resources.ERROR_PAGE;
      globalThis.sessionStorage.setItem("errorMessage", err.body.message);
    }
  }
  //get country values
  @wire(COUNTRYS)
  wiredCountries({ error, data }) {
    try {
      if (data) {
        this.countryCode = data.map((country) => ({
          label: country.label,
          value: country.value
        }));
      } else if (error) {
        let globalThis = window;
        this.error = error.body.message;
        globalThis.location.href = resources.ERROR_PAGE;
        globalThis.sessionStorage.setItem("errorMessage", this.error);
      }
    } catch (err) {
      let globalThis = window;
      globalThis.location.href = resources.ERROR_PAGE;
      globalThis.sessionStorage.setItem("errorMessage", err.body.message);
    }
  }

  //getcurrunt enrollee

  connectedCallback() {
     let globalThis = window;
    this.currentPageUrl = globalThis.location?.href;
            this.urlSegments = this.currentPageUrl.split('/');
            this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
    try {
      loadStyle(this, resources.TEXT_ALIGN);
      ENROLLEE_DETAILS({ userId: this.userId })
        .then((result) => {
          if (result !== null) {
            if (result[0].patientEnrolle !== null) {
              this.enrolleeids = result[0].patientEnrolle.Id;
            } else if (result[0].error !== null) {
              this.showError = true;
              this.errorMessage = result[0].error;
            }
          }
        })
        .catch(() => {
          this.error = resources.ENROLLEE_NOT_FOUND;
          globalThis.location.href = resources.ERROR_PAGE;
          globalThis.sessionStorage.setItem("errorMessage", this.error);
        });
    } catch (error) {
      globalThis.location.href = resources.ERROR_PAGE;
      globalThis.sessionStorage.setItem("errorMessage", error);
    }
  }

  dateDifference() {
    if (this.emailModifiedDate) {
      // Convert the BI_PSP_EmailModifiedDate__c to a Date object
      const emailModified = new Date(this.emailModifiedDate);
      const today = new Date();

      // Ensure that emailModified is a valid date
      if (isNaN(emailModified.getTime())) {
        return null;
      }

      // Calculate the difference in milliseconds
      const differenceInTime = today.getTime() - emailModified.getTime();

      // Convert milliseconds to days
      const differenceInDays = Math.floor(
        differenceInTime / (1000 * 3600 * 24)
      );
      return differenceInDays;
    }
    return null;
  }
  //to validate the first name
  handleFieldChange(event) {
    this.changeName = true;
    // Assuming you're using event.target.value to get the value from the input field
    this.patientFirstName = event.target.value;
    this.patientFirstName =
      event.target.value.trim().charAt(0).toUpperCase() +
      event.target.value.trim().slice(1);
    this.firstNameErrorMessag = false;

    this.validateFirstName(); // Call the method to validate the first name
  }

  //to validate the first name
  validateFirstName() {
    this.changeName = true;
    const FIRSTNAMELABLE = this.template.querySelector(
      'lightning-input[data-field="FirstName"]'
    );
    if (!this.patientFirstName) {
      this.firstNameErrorMessag = true;
      this.firstNameErrorMessageValid = false;
      // Add CSS classes to highlight the input field and label with an error
      //to get data field value from html

      FIRSTNAMELABLE.className = "textInput-err";
      this.template.querySelector('label[data-field="FirstName"]').className =
        "input-error-label";
    } else if (!/^[a-zA-ZÀ-ž\s\-`'.]+$/u.test(this.patientFirstName)) {
      this.firstNameErrorMessageValid = true;
      this.firstNameErrorMessag = false;
      FIRSTNAMELABLE.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="FirstName"]').className =
        "input-error-label";
    } else {
      this.firstNameErrorMessag = false;
      this.firstNameErrorMessageValid = false;
      // Remove CSS classes if the validation passes

      FIRSTNAMELABLE.className = "textInput";
      this.template.querySelector('label[data-field="FirstName"]').className =
        "input-label";
    }
  }

  //to validate the last name
  handlelastname(event) {
    this.changeName = true;
    this.patientLastName = event.target.value;
    this.patientLastName =
      event.target.value.trim().charAt(0).toUpperCase() +
      event.target.value.trim().slice(1);

    this.lastNameErrorMessage = false;
    this.validatelastName();
  }

  //to validate the last name
  validatelastName() {
    this.changeName = true;
    const LAST_NAME_FIELD = this.template.querySelector(
      'lightning-input[data-field="LastName"]'
    );
    if (!this.patientLastName) {
      this.lastNameErrorMessage = true;
      this.lastNameErrorMessageValid = false;
      // Add CSS classes to highlight the input field and label with an error
      LAST_NAME_FIELD.className = "textInput-err";
      this.template.querySelector('label[data-field="LastName"]').className =
        "input-error-label";
    } else if (!/^[a-zA-ZÀ-ž\s\-`'.]+$/u.test(this.patientLastName)) {
      this.lastNameErrorMessage = false;
      this.lastNameErrorMessageValid = true;
      LAST_NAME_FIELD.className = "textInput-err";
      this.template.querySelector('label[data-field="LastName"]').className =
        "input-error-label";
    } else {
      this.lastNameErrorMessage = false;
      this.lastNameErrorMessageValid = false;
      // Remove CSS classes if the validation passes
      LAST_NAME_FIELD.className = "textInput";
      this.template.querySelector('label[data-field="LastName"]').className =
        "input-label";
    }
  }

  // Validate that the date is not in the future
  agecalculationEvent(event) {

    this.patientDOB = event.target.value;
    this.validateDate();
  }

  validateDate() {
    const CURRENT_DATE = new Date();
    const SELECTED_DATE = new Date(this.patientDOB);
    const MIN_AGE = resources.MINOR_AGE;
    this.placeholderClass = 'hide-placeholder';
    // Reset error messages and input styles
    this.resetErrors();

    // Reset error messages and input styles
    if (!this.patientDOB) {
      this.dobErrorMessage = true;
      this.placeholderClass = 'date-input-container';
     this.setFieldError("Birthdate");
    } else {
      this.required = false;
      this.dobErrorMessage = false;
      this.placeholderClass = 'hide-placeholder';
      this.template
        .querySelector('input[data-field="Birthdate"]')
        .classList.remove("dateText-err");
      this.template
        .querySelector('label[data-field="Birthdate"]')
        .classList.remove("input-error-label");
    }

    // Check if the date is in the future
    if (SELECTED_DATE > CURRENT_DATE) {
      this.never = true;
      this.minorErrorThree = true;
      this.dobErrorMessage = false;
      this.setFieldError("Birthdate");
      return;
    }

    // Check if the user is a MINOR
    const AGE_IN_YEARS =
      CURRENT_DATE.getFullYear() - SELECTED_DATE.getFullYear();
    if (AGE_IN_YEARS < MIN_AGE) {
      this.never = true;
      this.minorerror = true;
      this.dobErrorMessage = false;
      this.setFieldError("Birthdate");
      return;
    }

    // Check if the date is before 1900
    if (SELECTED_DATE < new Date("1900-01-01")) {
      this.minorErrorTwo = true;
      this.dobErrorMessage = false;
      this.setFieldError("Birthdate");
      return;
    }

    // If all validations pass, clear the error message
    // this.dobErrorMessage = "";
    this.never = false;
  }

  resetErrors() {
    this.minorerror = false;
    this.minorErrorTwo = false;
    this.minorErrorThree = false;
     this.clearFieldError("Birthdate");
  }


  setFieldError(fieldName) {
    const INPUT_FIELD = this.template.querySelector(
      `input[data-field="${fieldName}"]`
    );
    INPUT_FIELD.className = "dateText-err";
    const LABEL_FIELD = this.template.querySelector(
      `label[data-field="${fieldName}"]`
    );
    LABEL_FIELD.className = "input-error-label";
  }

  clearFieldError(fieldName) {
    const INPUT_FIELD = this.template.querySelector(
      `input[data-field="${fieldName}"]`
    );
    INPUT_FIELD.className = "dateText";
    const LABEL_FIELD = this.template.querySelector(
      `label[data-field="${fieldName}"]`
    );
    LABEL_FIELD.className = "input-label";
  }

  //to validate phone field
  handleFielphone(event) {
    this.changeName = true;
    this.patientMobilePhone = event.target.value;

    this.validatePhone();
  }
  validatePhone() {

    if (
      this.patientMobilePhone === "" &&
      this.pmcName === resources.PHONE_MANDATORY
    ) {
      this.MobileErrorMessage = true;
      this.template.querySelector(
        'lightning-input[data-field="phone"]'
      ).className = "textInput-err";
      this.template.querySelector('label[data-field="phone"]').className =
        "input-error-label";
    } else {
      this.MobileErrorMessage = false;
      this.template.querySelector(
        'lightning-input[data-field="phone"]'
      ).className = "textInput";
      this.template.querySelector('label[data-field="phone"]').className =
        "input-label";
    }
  }
  //to validate relationship field
  relationshipEvent(event) {
    this.changeName = true;
    this.relations = event.target.value;
    this.validaterelation();
  }

  validaterelation() {
    const RELATION_FIELD = this.template.querySelector(
      `lightning-combobox[data-field="relationship"]`
    );
    if (!this.relations) {
      this.relationshiperrorMessage = true;
      RELATION_FIELD.className = "textInput-err";
      this.template.querySelector(
        'label[data-field="relationship"]'
      ).className = "input-error-label";
    } else {
      this.relationshiperrorMessage = false;
      RELATION_FIELD.className = "textInput box";
      this.template.querySelector(
        'label[data-field="relationship"]'
      ).className = "input-label";
    }
  }

  //to validate preferred communication method
  handlePmcChange(event) {
    this.changeName = true;
    this.preferredCommunication = event.target.value;
    if (this.preferredCommunication === resources.EMAIL_LABEL) {
      this.pmcName = resources.PHONE_NUMBER_LABEL;
    }
    this.validatepmc();
  }
  validatepmc() {
    // Check if preferred communication is SMS or PHONE
    if (
      this.preferredCommunication === resources.SMS_LABEL ||
      this.preferredCommunication === resources.PHONE_LABEL
    ) {
      this.pmcName = resources.PHONE_MANDATORY;

      // Validate phone number field
      if (!this.patientMobilePhone) {
        this.MobileErrorMessage = true;
        this.template
          .querySelector('lightning-input[data-field="phone"]')
          .classList.add("textInput-err");
        this.template
          .querySelector('label[data-field="phone"]')
          .classList.add("input-error-label");
        this.template
          .querySelector('label[data-field="phone"]')
          .classList.remove("input-label");
      } else {
        this.MobileErrorMessage = false;
        this.template
          .querySelector('lightning-input[data-field="phone"]')
          .classList.remove("textInput-err");
        this.template
          .querySelector('label[data-field="phone"]')
          .classList.remove("input-error-label");
        this.template
          .querySelector('label[data-field="phone"]')
          .classList.add("input-label");
      }
    }
    // Check if preferred communication is EMAIL
    else if (this.preferredCommunication === resources.EMAIL_LABEL) {
      this.pmcName = resources.PHONE_NUMBER_LABEL;
      this.MobileErrorMessage = false; // No error needed for phone field when preferred communication is EMAIL
      this.template
        .querySelector('lightning-input[data-field="phone"]')
        .classList.remove("textInput-err");
      this.template
        .querySelector('label[data-field="phone"]')
        .classList.remove("input-error-label");
      this.template
        .querySelector('label[data-field="phone"]')
        .classList.add("input-label");
    }
    // Preferred communication is not selected
    else {
      this.conPmcErrorMessage = true;
      this.template
        .querySelector('lightning-combobox[data-field="preefer"]')
        .classList.add("textInput-err");
      this.template
        .querySelector('div[data-field="preefer"]')
        .classList.add("input-error-label");
      this.template
        .querySelector('div[data-field="preefer"]')
        .classList.remove("input-label");
    }

    // Check if preferred communication is selected
    if (!this.preferredCommunication) {
      this.conPmcErrorMessage = true;
      this.template
        .querySelector('lightning-combobox[data-field="preefer"]')
        .classList.add("textInput-err");
      this.template
        .querySelector('div[data-field="preefer"]')
        .classList.add("input-error-label");
      this.template
        .querySelector('div[data-field="preefer"]')
        .classList.remove("input-label");
    } else {
      this.conPmcErrorMessage = false;
      this.template
        .querySelector('lightning-combobox[data-field="preefer"]')
        .classList.remove("textInput-err");
      this.template
        .querySelector('div[data-field="preefer"]')
        .classList.remove("input-error-label");
      this.template
        .querySelector('div[data-field="preefer"]')
        .classList.add("input-label");
    }
  }

  //to validate country field
  handleFielcountry(event) {
    this.changeName = true;
    this.country = event.target.value;
    this.state = null;
    this.loadState();
    this.validateCountry();
  }
  loadState() {
    STATES({ selectedCountry: this.country })
      .then((result) => {
        this.StateCode = result.map((state) => ({
          label: state.Name,
          value: state.BI_PSPB_StateCode__c
        }));
      })
      .catch(() => {
        let globalThis = window;
        this.error = resources.RECORD_NOT_FOUND;
        globalThis.location.href = resources.ERROR_PAGE;
        globalThis.sessionStorage.setItem("errorMessage", this.error);
      });
  }
  validateCountry() {
    if (!this.country) {
      this.countryCodeMessage = true;
      this.template
        .querySelector('lightning-combobox[data-field="country"]')
        .classList.add("textInput-err");
      this.template
        .querySelector('div[data-field="country"]')
        .classList.add("input-error-label");
    } else {
      this.countryCodeMessage = false;
      this.template
        .querySelector('lightning-combobox[data-field="country"]')
        .classList.remove("textInput-err");
      this.template
        .querySelector('div[data-field="country"]')
        .classList.remove("input-error-label");
    }
  }
  //to validate state field
  handleFieldstate(event) {
    this.changeName = true;
    this.state = event.target.value;
    this.validatestate();
  }
  validatestate() {
    if (!this.state) {
      this.stateCodeMessage = true;
      this.template
        .querySelector('lightning-combobox[data-field="state"]')
        .classList.add("textInput-err");
      this.template
        .querySelector('div[data-field="state"]')
        .classList.add("input-error-label");
    } else {
      this.stateCodeMessage = false;
      this.template
        .querySelector('lightning-combobox[data-field="state"]')
        .classList.remove("textInput-err");
      this.template
        .querySelector('div[data-field="state"]')
        .classList.remove("input-error-label");
    }
  }
  //to validate city field
  handleFieldCity(event) {
    this.changeName = true;
    this.patientCity = event.target.value;
    this.patientCity =
      event.target.value.trim().charAt(0).toUpperCase() +
      event.target.value.trim().slice(1);
    this.validateCity();
  }
  validateCity() {
    const CITYCLASS = this.template.querySelector(
      'lightning-input[data-field="city"]'
    );
    if (!this.patientCity) {
      this.cityMessage = true;
      this.RpCityErrorMessageValid = false;

      CITYCLASS.className = "textInput-err";
      this.template.querySelector('label[data-field="city"]').className =
        "input-error-label";
    } else if (!/^[a-zA-ZÀ-ž\s\-`'.]+$/u.test(this.patientCity)) {
      this.cityMessage = false;
      this.RpCityErrorMessageValid = true;
      CITYCLASS.className = "textInput-err";
      this.template.querySelector('label[data-field="city"]').className =
        "input-error-label";
    } else {
      this.cityMessage = false;
      this.RpCityErrorMessageValid = false;

      CITYCLASS.className = "textInput";
      this.template.querySelector('label[data-field="city"]').className =
        "input-label";
    }
  }
  //to validate street field
  handleFieldstreet(event) {
    this.changeName = true;
    this.patientStreet = event.target.value;
    this.validatestreet();
  }
  validatestreet() {
    const STREETCLASS = this.template.querySelector(
      'lightning-input[data-field="street"]'
    );
    if (!this.patientStreet) {
      this.streetMessage = true;

      STREETCLASS.className = "textInput-err";
      this.template.querySelector('label[data-field="street"]').className =
        "input-error-label";
    } else {
      this.streetMessage = false;

      STREETCLASS.className = "textInput";
      this.template.querySelector('label[data-field="street"]').className =
        "input-label";
    }
  }

  //to validate pincode field
  handleFieldcode(event) {
    this.changeName = true;
    this.patientZipCode = event.target.value;
    this.validatezipcode();
  }
  validatezipcode() {
    const PINCODECLASS = this.template.querySelector(
      'lightning-input[data-field="pincode"]'
    );
    if (!this.patientZipCode) {
      this.postalCodeMessage = true;
      this.ZipErrorMessageValid = false;

      PINCODECLASS.className = "textInput-err";
      this.template.querySelector('label[data-field="pincode"]').className =
        "input-error-label";
    } else if (!/^[a-zA-Z0-9]+$/u.test(this.patientZipCode)) {
      this.postalCodeMessage = false;
      this.ZipErrorMessageValid = true;
      PINCODECLASS.className = "textInput-err";
      this.template.querySelector('label[data-field="pincode"]').className =
        "input-error-label";
    } else {
      this.postalCodeMessage = false;
      this.ZipErrorMessageValid = false;
      PINCODECLASS.className = "textInput";
      this.template.querySelector('label[data-field="pincode"]').className =
        "input-label";
    }
  }
  uniqueEmail;
  matchEmail = false;
  uniqueDOB;
  uniqueLname;
  uniqueFName;

  // To validate the email field
  handleEmail(event) {

    this.patientEmail = ""; // Clear the previous email value
    this.patientEmail = event.target.value; // Set the new email value

    this.changeEmail = true;

    if (this.patientEmail === "") {
      this.emailErrorMessage = true;
      this.template.querySelector(
        'lightning-input[data-field="email"]'
      ).className = "textInput-err";
      this.template.querySelector('label[data-field="email"]').className =
        "input-error-label";
    } else {
       this.emailErrorMessage = false;
      this.template.querySelector(
              'lightning-input[data-field="email"]'
            ).className = "textInput";
            this.template.querySelector('label[data-field="email"]').className =
              "input-label";
      GET_EXISTING_ACCOUNTS({ email: this.patientEmail }).then((result) => {
        if (result && result.length > 0) {
          this.uniqueEmail = result.map((item) => item.PersonEmail);
          this.uniqueFName = result.map(item => item.FirstName);
					this.uniqueLname = result.map(item => item.LastName);
					this.uniqueDOB = result.map(item => item.BI_PSP_Birthdate__c);

          if (this.uniqueEmail[0] === this.patientEmail &&
				this.uniqueFName[0] === this.patientFirstName &&
				this.uniqueLname[0] === this.patientLastName &&
				this.uniqueDOB[0] === this.patientDOB){
          this.matchEmail = false;
        }else{
          this.checkemail();
        }
        } else {
          this.hasEmailChanged = true;
          this.emailErrorMessage = false;
          this.matchEmail = false;
          this.template.querySelector(
            'lightning-input[data-field="email"]'
          ).className = "textInput";
          this.template.querySelector('label[data-field="email"]').className =
            "input-label";
        }
      });
      // No need to catch black
    }
  }

  checkemail(){
    if (this.uniqueEmail.includes(this.patientEmail)) {
      this.matchEmail = true;
      this.emailErrorMessage = false;
      this.template.querySelector(
        'lightning-input[data-field="email"]'
      ).className = "textInput-err";
      this.template.querySelector('label[data-field="email"]').className =
        "input-error-label";
    } else {
      this.hasEmailChanged = true;
      this.matchEmail = false;
      this.emailErrorMessage = false;
      this.template.querySelector(
        'lightning-input[data-field="email"]'
      ).className = "textInput";
      this.template.querySelector('label[data-field="email"]').className =
        "input-label";
    }
  }
  //validate phone field
  validatePhoneInput(event) {
    this.changeName = true;
    const CHAR_CODE = event.which ? event.which : event.keyCode; // Get the ASCII code of the pressed key
    if (CHAR_CODE !== 43 && (CHAR_CODE < 48 || CHAR_CODE > 57)) {
      // Allow only digits (48-57) and the plus symbol (43)
      event.preventDefault(); // Prevent the character from being entered
    }
  }

  handleKeyDown1(event) {
    const ALLOWED_CHARACTERS = /^[A-Za-z]+$/u;
    if (!ALLOWED_CHARACTERS.test(event.key)) {
      event.preventDefault();
    }
  }
  // Not allow paste event in FIRST_NAME and last name
  handlePaste(event) {
    // Prevent default paste behavior
    event.preventDefault();
  }
  handleKeyDownThree(event) {
    event.preventDefault();
  }
  //checks whether all fields have values and updates patient information

  // Assuming patientFirstName is your variable that holds the value
  // Initialize a placeholder text variable

  // Now use this placeholderText in your template
  handleDeletPopup() {
    this.isDeletePopupOpen = !this.isDeletePopupOpen;
    document.body.style.overflow = "";
  }
  handleDeletPopupopen() {
    this.isDeletePopupOpen = !this.isDeletePopupOpen;
    document.body.style.overflow = "hidden";
  }

  handleAccessPopup() {
    this.isAccessPopupOpen = !this.isAccessPopupOpen;
    this.accesspopup = false;
    document.body.style.overflow = "";
  }
  handleAccessPopupopen() {
    this.isAccessPopupOpen = !this.isAccessPopupOpen;
    this.accesspopup = false;
    document.body.style.overflow = "hidden";
  }

  handleYesButtonClick() {
    this.isButtonDeleteDisabled = true;
    this.colorChanage = "button-btn";
    this.DeleteMessage = true;
    this.deletepopup = true;
    this.isDeletePopupOpen = false;
    this.showDiv = true;
    document.body.style.overflow = "";
    window.scrollTo({ top: 0, behavior: "smooth" });

    CREATE_CASE()
      .then(() => {
        window.scrollTo({ top: 0, behavior: "smooth" });
        this.showDiv = true;
      })
      .catch(() => {
        let globalThis = window;
        this.error = resources.CASE_NOT_CREATE;
        globalThis.location.href = resources.ERROR_PAGE;
        globalThis.sessionStorage.setItem("errorMessage", this.error);
      });

    if (this.checkboxFirstValue.checked) {
      this.isButtonDeleteDisabled = false;
    } else {
      this.isButtonDeleteDisabled = true;
    }
  }

  showToast(title, message, variant) {
    const toastEvent = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    if (typeof window !== "undefined") {
      this.dispatchEvent(toastEvent);
    }
  }

  handleYesButtonClick2() {
    this.isAccessPopupOpen = false;
    this.isAccessButtonDisabled = true;
    this.colorChnage = "button-btn";
    this.accessMessage = true;
    this.accesspopup = true;
    this.showDivOne = true;
    document.body.style.overflow = "";
    CREATE_ACCESS_CASE()
      .then(() => {
        window.scrollTo({ top: 0, behavior: "smooth" });
      })
      .catch(() => {
        let globalThis = window;
        this.error = resources.CASE_NOT_CREATE;
        globalThis.location.href = resources.ERROR_PAGE;
        globalThis.sessionStorage.setItem("errorMessage", this.error);
      });
  }

  handleClose() {
    this.showDiv = false;
    this.showDivOne = false;
    this.updatePopup = false;
  }
  click() {
    this.touch = true;
    this.down = false;
    this.up = true;
  }
  notclick() {
    this.touch = false;
    this.down = true;
    this.up = false;
  }

  handle_Success() {
    if(this.dobErrorMessage){
      return
    }
    const emailInput = this.template.querySelector('lightning-input[data-field="email"]');
    const emailLabel = this.template.querySelector('label[data-field="email"]');
    if (!this.patientEmail || this.patientEmail.length === 0) {
      this.emailErrorMessage = true;
      this.deleteButton = false;
      if (emailInput) {

        emailInput.className = 'textInput-err'; // Apply error class
        emailLabel.className = "input-error-label"; // Set error class
        this.deleteButton = false;

      }
      if (emailLabel) {
        this.deleteButton = false;
        emailLabel.className = 'input-error-label'; // Apply error class
      }
    }
    else if (this.changeEmail === true) {
      this.deleteButton = true;

      document.body.style.overflow = "";
    }
    if (this.matchEmail === true) {
      return;
    }

    this.validaterelation();
    if (this.never === true) {
      this.isValid = false;
    }
    // Define validation rules
    const validations = [
      {
        field: "patientFirstName",
        errorFlag: "firstNameErrorMessage",
        dataField: "FirstName",
        required: true
      },
      {
        field: "patientLastName",
        errorFlag: "lastNameErrorMessage",
        dataField: "LastName",
        required: true
      },
      {
        field: "patientDOB",
        errorFlag: "minorErrorThree",
        dataField: "Birthdate",
        required: true
      },
      {
        field: "patientMobilePhone",
        errorFlag: "MobileErrorMessage",
        dataField: "phone",
        condition: () =>
          (this.preferredCommunication === resources.SMS_LABEL ||
            this.preferredCommunication === resources.PHONE_LABEL) &&
          !this.patientMobilePhone
      },
      {
        field: "preferredCommunication",
        errorFlag: "conPmcErrorMessage",
        dataField: "preefer",
        required: true
      },
      {
        field: "country",
        errorFlag: "countryCodeMessage",
        dataField: "country",
        required: true
      },
      {
        field: "state",
        errorFlag: "stateCodeMessage",
        dataField: "state",
        required: true
      },
      {
        field: "patientCity",
        errorFlag: "cityMessage",
        dataField: "city",
        required: true
      },
      {
        field: "patientStreet",
        errorFlag: "streetMessage",
        dataField: "street",
        required: true
      },
      {
        field: "patientZipCode",
        errorFlag: "postalCodeMessage",
        dataField: "pincode",
        condition: () =>
          !this.patientZipCode || !/^[a-zA-Z0-9]+$/u.test(this.patientZipCode)
      },
      {
        field: "patientEmail",
        errorFlag: "emailErrorMessage",
        dataField: "email",
        required: true
      },
      {
        field: "relations",
        errorFlag: "relationshiperrorMessage",
        dataField: "relationship",
        required: true
      }
    ];

    let isValid = true;

    validations.forEach((validation) => {
      const fieldValue = this[validation.field];
      const isValidField = validation.condition
        ? !validation.condition()
        : !!fieldValue;
      this[validation.errorFlag] = !isValidField;

      const inputField =
        this.template.querySelector(
          `lightning-input[data-field="${validation.dataField}"]`
        ) ||
        this.template.querySelector(
          `lightning-combobox[data-field="${validation.dataField}"]`
        );
      const labelField = this.template.querySelector(
        `label[data-field="${validation.dataField}"]`
      );
      const genderField = this.template.querySelector(
        `lightning-combobox[data-field="relationship"]`
      );

      if (inputField && labelField) {
        if (!isValidField && validation.required) {
          inputField.classList.add("textInput-err");
          labelField.classList.add("input-error-label");
          labelField.classList.remove("input-label");
        } else {
          inputField.classList.remove("textInput-err");
          labelField.classList.remove("input-error-label");
          labelField.classList.add("input-label");
          genderField.classList.add("box");
        }
      }

      isValid = isValid && (isValidField || !validation.required);
    });


    if (this.minorerror || this.dobErrorMessage || this.minorErrorThree || this.minorErrorTwo) {
      isValid = false;
    }

    // Additional validation for phone field if required
    isValid = this.validatephone();
     isValid = this.validationall();
    // ZIP code validation
    if (!this.validateZipCode()) {
      isValid = false;
    }

    if (this.hasEmailChanged) {
      this.openModal = true;
      isValid = false;
    }
    else if (this.never === true) {
      isValid = false;
    }

    // Proceed if all fields are valid
    if (isValid) {
      this.updatePopup = true;


      this.callupdatereords();

    }

  }
 validationall() {
    let isValid = true; // Start with the assumption that the form is valid

    // If any of these error messages exist, set isValid to false
    if (this.firstNameErrorMessage || 
        this.lastNameErrorMessage || 
        this.cityMessage || 
        this.streetMessage || 
        this.emailErrorMessage) {
        isValid = false;
    }

    return isValid; // Return the final validation result
}

  validateZipCode() {
    const ZIPCODECLASS = this.template.querySelector(
      'lightning-input[data-field="pincode"]'
    );
    const ZIPCODE_LABEL = this.template.querySelector(
      'label[data-field="pincode"]'
    );

    if (this.patientZipCode && /^[a-zA-Z0-9]+$/u.test(this.patientZipCode)) {
      this.zipCodeErrorMessage = false;
      if (ZIPCODECLASS) ZIPCODECLASS.classList.remove("textInput-err");
      if (ZIPCODE_LABEL) {
        ZIPCODE_LABEL.classList.remove("input-error-label");
        ZIPCODE_LABEL.classList.add("input-label");
      }
    } else {
      this.zipCodeErrorMessage = true;
      if (ZIPCODECLASS) ZIPCODECLASS.classList.add("textInput-err");
      if (ZIPCODE_LABEL) {
        ZIPCODE_LABEL.classList.add("input-error-label");
        ZIPCODE_LABEL.classList.remove("input-label");
      }
      return false; // Return false if validation fails
    }
    return true; // Return true if validation passes
  }
  validatephone(){
    let isValid = true;
    const isPhoneFieldRequired =
    this.preferredCommunication === resources.SMS_LABEL ||
    this.preferredCommunication === resources.PHONE_LABEL;
  const PHONECLASS = this.template.querySelector(
    'lightning-input[data-field="phone"]'
  );
  const PHONE_LABEL = this.template.querySelector(
    'label[data-field="phone"]'
  );

  if (isPhoneFieldRequired && !this.patientMobilePhone) {
    this.MobileErrorMessage = true;
    if (PHONECLASS) PHONECLASS.classList.add("textInput-err");
    if (PHONE_LABEL) {
      PHONE_LABEL.classList.add("input-error-label");
      PHONE_LABEL.classList.remove("input-label");
    }
    isValid = false;
  } else {
    this.MobileErrorMessage = false;
    if (PHONECLASS) PHONECLASS.classList.remove("textInput-err");
    if (PHONE_LABEL) {
      PHONE_LABEL.classList.remove("input-error-label");
      PHONE_LABEL.classList.add("input-label");
    }
  }
  return isValid;
  }
  callupdatereords() {
    const caregiverDetails = {
      accountId: this.accountId,
      firstName: this.patientFirstName,
      lastName: this.patientLastName,
      personEmail: this.patientEmail,
      personBirthdate: this.patientDOB,
      personGender: this.relations,
      preferredMethodOfContact: this.preferredCommunication,
      street: this.patientStreet,
      city: this.patientCity,
      state: this.state,
      country: this.country,
      postalCode: this.patientZipCode,
      phone: this.patientMobilePhone
    };
    UPDATE_PATIENT_DETAILS({ wrapper: caregiverDetails })
      .then(() => {
        this.updatePopup = true; // Ensure updatePopup is set to true
        window.scrollTo({ top: 0, behavior: "smooth" });
      })
      .catch((error) => {
        let globalThis = window;
        globalThis.location.href = resources.ERROR_PAGE;
        globalThis.sessionStorage.setItem("errorMessage", error.body.message);
      });
  }

  handleDeleteBtn() {
    // Initialize validity flag
    let isValid = true;

    // Disable the delete button
    this.deleteButton = false;

    // Validate condition based on 'never' property
    if (this.never === true) {
        isValid = false;
    }

    // Proceed to update records if valid
    if (isValid) {
        this.callupdatereords();
        this.logoutFromSite()
    }
}
  closeEdit() {
    this.deleteButton = false;
    document.body.style.overflow = ""; // Reset to default
    if (this.changeEmail && this.changeName) {
      this.patientEmail = this.patientEmailold;
      this.callupdatereords();
    }
    // Reset email if it was changed
    else if (this.changeEmail) {
      this.patientEmail = this.patientEmailold; // Assuming defaultEmail holds the original email
      this.changeEmail = false; // Reset the flag
    }



  }

  closedeletbtnadd() {
    // Add your specific logic for closing the mood modal
    this.deleteButton = false;
    document.body.style.overflow = "";

    // Reset to default
  }
  logoutFromSite() {
        let globalThis = window;
        try {
            let currentUrl = window.location.href;
            let urlParts = currentUrl.split('/');
            let index = urlParts.indexOf('s');
            if (index !== -1) {
                this.desiredUrl = urlParts.slice(0, index + 1).join('/');
            }
            globalThis.location?.assign(this.desiredUrl.replace(/\/s/gu, '/') + this.secureLogout + this.baseUrl + this.siteUrlBranded + this.siteloginBranded);

        } catch (error) {
            //navigate to error page
            globalThis.sessionStorage.setItem('errorMessage', error.body.message);
            globalThis.location?.assign(this.baseUrl + this.siteUrlBranded + this.displayNavErrorPage);
        }
    }
}