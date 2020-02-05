###
#  to run use
#     ruby -I ./lib script/test_render.rb


require 'pluto/news'


NEWSFEED_TEMPLATE = <<TXT
  <% News.latest.limit(100).each do |item| %>
    <div class="item">
      <h2><a href="<%= item.url %>"><%= item.title %></a></h2>
      <div><%= item.content %></div>
    </div>
  <% end %>
TXT

puts News.render( NEWSFEED_TEMPLATE )

# -or-

puts News.render( <<TXT )
  <% News.latest.limit(100).each do |item| %>
    <div class="item">
      <h2><a href="<%= item.url %>"><%= item.title %></a></h2>
      <div><%= item.content %></div>
    </div>
  <% end %>
TXT

# -or-

template = News::Template.new( <<TXT )
<% News.latest.limit(100).each do |item| %>
  <div class="item">
    <h2><a href="<%= item.url %>"><%= item.title %></a></h2>
    <div><%= item.content %></div>
  </div>
<% end %>
TXT
puts template.render