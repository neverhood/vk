# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$.api.posts =
    init: ->
        # Elements
        container = $('div#posts')

        newPostFormToggler = $('a#new-post-form-toggler')
        newPostFormContainer = $('div#new-post-form-container')
        newPostForm = $('form#new-post')
        editPostFormToggler = 'div.post-options a.edit.post-option'
        editPostFormContainer = $('div#edit-post-form-container')
        editPostForm = $('form#edit-post')

        newPostFormToggler.bind 'click', (event) ->
            event.preventDefault()
            event.stopPropagation()

            $(this).find('i').toggleClass 'icon-angle-up icon-angle-down'
            newPostFormContainer.slideToggle('fast')

        newPostForm.bind('ajax:beforeSend', ->
            $.api.utils.clearErrors $(this)
        ).bind('ajax:complete', (event,xhr,status) ->
            response = $.parseJSON(xhr.responseText)

            if status == 'success'
                $.api.utils.prependEntry container, $(this), response.entry
            else
                $.api.utils.appendErrors $(this), 'post', response.errors
        )

        editPostForm.bind('ajax:beforeSend', ->
            $.api.utils.clearErrors $(this)
        ).bind('ajax:complete', (event,xhr,status) ->
            response = $.parseJSON(xhr.responseText)

            if status == 'success'
                editPostFormContainer.hide()
                $('div#group').append editPostFormContainer

                $("div#post-#{response.id}").replaceWith response.entry
            else
                $.api.utils.appendErrors $(this), 'edit_post', response.errors
        )


        container.on 'click', editPostFormToggler, (event) ->
            event.stopPropagation()
            event.preventDefault()

            container.find('div.post div.content').show()
            post = $(this).parents('div.post')

            post.find('div.content').hide()
            post.find('div.edit-form-placeholder').append(editPostFormContainer)
            editPostFormContainer.slideDown 'fast'
            editPostForm.attr('action', editPostForm.attr('action').replace(/\d+/, post.attr('id').replace('post-', '')))
            editPostForm.find('textarea#edit_post_body').val post.find('div.body').text()

        container.on 'ajax:beforeSend', 'a.post-option.destroy', (event) ->
            event.preventDefault()

            container.append editPostFormContainer
            $(this).parents('div.post').remove()

        $('a#cancel-post-edit').bind 'click', (event) ->
            event.preventDefault()

            editPostFormContainer.slideUp('fast')
            editPostForm.trigger 'reset'

            $(this).parents('div.post').find('div.content').show()


