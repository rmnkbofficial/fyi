###
requires jquery
###
config =
  html_dir: 'html'
  container: $("body")
generatePath = (root, target) ->
  return [config.html_dir, root, target].join "/"
loadFromPath = (root, target) ->
  config.container.addClass "loading"
  $.get generatePath(root, target), (content) ->
    $("[data-link-root]:not([data-link-target])")
      .each -> this.addClass "hidden"
      .filter "[data-link-root=" + root + "]"
      .on "transitionend", ->
        config.container.removeClass "loading"
        this
          .html content
          .removeClass "hidden"
          .off "transitionend", false
$(document).ready ->
  $("[data-link-root][data-link-target]").on "click", ->
    root = this.attr "data-link-root"
    target = this.attr "data-link-target"
    loadFromPath root, target
  $("[data-io-role='close']").on "click", ->
    # add .hidden to all nodes with a root AND no target
