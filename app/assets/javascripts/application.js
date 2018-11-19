//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require Chart.bundle
//= require chartkick
//= require bootstrap-wysihtml5
//= require social-share-button
//= require bootstrap-datepicker
//= require_tree .

$(function () {
    $(document).scroll(function () {
      var $nav = $(".fixed-top");
      $nav.toggleClass('scrolled', $(this).scrollTop() > $nav.height());
    });
});

toastr.options = {
    "debug": false,
    "newestOnTop": true,
    "progressBar": true,
    "positionClass": "toast-top-right",
    "preventDuplicates": false,
    "showDuration": "1000",
    "hideDuration": "1000",
    "timeOut": "1000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
};

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
    var startDate = document.querySelector('.start-date-input').value;
    var endDate = document.querySelector('.end-date-input').value;
    var adultCount = $('.adult-count').text();
    var childrenCount = $('.children-count').text();
    var reportTypeValue = document.querySelector('#report-type').value;
    
    document.querySelector('#start-date').value = startDate;
    document.querySelector('#end-date').value = endDate;
    document.querySelector('#adult-count').value = adultCount;
    document.querySelector('#children-count').value = childrenCount;
    document.querySelector('#meal-id').value = $('#meal-id').text();
    
    history
    .replaceState(null, '', "?start_date=" +
            startDate + "&end_date=" + endDate + "&adult_count=" +
            adultCount + "&children_count=" + childrenCount +
            (reportTypeValue ? "&customer_report=" + reportTypeValue : ""));
}

function selectReportCategory(elem) {
    $('.selection').html('<i class="fa fa-circle-thin text-muted"></i>');
    var id = elem.id;
    $('.selection-' + id).html('<i class="fa fa-circle theme-cyan"></i>');
    
    var reportType = document.querySelector('#report-type');
    var reportTypeValue = $('#category-value-' + id).text();
    reportType.value = reportTypeValue;
    document.querySelector('.step-1-btn').removeAttribute('disabled');
    
    updateReservationParams();
}

function mealReportHeader(step, reportType=null) {
    switch(step) {
        case "intro":
            return "Why are you reporting this listing?";
        default:
            switch(reportType.toLowerCase()) {
                case "it's a scam":
                    return "Why do you think this listing is a scam?";
                case "it's innacurate":
                    return "What makes this listing innacurate?";
                case "it's offensive":
                    return "What makes this listing offensive?";
                default:
                    return "Please provide more details for your report";
            }
    }
}

function reportingStepOne() {
    $('.report-type-div').show();
    $('.meal-report-form').hide();
    
    var header = mealReportHeader("intro");
    
    $('.modal-body-header-headline').html(header);
    $('.modal-body-subheader').show();
}

function reportingStepTwo() {
    $('.report-type-div').hide();
    $('.meal-report-form').show();
    
    var url = new URL(window.location.href);
    var customerReport = url.searchParams.get("customer_report");
    
    var header = mealReportHeader("step-2", customerReport);
    
    $('.modal-body-header-headline').html(header);
    $('.modal-body-subheader').hide();
}