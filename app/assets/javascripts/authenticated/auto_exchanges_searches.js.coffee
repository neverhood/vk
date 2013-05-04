$.api.autoExchangesSearches =
    init: ->
        container = $.api.body.find('div#search-results')

        formToggler = $.api.body.find('a#new-search-form-toggler')
        formContainer = $.api.body.find('div#new-search-form-container')
        form = $.api.body.find('form#new-search')

        formToggler.bind 'click', (event) ->
            event.preventDefault()

            $(this).find('i').toggleClass('icon-angle-up icon-angle-down')
            formContainer.slideToggle 'fast'

        form.bind 'ajax:complete', (event, xhr, status) ->
            response = $.parseJSON(xhr.responseText)

            container.append(response.results)
            formContainer.slideUp 'fast'

