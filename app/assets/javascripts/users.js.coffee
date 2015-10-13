# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this

root.encryptsignup = (dat)->
    $('#signUpButton').hide()
    uname = $("#username").val()
    email = $("#email").val()
    $.ajax(url: "/signup", method: "post", data: {name: uname, password: dat, email: email}).done (html) -> 
	    $("#signUpResponse").html(html)
	    $('#signUpButton').show()

