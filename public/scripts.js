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

// Show/Hide Paid Payments
var paidPayments = document.querySelector(".paid_payments");
var showHideButton = document.querySelector("#show_hide_payments");

var showPaidPayments = function (){
	showHideButton.innerHTML = "<h6 onclick=\"hidePaidPayments()\">hide paid</h6>"
	paidPayments.classList.remove("d-none");
}

var hidePaidPayments = function (){
	showHideButton.innerHTML = "<h6 onclick=\"showPaidPayments()\">show paid</h6>"
	paidPayments.classList.add("d-none");
}

// Edit Monthly Budget
var monthlyPayment = document.querySelector('#dollar_amount');
var url = window.location.host;

var setListener = function(el){
	var events = ['click', 'keypress'];

	// iterates over event types
	events.forEach(event => {
		el.addEventListener(event, function(event){
			if (event.which === 1) {
				el.contentEditable = 'true';
			} else if (event.which === 13) {
				console.log(el.innerText);
				fetch("https://" + url + "/user/" + el.innerText, {
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
				el.contentEditable = 'false';
			}
		});
	});
};

setListener(monthlyPayment);

$(document).ready(function(){
	// Import Modal Functionality
	(function (){
		var sources = import('/scripts/sources.js')
			.then((sources) => {
				let scriptSources = sources.getSources();

				for (i = 0; i < scriptSources.length; i++) {
					var module = import(`/scripts/${scriptSources[i]}`)
					.then((module) => {
						module.run();
					});
				}
			});
	})();

	$('#edit_payment').click(function(event) {
		paymentID = event.target.attributes["data-payment-id"].value;
	  $('#editPayment').modal('show');
	});

	$('#editPayment').on('shown.bs.modal', function (event) {
		var modal = $(this)
		modal.find('.modal-body input').val(paymentID);
		modal.find('#markPaid').attr('action', paymentURL + "/" + paymentID);
	})

	$(".alert").delay(4000).slideUp(200, function() {
		$(this).alert('close');
	});
});
