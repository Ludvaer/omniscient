root = exports ? this

serializeForm = (form) ->
    hash = {}
    for item in form.serializeArray()
        hash[item.name] = item.value
    hash

root.sendShulte = ()->
    data = serializeForm($('form'))
    method = 'post'
    if $('input[name="_method"]').val()
        method = $('input[name="_method"]').val()

    $.ajax $('form').attr('action'),
                type: method
                dataType: 'json'
                data: data
                error: (jqXHR, textStatus, errorThrown) ->
                    alert("Ajax request failed");
                    show_start_button()
                success: (data, textStatus, jqXHR) ->
                    $("#shulte-save-response").html(data.html)
