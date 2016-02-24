var elixir = require('laravel-elixir');
var del = require('del');
/*
 |--------------------------------------------------------------------------
 | Elixir Asset Management
 |--------------------------------------------------------------------------
 |
 | Elixir provides a clean, fluent API for defining some basic Gulp tasks
 | for your Laravel application. By default, we are compiling the Sass
 | file for our application, as well as publishing vendor resources.
 |
 */

elixir(function (mix) {
    return del([
        'public/css/',
        'public/fonts/',
        'public/images/'
    ]);
});

elixir(function (mix) {
    //fontawesome
    mix.copy('node_modules/font-awesome/css/font-awesome.css', 'public/css/font-awesome.css');
    mix.copy('node_modules/font-awesome/fonts/', 'public/fonts/');

    mix.copy('node_modules/simple-line-icons-webfont/simple-line-icons.css', 'public/css/simple-line-icons.css');
    mix.copy('node_modules/simple-line-icons-webfont/fonts/', 'public/fonts/');

    mix.copy('node_modules/bootstrap/dist/css/bootstrap.css', 'public/css/bootstrap.css');
    mix.copy('node_modules/bootstrap/dist/fonts/', 'public/fonts/');

    mix.copy('node_modules/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.css', 'public/css/bootstrap-switch.css');

    mix.copy('resources/assets/uniformjs/uniform.default.css', 'public/css/uniform.default.css');
    mix.copy('resources/assets/uniformjs/images/', 'public/images/');

    mix.copy('node_modules/daterangepicker/daterangepicker-bs3.css', 'public/css/daterangepicker.css');

    mix.copy('node_modules/morris.js/morris.css', 'public/css/morris.css');

    mix.copy('node_modules/fullcalendar/dist/fullcalendar.css', 'public/css/fullcalendar.css');

    mix.copy('node_modules/jqvmap/jqvmap/jqvmap.css', 'public/css/jqvmap.css');

});


elixir(function (mix) {
    mix.sass('app.scss');
});
