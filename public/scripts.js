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
	
	// Announcement Block
	var readAnnouncement = localStorage.getItem("readAnnouncement");

	if (!readAnnouncement){
		$('<div>', { id : 'overlay' }).appendTo('body');
		$("#announcement").fadeIn('slow');
		$("#close").click(function(e){
			localStorage.setItem("readAnnouncement", "true");
			$('#announcement').remove();
			$('#overlay').remove();
			e.preventDefault();
		});
	}
	// Announcement Block End
	
	var paymentID = "";
	var paymentURL = window.location.href;
	var url = window.location.href;

	$('#editAccountModal').on('shown.bs.modal', function(){
		$('input:text:visible:first', this).focus();

		var principal = document.querySelector("input[name='principal']");
		var min = document.querySelector("input[name='min_payment']");
		var apr = document.querySelector("input[name='apr']");
		var min_payment = principal.value * 0.03;
		var values = [
			{name: "principal", value: null},
			{name: "minimum_payment", value: null},
			{name: "apr", value: null},
			{name: "min_only", value: false}
		];

		var queryString = "?";

		$('#editAccountModal').on('change', function(e){
			var minOnly = document.querySelector("#editAccountModal > div > div > form > div.modal-body > div > div > input.editMinOnly");

			if (principal.value) {
				values[0].value = parseInt(principal.value);
			}
			if (min.value){
				values[1].value = parseInt(min.value);
			}
			if (apr.value){
				values[2].value = parseInt(apr.value);
			}

			if (minOnly.checked) {
				minOnly.value = true;
				values[3].value = true;
			} else {
				minOnly.value = false;
				values[3].value = false;
			}
			
			queryString = "?";
			new_values = values.filter(query => query.value != null).map(query => `${query.name}=${query.value}`).join("&");
			queryString += new_values;
			
			fetch(url + "/min_payment" + queryString, {
				headers: {
					"content-type":"application/json; charset=UTF-8"
				},
				method: "GET"
			})
			.then(res => res.text())
			.then(data => {
				console.log(JSON.parse(data));
				min.min = JSON.parse(data);
				document.querySelector("input[name='min_payment']").placeholder = `Suggested $${JSON.parse(data)}`;
			})

			document.querySelector("input[name='min_payment']").placeholder = `Suggested $${min.min}`;
			if ((parseInt(min.min) > parseInt(min.value))){
				min.classList.remove("is-valid");
				min.classList.add("is-invalid");
			} else {
				min.classList.remove("is-invalid");
				min.classList.add("is-valid");
			}
		})
	});

	$('#newAccount').on('shown.bs.modal', function(){
		$('input:text:visible:first', this).focus();
		
		var principal = document.querySelector("input[name='account[principal]']");
		var min = document.querySelector("input[name='account[min_payment]']");
		var min_payment = principal.value * 0.03

		$('#newAccount').on('change', function(){
			var minOnly = document.querySelector("#newAccountModal > div > div > form > div.modal-body > div > div > input.newMinOnly");
			
			if (minOnly.checked) {
				minOnly.value = true;
			}
			
			min.min = principal.value * 0.03;
			document.querySelector("input[name='account[min_payment]']").placeholder = `Suggested $${min.min}`;
			if ((parseInt(min.min) > parseInt(min.value))){
				min.classList.remove("is-valid");
				min.classList.add("is-invalid");
			} else {
				min.classList.remove("is-invalid");
				min.classList.add("is-valid");
			}
		});

		min = document.querySelector("input[name='account[min_payment]']");
		$(min).focusout(function(){
			if ((min).validity.rangeUnderflow){
				message = "Increase your minimum payment."
			}
		});


	});

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
