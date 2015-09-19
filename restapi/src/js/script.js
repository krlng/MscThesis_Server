 $(function() {
   $.getScript("../config.js").done(
     function(s, status) {
       console.log(config.machine_ip, s, status);

       L.mapbox.accessToken = 'pk.eyJ1IjoibmlrZm0iLCJhIjoiNjgwN2EzYjE5M2MzNjViMWNiMGNhZmI0ODYwZDNmMWUifQ.JowtfSyYik14skkdhKf18w';

       // General Functions
       // Get Timestamp format

       Date.prototype.yyyymmdd = function() {
         var yyyy = this.getFullYear().toString();
         var mm = (this.getMonth() + 1).toString(); // getMonth() is zero-based
         var dd = this.getDate().toString();
         var hh = this.getHours().toString();
         var min = this.getMinutes().toString();
         return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-' + (dd[1] ? dd : "0" + dd[0]) + ' ' + (hh[1] ? hh : "0" + hh[0]) + ':' + (min[1] ? min : "0" + min[0]); // padding
       };


       var geocoder = L.mapbox.geocoder('mapbox.places'),
         map = L.mapbox.map('map', 'examples.map-h67hf2ic', {
           zoomControl: false
         });
       new L.Control.Zoom({
         position: 'topright'
       }).addTo(map);


       if (!navigator.geolocation) {
         alert('Geolocation is not available');
       } else {
         map.locate();
       }

       map.on('locationfound', function(e) {
         map.fitBounds(e.bounds);

         var marker = L.marker(new L.LatLng(e.latlng.lat, e.latlng.lng), {
           icon: L.mapbox.marker.icon({
             'marker-color': 'ff8888'
           }),
           draggable: true
         }).on('dragend', function(e) {
           $('#form_lat').val(e.target._latlng.lat);
           $('#form_lng').val(e.target._latlng.lng);
         });
         marker.bindPopup('This marker is draggable! Position it to enter geolocations.');
         marker.addTo(map);
       });

       // If the user chooses not to allow their location
       // to be shared, display an error message.
       map.on('locationerror', function() {
         console.warn('Fehler beim Laden >> Keine Internetverbindung?')
         var marker = L.marker(new L.LatLng(49, 8.37), {
           icon: L.mapbox.marker.icon({
             'marker-color': 'ff8888'
           }),
           draggable: true
         });
         marker.bindPopup('This marker is draggable! Move it around.');
         marker.addTo(map);
       });

       $('#resetValues').on('click', function(e) {
         e.preventDefault();
         document.getElementById("generateData").reset();
       });

       $('#randomizeValues').on('click', function(e) {
         e.preventDefault();
         $('#generateData input').filter(function() {
           return $(this).val() === '';
         }).each(function() {
           var name = $(this).attr('name');
           switch (name) {
             case 'lat':
               $(this).val(Math.random() * 2 + 48);
               break;
             case 'date':
               $(this).val();
               break;
             case 'time':
               $(this).val();
               break;
             case 'lng':
               $(this).val(Math.random(1) + 8);
               break;
             case 'speed':
               $(this).val(Math.random() * 130);
               break;
             case 'height':
               $(this).val(Math.random() * 500);
               break;
             default:
               $(this).val(Math.random() * 10 - 5);
           }
         });
       });

       $.fn.serializeObject = function() {
         var o = {};
         var a = this.serializeArray();
         $.each(a, function() {
           if (o[this.name] !== undefined) {
             if (!o[this.name].push) {
               o[this.name] = [o[this.name]];
             }
             o[this.name].push(this.value || '');
           } else {
             o[this.name] = this.value || '';
           }
         });
         return o;
       };

       $('#saveValues').on('click', function(e) {
         e.preventDefault();
         var o = $('#generateData').serializeObject();

         o.timestamp = new Date(o.date + ' ' + o.time.toString());
         if (isNaN(o.timestamp.getTime())) { // d.valueOf() could also work
           o.timestamp = new Date();
         }
         delete o.time;
         delete o.date;
         o.timestamp = o.timestamp.yyyymmdd();
         o.position_type = 0;
         o.interpolated_point = 0;

         var DBConnection = $('#DBConnection').val();

         $.ajax({
             method: "POST",
             url: DBConnection,
             data: o,
             success: function(response) {
               console.log(response);
             },
             failure: function(response) {
               console.log(response);
             }
           })
           .done(function(msg) {
             alert("Data Saved: " + msg);
           });

       })
     }).fail(function(jqxhr, settings, exception) {
     console.warn("Something went wrong" + exception);
   });
 });