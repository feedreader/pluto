

def test_inner_example
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
