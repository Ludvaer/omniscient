# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this

root.encryptsignup = (dat1,dat2)->
    $('#sign-up-button').hide()
    uname = $("#username").val()
    email = $("#email").val()
    $.ajax(url: "/signup", method: "post", data: {name: uname, password: dat1, password_verify: dat2, email: email}).done (html) -> 
	    $("#signUpResponse").html(html)


