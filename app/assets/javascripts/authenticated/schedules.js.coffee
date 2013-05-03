# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.api.schedules =
    init: ->
        container = $.api.body.find('div#schedules')
        modal = $.api.body.find('div#schedules-modal')
        scheduleTogglers = $.api.body.find('div#schedule-options a')
        scheduleKinds = $.api.body.find('div#now-schedule, div#regular-schedule')
        forms = $.api.body.find('form#new-schedule, form#new-now-schedule')
        formsContainer = $.api.body.find('div#schedule-form-container')

        translations =
            invalidDate: 'Не правильная дата'
            invalidTime: 'Не правильный формат времени или выбранное время уже прошло'
            currentTimeSelected: 'Вы выбрали настоящее время. Пожалуйста, воспользуйтесь функцией "Опубликовать сейчас"'

        yesterday = ->
            now = new Date
            now.setDate(now.getDate() - 1)

            now

        #postNow = ->
            #date = new Date(Date.parse $('input#schedule_post_at_date').val())
            #hour = parseInt( $('select#schedule_post_at_time_4i').val() )
            #minutes = parseInt( $('select#schedule_post_at_time_5i').val() )
            #now = new Date

            #if date.getMonth() == now.getMonth() and date.getDay() == now.getDay() and hour == now.getHours() and minutes == now.getMinutes()
                #true
            #else
                #null

        validTime = ->
            date = new Date(Date.parse $('input#schedule_post_at_date').val())
            hour = parseInt( $('select#schedule_post_at_time_4i').val() )
            minutes = parseInt( $('select#schedule_post_at_time_5i').val() )

            currentTime = new Date
            currentHour = currentTime.getHours()
            currentMinutes = currentTime.getMinutes()

            return true if date.getMonth() > currentTime.getMonth()
            return true if date.getDay() > currentTime.getDay()

            return null if ( hour < currentHour ) or ( hour == currentHour and minutes < currentMinutes )
            return true

        $('div#posts').on 'click', 'a.post-option.add-timer', (event) ->
            event.preventDefault()

            postId = $(this).parents('div.post').attr('id').replace('post-', '')
            forms.find('input#schedule_post_id').val postId
            $.api.body.modalmanager('loading')

            $.getJSON("/schedules/#{postId}", (data) ->
                container.html(data.schedules)

                now = new Date
                hour = parseInt( $.api.body.find('select#schedule_post_at_time_4i').val now.getHours() )
                minutes = parseInt( $.api.body.find('select#schedule_post_at_time_5i').val now.getMinutes() )

                modal.modal 'show'
            )

        $('button#close-schedules-modal, a#close-schedules-modal').bind 'click', (event) ->
            event.preventDefault()

            modal.modal 'hide'

        $('input#schedule_post_at_date').datepicker language: 'ru', startDate: yesterday()

        scheduleTogglers.bind 'click', (event) ->
            event.preventDefault()

            scheduleTogglers.toggleClass 'disabled'
            scheduleKinds.toggleClass 'hidden'

        forms.bind('ajax:beforeSend', (event) ->
            $(this).find('span.error').remove()

            if $('div#regular-schedule').is(':visible') and $('input#schedule_post_at_date').val().length < 10
                $('input#schedule_post_at_date').after("<span class='error'> #{ translations.invalidDate } </span>")
                event.stopPropagation()
                return false

            if $('div#regular-schedule').is(':visible') and not validTime()?
                $('select#schedule_post_at_time_5i').after("<span class='error'> #{ translations.invalidTime } </span>")
                return false

        ).bind('ajax:complete', (event, xhr, status) ->
            response = $.parseJSON(xhr.responseText)

            if status == 'success'
                container.prepend response.entry
                formsContainer.slideUp 'fast'

                $('input#schedule_post_at_date').val ''
        )

        $('a#new-schedule-form-toggler').bind 'click', (event) ->
            event.preventDefault()
            $(this).find('i').toggleClass('icon-angle-up icon-angle-down')

            formsContainer.slideToggle 'fast'
