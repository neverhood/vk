# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.api.posts =
    init: ->
        $.api.photos.init() if $.api.action == 'index'
        $.api.schedules.init() if $.api.action == 'index'

        container = $('div#posts')
        entrySelector = 'div.post'

        toggler = $('a#post-form-toggler')
        form  = $('form#post-form')
        repostForm = $('form#repost-form')
        forms = $('form#post-form, form#repost-form')
        formContainer = $('div#post-form-container')
        resetForm = ->
            form.trigger 'reset'
            form.find('input#post_photo_ids').val ''
            container.find('div.content').show()
            attachments.mediaPreviewsContainer.find('div.post-media-preview').remove()
            attachments.photosContainer.find('div.photo').show()
        updateUrl = (id) -> "/posts/#{id}"
        createUrl = '/posts/'

        attachments =
            mediaPreviewTemplate: $('div#post-media-preview-template')
            mediaPreviewsContainer: $('div#post-media-previews')
            appendPreview: (img, id, container) ->
                preview  = attachments.mediaPreviewTemplate.clone().removeAttr('id').removeClass('hidden').data('id', id).append(img)
                photoIds = if form.find('input#post_photo_ids').val().length > 0 then form.find('input#post_photo_ids').val().split(',') else []
                photoIds.push id

                form.find('input#post_photo_ids').val photoIds.join(',')
                attachments.mediaPreviewsContainer.append(preview)
            removePreview: ->
                preview  = $(this).parents('div.post-media-preview')
                photoIds = $.grep( form.find('input#post_photo_ids').val().split(','), (value) -> value != preview.data('id') )

                $("div#photo-#{preview.data('id')}").show()
                console.log photoIds
                form.find('input#post_photo_ids').val photoIds.join(',')
                preview.remove()

            photosContainer: $('div#photos')

        # Functions
        toggleForm = (event) ->
            event.preventDefault()
            $(this).find('i').toggleClass('icon-angle-up icon-angle-down')

            container.find('div#post-kinds').show()
            form.find('a#cancel-post-edit').addClass 'hidden'
            form.attr('method', 'post').attr('action', createUrl)
            resetForm()

            if $('div#initial-post-form-container').find('form').length == 0
                formContainer.hide().
                    appendTo('div#initial-post-form-container').
                    slideDown 'fast'
            else
                formContainer.slideToggle 'fast'

        removeEntry = (event) ->
            event.preventDefault()

            $('div#initial-post-form-container').append(formContainer.hide())
            $(this).parents(entrySelector).remove()

        $('a#post-regular, a#post-repost').bind('click', (event) ->
            event.preventDefault()

            $('a#post-regular, a#post-repost').toggleClass('disabled')
            formContainer.find('div#post-regular, div#post-repost').toggleClass('hidden')
        )

        # Form toggling(slideUp/slideDown)
        toggler.bind 'click', toggleForm
        container.on 'ajax:beforeSend', 'a.post-option.destroy', removeEntry

        $('a#cancel-post-edit').bind 'click', (event) ->
            event.preventDefault()
            post = $(this).parents('div.post')

            formContainer.slideUp('fast', ->
                post.find('div.content').show()
                resetForm()
            )

        form.bind('ajax:beforeSend', ->
            $.api.utils.clearErrors $(this)
        ).bind('ajax:complete', (event,xhr,status) ->
            response = $.parseJSON(xhr.responseText)
            mode = if $('div#initial-post-form-container').find('form#post-form').length > 0 then 'new' else 'edit'

            if status == 'success'
                if mode == 'new'
                    container.prepend response.entry
                    $(this).trigger('reset')
                    formContainer.slideUp 'fast'
                else
                    postId = form.attr('action').replace(/\D+/, '')
                    $('div#initial-post-form-container').append formContainer
                    container.find("div#post-#{postId}").replaceWith response.entry
                    formContainer.slideToggle 'fast'

                resetForm()
            else
                $.api.utils.appendErrors $(this), 'post', response.errors
        )

        repostForm.bind('ajax:beforeSend', ->
            $.api.utils.clearErrors $(this)
        ).bind('ajax:complete', (event, xhr, status) ->
            $this = $(this)
            response = $.parseJSON(xhr.responseText)

            if status == 'success'
                container.prepend response.entry
                $this.trigger('reset')

                formContainer.slideUp 'fast'
            else
                $.api.utils.appendErrors $(this), 'post', response.errors
        )


        # Attachments
        $('a#attachments-dropdown-toggler').bind('click', (event) -> event.preventDefault())
        $('div#attachments-dropdown-container').bind('mouseenter mouseleave', -> $('ul#attachments-dropdown').slideToggle 'fast')


        attachments.photosContainer.on 'click', 'div.photo', ->
            $this   = $(this).hide()
            attachments.appendPreview $this.find('img').clone(), this.id.replace('photo-', '')

        $('div#post-media-previews').on 'click', 'span.remove-preview', attachments.removePreview

        container.on 'click', 'a.post-option.edit', (event) ->
            event.preventDefault()
            post = $(this).parents('div.post')

            $('div#post-kinds').hide()

            resetForm()
            post.find('div.content').hide()
            post.find('div.form-placeholder').append(formContainer)
            formContainer.slideDown 'fast', ->
                form.attr('action', updateUrl(post.attr('id').replace('post-', ''))).attr('method', 'put')
                form.find('textarea#post_body').val post.find('div.body').text()
                form.find('input#post_from_group').prop('checked', post.data('from-group'))
                form.find('a#cancel-post-edit').removeClass 'hidden'

                postPhotos = post.find('div.post-photo')
                postPhotoIds = []
                $.each postPhotos, (index, photo) ->
                    photoId  = this.id.replace('post-photo-', '')
                    postPhotoIds.push photoId
                    $("div#photo-#{photoId}").hide()
                    attachments.appendPreview $(photo).find('img').clone(), photoId

                    $('input#post_photo_ids').val postPhotoIds.join(',')

        container.on 'ajax:beforeSend', 'div.available-for-exchanges-column a', (event) ->
            $(this).find('i').toggleClass('icon-star icon-star-empty')

            if /true/.test this.href
                this.href = this.href.replace('true', 'false')
            else
                this.href = this.href.replace('false', 'true')

