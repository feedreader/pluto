
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

  puts t.text
  puts "---"
  result = t.render( foos: [{ name: 'Dave Grohl' },
                            { name: 'Nate Mendel' },
                            { name: 'Pat Smear' },
                            { name: 'Taylor Hawkins' },
                            { name: 'Chris Shiflett' },
                            { name: 'Rami Jaffee' }] )
  puts result

  exp =<<TXT
    to be done
  TXT

  assert_equal exp, result
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
