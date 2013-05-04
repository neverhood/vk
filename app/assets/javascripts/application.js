// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery-fileupload/basic
//
//= require api
//
//= require bootstrap-alert
//= require bootstrap-modal
//= require bootstrap-modal-extended
//= require bootstrap-modalmanager
//= require bootstrap-transition
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.ru.js
//
//= require cookie
//
//= require header
//= require welcome
//
//= require authenticated/users
//= require authenticated/groups
//= require authenticated/posts
//= require authenticated/photos
//= require authenticated/schedules
//= require authenticated/auto_exchanges_searches
//

$.ajaxSettings.dataType = 'json';

function nearBottomOfPage() {
    return scrollDistanceFromBottom() < 400;
}

function scrollDistanceFromBottom() {
    return pageHeight() - (window.pageYOffset + window.innerHeight);
}

function pageHeight() {
    return Math.max(document.body.scrollHeight, document.body.offsetHeight);
}

$(window).on('page:fetch', function(event) {
    $.api.loading = true;

    $.api.utils.toggleSpinner();
});

$(window).on('page:restore', function() {
    // History
    if ( $('div#loader').is(':visible') ) {
        $.api.utils.toggleSpinner();

        $.api.loading = false;
    }
});

$(window).on('page:fetch', function() {
});

$(window).bind('page:load load', function(event) {
    $.api.controller     = document.body.id;
    $.api.action         = document.body.attributes['data-action'].value;
    $.api.body = $(document.body)

    $.api.header.init();

    var controllerPath = $.api[ $.camelCase($.api.controller).replace('/', '-') ];
    if ( typeof controllerPath === 'object' ) controllerPath.init();

    $.api.loading = false;

    $(document.body).on('click', 'a.disabled', function(event) {
        event.stopPropagation();
    });
});



