# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


#$(document).ready ->
#    $('#new_user').on "ajax:success", ajax_success_handler



root = exports ? this

root.init_users_form = ()->
    $('#user-submit').hide();
    $('#sign-up-button').show();

root.encryptsignup = ()->
    uname = $("#user_name").val()
    email = $("#user_email").val()
    
    name_as_salt = uname.trim().replace(/ +/g, " ").toLowerCase();


    hmac = forge.hmac.create();
    hmac.start('sha256', name_as_salt);
    hmac.update($('#user_password').val());
    hashed1 = hmac.digest().toHex();

    hmac = forge.hmac.create();
    hmac.start('sha256', name_as_salt);
    hmac.update($('#user_password_confirmation').val());
    hashed2 = hmac.digest().toHex();

    publicKey1 = forge.pki.publicKeyFromPem($("#publickey").val());
    salt = $("#salt").val()
    encrypted1 = forge.util.bytesToHex(publicKey1.encrypt(hashed1 + '|' + salt));
    encrypted2 = forge.util.bytesToHex(publicKey1.encrypt(hashed2 + '|' + salt));
    $.ajax '/users',
                type: 'POST'
                dataType: 'json'
                data: { user: { name: uname, password_encrypted: encrypted1, password_confirmation_encrypted: encrypted2, email: email } }
                error: (jqXHR, textStatus, errorThrown) ->
                    alert("Ajax request failed");
                    $('#sign-up-button').show()
                success: (data, textStatus, jqXHR) ->
                        $("#sign-up-response").html(data.html)
                        if data.redirect
                            Turbolinks.visit($('#redirect-to-user').attr('href'));
                        else
                            $('#sign-up-button').show()
                            $('#user-submit').hide()
                    
                    


