# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


#$(document).ready ->
#    $('#new_user').on "ajax:success", ajax_success_handler



root = exports ? this

root.ajax_success_handler = (event, data) ->
        $("#sign-up-response").html(data.html)
        if data.redirect
            window.location.replace($('#redirect-to-user').attr('href'))
        else
            $('#sign-up-button').show()

root.ajax_failed_handler = (event, data) ->
        #alert("Ajax request failed");
        $("#sign-up-response").html(data.html)
        $('#sign-up-button').show()

root.encryptsignup = (dat1,dat2)->
    $('#sign-up-button').hide()
    $('#user_name').val($("#name").val())
    $('#user_email').val($("#email").val())
    $('#user_password').val(dat1)
    $('#user_password_confirmation').val(dat2)
    $('#user-submit').click()
    #uname = $("#name").val()
    #email = $("#email").val()
    #$.ajax(url: "/signup", method: "post", data: {user: {name: uname, password: dat1, password_confirmation: dat2, email: email}}).done (html) -> 
	#    $("#sign-up-response").html(html)


