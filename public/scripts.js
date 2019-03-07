// Showing / Hiding personal info section

var infoButton = document.querySelector("#info__button");
var infoPanel = document.querySelector("#personal__info");

infoButton.addEventListener("click", function(event){
	if (infoPanel.className === 'd-inline') {
		infoPanel.className = "d-none";
	} else {
		infoPanel.className = "d-inline";
	}
});
