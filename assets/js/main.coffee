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
getActiveCardIndex = (cards) ->
	lost = true
	i = -1
	while lost
		i++
		lost = cards.children().eq(i).hasClass "inactive"
	return i
scrollToCard = (target_card) ->
	section_width = target_card.closest("section").width()
	cards = target_card.closest(".cards").children()
	transform_change = target_card.position().left
	#scroll backward up to one section_width
	if transform_change < 0
		card_index = target_card.index()
		remainder = section_width - cards.eq(card_index).width() + 16
		while remainder > 0
			transform_change = cards.eq(Math.max(0, card_index)).position().left
			card_index--
			remainder -= (cards.eq(card_index).width() + 16)
	#apply left gutter to phones
	is_phone = $(window).width() < 768
	needs_gutter = cards.first().position().left - transform_change < 0
	transform_change -= 16 if is_phone and needs_gutter
	#remove empty space at the end
	if transform_change > 0
		last_element = cards.last()
		offset = last_element.position().left - transform_change + 1
		while offset < section_width - last_element.width()
			transform_change--
			offset++
	#put a rest to the right gutter shenanigans
	if is_phone and offset < cards.last().width()
		transform_change += 32
	#determine translation
	current_transform = parseInt target_card.css('transform').split(',')[4]
	current_transform = current_transform or 0
	new_translate = current_transform - transform_change
	#apply translation
	target_card.siblings().andSelf().each ->
		$(this)
			.css "transform", "translateX(" + new_translate + "px)"
			.on "transitionend", ->
				setInactiveCards()
				$(this).off "transitionend", false
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
	$("body").on "swipeleft", ".cards", ->
		cards = $(this)
		target_card = cards.children().eq getActiveCardIndex(cards) + 1
		scrollToCard(target_card)
	$("body").on "swiperight", ".cards", ->
		cards = $(this)
		target_card = cards.children().eq Math.max getActiveCardIndex(cards) - 1, 0
		scrollToCard(target_card)
	$("body").on "click", ".cards .inactive", ->
		scrollToCard($(this))


	colors = ["#e01a4f", "#f15946", "#f9c22e", "#53b3cb"]
	setInterval styleParty, 1000, "#tagline", "color", colors
