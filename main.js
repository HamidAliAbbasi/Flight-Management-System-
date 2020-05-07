function hideForms(formToShow) {
	var selection = document.getElementById("selection");
	for (var i = 0; i < selection.length; i++) {
		tempString = selection[i].value + "Form";
		document.getElementById(tempString).style.display = "none";
	}
	if (formToShow != null) {
		document.getElementById(formToShow.id).style.display = "block";
		selection.value = formToShow.id.substring(0, formToShow.id.length - 4);
	} else {
		document.getElementById(selection[0].value + "Form").style.display = "block";
	}
}

function changeForm() {
	var selection = document.getElementById("selection");
	var tempString;
	for (var i = 0; i < selection.length; i++) {
		tempString = selection[i].value + "Form";
		if (selection[i].selected) {
			document.getElementById(tempString).style.display = "block";
		} else {
			document.getElementById(tempString).style.display = "none";
		}
	}
}


/* Edit Information form divs */
function hideEditInformationForms(formToShow) {
	console.log("Displaying");
	var selection = document.getElementById("editInformationSelection");
	for (var i = 0; i < selection.length; i++) {
		tempString = selection[i].value + "Form";
		document.getElementById(tempString).style.display = "none";
	}
	if (formToShow != null) {
		document.getElementById(formToShow.id).style.display = "block";
		selection.value = formToShow.id.substring(0, formToShow.id.length - 4);
	} else {
		document.getElementById(selection[0].value + "Form").style.display = "block";
	}
}


function changeEditInformationForm() {
	var selection = document.getElementById("editInformationSelection");
	var tempString;
	for (var i = 0; i < selection.length; i++) {
		tempString = selection[i].value + "Form";
		if (selection[i].selected) {
			document.getElementById(tempString).style.display = "block";
		} else {
			document.getElementById(tempString).style.display = "none";
		}
	}
	
}