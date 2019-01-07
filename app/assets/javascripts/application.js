//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require turbolinks
//= require Chart.bundle
//= require chartkick
//= require bootstrap-wysihtml5
//= require social-share-button
//= require bootstrap-datepicker
//= require_tree .


toastr.options = {
    "debug": false,
    "newestOnTop": true,
    "progressBar": true,
    "positionClass": "toast-top-right",
    "preventDuplicates": false,
    "showDuration": "5000",
    "hideDuration": "1000",
    "timeOut": "1000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
};

function initMap() {
    var input = document.getElementById('banner-request-location');
    if (!input) {
        var input = document.getElementById('request-location');
    }
    var map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: -33.8688, lng: 151.2195},
        zoom: 13
    });
    var autocomplete = new google.maps.places.Autocomplete(input);

    var infowindow = new google.maps.InfoWindow();
    var infowindowContent = document.getElementById('infowindow-content');
    infowindow.setContent(infowindowContent);

    autocomplete.addListener('place_changed', function() {
        infowindow.close();
        var place = autocomplete.getPlace();
        var address = '';
        if (place.address_components) {
            address = [
              (place.address_components[0] && place.address_components[0].short_name || ''),
              (place.address_components[1] && place.address_components[1].short_name || ''),
              (place.address_components[2] && place.address_components[2].short_name || ''),
              (place.address_components[5] && place.address_components[5].short_name || '')
            ].join(', ');
            window.location.replace("/search?request_location=" + encodeURI(address));
        }
    });
}

$('.pac-item').on('click', e => {
  var searchValue = document.getElementById('banner-request-location').value;
  window.location.href = "/search?request_location=" + encodeURI(searchValue);
});

function loading(element) {
    $('#' + element.id)
    .css('opacity', '0.7')
    .prepend(`
        <div class="text-center" style="margin-top: 25%; z-index: 1049 !important;">
            <span>
                <i class="fa fa-spinner fa-pulse fa-3x fa-fw theme-blue"
                    style="font-size: 20px;">
                </i>
            </span>
        </div>
    `);
}

function fadeModal(modal) {
    $('.modal-backdrop').remove();
    $('#' + modal).remove();
    document.querySelector('#body').classList.remove('modal-open');
    $('.footer').remove();
}

function updateReservationParams() {
    var reservationID = $('#reservation-id').text();
    try {
        var requestDate = document.querySelector('.start-date-input').value;
        var requestTime = $('#chosen-time').text();
        var adultCount = $('.adult-count').text();
        var childrenCount = $('.children-count').text();
        var reportType = document.querySelector('#report-type');
        var reportTypeValue = reportType ? reportType.value : "";
        var mealIDS = $('.meal-ids').text();
        var allergies = document
                        .querySelector('#allergies')
                        .value.replace(/\s/g,'');
        var bookingBtn = document.querySelector('#booking-btn');
        
        var $requestDate = document.querySelector('#request-date');
        var $requestTime = document.querySelector('#request-time');
        var $adultCount = document.querySelector('#adult-count');
        var $childrenCount = document.querySelector('#children-count');
        var $customerAllergies = document.querySelector('#customer-allergies');
        var $mealIDS = document.querySelector('#meal-ids');
        
        $requestDate.value = requestDate;
        $requestTime.value = requestTime;
        $adultCount.value = adultCount;
        $childrenCount.value = childrenCount;
        $customerAllergies.value = allergies;
        $mealIDS.value = mealIDS;
        
        if ($mealIDS.value && $requestDate.value) {
            bookingBtn.removeAttribute('disabled');
        }
        
        history
        .replaceState(null, '', "?meal_ids=" + mealIDS + "&request_date=" + requestDate +
                "&request_time=" + requestTime + "&adult_count=" + adultCount +
                "&children_count=" + childrenCount + "&allergies=" + allergies +
                (reportTypeValue ? "&customer_report=" + reportTypeValue : ""));
        var reservation = {
            "id": reservationID,
            "meal_ids": mealIDS,
            "request_date": requestDate,
            "request_time": requestTime,
            "adult_count": adultCount,
            "children_count": childrenCount,
            "allergies": allergies
        };
        $.get('/update_reservation', { reservation: reservation });
    } catch(err) {
        showNotice("Login or Signup to make a reservation");
    }
}

