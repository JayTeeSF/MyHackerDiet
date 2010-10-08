var options = { 
	beforeSubmit:  validate,  // pre-submit callback 
	success:       showResponse,  // post-submit callback 
	resetForm: true        // reset the form after successful submit 
}; 
				
$('#contact_us').ajaxForm(options); 
				
function showResponse(responseText, statusText){
	$('#contact_us').slideUp({ opacity: "hide" }, "normal")
	$('#success').fadeIn(2000)
	
}
				
function validate(formData, jqForm, options) {
	$("p.error").slideUp({ opacity: "hide" }, "fast");
			 
	var nameValue = $('input[name=Name]').fieldValue(); 
	var emailValue = $('input[name=Email]').fieldValue();
	var messageValue = $('textarea[name=Message]').fieldValue(); 
	
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	var correct = true;
	
	if (!nameValue[0]) {
		$("p.error.wrong_name").slideDown({ opacity: "show" }, "slow");
		correct = false;
	}
	
	if (!emailValue[0]) {
		$("p.error.wrong_email").slideDown({ opacity: "show" }, "slow");
		correct = false;
	} else if(!emailReg.test(emailValue[0])) {
		$("p.error.wrong_email").slideDown({ opacity: "show" }, "slow");
		correct = false;
	}
	
	if (!messageValue[0]) {
		$("p.error.wrong_message").slideDown({ opacity: "show" }, "slow");
		correct = false;
	}
	
	if (!correct) {return false;}
} 	
								 