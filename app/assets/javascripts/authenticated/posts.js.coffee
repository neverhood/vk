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

        resetNewPostForm = ->
            newPostForm.trigger 'reset'
            newPostForm.find('span.remove-preview').trigger 'click'
        resetEditPostForm = ->
            editPostFormContainer.hide()
            editPostForm.trigger 'reset'
            editPostForm.find('span.remove-preview').trigger 'click'
            container.find('div.post div.content').show()

        newPostFormToggler.bind 'click', (event) ->
            event.preventDefault()
            event.stopPropagation()

            $(this).find('i').toggleClass 'icon-angle-up icon-angle-down'
            newPostFormContainer.slideToggle 'fast'
            resetEditPostForm()

        newPostForm.bind('ajax:beforeSend', ->
            $.api.utils.clearErrors $(this)
        ).bind('ajax:complete', (event,xhr,status) ->
            response = $.parseJSON(xhr.responseText)

            if status == 'success'
                $.api.utils.prependEntry container, $(this), response.entry
                $(this).find('span.remove-preview').trigger 'click'
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
            editPostForm.find('input#edit_post_from_group').prop('checked', post.data('from-group'))

            images = post.find('div.post-photo')
            previewsContainer = $('div#edit-post-media-previews')
            previewsContainer.find('div.post-media-preview').remove()
            photoIds = []

            $.each images, (index, image) ->
                photoId  = this.id.replace('post-photo-', '')
                photoIds.push photoId
                template = $('div#post-media-preview-template').clone().removeAttr('id').removeClass('hidden').data('photo-id', photoId)
                previewsContainer.append( template.append $(this).find('img').clone() )

            $('input#edit_post_photo_ids').val photoIds.join(',')

            newPostFormContainer.hide()
            resetNewPostForm()

        container.on 'ajax:beforeSend', 'a.post-option.destroy', (event) ->
            event.preventDefault()

            container.append editPostFormContainer
            $(this).parents('div.post').remove()

        $('a#cancel-post-edit').bind 'click', (event) ->
            event.preventDefault()

            editPostFormContainer.slideUp('fast')
            editPostForm.trigger 'reset'

            $(this).parents('div.post').find('div.content').show()

        $('a#attachments-dropdown-toggler').bind('click', (event) ->
            event.preventDefault()
        )

        $('div#attachments-dropdown-container, div#edit-attachments-dropdown-container').bind('mouseenter mouseleave', ->
            if this.id == 'attachments-dropdown-container'
                $('ul#attachments-dropdown').slideToggle 'fast'
            else
                $('ul#edit-attachments-dropdown').slideToggle 'fast'
        )

        $('a#attachment-photo, a#edit-attachment-photo').bind('click', (event) ->
            event.preventDefault()
            $('div#photos div.photo').show()
            mode = if this.id == 'edit-attachment-photo' then 'edit' else 'new'

            if mode == 'edit'
                post   = $(this).parents('div.post')
                attachedImages = post.find('div.post-photo')
                $.each attachedImages, (index, image) ->
                    photoId = this.id.replace('post-photo-', '')
                    console.log photoId
                    $("div#photos div#photo-#{photoId}").hide()

            $('div#photos-modal').modal('show').data('mode', mode)
        )

        $('button#close-photos-modal, a#close-photos-modal').bind 'click', (event) ->
            event.preventDefault()

            $('div#photos-modal').modal 'hide'


