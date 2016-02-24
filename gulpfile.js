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
        'public/fonts/'
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

});


elixir(function (mix) {
    mix.sass('app.scss');
});