function selectReportCategory(elem) {
    $('.selection').html('<i class="fa fa-circle-thin text-muted"></i>');
    var id = elem.id;
    $('.selection-' + id).html('<i class="fa fa-circle theme-cyan"></i>');
    
    var reportType = document.querySelector('#report-type');
    var reportTypeValue = $('#category-value-' + id).text();
    reportType.value = reportTypeValue;
    document.querySelector('.step-1-btn').removeAttribute('disabled');
    
    // updateReservationParams();
}

function cookReportHeader(step, reportType=null) {
    switch(step) {
        case "intro":
            return "Why are you reporting this chef?";
        default:
            switch(reportType.toLowerCase()) {
                case "this is not a real cook":
                    return "Why do you think this user isn't real?";
                case "this chef has fradulent listings":
                    return "Please provide links to the fraudulent listings";
                case "this chef has offensive listings":
                    return "Please provide links to the offensive listings";
                default:
                    return "Please provide more details for your report";
            }
    }
}

function reportingStepOne() {
    $('.report-type-div').show();
    $('.cook-report-form').hide();
    
    var header = cookReportHeader("intro");
    
    $('.modal-body-header-headline').html(header);
    $('.modal-body-subheader').show();
}

function reportingStepTwo() {
    $('.report-type-div').hide();
    $('.cook-report-form').show();
    
    var customerReport = document.querySelector('#report-type').value;
    
    var header = cookReportHeader("step-2", customerReport);
    
    $('.modal-body-header-headline').html(header);
    $('.modal-body-subheader').hide();
}

function searchReviews(elem) {
    var mealID = $('#meal-id').text();
    var value = document.querySelector('#meal-review-search').value;
    $.get('/search_meal_reviews', { search: value, meal_id: mealID });
}

function browseReviews(page) {
    console.log(page);
    var mealID = $('#meal-id').text();
    
    $.get('/browse_reviews', { page: page, meal_id: mealID });
}

function hideSearchBox() {
    $('#search-box').hide();
    $('#request-location').css('width', '300px');
}

function setCuisine() {
    document.querySelector('#meal-type').value = document.querySelector('#cuisine').value;
}


function setMealType(elem) {
    var id = elem.id;
    
    var cat = $('#' + id).text();
    document.querySelector('#meal-type').value = cat;
    document.querySelector('#cuisine').value = cat;
    
    // submitSearchForm();
}

function submitSearchForm() {
    var location = document.querySelector('#request-location').value;
    
    if (location) {
        document.querySelector('#main-search-form').submit();
    } else {
        toastr.warning('Set your current location')
    }
}

function setID() {
    $('#official-id-field').html(`
        <div class="input-group mb-3" style="margin-bottom: 0 !important;">
            <div class="input-group-prepend cursor-pointer"
                onclick="cancelOfficialId(this)">
                <span class="input-group-text">
                    <i class="fa fa-times-circle"></i>
                </span>
            </div>
            <input class="form-control no-box-shadow" placeholder="ID" onchange="fillIDField(this)"
                id="id-setter" style="border-top-left-radius: 0 !important;
                                    border-bottom-left-radius: 0 !important;">
        </div>
    `);
}

function cancelOfficialId() {
    $('#official-id-field').html(`
        <button class="btn btn-primary" onclick="setID(this)">
            Provide ID
        </button>
    `);
}

function fillIDField(elem) {
    document
    .querySelector('#government-id')
    .value = document.querySelector('#' + elem.id).value;
}

function showNotice(notice) {
    toastr.success(notice);
}

function showFiltersBox() {
    $('.filters-box').show();
}

