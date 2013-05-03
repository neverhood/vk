# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$.api.photos =
    allowedImageFormats: /(\.|\/)(gif|p?jpe?g|png)$/i,
    container: -> $('div#photos'),

    init: ->
        modal = $('div#photos-modal')

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

        $('button#close-photos-modal, a#close-photos-modal').bind 'click', (event) ->
            event.preventDefault()

            modal.modal 'hide'

        $('a#attachment-photo').bind 'click', (event) ->
            event.preventDefault()

            $('div#photos div.photo').show()
            modal.modal 'show'

