# fyi
this is my v3 website. u can fork it, swap out the content & emailjs keys, and use it as yours. too bad nothing works yet
#### overview
- static
- single-page
- follows the [app shell model](https://developers.google.com/web/fundamentals/architecture/app-shell) using jquery `.load()`
- built with [middleman](https://middlemanapp.com)
- [surge](https://surge.sh) recommended for hosting
## development
#### stack
- [middleman](https://middlemanapp.com) as our generator
- [slim](http://slim-lang.com) as our templating language
- [coffeescript](http://coffeescript.org) to make javascript less annoying
#### preview
1. `cd` to project
2. `bundle exec middleman`
3. open [localhost:4567](http://localhost:4567)
#### build
1. `cd` to project
2. `bundle exec middleman build`
## 3.x vs 2.x
- i ditched [hammer](https://hammerformac.com) for interoperability (also because the high sierra beta breaks it--i actually rly liked hammer, rip)
- new internal link control script
	- url params: `#key-value` becomes `?key=value`
	-	targets defined in data-attributes
	-	no reloads
- new card slider script
- visual refresh
