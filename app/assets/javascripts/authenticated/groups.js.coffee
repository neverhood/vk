# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$.api.groups =
    init: ->
        container = $.api.body.find('div#groups')
        modal = $.api.body.find('div#group-modal')

        $('a#update-groups').bind('ajax:beforeSend', ->
            $(this).addClass 'disabled'
        ).bind('ajax:complete', (event, xhr, status) ->
            $(this).removeClass 'disabled'
            response = $.parseJSON(xhr.responseText)

            $('div#groups').html response.groups
        )

        container.on 'ajax:beforeSend', 'a.destroy-group', ->
            $(this).parents('div.group').remove()

        container.on 'click', 'a.show-group', (event) ->
            event.preventDefault()

            $.api.body.modalmanager('loading')
            $.getJSON this.href, (data) ->
                $.api.body.find('div#group').html data.group

                modal.modal 'show'

        $.api.body.find('a#close-group-modal, button#close-group-modal').bind 'click', (event) ->
            event.preventDefault()

            modal.modal 'hide'

