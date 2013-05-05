$.api.autoExchangesSearches =
    init: ->
        container = $.api.body.find('div#search-results')
        sortsContainer = $.api.body.find('div#search-results-sortings-container')
        noResults = $.api.body.find('div#no-results')

        formToggler = $.api.body.find('a#new-search-form-toggler')
        formContainer = $.api.body.find('div#new-search-form-container')
        form = $.api.body.find('form#new-search')

        formToggler.bind 'click', (event) ->
            event.preventDefault()

            $(this).find('i').toggleClass('icon-angle-up icon-angle-down')
            formContainer.slideToggle 'fast'

        form.bind('ajax:complete', (event, xhr, status) ->
            response = $.parseJSON(xhr.responseText)

            if response.results.length > 0
                noResults.hide()
                sortsContainer.show() if response.results.length > 0
            else
                noResults.show()

            container.html(response.results)
            formContainer.slideUp 'fast'
            container.removeClass 'loading'
        ).bind('ajax:beforeSend', ->
            container.addClass 'loading'
        )

        sortsContainer.find('a').bind 'click', (event) ->
            event.preventDefault()

            $this = $(this)

            if $this.hasClass 'active'
                $this.data('sort-direction', if $this.data('sort-direction') == 'asc' then 'desc' else 'asc')
                $this.find('i').toggleClass 'icon-angle-up icon-angle-down'
            else
                sortsContainer.find('a').removeClass('active').data('sort-direction', 'desc').
                    find('i').removeClass 'icon-angle-up icon-angle-down'
                $this.addClass('active').find('i').addClass 'icon-angle-down'

            form.find('input#auto_exchanges_search_sort_attribute').val $this.data('sort-attribute')
            form.find('input#auto_exchanges_search_sort_direction').val $this.data('sort-direction')

            form.trigger 'submit'

