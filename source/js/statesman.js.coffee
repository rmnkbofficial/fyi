###
requires jquery
###
config =
  html_dir: 'html'
  container: $("body")
generatePath = (root, target) ->
  return [config.html_dir, root, target].join "/"
getFrames = ->
  frames = []
  $("[data-link-root]:not([data-link-target])").each ->
    frames.push this.attr "data-link-root"
  return frames
loadFromPath = (root, target) ->
  config.container.addClass "loading"
  $.get generatePath(root, target), (content) ->
    frames = getFrames()
    frames.each ->
      this.addClass "hidden"
    frames[root]
      .html content
      .removeClass "hidden"
    config.container.removeClass "loading"
$(document).ready ->
  $(OPENBTN).on "click", ->
    root = this.attr "data-link-root"
    target = this.attr "data-link-target"
    loadFromPath root, target
  $(CLOSEBTN).on "click", ->
    # add .hidden to all nodes with a root AND no target
