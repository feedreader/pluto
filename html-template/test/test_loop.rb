###
#  to run use
#     ruby -I ./lib -I ./test test/test_loop.rb

require 'helper'



class TestLoop < MiniTest::Test

def test_loop_meta
  [].each_with_loop do |item, item_loop|
    assert false   ## empty loop; fail/error if we get here
  end

  [{index:   0,
    counter: 1,
    odd:     true,
    even:    false,
    first:   true,
    inner:   false,
    outer:   true,
    last:    true}].each_with_loop do |item, item_loop|
      assert_equal item[:index],   item_loop.index
      assert_equal item[:counter], item_loop.counter
      assert                       item_loop.odd?   == item[:odd]
      assert                       item_loop.even?  == item[:even]
      assert                       item_loop.first? == item[:first]
      assert                       item_loop.inner? == item[:inner]
      assert                       item_loop.outer? == item[:outer]
      assert                       item_loop.last?  == item[:last]
  end

  [{index:   0,
    counter: 1,
    odd:     true,
    even:    false,
    first:   true,
    inner:   false,
    outer:   true,
    last:    false},
   {index:   1,
    counter: 2,
    odd:     false,
    even:    true,
    first:   false,
    inner:   true,
    outer:   false,
    last:    false},
   {index:   2,
    counter: 3,
    odd:     true,
    even:    false,
    first:   false,
    inner:   false,
    outer:   true,
    last:    true}].each_with_loop do |item, item_loop|
      assert_equal item[:index],   item_loop.index
      assert_equal item[:counter], item_loop.counter
      assert                       item_loop.odd?   == item[:odd]
      assert                       item_loop.even?  == item[:even]
      assert                       item_loop.first? == item[:first]
      assert                       item_loop.inner? == item[:inner]
      assert                       item_loop.outer? == item[:outer]
      assert                       item_loop.last?  == item[:last]
  end
end


def test_loop_example
  t = HtmlTemplate.new( <<TXT )
<TMPL_LOOP foos>
<TMPL_IF __FIRST__>
This only outputs on the first pass.
</TMPL_IF>
<TMPL_IF __ODD__>
This outputs every other pass, on the odd passes.
</TMPL_IF>
<TMPL_UNLESS __ODD__>
This outputs every other pass, on the even passes.
</TMPL_UNLESS>
<TMPL_IF __INNER__>
This outputs on passes that are neither first nor last.
</TMPL_IF>

This is pass number <TMPL_VAR __COUNTER__>.

<TMPL_IF __LAST__>
This only outputs on the last pass.
</TMPL_IF>
</TMPL_LOOP>
TXT

  pp t.names
  puts "---"

  puts t.text
  puts "---"

  assert_equal <<TXT, t.text
<% foos.each_with_loop do |foo, foo_loop| %>
<% if foo_loop.__FIRST__ %>
This only outputs on the first pass.
<% end %>
<% if foo_loop.__ODD__ %>
This outputs every other pass, on the odd passes.
<% end %>
<% unless foo_loop.__ODD__ %>
This outputs every other pass, on the even passes.
<% end %>
<% if foo_loop.__INNER__ %>
This outputs on passes that are neither first nor last.
<% end %>

This is pass number <%= foo_loop.__COUNTER__ %>.

<% if foo_loop.__LAST__ %>
This only outputs on the last pass.
<% end %>
<% end %>
TXT

  result = t.render( foos: [{ name: 'Dave Grohl' },
                            { name: 'Nate Mendel' },
                            { name: 'Pat Smear' },
                            { name: 'Taylor Hawkins' },
                            { name: 'Chris Shiflett' },
                            { name: 'Rami Jaffee' }] )
  puts result

  assert_equal <<TXT, result
This only outputs on the first pass.
This outputs every other pass, on the odd passes.

This is pass number 1.

This outputs every other pass, on the even passes.
This outputs on passes that are neither first nor last.

This is pass number 2.

This outputs every other pass, on the odd passes.
This outputs on passes that are neither first nor last.

This is pass number 3.

This outputs every other pass, on the even passes.
This outputs on passes that are neither first nor last.

This is pass number 4.

This outputs every other pass, on the odd passes.
This outputs on passes that are neither first nor last.

This is pass number 5.

This outputs every other pass, on the even passes.

This is pass number 6.

This only outputs on the last pass.
TXT
end


def test_loop_inner
  t = HtmlTemplate.new( <<TXT )
<TMPL_LOOP feeds>
  <TMPL_VAR title>
  <TMPL_VAR updated>
  <TMPL_LOOP items>
    <TMPL_VAR title>
    <TMPL_VAR updated>
  </TMPL_LOOP>
</TMPL_LOOP>
TXT

  pp t.names
  puts "---"

  puts t.text
  puts "---"

  assert_equal <<TXT, t.text
<% feeds.each_with_loop do |feed, feed_loop| %>
  <%= feed.title %>
  <%= feed.updated %>
  <% feed.items.each_with_loop do |item, item_loop| %>
    <%= item.title %>
    <%= item.updated %>
  <% end %>
<% end %>
TXT

  result = t.render( feeds: [{ title: 'Feed 1', updated: Date.new(2010,1,3),
                               items: [{ title: 'Item 1.1', updated: Date.new(2010,1,1)},
                                       { title: 'Item 1.2', updated: Date.new(2010,1,2)}]},
                             { title: 'Feed 2', updated: Date.new(2020,1,3),
                               items: [{ title: 'Item 2.1', updated: Date.new(2020,1,1)},
                                       { title: 'Item 2.2', updated: Date.new(2020,1,2)}]}] )

  result = result.gsub( /^[ ]+$/, '' )   ## note: remove spaces in empty lines (only with spaces)
  puts result

  assert_equal <<TXT, result
  Feed 1
  2010-01-03

    Item 1.1
    2010-01-01

    Item 1.2
    2010-01-02

  Feed 2
  2020-01-03

    Item 2.1
    2020-01-01

    Item 2.2
    2020-01-02

TXT
end


end # class TestLoop
