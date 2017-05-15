###
requires jquery, widowfix, autosize, and emailjs
###
setInactiveCards = ->
	$(".cards li").each ->
		left_edge_position = $(this).position().left + $(this).width()
		if left_edge_position >= $(this).closest("section").width() or $(this).position().left < 0
			$(this).addClass "inactive"
		else
			$(this).removeClass "inactive"
openDialog = (target) ->
	$("article").load "pages/" + target + ".html", ->
		$("article").css "display", ""
		callback = ->
			$("article")
				.removeClass "inactive"
				.on "transitionend", ->
					setInactiveCards()
		setTimeout callback, 50
		$("article p").widowFix()
styleParty = (selector, rule, values) ->
	index = Math.floor(Math.random() * values.length)
	$(selector).css(rule, values[index])
$(document).ready ->
	$.ajax { headers: { "Cache-Control": "max-age=0" } }
	$("p").widowFix()
	#load state from url
	hash = window.location.hash
	if hash
		target = hash.split("#")[1]
		if target.split("-")[0] == "page"
			page_index = $(".pager .page").index($("[href='#" + target + "']"))
			#set tab states
			$(".pager .page:not(.inactive)").addClass "inactive"
			$(".pager .page").eq(page_index).removeClass "inactive"
			#set section states
			$("body > main").children("section:not('.inactive')")
				.addClass "inactive"
				.siblings().andSelf().eq(page_index).removeClass "inactive"
			setInactiveCards()
		else openDialog target
	setInactiveCards()
	#ALRIGHT SHOWTIME
	#open dialog
	$("body > main").on "click", ".button", ->
		target = $(this).attr("href").split("#")[1]
		openDialog target
	$("#button-contact").on "click", ->
		openDialog "contact"
	#close dialog
	$("article").on "click", "#button-close", ->
		$("article").addClass "inactive"
		$("body").on "transitionend", "article", ->
			$("article").css "display", "none"
			$("body").off "transitionend", "article"
			callback = -> history.pushState null, null, "#"
			setTimeout callback, 50
	#switch pages
	$(".pager").on "click", ".inactive", ->
		#set tab states
		$(".pager .page:not(.inactive)").addClass "inactive"
		$(this).removeClass "inactive"
		#set section states
		page_index = $(".pager .page").index $(this)
		$("body > main").children "section:not('.inactive')"
			.addClass "inactive"
			.siblings().andSelf().eq(page_index).removeClass "inactive"
		setInactiveCards()
	#switch tabs
	$("body").on "click", ".tabs .inactive", ->
		$(this)
			.removeClass "inactive"
			.siblings().addClass "inactive"
		tab_index = $(this).index()
		$(this)
			.closest("section").children(".cards").eq(tab_index).removeClass "inactive"
			.siblings(".cards").addClass "inactive"
	#scroll cards oh god i'm so sorry about this
	$("body").on "click", ".cards .inactive", ->
		section_width = $(this).closest("section").width()
		cards = $(this).closest(".cards").children()
		target_index = $(this).index()
		transform_change = $(this).position().left
		#scroll backward up to one section_width
		if transform_change < 0
			iterations = 1
			card_index = target_index - iterations
			cards_width_remainder = section_width - cards.eq(card_index).width() + 16
			while cards_width_remainder > 0
				transform_change = cards.eq(Math.max(0, card_index)).position().left
				iterations++
				card_index = target_index - iterations
				cards_width_remainder -= (cards.eq(card_index).width() + 16)
		#apply left gutter to phones
		needs_gutter = cards.first().position().left - transform_change < 0
		transform_change -= 16 if $(window).width() < 768 and needs_gutter
		#remove empty space at the end
		if transform_change > 0
			last_element = cards.last()
			offset = last_element.position().left - transform_change
			while offset + 1 < $(this).closest("section").width() - last_element.width()
				transform_change--
				offset++
		#put a rest to the right gutter shenanigans
		if window.innerWidth < 768 and offset < section_width - cards.last().width()
			transform_change += 32
		#determine translation
		current_transform = parseInt $(this).css('transform').split(',')[4]
		current_transform = current_transform or 0
		new_translate = current_transform - transform_change
		#apply translation
		$(this).siblings().andSelf().each ->
			$(this)
				.css "transform", "translateX(" + new_translate + "px)"
				.on "transitionend", ->
					setInactiveCards()
					$(this).off "transitionend", false
	colors = ["#e01a4f", "#f15946", "#f9c22e", "#53b3cb"]
	setInterval styleParty, 1000, "#tagline", "color", colors
