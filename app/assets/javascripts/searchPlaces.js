// function initMap() {
//   var input = document.getElementById('banner-request-location');
//   var map = new google.maps.Map(document.getElementById('map'), {
//       center: {lat: -33.8688, lng: 151.2195},
//       zoom: 13
//   });
//   var autocomplete = new google.maps.places.Autocomplete(input);

//   var infowindow = new google.maps.InfoWindow();
//   var infowindowContent = document.getElementById('infowindow-content');
//   infowindow.setContent(infowindowContent);
//   // var marker = new google.maps.Marker({
//   //     map: map,
//   //     anchorPoint: new google.maps.Point(0, -29)
//   // });
//   console.log(autocomplete.getPlace().address_components);
//   autocomplete.addListener('place_changed', function() {
//     infowindow.close();
//     var place = autocomplete.getPlace();
//     // if (!place.geometry) {
//     //   // User entered the name of a Place that was not suggested and
//     //   // pressed the Enter key, or the Place Details request failed.
//     //   window.alert("Place not available");
//     //   return;
//     // }

//     var address = '';
//     if (place.address_components) {
//       address = [
//         (place.address_components[0] && place.address_components[0].short_name || ''),
//         (place.address_components[1] && place.address_components[1].short_name || ''),
//         (place.address_components[2] && place.address_components[2].short_name || '')
//       ].join(' ');
//       // window.location.replace("/search?q=" + encodeURI(address));
//     }
//   });
// }