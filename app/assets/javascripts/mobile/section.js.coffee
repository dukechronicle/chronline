listItem = (article) ->
  article.byline = -> (author.name for author in @authors).join(', ')
  article.date = -> (new Date(@created_at)).format("mmmm d, yyyy")
  _.template("""
             <li>
               <a href="/article/<%= slug %>">
                 <% if (thumb_square_s_url) { %>
                   <img src="<%= thumb_square_s_url %>"/>
                 <% } %>
                 <h2><%= title %></h2>
                 <p><%= byline() + " |  " + date() %></p>
               </a>
             </li>
             """,
             article
  )

initialize '#section-listing', ->
  $(this).on 'expand', 'div[data-role=collapsible]', ->
    if not $(this).data('initialized')
      $listview = $(this).find('ul[data-role=listview]')
      url = fullUrl('api', '/section' + $(this).data('section'))
      $.get url, {limit: 7}, (articles) =>
        $listview.children().last().before(_.map(articles, listItem))
        $listview.listview('refresh')
        $(this).data('initialized', true)
