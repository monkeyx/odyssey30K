jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

$(document).ready(function(){
  $("#comment_form").ajaxForm();
});

function set_notice(msg) {
	$(".notice").html(msg);
} 

function set_warning(msg) {
	$(".warning").html(msg);
}

function set_error(msg) {
	$(".error").html(msg);
}

function set_colorbox_error(msg) {
	$("#form-error").html(msg);
}

function set_colorbox_notice(msg) {
	$("#form-error").html('');
	$("#notice").html(msg);
	$("#notice").addClass('notice');
}

function preProcessAjaxForm() {
}

function processAjaxJsonForm(data) {
	if(data.success) {
		set_colorbox_notice(data.notice);
	}
	else {
		set_colorbox_error(data.error);
	}
	parent.colorbox.resize();
}
