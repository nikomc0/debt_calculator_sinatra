export function run (){
	// Show Announcement flag set to true when new features are ready.
	var showAnnouncement = true;
	var readAnnouncement = localStorage.getItem("readAnnouncement");

	if (showAnnouncement && !readAnnouncement){
		var data = {
			"read":   true,
			"date":   setDate(),
			"expire": setExpiration()
		};

		$('<div>', { id : 'overlay' }).appendTo('body');
		$("#announcement").fadeIn('slow');
		$("#close").click(function(e){
			localStorage.setItem("readAnnouncement", JSON.stringify(data));
			$('#announcement').remove();
			$('#overlay').remove();
			e.preventDefault();
		});
	} else {
		var now = new Date();
		var expiration = JSON.parse(readAnnouncement)

		expiration = new Date(expiration.expire)

		if (now > expiration) {
			localStorage.removeItem("readAnnouncement");
		}
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