//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require Chart.bundle
//= require chartkick
//= require bootstrap-wysihtml5
//= require social-share-button
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