# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$.api.groups =
    init: ->
        $.api.posts.init() if $.api.action == 'show'

        $('a#update-groups').bind('ajax:beforeSend', ->
            $(this).addClass 'disabled'
        ).bind('ajax:complete', (event, xhr, status) ->
            $(this).removeClass 'disabled'
            response = $.parseJSON(xhr.responseText)

            $('div#groups').html response.groups
        )

        $('div#groups').on 'ajax:beforeSend', 'a.destroy-group', ->
            $(this).parents('div.group').remove()


