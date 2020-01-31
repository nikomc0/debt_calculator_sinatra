export function run () {
	$('#editAccountModal').on('shown.bs.modal', function(){
		$('input:text:visible:first', this).focus();
		
		var paymentID = "";
		var paymentURL = window.location.href;
		var url = window.location.href

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
			}
			
			queryString = "?";
			var new_values = values.filter(query => query.value != null).map(query => `${query.name}=${query.value}`).join("&");
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
};
