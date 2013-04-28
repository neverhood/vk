# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$.api.photos =
    allowedImageFormats: /(\.|\/)(gif|p?jpe?g|png)$/i,
    container: -> $('div#photos'),

    init: ->
        _this = this

        $('form#upload-photos').fileupload
            dataType: 'json',
            maxFileSize: 10000000,
            done: (event, response) ->
                $.api.photos.container().prepend response.result.photo

                $('div#photo-uploading-container').find('#' + response.identifier ).remove()
                $('div.no-results').remove()

            add: (event, data) ->
                file       = data.files[0]
                if _this.allowedImageFormats.test(file.type) or _this.allowedImageFormats.test(file.name)
                    identifier = "photo-upload-#{ new Date().getTime() }"

                    data.identifier = identifier
                    data.context = $('div#file-upload-progress').clone().attr('id', identifier).removeClass('hidden')
                    data.context.find('div.filename').text file.name

                    $('div#photo-uploading-container').append data.context

                    data.submit()
                else
                    alert "#{ file.name }: #{ $(this).data('alert') }"

            progress: (event, data) ->
                if data.context?
                    progress = parseInt( data.loaded/data.total * 100, 10 )
                    data.context.find('.bar').css
                        width: progress + '%'

        $('div#photos').on 'click', 'div.photo', ->
            mode = $('div#photos-modal').data('mode')
            photoIdsInput = if mode == 'new' then $('input#post_photo_ids') else $('input#edit_post_photo_ids')
            photoId       = this.id.replace('photo-', '')
            template      = $('div#post-media-preview-template').clone().removeAttr('id').removeClass('hidden').data('photo-id', photoId)

            photoIds = if photoIdsInput.val().length > 0 then photoIdsInput.val().split(',') else []
            photoIds.push photoId
            photoIds = $.unique(photoIds).join(',')

            photoIdsInput.val photoIds

            container = if mode == 'new' then $('div#post-media-previews') else $('div#edit-post-media-previews')
            template.append  $(this).hide().find('img').clone()
            container.append template

        $('div#post-media-previews').on 'click', 'div.post-media-preview span.remove-preview', ->
            $this = $(this).parents('div.post-media-preview')
            $("div#photos div#photo-#{$this.data('photo-id')}").show()

            photoIdsInput = $('input#post_photo_ids')
            photoIds = photoIdsInput.val().split(',')
            photoIds = $.grep(photoIds, (value) -> value != $this.data('photo-id'))
            photoIdsInput.val photoIds.join(',')

            $this.remove()

        $('div#edit-post-media-previews').on 'click', 'div.post-media-preview span.remove-preview', ->
            $this = $(this).parents('div.post-media-preview')
            $("div#photos div#photo-#{$this.data('photo-id')}").show()

            photoIdsInput = $('input#edit_post_photo_ids')
            photoIds = photoIdsInput.val().split(',')
            photoIds = $.grep(photoIds, (value) -> value != $this.data('photo-id'))
            photoIdsInput.val photoIds.join(',')

            $this.remove()

