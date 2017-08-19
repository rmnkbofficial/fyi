###
requires jquery
###

###
qs by BrunoLM
https://stackoverflow.com/a/3855394/2467656
###
qs = ((a) ->
  return {} if a == ''
  b = {}
  for i in a
    p = i.split '=', 2
    if p.length == 1
      b[p[0]] = ''
    else
      b[p[0]] = decodeURIComponent p[1].replace(/\+/g, ' ')
  b
)(window.location.search.substr(1).split('&'))

###
statesman by imogen
###
config =
  base_url: "https://imogen.fyi/"
  html_dir: "html"
  home:
    root: "page"
    target: "about"
  container: $("body")
generateSlug = (key, value) ->
  return "/?" + key + "=" + value
generatePath = (root, target) ->
  return [config.html_dir, root, target].join("/") + ".html"
renderState = (root, target, apply_state = false) ->
  container = config.container
  container.addClass "loading"
  $.get generatePath(root, target), (content) ->
    $("[data-link-root]:not([data-link-target])")
      .each -> this.addClass "hidden"
      .filter "[data-link-root=" + root + "]"
      .on "transitionend", ->
        container.removeClass "loading"
        this
          .html content
          .removeClass "hidden"
          .off "transitionend", false
renderStateFromURL = ->
  root = false
  target = false
  $("[data-link-root]:not([data-link-target])").each ->
    root = $(this).attr "data-link-root"
    return true unless root
    target = qs[root]
    return false if target
  renderState(root, target) if target
initializeStateFromURL = ->
  renderStateFromURL()
  home = config.home
  selector = "[data-link-root=" + home.root + "]:not([data-link-target])"
  $(selector).load generatePath home.root, home.target
applyState = (root, target) ->
  renderState(root, target)
  home = config.home
  if root == home.root and target == home.target
    clearState()
  else
    renderState(root, target)
    history.pushState null, null, generateSlug()
clearState = ->
  $("[data-link-root]:not([data-link-target])").addClass "hidden"
  history.pushState null, null, "/"
$(document).ready ->
  initializeStateFromURL()
  $(window).on "popstate", ->
    renderStateFromURL()
  $("[data-link-root][data-link-target]") .on "click", ->
    root = this.attr "data-link-root"
    target = this.attr "data-link-target"
    applyState root, target
  $("[data-io-role='close']").on "click", ->
    clearState()
