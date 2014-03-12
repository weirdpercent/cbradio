((window, document, undefined_) ->
  "use strict"
  addCommas = (nStr) ->
    nStr += ""
    x = nStr.split(".")
    x1 = x[0]
    x2 = (if x.length > 1 then "." + x[1] else "")
    rgx = /(\d+)(\d{3})/
    x1 = x1.replace(rgx, "$1" + "," + "$2")  while rgx.test(x1)
    x1 + x2

  buildSummary = (data) ->
    content = ""
    content += "<div id=\"coderbits-summary\">"
    content += "<div id=\"coderbits-avatar\">"
    content += "<a href=\"" + data.link + "\" target=\"_parent\">"
    content += "<img alt=\"" + data.name + "\" class=\"avatar\" src=\"https://secure.gravatar.com/avatar/" + data.gravatar_hash + "?d=https%3A%2F%2Fcoderbits.com%2Fimages%2Fgravatar.png&r=PG&s=48\">"
    content += "</a>"
    content += "</div>"
    content += "<div id=\"coderbits-overview\">"
    content += "<h1>"
    content += "<a href=\"" + data.link + "\" target=\"_parent\" title=\"" + data.name + "\">" + data.name + "</a>"
    content += "</h1>"
    content += "<p>"
    content += "<span>" + data.title + "</span>"
    content += "</p>"
    content += "</div>"
    content += "</div>"
    content

  buildSkills = (data) ->
    content = ""
    items = undefined
    content += "<div id=\"coderbits-skills\">"
    if data.top_skills.length > 0
      content += "<h2>Top Skills</h2>"
      items = data.top_skills
    else if data.top_interests.length > 0
      content += "<h2>Top Interests</h2>"
      items = data.top_interests
    else if data.top_traits.length > 0
      content += "<h2>Top Traits</h2>"
      items = data.top_traits
    else if data.top_areas.length > 0
      content += "<h2>Top Areas</h2>"
      items = data.top_areas
    else
      return ""
    content += "<p>"
    i = 0

    while i < items.length
      content += items[i].name
      content += ", "  if i < items.length - 1
      i++
    content += "</p>"
    content += "</div>"
    content

  buildStats = (data) ->
    total = 0
    i = 0

    while i < data.badges.length
      total++  if data.badges[i].earned
      i++
    content = ""
    content += "<div id=\"coderbits-stats\">"
    content += "<ul id=\"coderbits-stats-list\">"
    content += "<li>"
    content += "<p>"
    content += "<strong>" + addCommas(total) + "</strong>"
    content += "<span> badges</span>"
    content += "</p>"
    content += "<p>"
    content += "<strong>" + addCommas(data.follower_count) + "</strong>"
    content += "<span> followers</span>"
    content += "</p>"
    content += "</li>"
    content += "<li class=\"last\">"
    content += "<p>"
    content += "<strong>" + addCommas(data.views) + "</strong>"
    content += "<span> views</span>"
    content += "</p>"
    content += "<p>"
    content += "<strong>" + addCommas(data.following_count) + "</strong>"
    content += "<span> friends</span>"
    content += "</p>"
    content += "</li>"
    content += "</ul>"
    content += "</div>"
    content

  buildBadges = (data) ->
    content = ""
    count = 0
    total = 0
    content += "<div id=\"coderbits-awards\">"
    content += "<p id=\"coderbits-badges\">"
    i = 0

    while i < data.badges.length
      badge = data.badges[i]
      if badge.earned
        total++
        if count < 11 and badge.level is 1
          content += "<img src=\"" + badge.image_link + "\" title=\"" + badge.name + " - " + badge.description + "\" alt=\"" + badge.level + " bit " + badge.name + " - " + badge.description + "\" />"
          count++
      i++
    content += "<a href=\"" + data.link + "/badges\">view all " + total + "</a>"
    content += "</p>"
    content += "</div>"
    content

  request = (url) ->
    script = document.getElementsByTagName("script")[0]
    handler = document.createElement("script")
    handler.src = url
    script.parentNode.insertBefore handler, script
    return

  global = "coderbits"
  window[global] = (data) ->
    content = ""
    content += buildSummary(data)
    content += buildSkills(data)
    content += buildStats(data)
    content += buildBadges(data)
    document.getElementById(global).innerHTML = content
    delete window[global]

    return

  username = document.getElementById(global).getAttribute("data-coderbits-username")
  request "https://coderbits.com/" + username + ".json?callback=" + global
  return
) window, document
