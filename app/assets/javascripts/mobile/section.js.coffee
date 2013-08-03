listItem = (article) ->
  article.byline = -> (author.name for author in @authors).join(', ')
  article.date = -> (new Date(@published_at)).format("mmmm d, yyyy")
  _.template("""
             <li>
               <a href="/articles/<%= slug %>">
                 <% if (square_80x_url) { %>
                   <img src="<%= square_80x_url %>"/>
                 <% } %>
                 <h2><%= title %></h2>
                 <p><%= byline() + " |  " + date() %></p>
               </a>
             </li>
             """,
             article
  )

fetchMore = (url) ->
  ->
    $(this).on 'expand', 'div[data-role=collapsible]', ->
      if not $(this).data('initialized')
        $listview = $(this).find('ul[data-role=listview]')
        $.get url.call(this), {limit: 7}, (articles) =>
          $listview.children().last().before(_.map(articles, listItem))
          $listview.listview('refresh')
          $(this).data('initialized', true)

sectionUrl = ->
  fullUrl('api', '/section' + $(this).data('section'))

blogUrl = ->
  blog = $(this).data('blog')
  fullUrl('api', "/blogs/#{blog}/posts")

initialize '#section-listing', fetchMore(sectionUrl)
initialize '#blog-listing', fetchMore(blogUrl)