function setNewUrl() {
    var filterParams = {};
    var filters = document.getElementsByClassName('filter');
    var tags = document.querySelector('#filter-by-tags').value;
    var cuisine = document.querySelector('#filter-by-meal-type').value;
    
    for (idx = 0; idx < filters.length; idx++) {
        var i = filters[idx];
        var param = i.id.split('_')[0];
        var value = i.id.split('_')[1];
        
        if ($('#' + i.id).html().trim().includes('<i class="fa fa-circle theme-cyan"></i> ')) {
            if (Object.keys(filterParams).includes(param)) {
                filterParams[param] = filterParams[param] + "," + value
            } else {
                filterParams[param] = value;
            }
        }
        
        if (tags) {
            filterParams["tags"] = tags.replace(/ /g, '');
        }
        
        if (cuisine) {
            var mealType = cuisine.replace(/ /g, '');
        } else {
            var mealType = '';
        }
    }
    
    var urlString = window.location.href;
    var url = new URL(urlString);
    // var mealType = url.searchParams.get("meal_type");
    var requestLocation = url.searchParams.get("request_location");
    
    var urlParams = "meal_type=" + mealType + "&request_location=" +
                    requestLocation + "&filters=" + JSON.stringify(filterParams);
    
    history
    .replaceState(null, '', "?" + urlParams);
    
    return urlParams;
}

function applyFilters(elem) {
    var btn = document.querySelector("#" + elem.id);
    btn.setAttribute('disabled', 'true');
    btn.innerHTML = 'filtering...';
    
    var urlString = window.location.href;
    var url = new URL(urlString);
    var mealType = url.searchParams.get("meal_type");
    var requestLoc = url.searchParams.get("request_location");
    var filters = url.searchParams.get("filters");
    
    var data = {
        "meal_type": mealType,
        "request_location": requestLoc,
        "filters": filters
    };
    
    $.get('/filter_dishes', { data: data });
}

function clearFilters(elem) {
    var btn = document.querySelector("#" + elem.id);
    btn.setAttribute('disabled', 'true');
    btn.innerHTML = 'clearing...';
    
    var urlString = window.location.href;
    var url = new URL(urlString);
    var mealType = url.searchParams.get("meal_type");
    var requestLoc = url.searchParams.get("request_location");
    var urlParams = "meal_type=" + '' + "&request_location=" + requestLoc;
    
    history
    .replaceState(null, '', "?" + urlParams);
    
    var data = {
        "meal_type": '',
        "request_location": requestLoc
    };
    
    $.get('/filter_dishes', { data: data });
}

function showStars(elem) {
    var id = elem.id.split('star-').join('');
    for (i = 0; i <= parseInt(id); i++) {
        $('#star-' + i.toString())
        .html(`<i class="fa fa-star theme-cyan"
            style="font-size: 28px;"></i>`);
    }
    
    document.querySelector('#cook-rating-value').value = parseInt(id);
    
    $('.cook-rating-form').show();
    $('.diner-rating-form').show();
}

function cancelRating() {
    $('.cook-rating-form').hide();
    
    $('.unrated-star')
    .html(`<i class="fa fa-star-o theme-cyan"
                    style="font-size: 28px;"></i>`);
}

function resetHistory() {
    history
    .replaceState(null, '', "?" + '');
}

function displayTimes() {
    $('#times').show();
}

function hideTimes() {
    $('#times').hide();
}

function chooseTime(elem) {
    var hour = elem.id.split("-")[1];
    $('#chosen-time').text(hour);
    updateReservationParams();
    
    hideTimes();
}

function saveListing(elem,id) {
    $('#save-listing').html("saving...");
    $.get('/save_listing/'+id);
}

function copyListingLink(elem) {
    var link = document.querySelector("#meal-link");
    link.select();
    document.execCommand("copy");
    $("#"+elem.id).html('Copied!');
}

function resetLink(elem) {
    $("#"+elem.id)
    .html('<i class="fa fa-file-text-o theme-blue" style="margin-right: 5px;"></i>Copy');
}

function adjustPacContainerWidth() {
    var pac = document.querySelector('.pac-container');
    if (window.innerWidth > 1024) {
        if (!pac.classList.contains('width-over-1024')) {
            pac.classList.add('width-over-1024');
        }
    }
}