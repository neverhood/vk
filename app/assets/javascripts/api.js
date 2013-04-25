$.api = {
    translations: {
        headsUp: 'Ок!',
        warning: 'Внимание!'
    },

    elements: {
        notifications: 'div#notifications'
    },

    loading: false,

    utils: {
        toggleSpinner: function() {
            $('div#backdrop, div#loader').toggleClass('hidden');
        },

        appendErrors: function(form, model, errors) {
            $.each(errors, function(key, errors) {
                var attribute = model + '_' + key;

                var input = form.find('#' + attribute);
                form.find('div.control-group' + ( '.' + attribute )).addClass('error');

                $.each(errors, function(index, error) {
                    input.after("<span class='help-inline'>" + error + "</span>");
                });
            });
        },

        appendEntry: function(container, form, entry) {
            form.trigger('reset').parent().slideToggle('fast');

            container.append(entry);
        },

        prependEntry: function(container, form, entry) {
            form.trigger('reset').parent().slideUp('fast');

            container.prepend(entry);
        },

        clearErrors: function(form) {
            form.find('span.help-inline').remove();
            form.find('.error').removeClass('error');
        },

        appendNotification: function(type, message) {
            classNames = 'alert ' + (type == 'error' ? 'alert-error' : 'alert-info');
            notificationHeader = type == 'error' ? $.api.translations.warning : $.api.translations.headsUp;

            notification = "<div class='" + classNames + "'> <button type='button' class='close' data-dismiss='alert'> × </button>" +
                "<h4>" + notificationHeader + "</h4>" +
                message +
                "</div";

            notifications = $($.api.elements.notifications);
            notifications.find('div.alert').remove();
            notifications.append(notification);
        }
    }
}
