export function run (){
	// Show Announcement flag set to true when new features are ready.
	var showAnnouncement = true;
	var readAnnouncement = localStorage.getItem("readAnnouncement");

	var data = {
		"read":   true,
		"date":   setDate(),
		"expire": setExpiration()
	};

	if (showAnnouncement && !readAnnouncement){
		$('<div>', { id : 'overlay' }).appendTo('body');
		$("#announcement").fadeIn('slow');
		$("#close").click(function(e){
			setValues();
			$('#announcement').remove();
			$('#overlay').remove();
			e.preventDefault();
		});
	} else {
		removeOldValues();
		var now = new Date();
		var expiration = JSON.parse(readAnnouncement);

		expiration = new Date(expiration.expire);

		if (now > expiration) {
			localStorage.removeItem("readAnnouncement");
		}
	}

	function removeOldValues() {
		var value = JSON.parse(readAnnouncement);
		
		if (value && !value.expire) {
			localStorage.removeItem("readAnnouncement");
			setValues();
		}	
	}

	function setValues() {
		localStorage.setItem("readAnnouncement", JSON.stringify(data));
	}

	function setDate() {
		var date = new Date();
		return date;
	}

	function setExpiration() {
		var date = new Date();
		date.setDate(date.getDate() + 15)
		
		return date;
	}
};