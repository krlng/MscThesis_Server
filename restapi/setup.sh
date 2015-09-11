js_target='client/js/lib'
css_target='client/css/lib'
bower='bower_components'

ln -F -f bower_components/mapbox.js/mapbox.js client/js/lib/mapbox.js
ln -F -f bower_components/mapbox.js/mapbox.css client/css/lib/mapbox.css
ln -F -f bower_components/mapbox.js/images client/css/lib/images

ln -F -f bower_components/jquery/dist/jquery.js client/js/lib/jquery.js

ln -F -f bower_components/fontawesome/css/font-awesome.css client/css/lib/fontawesome.css
ln -F -f bower_components/fontawesome/fonts client/fonts

ln -F -f bower_components/bootstrap/dist/css/bootstrap.min.css client/css/lib/bootstrap.min.css
ln -F -f bower_components/bootstrap/dist/js/bootstrap.min.js client/js/lib/bootstrap.min.js

ln -F -f bower_components/jasny-bootstrap/dist/css/jasny-bootstrap.min.css client/css/lib/jasny-bootstrap.min.css
ln -F -f bower_components/jasny-bootstrap/dist/js/jasny-bootstrap.min.js client/js/lib/jasny-bootstrap.min.js