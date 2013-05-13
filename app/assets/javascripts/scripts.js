// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.noConflict();

jQuery.ajaxSetup({
    'beforeSend': function (xhr) {
        xhr.setRequestHeader("Accept", "text/javascript")
    }
});

function remove_fields(link) {
    $(link).previous("input[type=hidden]").value = "1";
    $(link).up(".fields").hide();
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    $(link).up().insert({
        before: content.replace(regexp, new_id)
    });
}

jQuery.fn.submitWithAjax = function () {
    this.unbind('submit', false);
    this.submit(function () {
        jQuery.post(this.action, jQuery(this).serialize(), null, "script");
        return false;
    })

    return this;
};

//This will "ajaxify" the links
function ajaxLinks() {
    jQuery('.ajaxForm').submitWithAjax();
}

var $ = jQuery;

$(document).ready(function () {

    // All non-GET requests will add the authenticity token
    // if not already present in the data packet
    $(document).ajaxSend(function (event, request, settings) {
        if (typeof(window.AUTH_TOKEN) == "undefined") return;
        // <acronym title="Internet Explorer 6">IE6</acronym> fix for http://dev.jquery.com/ticket/3155
        if (settings.type == 'GET' || settings.type == 'get') return;
        settings.data = settings.data || "";
        settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
    });
    ajaxLinks();

    //Best In Place Gem Init
    $('.best_in_place').best_in_place();

    //jQuery UI Sortable and Mixonic Ranked-Model to sort and submit playlist orders
    var item_id,
        position,
        url;

    $(".sort-list").sortable({
        axis: 'y',
        containment: 'parent',
        cursor: 'crosshair',
        items: 'tr.sortable',

        stop: function(e, ui) {
            ui.item.children('td').effect('highlight', {}, 1000);
        },
        update: function(e, ui) {
            item_id = ui.item.attr('data-id');
            position = ui.item.index();
            url = $(this).attr('data-url');
            console.log(item_id + " " + position + " " + url);
            $.ajax({
                type: 'POST',
                url: $(this).data('url'),
                dataType: 'json',

                //the :thing hash gets passed to @thing.attributes
                data: {
                    id: item_id,
                    position_position: position
                }
            });
        }
    });

    //Auto-completing sections of the movies form based on selected inputs
    $('#movie_movie_type').on("change", function() {
        $('#movie_language_tracks_input').find('input').prop('checked', false);
        var movieType = $(this).val();
        switch(movieType) {
            case "Hollywood Movie" :
                $('#movie_foreign_language_title').val("");
                $('#movie_foreign_language_title').prop('disabled', true);
                $('#movie_language_tracks_eng').prop('checked', true);
                break;
            case "Cantonese Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_zho').prop('checked', true);
                break;
            case "Arabic Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_ara').prop('checked', true);
                break;
            case "Danish Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_dan').prop('checked', true);
                break;
            case "Dutch Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_ndl').prop('checked', true);
                break;
            case "Finnish Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_fin').prop('checked', true);
                break;
            case "French Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_fra').prop('checked', true);
                break;
            case "German Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_deu').prop('checked', true);
                break;
            case "Greek Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_ell').prop('checked', true);
                break;
            case "Hebrew Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_heb').prop('checked', true);
                break;
            case "Hindi Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_hin').prop('checked', true);
                break;
            case "Indonesian Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_ind').prop('checked', true);
                break;
            case "Italian Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_ita').prop('checked', true);
                break;
            case "Japanese Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_jpn').prop('checked', true);
                break;
            case "Korean Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_kor').prop('checked', true);
                break;
            case "Malay Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_msa').prop('checked', true);
                break;
            case "Mandarin Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_zho').prop('checked', true);
                break;
            case "Norwegian Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_nor').prop('checked', true);
                break;
            case "Persian Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_fas').prop('checked', true);
                break;
            case "Portuguese Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_por').prop('checked', true);
                break;
            case "Russian Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_ru').prop('checked', true);
                break;
            case "Spanish Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_spa').prop('checked', true);
                break;
            case "Swedish Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_swe').prop('checked', true);
                break;
            case "Thai Movie" :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_tha').prop('checked', true);
                break;
            default :
                $('#movie_foreign_language_title').prop('disabled', false);
                $('#movie_language_tracks_eng').prop('checked', false);
                break;
        }
    });

    $('#movie_screener_remarks_other').on("change", function() {
        if($(this).prop('checked')) {
            $('#movie_screener_remarks_other_input').find('input').prop('disabled', false);
        } else {
            $('#movie_screener_remarks_other_input').find('input').prop('disabled', true);
        }
    });

    $('#movie_airline_rights').on("change", function() {
        var airlineRights = $(this).val();
        switch(airlineRights) {
            case "North America" :
                $('#movie_airline_countries').prop('disabled', true);
                break;
            case "Worldwide" :
                $('#movie_airline_countries').prop('disabled', true);
                break;
            default :
                $('#movie_airline_countries').prop('disabled', false);
                break;
        }
    });

    // Remote pagination links for UI Dialog forms
    $('.ui-dialog .pagination a').live('click', function () {
        $.rails.handleRemote($(this));
        return false;
    });

    // Show and hide "working" spinner
    $(".spinner-trigger[data-remote='true']")
        .live("ajax:beforeSend",  function() {
            $('#spinner').removeClass('transparent');
            console.log("on");
        })
        .live("ajax:ajaxComplete", function() {
            $('#spinner').addClass('transparent');
            console.log("off");
        })
    
    $('input[type="file"]').attr("size", 6);

});
