listArticle = (article) ->
  article.byline = -> (author.name for author in @authors).join(', ')
  article.date = -> (new Date(@published_at)).format("mmmm d, yyyy")
  article.url = -> "/articles/#{@slug}"
  listItem(article)

listBlogPost = (blogPost) ->
  blogPost.byline = -> @author.name
  blogPost.date = -> (new Date(@published_at)).format("mmmm d, yyyy")
  blogPost.url = -> "/blogs/#{@blog.id}/posts/#{@slug}"
  listItem(blogPost)

listItem = (postable) ->
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
             postable
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
