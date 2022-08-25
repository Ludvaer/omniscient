# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
root = exports ? this

root.ajaxify_link = (link,response_area)->
	link.on "ajax:success", (e, data, status, xhr) ->
	 	response_area.html(data.html)
	 	if data.redirect
		    Turbolinks.visit($('#redirect-to-user').attr('href'));
	link.on "ajax:error", (e, xhr, status, error) ->
	 	alert("Ajax request failed");

		#e.preventDefault()
		#method = link.attr('data-method')
		#method ?= 'get'
		#$.ajax link.attr('href'), () ->
		#            type: method
		#            dataType: 'json'
		#            error: (jqXHR, textStatus, errorThrown) ->
		#                alert("Ajax request failed");
		#            success: (data, textStatus, jqXHR) ->
		#                response_area.html(data.html)
		                #if data.redirect
		                #    Turbolinks.visit($('#redirect-to-user').attr('href'));
