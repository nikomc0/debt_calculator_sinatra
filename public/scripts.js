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

// PATCH METHOD for Payments

var paymentTable = document.querySelectorAll("#table tr");
var url = window.location.href;

var setListener = function(el){
	el.addEventListener('click', function(event){
		fetch(url + "/" + el.id, {
			headers: {
				"content-type":"application/json; charset=UTF-8"
			},
			payment_id: el.id,
			method: "PATCH"
		})
		.then(data => { 
			location.reload(true);
			return data;
		})
	});
	
}

if (paymentTable[0]) {
	setListener(paymentTable[0]);
}
