# fyi
this is my website.
<br>u can fork it, swap out the content & emailjs keys, and use it as yours.
#### neat things:
- it's static & s3-friendly
- it's served as a single-page app
- it's easy to update
## how to build
i used [hammer](http://hammerformac.com) to build, but it's easy to do it yourself:
1. prepare the slim templates:
	- for `<-- @path ... -->` and `<-- @javascript ... -->`, insert relative paths
		- make sure u use `.coffee` instead of `.js`!
	- for `<-- @include ... -->`, insert the corresponding code from `partials/`
2. compile `.slim`, `.scss`, and `.coffee` to `.html`, `.css`, and `.js`
3. copy everything to your 'build' directory, excluding 'partials/' and your original `.slim`, `.scss`, and `.coffee` files
## to-dos
#### 2.x
1. support body links to `#page-*` without reload
2. explore defining image cards as partials with slim variables as parameters
3. rewrite the card scrolling logic and separate it from main.coffee
4. replace my hash-based pagination with url params. this'll make it possible to easily track the pages as separate views in google analytics
5. finish populating icons and social/search graph data
#### 3.0
1. convert this to a [phoenix](https://github.com/phoenixframework/phoenix) app that optionally deploys to to s3. this lets you use the site in one of two ways:
	- run the server locally whenever you want to update content or deploy to s3
	- deploy the server to heroku or elsewhere to run 24/7
		- this'll enable some goodies like better email handling and integrations with slack, ifttt, or asana
2. support gzipping in the asset pipeline
3. add a generator for icons and social/search graph data
