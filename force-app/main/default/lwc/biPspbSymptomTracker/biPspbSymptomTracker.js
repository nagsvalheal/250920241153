// This components using  Main component connect all child components user date 
// and recntactivty gpp symptoms
// To import Libraries
import{LightningElement,track,api,wire}from "lwc";
import{loadStyle}from "lightning/platformResourceLoader";
import{NavigationMixin}from "lightning/navigation";
// To import Apex Classes
import CHECK_UNIQUE_DATE from "@salesforce/apex/BI_PSP_SymptomTrackerCtrl.checkUniqueDate";
import CREATE_CONTENT_DOCUMENT_LINKS from "@salesforce/apex/BI_PSP_SymptomTrackerOperationsCtrl.createContentDocumentLinks";
import DELETE_CONTENT_DOCUMENT_LINKS from "@salesforce/apex/BI_PSP_SymptomTrackerOperationsCtrl.deleteContentDocumentLinks";
import FETCH_ACCOUNT_DETAILS from "@salesforce/apex/BI_PSP_SymptomTrackerOperationsCtrl.fetchAccountDetails";
import GET_ALLERGYINTOLERANCE_DATA from "@salesforce/apex/BI_PSPB_SymptomPrimaryPageCtrl.getAllergyIntoleranceData";
import GET_LAST from "@salesforce/apex/BI_PSP_SymptomTrackerOperationsCtrl.getLastCareTemplate";
import GET_SYMPTOM_RECORD_DATA from "@salesforce/apex/BI_PSPB_SymptomPrimaryPageCtrl.getSymptomRecordData";
import GET_CASE_IMAGE_URL from "@salesforce/apex/BI_PSPB_SymptomPrimaryPageCtrl.getBase64Image";
import GET_ENROLLE from "@salesforce/apex/BI_PSP_CurrentUser.getEnrolleeRecords";
import RECORD_INSERT_STS from "@salesforce/apex/BI_PSP_SymptomTrackerCtrl.insertSymptomTracker";
import RECORD_INSERTST_UPDATE from "@salesforce/apex/BI_PSP_SymptomTrackerCtrl.updateSymptomTracker";
import SAVE_FILES from "@salesforce/apex/BI_PSP_SymptomTrackerOperationsCtrl.saveFiles";
import UPDATE_GPP_VALUE from "@salesforce/apex/BI_PSP_SymptomTrackerCtrl.updateGppValue";
import UPDATE_RECENT_VALUE from "@salesforce/apex/BI_PSP_SymptomTrackerCtrl.updateRecentSymptomActivity";

