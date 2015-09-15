js_target='client/js/lib'
css_target='client/css/lib'
bower='bower_components'

ln -F -f bower_components/mapbox.js/mapbox.js src/js/lib/mapbox.js
ln -F -f bower_components/mapbox.js/mapbox.css src/css/lib/mapbox.css
ln -F -f bower_components/mapbox.js/images src/css/lib/images

ln -F -f bower_components/jquery/dist/jquery.js src/js/lib/jquery.js

ln -F -f bower_components/fontawesome/css/font-awesome.css src/css/lib/fontawesome.css
ln -F -f bower_components/fontawesome/fonts src/fonts

ln -F -f bower_components/bootstrap/dist/css/bootstrap.min.css src/css/lib/bootstrap.min.css
ln -F -f bower_components/bootstrap/dist/js/bootstrap.min.js src/js/lib/bootstrap.min.js

ln -F -f bower_components/jasny-bootstrap/dist/css/jasny-bootstrap.min.css src/css/lib/jasny-bootstrap.min.css
ln -F -f bower_components/jasny-bootstrap/dist/js/jasny-bootstrap.min.js src/js/lib/jasny-bootstrap.min.js