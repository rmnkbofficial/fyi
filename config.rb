require 'slim'
require 'coffee-script'

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

set :layout, false
page "/html/project/*", :layout => "project"

set :js_dir, 'js'
set :css_dir, 'css'
set :images_dir, 'img'

configure :development do
   activate :livereload, livereload_css_target: 'css/main.css'
end

configure :build do
  activate :minify_css
  activate :minify_javascript
end