// To import Custom labels and static resources
import * as label from 'c/biPspbLabelAndResourceSymptom';
import GET_SYMPTOM_TRACKER_DETAILS from "@salesforce/apex/BI_PSP_SymptomTrackerAllergyCtrl.getSymptomTrackerDetails";
export default class BiPspbSymptomTracker extends NavigationMixin(LightningElement)
{
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@api variable declaration
	@api symptomrecord1;
	@api symptomTrackerId;
	@track imageUrls = [];
	@api recordId;
	//@track variable declaration
	fileType = label.FILE_TYPE;
	addSymptom = label.ADD_SYMPTOM;
	enterDate = label.ENTER_DATE;
	saveDate = label.SAVE_DATE;
	alreadyExist = label.SYMPTOM_ALREADY_EXIST;
	futureDate = label.SYMPTOM_FUTURE_DATE;
	lastModified = label.LAST_MODIFIED;
	experiencingGpp = label.EXPERIENCING_GPP_NOW;
	confirmAndSave = label.CONFIRM_SAVE;
	speakToDoctor = label.SPOKEN_GPP;
	selectSymptomsYouExperiencing = label.SELECT_BODY_SYMPTOM;
	activityLabel = label.SYMPTOM_ACTIVITY;
	selectCausesSymptom = label.CAUSE_SYMPTOM;
	steroidWithdrawal = label.STEROID_WITHDRAWAL;
	hadInfection = label.HAD_INFECTION;
	stressLabel = label.STRESS_LABEL;
	confirmPregnant = label.CONFIRMED_PREGNENT;
	stopSteroids = label.STARTING_STEROID;
	extremeClimate = label.EXTREME_WEATHER;
	newOintment = label.NEW_OINTMENT;
	excessiveSunExposure = label.SUN_EXPOSURE;
	addSkinPhoto = label.SYMPTOM_PHOTO;
	limitReached = label.LIMITED_REACHED;
	lastModifiedDate;
	pdfFile = label.PDF_FILE;
	maxFiveImage = label.MAXIMUM_IMAGE;
	maxLimit = label.MAXIMUM_LIMIT;
	addYourPhoto = label.ADD_YOUR_PHOTO;
	fileTooLarge = label.FILE_SIZE;
	photoOfFlares = label.PHOTO_FLARES;
	hereSomeAdvice = label.HERE_SOME_ADVICE;
	photoHostedRegion = label.SYMPTOM_PHOTO_ADVICE;
	takingPictures = label.TAKING_PICTURES;
	tipsToPerfectPhoto = label.TIPS_PERFECT_PHOTO;
	trySelfieMode = label.NO_SELFIE_MODE;
	lowerQuality = label.QUALITY_LOW;
	avoidZoom = label.ZOOM_AMOUNT;
	fastShutterSpeed = label.SET_SHUTTER_SPEED;
	goodLight = label.GOOD_LIGHTNING;
	closeLabel = label.CLOSE_PHOTO;
	submitEntry = label.SUBMIT_ENTRY;
	addAtLeastOneSymptom = label.ADD_ONE_SYMPTOM;
	iUnderstandInformationCorrect = label.UNDERSTAND_PROVIDED_INFO;
	understandLabel = label.I_UNDERSTAND;
	itchinessLabel = label.ITCHINESS_VALUES;
	rednessLabel = label.REDNESS_VALUE;
	temperatureLabel = label.TEMPERATURE_VALUES;
	pustulesLabel = label.PUSTULES_VALUE;
	painLabel = label.PAIN_VALUES;
	fatigueLabel = label.FATIGUE_VALUES;
	moodLabel = label.MOOD_IMG;
	symptomLabel = label.SYMPTOMS_LABEL;
	photosLabel = label.PHOTOS_LABEL;
	confirmSubmit = label.CONFIRM_SUBMISSION;
	okLabel = label.OK_LABEL;
	symptomCompleteTick = label.SYMPTOM_TICK_IMG;
	itchinessColorVarient = label.ITCHINESS_COLOR_VARIENT;
	rednessColorVarient = label.REDNESS_COLOR_VARIENT;
	painColorVarient = label.PAIN_COLOR_VARIENT;
	pustulesColorVarient = label.PUSTULES_COLOR_VARIENT;
	fatigueColorVarient = label.FATIGUE_COLOR_VARIENT;
	moodColorVarient = label.MOOD_COLOR_VARIENT;
	temperatureColorVarient = label.TEMPERATURE_COLOR_VARIENT;
	symptomTickIcon = label.SYMPTOM_TICK_ICON;
	alternateTextCalender = label.ALTERNATE_TEXT_EMPTY_CALENDER;
	alternateTextTick = label.ALTERNATE_TICK;
	alternateTextIcon = label.ALTERNATE_ALLERGY_ICON;
	alternateTextItchiness = label.ALTERNATE_TEXT_EMPTY_ITCHINESS;
	alternateTextRedness = label.ALTERNATE_TEXT_EMPTY_REDNESS;
	alternateTextPain = label.ALTERNATE_TEXT_EMPTY_PAIN;
	alternateTextPustules = label.ALTERNATE_TEXT_EMPTY_PUSTULES;
	alternateTextFatigue = label.ALTERNATE_TEXT_EMPTY_FATIGUE;
	alternateTextTemperature = label.ALTERNATE_TEXT_EMPTY_TEMPERATURE;
	alternateTextUpload = label.ALTERNATE_TEXT_EMPTY_UPLOAD;
	rednessChange = false;
	painChange = false;
	pustlesChange = false;
	fatiquesChange = false;
	moodChange = false;
	temperatureChange = false;
	sliderValue = 8;
	invalidFileType = false;
	boxedIcon = label.BOXED_ICON;
	limtUpLoad = label.UPLOAD_IMG;
	isPopupOpenUndersatand = false;
	isPopupOpenDisable = true;
	lastModifi = false;
	allergyDataResult;
	entryDate;
	chsngedVal;
	isDateUnique = false;
	gpp;
	editEntryDate = [];
	accGender = false;
	accGenderCheck;
	isDropDownVisible = false;
	bodyParts = [];
	changeValue = "";
	isDropDownOpen = false;
	isPopUpOpen = false;
	isDropDownOpen1 = false;
	isPopUpOpen1 = false;
	isDropDownOpen2 = false;
	isPopUpOpen2 = false;
	isDropDownOpen3 = false;
	isPopUpOpen3 = false;
	isDropDownOpen4 = false;
	isPopUpOpen4 = false;
	result = "";
	currentDate;
	currentDate2;
	colorChange = "";
	colorChange1 = "";
	colorChange2 = "";
	colorChange3 = "";
	colorChange4 = "";
	colorChange5 = "";
	colorChange6 = "";
	itchinessChange1 = false;
	formattedLastModifiedDate;
	lastModifiedTime;
	accordColor;
	accordColorSymptom;
	itchinessChange = false;
	primaryPage;
	submitModal = false;
	undersatand = false;
	showFiles = false;
	recntBtn = []; // Initialize recntBtn as an empty array
	btnColorChange = "dropdown3-activity-btn";
	accordColorBtn;
	files = [];
	fileIds = [];
	isLimitReached = false;
	upLoadedLarge = false;
	attachmentIdsValues;
	fileChangeColour;
	fileWork = false;
	fileMessage = false;
	isEditMode = false;
	resultId;
	dataMandatory = false;
	dataMantroyDispable = true;
	currentlyGpp = false;
	changerAdioBtn;
	symptomData;
	symptomGpp;
	showMessage = false;
	recentActivity = false;
	dateDisable = false;
	firstTime = false;
	recentImages = false;
	intensity;
	whichSymptom;
	fileTitle = label.UPLOADED_FILE;
	filePath = label.UPLOADED_FILE_PNG;
	Editdatedisable = false;
	oldimageurl = [];
	totalSize = [];
	vari;
	// Variable declaration
	selectedOption = [];
	accountId;
	lastsymptomid;
	receivedValue;
	gppvaluesradio;
	image;
	image1;
	image2;
	image3;
	image4;
	image5;
	image6;
	imageUrl;
	showItchinessModal = false;
	showPainModal = false;
	showMoodModal = false;
	showFatigueModal = false;
	showTemperatureModal = false;
	showrednessModal = false;
	showPustulesModal = false;
	gppsymptomdata = true;
	placeholderClass = 'date-input-container';
	// popup end
	openrpopup()
	{
		this.ispoup = true;
	}
	closrpopup()
	{
		this.ispoup = false;
	}
	openPopup1()
	{
		this.isPopUpOpen1 = true;
	}
	closePopup1()
	{
		this.isPopUpOpen1 = false;
	}
	openPopup()
	{
		this.isPopUpOpen = true;
	}
	closePopup()
	{
		this.isPopUpOpen = false;
	}
	handleDateEntry(event)
	{
		event.preventDefault();
	}
	// lAST MODFIED START
	//Wire method to call the fetchAccountDetails Apex method
	@wire(FETCH_ACCOUNT_DETAILS,
	{
		careProgramEnrolleeId: "$accountId"
	})
	wiredAccountDetails(
	{
		error,
		data
	})
	{
		if (data && data.length > 0)
		{
			const enrollee = data[0];
			const personGenderIdentity = enrollee.Account.HealthCloudGA__Gender__pc;
			// Assign values to component properties if needed
			this.accGenderCheck = personGenderIdentity;
			if (this.accGenderCheck !== label.MALE)
			{
				this.accGender = true;
			}
		}
		else if (error)
		{
			// Handle any errors            
			this.handleError(error.body.message);
		}
	}
	options = [
		{
			label: label.YES,
			value: label.YES
    },
		{
			label: label.NO,
			value: label.NO
    }
        // Add more options as needed
    ];
	toggleDropdown()
	{
		this.isDropDownVisible = !this.isDropDownVisible;
	}
	handleChange(event)
	{
		this.selectedOption = event.target.value;
	}
	formatDate(date)
	{
		const options = {
			month: "numeric",
			day: "numeric",
			hour: "numeric",
			minute: "numeric",
			hour12: true
		};
		return date.toLocaleString(label.LABEL_US, options);
	}
	changerecord(event)
	{
		this.vari = event.detail;
		if (this.vari === label.ITCHINESS_VALUES)
		{
			this.colorChange = "colorChange";
			this.accordColorSymptom = "card-header-accord";
			this.itchinessChange = true;
			this.itchinessChange1 = true;
		}
		else
		{
			this.colorChange = "symptoms";
		}
		if (this.vari === label.REDNESS_VALUE)
		{
			this.colorChange1 = "colorChange1";
			this.rednessChange = true;
			this.itchinessChange1 = true;
			this.accordColorSymptom = "card-header-accord";
		}
		else
		{
			this.colorChange1 = "symptoms";
		}
		if (this.vari === label.PAIN_VALUES)
		{
			this.colorChange2 = "colorChange2";
			this.accordColorSymptom = "card-header-accord";
			this.painChange = true;
			this.itchinessChange1 = true;
		}
		else
		{
			this.colorChange3 = "symptoms";
		}
		if (this.vari === label.PUSTULES_VALUE)
		{
			this.colorChange3 = "colorChange3";
			this.pustlesChange = true;
			this.itchinessChange1 = true;
			this.accordColorSymptom = "card-header-accord";
		}
		else
		{
			this.colorChange3 = "symptoms";
		}
		if (this.vari === label.FATIGUE_VALUES)
		{
			this.colorChange4 = "colorChange4";
			this.fatiquesChange = true;
			this.itchinessChange1 = true;
			this.accordColorSymptom = "card-header-accord";
		}
		else
		{
			this.colorChange4 = "";
		}
		if (this.vari === label.TEMPERATURE_VALUES)
		{
			this.colorChange5 = "colorChange5";
			this.accordColorSymptom = "card-header-accord";
			this.itchinessChange1 = true;
			this.temperatureChange = true;
		}
		else
		{
			this.colorChange4 = "";
		}
		if (this.vari === label.MOOD_IMG)
		{
			this.moodChange = true;
			this.itchinessChange1 = true;
			this.colorChange6 = "colorChange6";
			this.accordColorSymptom = "card-header-accord";
		}
		else
		{
			this.colorChange6 = "";
		}
	}
	renderedCallback()
	{
		if (this.recntBtn && this.recntBtn.length > 0)
		{
			this.recntBtn?.forEach((item) =>
			{
				let clickedElement = this.template.querySelector(`[data-name='${item}']`);
				if (clickedElement && (clickedElement.style.backgroundColor === "" || clickedElement.style.backgroundColor === "white"))
				{
					// If the background color is white, it means it's not selected
					clickedElement.style.backgroundColor = "#C6AA76"; // Set to selected color
					clickedElement.style.fontFamily = "Eina-Semibold";
				}
				else if (clickedElement)
				{
					clickedElement.style.backgroundColor = "white"; // Reset to original color
					clickedElement.style.fontFamily = "Eina-Regular";
				}
			});
		}
		let globalThis = window;
		globalThis.addEventListener("beforeunload", this.handlePageRefresh);
	}
	connectedCallback()
	{
		let globalThis = window;
		loadStyle(this, label.FILE_UPLOADER_CSS);
		loadStyle(this, label.SYMPTOMS_IMG);
		const queryParams = new URLSearchParams(globalThis.location?.search);
		// Get the value of the 'value' parameter
		this.receivedValue = queryParams.get("value");
		globalThis.history.replaceState(
		{}, globalThis.document?.title, globalThis.location?.pathname);
		// Check if the value is received
		if (this.receivedValue)
		{
			try
			{
				this.lastModifi = false;
			}
			catch (error)
			{
				this.handleError(error.body.message);
			}
			// You can use the value here as needed
		}
		//This code retrieves data labeled as 'recentactivity' from the session storage without altering custom labels.
		let recntBtn = globalThis?.sessionStorage.getItem("recentActivity");
		//The use of setInterval ensures optimal timing for thumb label position updates, enhancing animation smoothness and performance
		Promise.resolve()
			.then(() =>
			{
				recntBtn?.forEach((item) =>
				{
					let element = this.template.querySelector(`[data-name='${item}']`);
					if (element)
					{
						element.style.backgroundColor = "#C6AA76";
						element.style.fontFamily = "Eina-Semibold";
					}
					this.accordColor = "card-header-accord";
					this.accordColorBtn = "card-header-accord";
					this.recentactivity = true;
				});
			});
		const currentURL = globalThis.location?.href;
		// Create a URL object
		const urlObject = new URL(currentURL);
		// Get the path
		const path = urlObject.pathname;
		// Split the path using '/' as a separator
		const pathComponents = path.split("/");
		// Find the component you need (in this case, 'Branded')
		const desiredComponent = pathComponents.find((component) => [label.BRANDED_URL.toLowerCase(), label.UNASSIGNED_URL.toLowerCase()].includes(component.toLowerCase()));
		if (desiredComponent.toLowerCase() === label.BRANDED_URL.toLowerCase())
		{
			this.urlq = label.BRANDED_URL_NAVIGATION;
		}
		else
		{
			this.urlq = label.UNASSIGNED_URL_NAVIGATION;
		}
		//This code retrieves data labeled as 'stopprcocess' from the session storage without altering custom labels.
		this.primaryPage = globalThis?.localStorage.getItem("stopprcocess");
		if (this.primaryPage === label.DATE_INPUT_PAGE)
		{
			this.dataMandatory = false;
		}
		//This code retrieves data labeled as 'symptomlastid' from the session storage without altering custom labels.
		this.lastsymptomid = globalThis?.localStorage.getItem("symptomlastid");
		try
		{
			GET_ENROLLE()
				// Null data is checked and AuraHandledException is thrown from the Apex
				.then((result) =>
				{
					if (result && result[0].Id !== null)
					{
						this.accountId = result[0].Id;
					}
				})
				.catch((error) =>
				{
					// Handle any errors occurring during the promise chain
					this.handleError(error.body.message);
				});
		}
		catch (error)
		{
			// Handle any synchronous errors outside the promise chain
			this.handleError(error.body.message);
		}
		//This code retrieves data labeled as 'Time' from the session storage without altering custom labels.
		const localStorageValue = globalThis?.localStorage.getItem("Time", this.resultId);
		//This code retrieves data labeled as 'gppvalues' from the session storage without altering custom labels.
		this.sessionstrogegpp = globalThis?.sessionStorage.getItem("gppvalues", this.resultId);
		this.gppvaluesradio = this.sessionstrogegpp;
		this.time = localStorageValue;
		this.currentDate = new Date()
			.toISOString()
			.slice(0, 10);
		const today = new Date();
		this.maxDate = today.toISOString()
			.slice(0, 10);
		// window.addEventListener('beforeunload', this.handlePageRefresh);
		//The use of setInterval ensures optimal timing for thumb label position updates, enhancing animation smoothness and performance
		this.currentDate = new Date()
			.toISOString()
			.slice(0, 10);
	}
	handlePageRefresh(event)
	{
		let globalThis = window;
		globalThis.sessionStorage?.clear();
		event.returnValue = "";
	}
	handleEditDate()
	{
		this.isEditMode = true;
	}
	get dropdownButtonClass()
	{
		return this.isDropDownOpen ? "dropdown-arrow-button dropdown-arrow-button-open" : "dropdown-arrow-button";
	}
	get dropdownButtonClass1()
	{
		return this.isDropDownOpen1 ? "dropdown-arrow-button dropdown-arrow-button-open" : "dropdown-arrow-button";
	}
	get dropdownButtonClass2()
	{
		return this.isDropDownOpen2 ? "dropdown-arrow-button dropdown-arrow-button-open" : "dropdown-arrow-button";
	}
	get dropdownButtonClass3()
	{
		return this.isDropDownOpen3 ? "dropdown-arrow-button dropdown-arrow-button-open" : "dropdown-arrow-button";
	}
	get dropdownButtonClass4()
	{
		return this.isDropDownOpen4 ? "dropdown-arrow-button dropdown-arrow-button-open" : "dropdown-arrow-button";
	}
	toggleDropdown1()
	{
		this.isDropDownOpen1 = !this.isDropDownOpen1;
		this.isDropDownOpen2 = false;
		this.isDropDownOpen4 = false;
		this.isDropDownOpen3 = false;
	}
	toggleDropdown2()
	{
		this.isDropDownOpen2 = !this.isDropDownOpen2;
		this.isDropDownOpen3 = false;
		this.isDropDownOpen1 = false;
		this.isDropDownOpen4 = false;
	}
	toggleDropdown3()
	{
		this.isDropDownOpen3 = !this.isDropDownOpen3;
		this.isDropDownOpen2 = false;
		this.isDropDownOpen1 = false;
		this.isDropDownOpen4 = false;
		//The setTimeout with a small delay ensures UI updates occur after the current rendering tasks, preventing glitches.
		if (this.recntBtn && this.recntBtn.length > 0)
		{
			this.recntBtn?.forEach((item) =>
			{
				let clickedElement = this.template.querySelector(`[data-name='${item}']`);
				if (clickedElement && (clickedElement.style.backgroundColor === "" || clickedElement.style.backgroundColor === "white"))
				{
					// If the background color is white, it means it's not selected
					clickedElement.style.backgroundColor = "#C6AA76"; // Set to selected color
					clickedElement.style.fontFamily = "Eina-Semibold";
				}
				else if (clickedElement)
				{
					clickedElement.style.fontFamily = "Eina-Regular";
					clickedElement.style.backgroundColor = "white"; // Reset to original color
				}
			});
		}
	}
	toggleDropdown4()
	{
		this.isDropDownOpen4 = !this.isDropDownOpen4;
		this.isDropDownOpen3 = false;
		this.isDropDownOpen2 = false;
		this.isDropDownOpen1 = false;
	}
	handlechnagedropdown()
	{
		if (this.whichSymptom)
		{
			this.itchinessChange1 = true;
			this.accordColorSymptom = "card-header-accord";
			this.isDropDownOpen3 = !this.isDropDownOpen3;
			this.isDropDownOpen2 = false;
			this.isDropDownOpen1 = false;
			this.isDropDownOpen4 = false;
		}
		else
		{
			this.check();
		}
	}
	check()
	{
		let globalThis = window;
		//This code retrieves data labeled as from the session storage without altering custom labels using for all function.
		const changeValue = globalThis?.sessionStorage.getItem("myData");
		const changeValue1 = globalThis?.sessionStorage.getItem("redness");
		const changeValue2 = globalThis?.sessionStorage.getItem("Paindata");
		const changeValue3 = globalThis?.sessionStorage.getItem("Pustule");
		const changeValue6 = globalThis?.sessionStorage.getItem("mood");
		const changeValue7 = globalThis?.sessionStorage.getItem("fatigue");
		const changeValue8 = globalThis?.sessionStorage.getItem("temprature");
		globalThis?.sessionStorage.setItem("syptombtn", true);
		if (!changeValue && !changeValue1 && !changeValue2 && !changeValue3 && !changeValue6 && !changeValue7 && !changeValue8 && this.chsngedVal === label.YES)
		{
			this.opensubmitModal();
		}
		else if (this.chsngedVal === label.NO)
		{
			this.accordColorSymptom = "card-header-accord";
			this.itchinessChange1 = true;
			this.isDropDownOpen3 = !this.isDropDownOpen3;
			this.isDropDownOpen2 = false;
			this.isDropDownOpen1 = false;
			this.isDropDownOpen4 = false;
		}
		else
		{
			this.isDropDownOpen3 = !this.isDropDownOpen3;
			this.isDropDownOpen2 = false;
			this.isDropDownOpen1 = false;
			this.isDropDownOpen4 = false;
		}
	}
	handleButtonClick()
	{
		const sessionData = this.getSessionData();
		if (this.shouldOpenSubmitModal(sessionData))
		{
			this.isPopupOpenDisable = false;
			this.opensubmitModal();
		}
		else
		{
			this.openundersatand();
			this.isPopupOpenDisable = false;
		}
	}
	getSessionData()
	{
		let globalThis = window;
		return {
			changeValue: globalThis?.sessionStorage.getItem("myData"),
			changeValue1: globalThis?.sessionStorage.getItem("redness"),
			changeValue2: globalThis?.sessionStorage.getItem("Paindata"),
			changeValue3: globalThis?.sessionStorage.getItem("Pustule"),
			changeValue6: globalThis?.sessionStorage.getItem("mood"),
			changeValue7: globalThis?.sessionStorage.getItem("fatigue"),
			changeValue8: globalThis?.sessionStorage.getItem("temprature"),
			changeValue9: globalThis?.sessionStorage.getItem("gpp"),
			symptbtn: globalThis?.sessionStorage.getItem("syptombtn")
		};
	}
	shouldOpenSubmitModal(sessionData)
	{
		return this.isAllConditionsEmpty(sessionData) && sessionData.changeValue9?.toLocaleLowerCase() === "yes" ||
			(!sessionData.symptbtn || sessionData.symptbtn === "false") && sessionData.changeValue9?.toLocaleLowerCase() === "yes" ||
			this.isAllAttributesDefault();
	}
	isAllConditionsEmpty(sessionData)
	{
		return !sessionData.changeValue && !sessionData.changeValue1 && !sessionData.changeValue2 &&
			!sessionData.changeValue3 && !sessionData.changeValue6 && !sessionData.changeValue7 &&
			!sessionData.changeValue8;
	}
	isAllAttributesDefault()
	{
		return this.gpp === label.YES &&
			(!this.allergyDataResult || this.allergyDataResult.length === 0) &&
			!this.pustlesChange && !this.itchinessChange && !this.rednessChange &&
			!this.painChange && !this.moodChange && !this.temperatureChange &&
			!this.fatiquesChange;
	}
	opensubmitModal()
	{
		this.submitModal = true;
		document.body.style.overflow = "hidden";
	}
	closesubmitModal()
	{
		this.submitModal = false;
		document.body.style.overflow = ""; // Reset to default
	}
	openundersatand()
	{
		this.undersatand = true;
		document.body.style.overflow = "hidden";
		this.submitModal = false;
	}
	closeundersatand()
	{
		this.undersatand = false;
		document.body.style.overflow = ""; // Reset to default
	}
	addsymtom()
	{
		if (!this.isDropDownOpen)
		{
			this.isDropDownOpen2 = true;
			this.isDropDownOpen1 = false;
			this.submitModal = false;
			document.body.style.overflow = ""; // Reset to default
		}
		else
		{
			this.isDropDownOpen2 = false;
			this.isPopUpOpen = false;
		}
	}
	understand()
	{
		let globalThis = window;
		globalThis?.localStorage.clear();
		globalThis.location.assign(this.urlq + label.SYMPTOM_GRAPH_PAGE);
		globalThis?.sessionStorage.setItem(label.DYNAMIC_VALUE, 'someDynamicValue')
	}
	openItchinessModal()
	{
		this.showItchinessModal = true;
		document.body.style.overflow = "hidden";
	}
	closeItchinessModal()
	{
		this.showItchinessModal = false;
		document.body.style.overflow = ""; // Reset to default
	}
	// PainModal
	openPainModal()
	{
		this.showPainModal = true;
		document.body.style.overflow = "hidden";
	}
	closePainModal()
	{
		let globalThis = window;
		this.showPainModal = false;
		document.body.style.overflow = ""; // Reset to default
		// Store data labeled as 'Paindatavalues' in the session storage without altering custom labels.
		globalThis?.sessionStorage.setItem("Paindatavalues", 0);
	}
	// RednessModal
	openRednessModal()
	{
		this.showrednessModal = true;
		document.body.style.overflow = "hidden";
	}
	closeRednessModal()
	{
		let globalThis = window;
		this.showrednessModal = false;
		document.body.style.overflow = ""; // Reset to default
		// Store data labeled as 'rednessvalues' in the session storage without altering custom labels.
		globalThis?.sessionStorage.setItem("rednessvalues", 0);
	}
	// pustel model
	openPustulesModal()
	{
		this.showPustulesModal = true;
		document.body.style.overflow = "hidden";
	}
	closePustulesModal()
	{
		let globalThis = window;
		this.showPustulesModal = false;
		document.body.style.overflow = ""; // Reset to default
		// Store data labeled as 'Pustulevalues' in the session storage without altering custom labels.
		globalThis?.sessionStorage.setItem("Pustulevalues", 0);
	}
	// Fatigue Modal
	openFatigueModal()
	{
		this.showFatigueModal = true;
		document.body.style.overflow = "hidden";
	}
	closeFatigueModal()
	{
		let globalThis = window;
		this.showFatigueModal = false;
		document.body.style.overflow = ""; // Reset to default
		// Store data labeled as 'fatiguevalues' in the session storage without altering custom labels.
		globalThis?.sessionStorage.setItem("fatiguevalues", 0);
	}
	// Temperature Modal
	openTemperatureModal()
	{
		this.showTemperatureModal = true;
		document.body.style.overflow = "hidden";
	}
	closeTemperatureModal()
	{
		this.showTemperatureModal = false;
		document.body.style.overflow = "";
	}
	// Mood Modal
	openMoodModal()
	{
		this.showMoodModal = true;
		document.body.style.overflow = "hidden";
	}
	closeMoodModal()
	{
		this.showMoodModal = false;
		document.body.style.overflow = ""; // Reset to default
	}
	// files upload
	openfiles()
	{
		this.showFiles = true;
		document.body.style.overflow = "hidden";
	}
	closefiles()
	{
		this.showFiles = false;
		document.body.style.overflow = ""; // Reset to default
	}
	handleClickactivites(event)
	{
		const clickedElement = event.target;
		const elementClass = clickedElement.classList.value;
		if (elementClass.includes(this.btnColorChange))
		{
			const selectedOption = clickedElement.getAttribute("data-name");
			// Toggle the background color and update the selected values
			// Initialize this.recntBtn as an array if it's not already initialized
			if (!this.recntBtn)
			{
				this.recntBtn = [];
			}
			if (clickedElement.style.backgroundColor === "" || clickedElement.style.backgroundColor === "white")
			{
				// If the background color is white, it means it's not selected
				clickedElement.style.backgroundColor = "#C6AA76"; // Set to selected color
				clickedElement.style.fontFamily = "Eina-Semibold";
				this.recntBtn.push(selectedOption);
			}
			else
			{
				// If the background color is not white, it means it's selected
				clickedElement.style.fontFamily = "Eina-Regular";
				clickedElement.style.backgroundColor = "white"; // Reset to original color
				this.recntBtn = this.recntBtn.filter(
					(option) => option !== selectedOption); // Remove the selected option from the array
			}
		}
	}
	updatedRecordId;
	handleClickForAccept()
	{
		let globalThis = window;
		// Close all dropdowns except the fourth one
		this.isDropDownOpen4 = true;
		this.isDropDownOpen3 = false;
		this.isDropDownOpen2 = false;
		this.isDropDownOpen1 = false;
		// Store data labeled as 'recentactivity' in the session storage without altering custom labels.
		globalThis?.sessionStorage.setItem("recentActivity", this.recntBtn);
		// Set the class based on the condition whether recntBtn has only one item or not
		this.accordColorBtn = this.recntBtn ? "card-header-accord" : "another-class";
		try
		{
			this.recentActivity = true;
			if (this.lastsymptomid)
			{
				this.updatedRecordId = UPDATE_RECENT_VALUE(
				{
					symptomTrackerId: this.lastsymptomid,
					valuesToUpdate: this.recntBtn
				});
				this.recentActivity = true;
			}
			else
			{
				this.updatedRecordId = UPDATE_RECENT_VALUE(
				{
					symptomTrackerId: this.resultId,
					valuesToUpdate: this.recntBtn
				});
				this.recentActivity = true;
			}
		}
		catch (error)
		{
			this.handleError(error.body.message);
		}
	}
	// Call this method to trigger the deletion
	async removeImage(event)
	{
		this.upLoadedLarge = false;
		this.invalidFileType = false;
		this.isLimitReached = false;
		const index = event.target.dataset.index;
		this.imageUrls.splice(index, 1);
		if (this.imageUrls.length > 4)
		{
			this.isLimitReached = true;
		}
		else
		{
			this.isLimitReached = false;
		}
		await DELETE_CONTENT_DOCUMENT_LINKS(
		{
			symptomTrackerId: this.lastsymptomid
		});
	}
	async handleSaveDate()
	{
		let globalThis = window;
		let myBoolean = false;
		// Ensure isDateUnique is resolved before proceeding
		this.checkDateUniqueness();
		if (this.isDateUnique === false)
		{
			if (!this.lastsymptomid)
			{
				this.resultId = await RECORD_INSERT_STS(
				{
					editEntryDate: this.currentDate2
				});
			}
			else
			{
				this.resultId = await RECORD_INSERTST_UPDATE(
				{
					symptomTrackerId: this.lastsymptomid,
					gpp: myBoolean,
					editEntryDate: this.currentDate2
				});
			}
			if (this.resultId)
			{
				// Store data labeled as 'Time' in the session storage without altering custom labels.
				globalThis?.localStorage.setItem("Time", this.resultId);
				// Store data labeled as 'gppvalues' in the session storage without altering custom labels.
				globalThis?.sessionStorage.setItem("gppvalues", this.resultId);
				this.dataMandatory = true;
				this.dataMantroyDispable = true;
				this.Editdatedisable = true;
				this.placeholderClass = 'hide-placeholder';
			}
		}
	}
	checkDateUniqueness()
	{
		if (this.currentDate)
		{
			CHECK_UNIQUE_DATE(
				{
					editedDate: this.currentDate,
					accountId: this.accountId
				})
				.then(result =>
				{
					this.result = result;
					if (this.result)
					{
						this.isDateUnique = false;
					}
					else
					{
						this.isDateUnique = true;
						this.dataMantroyDispable = true;
					}
				})
				.catch(error =>
				{
					this.handleError(error.body.message);
				});
		}
	}
	handleDateChange(event)
	{
		this.placeholderClass = 'hide-placeholder';
		this.currentDate = event.target.value;
		this.currentDate2 = event.target.value;
		this.dataMantroyDispable = false; // Enable the 'Submit' button
		const selectedDate = new Date(this.currentDate);
		const today = new Date();
		if (selectedDate > today)
		{
			this.showText = true; // Show the message
			this.futuredatedisable = true;
			this.dataMantroyDispable = true; // Show the future date error message
		}
		else
		{
			this.showText = false; // Hide the message
			this.futuredatedisable = false; // Hide the future date error message
		}
		// Call the checkDateUniqueness function
		this.checkDateUniqueness();
	}
	handleRadioChange(event)
	{
		this.gppsymptomdata = false;
		this.chsngedVal = event.detail.value;
		this.gpp = this.chsngedVal;
		// Assuming that this.chsngedVal is a string, use 'true' (string) instead of true (boolean)
		this.showMessage = this.chsngedVal === label.YES;
	}
	handleSavegpp()
	{
		if (this.gpp === label.YES && (!this.allergyDataResult || this.allergyDataResult.length === 0) && this.pustlesChange === false && this.itchinessChange === false && this.rednessChange === false && this.painChange === false && this.moodChange === false && this.temperatureChange === false && this.fatiquesChange === false)
		{
			this.opensubmitModal();
		}
		if (this.gpp === label.YES)
		{
			this.isDropDownOpen2 = true;
			this.isDropDownOpen1 = false;
			this.currentlyGpp = true;
			this.accordColor = "card-header-gpp";
			this.isPopupOpenDisable = false;
			// Save radio value
			this.changerAdioBtn = true;
			UPDATE_GPP_VALUE(
				{
					symptomTrackerId: this.resultId ? this.resultId : this.lastsymptomid,
					gpp: this.changerAdioBtn
				})
				.then((result) =>
				{
					if (result)
					{
						this.accordColor = "card-header-gpp";
					}
				})
				.catch((error) =>
				{
					this.handleError(error.body.message);
				})
		}
		else if (this.gpp === label.NO)
		{
			this.isPopupOpenDisable = false;
			this.symptomGpprecord();
		}
		else
		{
			this.isDropDownOpen2 = true;
			this.isDropDownOpen1 = false;
		}
	}
	symptomGpprecord()
	{
		let globalThis = window;
		// Check if sessionStorage values are empty
		//This code retrieves data labeled as  from the session storage without altering custom labels for all function.
		const changeValue = globalThis?.sessionStorage.getItem("myData");
		const changeValue1 = globalThis?.sessionStorage.getItem("redness");
		const changeValue2 = globalThis?.sessionStorage.getItem("Paindata");
		const changeValue3 = globalThis?.sessionStorage.getItem("Pustule");
		const changeValue6 = globalThis?.sessionStorage.getItem("mood");
		const changeValue7 = globalThis?.sessionStorage.getItem("fatigue");
		const changeValue8 = globalThis?.sessionStorage.getItem("temperature");
		if (!changeValue && !changeValue1 && !changeValue2 && !changeValue3 && !changeValue6 && !changeValue7 && !changeValue8 && this.chsngedVal === label.YES)
		{
			this.opensubmitModal();
			this.accordColor = "card-header-gpp";
			// Save radio value
			this.changerAdioBtn = true;
			this.isPopUpOpen = true;
			this.currentlyGpp = true;
			try
			{
				UPDATE_GPP_VALUE(
					{
						symptomTrackerId: this.resultId ? this.resultId : this.lastsymptomid,
						gpp: this.changerAdioBtn
					})
					// Null data is checked and AuraHandledException is thrown from the Apex
					.then((result) =>
					{
						if (result)
						{
							this.accordColor = "card-header-gpp";
						}
					})
					.catch((error) =>
					{
						this.handleError(error.body.message);
					})
					.finally(() =>
					{
						this.isEditMode = false;
						globalThis?.sessionStorage.setItem("gpp", this.chsngedVal);
					});
			}
			catch (error)
			{
				this.handleError(error.body.message);
			}
		}
		else if (this.lastsymptomid || this.chsngedVal === label.NO)
		{
			this.currentlyGpp = true;
			this.isPopupOpenUndersatand = true;
			this.isDropDownOpen2 = true;
			this.isDropDownOpen1 = false;
			this.accordColor = "card-header-gpp";
			this.changerAdioBtn = false;
			try
			{
				UPDATE_GPP_VALUE(
				{
					symptomTrackerId: this.lastsymptomid ? this.lastsymptomid : this.resultId,
					gpp: this.changerAdioBtn
				});
				globalThis?.sessionStorage.setItem("gpp", this.chsngedVal);
				if (this.chsngedVal === 'No')
				{
					this.isPopupOpenDisable = false;
				}
			}
			catch (error)
			{
				this.handleError(error.body.message);
			}
		}
	}
	@wire(GET_LAST)
	wiredLastEntryDate(
	{
		error,
		data
	})
	{
		// Null data is checked and AuraHandledException is thrown from the Apex
		if (data)
		{
			data.forEach(careplanimage =>
			{
				if (careplanimage.Name === label.ITCHINESS_VALUES)
				{
					this.imageItchiness = careplanimage.BI_PSP_Symptom_image__c;
				}
				else if (careplanimage.Name === label.REDNESS_VALUE)
				{
					this.imageRedness = careplanimage.BI_PSP_Symptom_image__c;
				}
				else if (careplanimage.Name === label.PAIN_VALUES)
				{
					this.imagePain = careplanimage.BI_PSP_Symptom_image__c;
				}
				else if (careplanimage.Name === label.PUSTULES_VALUE)
				{
					this.imagePustules = careplanimage.BI_PSP_Symptom_image__c;
				}
				else if (careplanimage.Name === label.FATIGUE_VALUES)
				{
					this.imageFatigue = careplanimage.BI_PSP_Symptom_image__c;
				}
				else if (careplanimage.Name === label.TEMPERATURE_VALUES)
				{
					this.imageTemperature = careplanimage.BI_PSP_Symptom_image__c;
				}
				else if (careplanimage.Name === label.MOOD_IMG)
				{
					this.imageMood = careplanimage.BI_PSP_Symptom_image__c;
				}
			});
			const imgTagRegex = /<img\s+[^>]*src='([^']+)'[^>]*>/giu;
			const formatImageContent = (image) => image.replace(imgTagRegex, (match, src) => `<img src='${src}'>`);
			this.image = formatImageContent(this.image);
			this.image1 = formatImageContent(this.image1);
			this.image2 = formatImageContent(this.image2);
			this.image3 = formatImageContent(this.image3);
			this.image4 = formatImageContent(this.image4);
			this.image5 = formatImageContent(this.image5);
			this.image6 = formatImageContent(this.image6);
		}
		else if (error)
		{
			// Handle error            
			this.handleError(error.body.message);
		}
	}
	@wire(GET_SYMPTOM_RECORD_DATA,
	{
		symptomTrackerId: "$lastsymptomid"
	})
	wiredGetsymptomrecorddata(
	{
		data
	})
	{
		try
		{
			if (data && data !== null)
			{
				this.Editdatedisable = true;
				this.placeholderClass = 'hide-placeholder';
				this.satrdate = false;
				this.symptomData = data[0].BI_PSP_EditEntrydates__c;
				this.symptomGpp = data[0].BI_PSP_Are_you_currently_experiencing__c;
				this.chsngedVal = this.symptomGpp;
				this.gppsymptomdata = false;
				let getsymptombtn = data[0].BI_PSP_Recent_Activities__c;
				if (this.chsngedVal === true)
				{
					this.chsngedVal = label.YES;
				}
				else
				{
					this.chsngedVal = label.NO;
				}
				this.currentlyGpp = true;
				this.dateDisable = true;
				if (this.symptomGpp === true)
				{
					this.showMessage = true;
				}
				if (this.symptomData)
				{
					this.dataMandatory = true;
				}
				this.symptomGpp = true;
				if (getsymptombtn)
				{
					this.recentActivity = true;
					this.accordColorBtn = "card-header-accord";
				}
				data.forEach(symptomrecord =>
				{
					let getsymtomdate = symptomrecord.BI_PSP_EditEntrydates__c;
					let getsymptomrecentbtn = symptomrecord.BI_PSP_Recent_Activities__c;
					this.currentDate2 = new Date(getsymtomdate)
						.toISOString()
						.split("T")[0];
					this.recntBtn = getsymptomrecentbtn?.split(";");
					this.recentActivity = true;
					this.accordColor = "card-header-gpp";
					this.accordColorBtn = "card-header-accord";
					// The use of setInterval ensures optimal timing for thumb label position updates, enhancing animation smoothness and performance
					this.recntBtn?.forEach(item =>
					{
						let element = this.template.querySelector(`[data-name='${item}']`);
						if (element)
						{
							element.style.backgroundColor = "#C6AA76";
							element.style.fontFamily = "Eina-Semibold";
						}
					});
				});
			}
		}
		catch (error)
		{
			this.handleError(error.body.message);
		}
	}
	@wire(GET_CASE_IMAGE_URL,
	{
		symptomTrackerId: "$lastsymptomid"
	})
	wiredgetCaseImageURL(
	{
		data
	})
	{
		try
		{
			if (data && data !== null)
			{
				this.caseImageURL = data;
				this.fileMessage = true;
				this.fileChangeColour = "card-header-accord";
				if (this.firstTime === false)
				{
					let newImageUrls = [];
					let splitArray = data.map((obj) =>
						{
							// Ensure obj contains a base64URL and check if it's valid
							const base64URL = obj.base64URL;
							if (base64URL.startsWith("data:"))
							{
								return [base64URL, obj?.fileName];
							}
							else if (base64URL.includes(";base64,"))
							{
								return ["data:" + base64URL, obj?.fileName];
							}
								return null; // Invalid data, handle accordingly
						})
						.filter(record => record !== null); // Filter out any invalid records
					// Filter out any null or invalid records
					splitArray.forEach(record =>
					{
						if (record[0] !== "" && record[0] !== undefined)
						{
							if (!this.oldimageurl.some(oldUrl => oldUrl.dataUrl === record[0]))
							{
								const isPdf = record[0].includes("image/PDF");
								// const fileName = this.extractFileName(record[0]);
								newImageUrls.push(
								{
									dataUrl: record[0],
									isPdf: isPdf,
									fileName: this.truncateFileName(record[1]),
								});
							}
						}
					});
					this.imageUrls = [...newImageUrls];
					this.oldimageurl = [...newImageUrls];
					this.firstTime = true;
					this.recentImages = true;
				}
				else if (this.imageUrls.length > 0)
				{
					this.fileChangeColour = "card-header-accord";
				}
			}
		}
		catch (error)
		{
			this.handleError(error.body.message);
			// Handle the error as needed
		}
	}
	truncateFileName(fileName)
	{
		return fileName.length > 11 ? fileName.substring(0, 11) + '...' : fileName;
	}
	extractFileName(record)
	{
		const mimeType = record.split(";")[0].split(":")[1];
		return mimeType === "application/pdf" ? "Document.pdf" : "Image.jpg";
	}
	readAsDataURL(blob)
	{
		return new Promise((resolve, reject) =>
		{
			const reader = new FileReader();
			reader.onload = (event) =>
			{
				const base64String = event.target.result;
				resolve(`data:image/${blob.type.split("/")[1]};base64,${base64String}`);
			};
			reader.onerror = (error) =>
			{
				reject(error);
			};
			reader.readAsDataURL(blob);
		});
	}
	checksubmit()
	{
		if (this.carePlanTemplateName)
		{
			this.openundersatand();
		}
	}
	@wire(GET_ALLERGYINTOLERANCE_DATA,
	{
		symptomTrackerId: "$lastsymptomid"
	})
	wiredAllergyIntoleranceData(
	{
		data
	})
	{
		try
		{
			if (data && data !== null)
			{
				this.accordColorSymptom = "card-header-accord";
				this.itchinessChange1 = true;
				this.allergyDataResult = data;
				this.isPopupOpenDisable = false;
				this.whichSymptom = data;
				// ... (Previous code)
				data.forEach(record =>
				{
					// Access values of each record
					this.intensity = record.BI_PSP_Intensity__c;
					this.carePlanTemplateName = record?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name;
					// Compare with the string 'Itchiness'
					if (this.carePlanTemplateName === label.ITCHINESS_VALUES)
					{
						this.itchinessChange = true;
						this.itchinessChange1 = true;
						// As these are css class names, we haven't used custom label for this scenario
						this.accordColorSymptom = "card-header-accord";
					}
					if (this.carePlanTemplateName === label.REDNESS_VALUE)
					{
						this.rednessChange = true;
						// As these are css class names, we haven't used custom label for this scenario
						this.accordColorSymptom = "card-header-accord";
						this.itchinessChange1 = true;
					}
					if (this.carePlanTemplateName === label.PAIN_VALUES)
					{
						this.painChange = true;
						// As these are css class names, we haven't used custom label for this scenario
						this.accordColorSymptom = "card-header-accord";
						this.itchinessChange1 = true;
					}
					if (this.carePlanTemplateName === label.PUSTULES_VALUE)
					{
						this.pustlesChange = true;
						this.itchinessChange1 = true;
						// As these are css class names, we haven't used custom label for this scenario
						this.accordColorSymptom = "card-header-accord";
					}
					if (this.carePlanTemplateName === label.FATIGUE_VALUES)
					{
						this.fatiquesChange = true;
						this.itchinessChange1 = true;
						// As these are css class names, we haven't used custom label for this scenario
						this.accordColorSymptom = "card-header-accord";
					}
					if (this.carePlanTemplateName === label.TEMPERATURE_VALUES)
					{
						this.itchinessChange1 = true;
						this.temperatureChange = true;
						// As these are css class names, we haven't used custom label for this scenario
						this.accordColorSymptom = "card-header-accord";
					}
					if (this.carePlanTemplateName === label.MOOD_IMG)
					{
						this.itchinessChange1 = true;
						this.moodChange = true;
						// As these are css class names, we haven't used custom label for this scenario
						this.accordColorSymptom = "card-header-accord";
					}
				});
			}
		}
		catch (error)
		{
			this.handleError(error.body.message);
		}
	}
	handleError(error)
	{
		let globalThis = window;
		//globalThis.location.href = label.ERROR_PAGE;
		globalThis.sessionStorage.setItem('errorMessage', error);
	}
	@wire(GET_SYMPTOM_TRACKER_DETAILS,
	{
		careProgramEnrolleeId: "$accountId"
	})
	wiredResult(
	{
		data
	})
	{
		try
		{
			if (data)
			{
				this.lastModifiedDate = data.lastModifiedDate;
				this.lastModifiedTime = data.lasttime;
				let newdate3 = this.lastModifiedTime.split(", ");
				const dateTime = new Date(newdate3);
				// Get the hours, minutes, and seconds from the Date object
				const hours = dateTime.getHours();
				const minutes = dateTime.getMinutes();
				const seconds = dateTime.getSeconds();
				// Format the time in HH:mm:ss format (24-hour format)
				const formattedTime = `${hours.toString().padStart(2, "0")}:${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;
				this.lastModifi = true;
				// Get the current date and time
				let date = new Date(this.lastModifiedDate);
				let day = date.getDate()
					.toString()
					.padStart(2, '0');
				let month = (date.getMonth() + 1)
					.toString()
					.padStart(2, '0');
				let formattedDate = `${day}/${month}`;
				let newdate = formattedDate;
				this.formattedLastModifiedDate = `${newdate} at ${formattedTime}`;
			}
		}
		catch (errors)
		{
			this.handleError(errors.body.message);
		}
	}
	// 
	handleFileInputChange(event)
	{
		this.resetFlags();
		const files = event.target.files;
		if (!files || files.length === 0) return;
		const newImageUrls = [...this.imageUrls];
		const maxFileSize = 5 * 1024 * 1024; // 5MB
		const maxImagesAllowed = 5;		

		if (this.checkLimitReached(newImageUrls, files, maxImagesAllowed))
		{
			this.isLimitReached = true;
			return;
		}
		Array.from(files)
			.forEach(file =>
			{
				if (this.isFileAlreadyUploaded(newImageUrls, file)) return;
				if (this.isValidFileType(file)) {
					if (this.checkFileSize(file, maxFileSize)) {
						this.handleFile(file, newImageUrls);
					} else {
						// File too large
						this.upLoadedLarge = true;
						this.invalidFileType = false;
					}
				} else {
					// Invalid file type
					this.invalidFileType = true;
					this.upLoadedLarge = false;
				}
			});
		this.imageUrls = [...newImageUrls];
	}
	resetFlags()
	{
		this.upLoadedLarge = false;
		this.invalidFileType = false;
		this.isLimitReached = false;
	}

	checkLimitReached(newImageUrls, files, maxImagesAllowed) {
		// Check the total number of files
		if ((newImageUrls.length + files.length) > maxImagesAllowed) {
			return true; // Limit reached by number of files
		}
	
		// Check the total size of new files
		let totalSize = 0;
		Array.from(files).forEach(file => {
			totalSize += file.size; // Accumulate the file sizes
		});
			newImageUrls.forEach(image => {
			if (image.size) {
				totalSize += image.size; // Assuming 'size' is a valid property of existing images
			}
		});
		const maxFileSize = 5 * 1024 * 1024; 
		
			if (totalSize > maxFileSize) {
			return true; 
		}
			return false;
	}
	
isFileAlreadyUploaded(newImageUrls, file) {
    return newImageUrls.some(url => url.fileName === file.name);
}
	isValidFileType(file)
	{
		const acceptedTypes = ['image/png', 'image/jpeg', 'application/pdf'];
		return acceptedTypes.includes(file.type);
	}
	checkFileSize(file, maxFileSize)
	{
		if (file.size > maxFileSize)
		{
			this.upLoadedLarge = true;
			this.invalidFileType = false;
			return false;
		}
		return true;
	}

	addPdfFile(file, newImageUrls, fileName)
	{
		const reader = new FileReader();
		reader.onload = () =>
		{
			const dataUrl = reader.result;
			newImageUrls.push(
			{
				dataUrl: dataUrl,
				isPdf: true,
				fileName: this.truncateFileName(fileName)
			});
			this.imageUrls = [...newImageUrls];
		};
		reader.readAsDataURL(file);
	}
	readImageFile(file, newImageUrls, fileName)
	{
		const reader = new FileReader();
		reader.onload = () =>
		{
			newImageUrls.push(
			{
				dataUrl: reader.result,
				isPdf: false,
				fileName: this.truncateFileName(fileName)
			});
			this.imageUrls = [...newImageUrls];
		};
		reader.readAsDataURL(file);
	}
	handleClickpdf()
	{
		this.fileMessage = true;
        this.fileChangeColour = "card-header-accord";
		this.closeAllDropdowns();
		const newArray = this.imageUrls.filter(imageUrl =>
			!this.oldimageurl.some(existing => existing.dataUrl === imageUrl.dataUrl)
		);
		newArray.forEach(imageUrl => this.oldimageurl.push(imageUrl));
		const fileContents = newArray.map(imageUrl => imageUrl.dataUrl);
		const fileNames = newArray.map(imageUrl => imageUrl.fileName);
		this.updateFileUI(fileContents);
		const parentId = this.resultId || this.lastsymptomid;
		if (parentId)
		{
			this.saveFiles(fileContents, parentId, fileNames);
		}
	}
	closeAllDropdowns()
	{
		this.isDropDownOpen1 = false;
		this.isDropDownOpen2 = false;
		this.isDropDownOpen4 = false;
	}
	updateFileUI(fileContents)
	{
		this.recentImages = true;
		// this.fileChangeColour = fileContents.length > 0 ? "card-header-accord" : null;
		this.fileWork = fileContents.length > 0;
	}
	handleFile(file, newImageUrls)
	{
		const fileName = file.name;
		if (file.type.startsWith("image"))
		{
			this.readImageFile(file, newImageUrls, fileName);
		}
		else if (file.type === "application/pdf")
		{
			this.addPdfFile(file, newImageUrls, fileName);
		}
	}
	saveFiles(fileContents, parentId, fileNames)
	{		
		SAVE_FILES(
			{
				fileContents,
				parentId,
				fileNames
			})
			.then(attachmentIds =>
			{
				this.attachmentIdsValues = attachmentIds;
				return CREATE_CONTENT_DOCUMENT_LINKS(
				{
					fileIds: this.attachmentIdsValues,
					symptomTrackerId: parentId
				});
			})
			.then(() =>
			{
				this.fileMessage = 'Files uploaded and linked successfully';
			})
			.catch((error) => {
				this.handleError(error);
			});
	}
}