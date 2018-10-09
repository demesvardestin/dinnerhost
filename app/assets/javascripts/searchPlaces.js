function initMap(store=null, lat=null, lng=null) {
  if (store) {
    var map = new google.maps.Map(document.getElementById('storeMap'), {
        center: {lat: -lat, lng: -lng},
        zoom: 13
    });
  } else {
    var input = document.getElementById('store-search');
    var map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: -33.8688, lng: 151.2195},
        zoom: 13
    });
    var autocomplete = new google.maps.places.Autocomplete(input);

    var infowindow = new google.maps.InfoWindow();
    var infowindowContent = document.getElementById('infowindow-content');
    infowindow.setContent(infowindowContent);
    // var marker = new google.maps.Marker({
    //     map: map,
    //     anchorPoint: new google.maps.Point(0, -29)
    // });

    autocomplete.addListener('place_changed', function() {
      infowindow.close();
      var place = autocomplete.getPlace();
      if (!place.geometry) {
        // User entered the name of a Place that was not suggested and
        // pressed the Enter key, or the Place Details request failed.
        window.alert("Place not available");
        return;
      }

      var address = '';
      if (place.address_components) {
        address = [
          (place.address_components[0] && place.address_components[0].short_name || ''),
          (place.address_components[1] && place.address_components[1].short_name || ''),
          (place.address_components[2] && place.address_components[2].short_name || '')
        ].join(' ');
        window.location.replace("/search?q=" + encodeURI(address));
      }
    });
  }
}

$('.pac-item').on('click', e => {
  var searchValue = document.getElementById('store-search').value;
  document.getElementById("navigatorBtn").href = "/search?q=" + encodeURI(searchValue);
  $('#navigatorBtn').click();
  // window.location.replace("/search?q=" + encodeURI(searchValue));
})