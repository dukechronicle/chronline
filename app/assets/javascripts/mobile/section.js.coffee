listArticle = (article) ->
  article.url = -> "/articles/#{@slug}"
  listItem(article)

listBlogPost = (blogPost) ->
  blogPost.url = -> "/blogs/#{@blog.id}/posts/#{@slug}"
  listItem(blogPost)

listItem = (post) ->
  post.byline = -> (author.name for author in @authors).join(', ')
  post.date = -> (new Date(@published_at)).format("mmmm d, yyyy")
  _.template("""
             <li>
               <a href="<%= url() %>">
                 <% if (square_80x_url) { %>
                   <img src="<%= square_80x_url %>"/>
                 <% } %>
                 <h2><%= title %></h2>
                 <p><%= byline() + " |  " + date() %></p>
               </a>
             </li>
             """,
             post
  )

fetchMore = (url, listFunction) ->
  ->
    $(this).on 'expand', 'div[data-role=collapsible]', ->
      if not $(this).data('initialized')
        $listview = $(this).find('ul[data-role=listview]')
        $.get url.call(this), {limit: 7}, (posts) =>
          $listview.children().last().before(_.map(posts, listFunction))
          $listview.listview('refresh')
          $(this).data('initialized', true)

sectionUrl = ->
  fullUrl('api', '/section' + $(this).data('section'))

blogUrl = ->
  blog = $(this).data('blog')
  fullUrl('api', "/blogs/#{blog}/posts")

initialize '#section-listing', fetchMore(sectionUrl, listArticle)
initialize '#blog-listing', fetchMore(blogUrl, listBlogPost)
