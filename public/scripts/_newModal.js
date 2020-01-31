export function run () {
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
}