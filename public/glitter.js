
// ============= PONY SPIN ON POST SUBMIT=============

function ponySpin(){
	var img = getElementById("unicorn")
	img.setAttribute("class", "unicorn")
}

// ============= BASIC FUNCTIONALITY =============

document.getElementById('submit').onclick = function validate() {
	//checks character length of posts
	var P = document.getElementById('accountContent').value
	if (P.length >= 150 || P.length < 1) {
		alert("Must be at least 1 character and fewer than 150 characters.");
	    return false; //forces to stay on page if wrong
	}	
}

// ============= SPARKLY STUFF ON HOVER =============





