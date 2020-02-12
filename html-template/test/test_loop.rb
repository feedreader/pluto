
def test_loop_meta
  [].each_with_loop do |item, item_loop|
    assert false   ## empty loop; fail/error if we get here
  end

  [0].each_with_loop do |item, item_loop|
    if item == 0
     assert_equal 0, item_loop.index
     assert_equal 1, item_loop.counter
     assert          item_loop.odd?   == true
     assert          item_loop.even?  == false
     assert          item_loop.first? == true
     assert          item_loop.inner? == false
     assert          item_loop.outer? == true
     assert          item_loop.last?  == true
    end
  end

  [0,1,2].each_with_loop do |item, item_loop|
     if item == 0
      assert_equal 0, item_loop.index
      assert_equal 1, item_loop.counter
      assert          item_loop.odd?   == true
      assert          item_loop.even?  == false
      assert          item_loop.first? == true
      assert          item_loop.inner? == false
      assert          item_loop.outer? == true
      assert          item_loop.last?  == false
     end
     if item == 1
      assert_equal 1, item_loop.index
      assert_equal 2, item_loop.counter
      assert          item_loop.odd?   == false
      assert          item_loop.even?  == true
      assert          item_loop.first? == false
      assert          item_loop.inner? == true
      assert          item_loop.outer? == false
      assert          item_loop.last?  == false
     end
     if item == 2
      assert_equal 2, item_loop.index
      assert_equal 3, item_loop.counter
      assert          item_loop.odd?   == true
      assert          item_loop.even?  == false
      assert          item_loop.first? == false
      assert          item_loop.inner? == false
      assert          item_loop.outer? == true
      assert          item_loop.last?  == true
     end
  end
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

  puts t.text
  puts "---"
  result = t.render( feeds: [{ title: 'Feed 1', updated: Date.new(2010,1,3),
                               items: [{ title: 'Item 1.1', updated: Date.new(2010,1,1)},
                                       { title: 'Item 1.2', updated: Date.new(2010,1,2)}]},
                             { title: 'Feed 2', updated: Date.new(2020,1,3),
                               items: [{ title: 'Item 2.1', updated: Date.new(2020,1,1)},
                                       { title: 'Item 2.2', updated: Date.new(2020,1,2)}]}] )
  puts result

  exp =<<TXT
    to be done
  TXT

  assert_equal exp, result
end
