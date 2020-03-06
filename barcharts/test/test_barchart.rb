###
#  to run use
#     ruby -I ./lib -I ./test test/test_barchart.rb


require 'helper'


class TestBarchart < MiniTest::Test

  def test_array
    data = [
     ['two',   2],
     ['one',   1],
     ['three', 3],
     ['five',  5],
     ['four',  4],
    ]


    assert_equal <<TXT, barchart( data, title: 'Test' )
Test  (n=15)
---------------------------------
  two    (13%) | ▉▉▉▉▉▉▊ 2
  one    ( 6%) | ▉▉▉▍ 1
  three  (20%) | ▉▉▉▉▉▉▉▉▉▉ 3
  five   (33%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▊ 5
  four   (26%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▍ 4
TXT

    assert_equal <<TXT, barchart( data, title: 'Test', sort: true )
Test  (n=15)
---------------------------------
  five   (33%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▊ 5
  four   (26%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▍ 4
  three  (20%) | ▉▉▉▉▉▉▉▉▉▉ 3
  two    (13%) | ▉▉▉▉▉▉▊ 2
  one    ( 6%) | ▉▉▉▍ 1
TXT
  end


  def test_hash
data = {
  'two':   2,
  'one':   1,
  'three three': 3,
  'five':  5,
  'four':  4,
}

  assert_equal <<TXT, barchart( data, title: 'Test' )
Test  (n=15)
---------------------------------
  two          (13%) | ▉▉▉▉▉▉▊ 2
  one          ( 6%) | ▉▉▉▍ 1
  three three  (20%) | ▉▉▉▉▉▉▉▉▉▉ 3
  five         (33%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▊ 5
  four         (26%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▍ 4
TXT

  assert_equal <<TXT, barchart( data, title: 'Test', sort: true )
Test  (n=15)
---------------------------------
  five         (33%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▊ 5
  four         (26%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▍ 4
  three three  (20%) | ▉▉▉▉▉▉▉▉▉▉ 3
  two          (13%) | ▉▉▉▉▉▉▊ 2
  one          ( 6%) | ▉▉▉▍ 1
TXT
  end

  def test_hash_count
data = {
  'two':   { count: 22 },
  'one':   { count: 1 },
  'three': { count: 3 },
  'five':  { count: 55 },
  'four':  { count: 44 },
}

  puts barchart( data, title: 'Test' )
  puts barchart( data, title: 'Test', sort: true )

  assert_equal <<TXT, barchart( data, title: 'Test' )
Test  (n=125)
---------------------------------
  two    (17%) | ▉▉▉▉▉▉▉▉▊ 22
  one    ( 0%) | ▍ 1
  three  ( 2%) | ▉▎ 3
  five   (44%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉ 55
  four   (35%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▋ 44
TXT

  assert_equal <<TXT, barchart( data, title: 'Test', sort: true )
Test  (n=125)
---------------------------------
  five   (44%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉ 55
  four   (35%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▋ 44
  two    (17%) | ▉▉▉▉▉▉▉▉▊ 22
  three  ( 2%) | ▉▎ 3
  one    ( 0%) | ▍ 1
TXT
end

end  # class TestBarchart

