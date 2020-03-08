require_relative './opml'


# path = "./rubyland.opml.xml"
# path = "./opml/states.opml.xml"
# path = "./opml/category.opml.xml"
# path = "./opml/directory.opml.xml"
# path = "./opml/places_lived.opml.xml"
# path = "./opml/simple_script.opml.xml"
path = "./subscription_list.opml.xml"

xml = File.open( path, 'r:utf-8' ) { |f| f.read }
puts xml


h = OPML.load( xml )
pp h

h = OPML.load_file( path )
pp h


o = Outline.parse( xml ) # load( xml )
pp o

o = Outline.read( path )  # load_file( path )
pp o




__END__
o = parse_outline( xml )
pp o

puts o[0].text
puts o.size

o.each do |item|
  puts item.text
  puts item.xml_url
  puts item.url
  puts
end



__END__

## add each - for looping why? why not?



# path = "./rubyland.opml.xml"
# path = "./opml/states.opml.xml"
# path = "./opml/category.opml.xml"
# path = "./opml/directory.opml.xml"
# path = "./opml/places_lived.opml.xml"
# path = "./opml/simple_script.opml.xml"
path = "./opml/subscription_list.opml.xml"

xml = File.open( path, 'r:utf-8' ) { |f| f.read }
puts xml


h = parse_opml( xml )
pp h

o = parse_outline( xml )
pp o

puts o[0].text
puts o.size

o.each do |item|
  puts item.text
  puts item.xml_url
  puts item.url
  puts
end


__END__

pp h['outline'][0]['text']                              #=> "United States"
pp h['outline'][0]['outline'][0]['text']                #=> "Far West"
pp h['outline'][0]['outline'][0]['outline'][0]['text']  #=> "Alaska"

pp h['outline'][0]['outline'][1]['text']                #=> "Great Plains"


puts
puts "Outline:"
outline = Outline.new( h )
pp outline[0].text
pp outline[0][ 'text' ]
pp outline[0][0].text
pp outline[0][0][0].text


__END__
"outline"=>
  [[{"text"=>"United States"},
    [[{"text"=>"Far West"},
      [[{"text"=>"Alaska"}],
       [{"text"=>"California"}],
       [{"text"=>"Hawaii"}],
       [{"text"=>"Nevada"},
        [[{"text"=>"Reno", "created"=>"Tue, 12 Jul 2005 23:56:35 GMT"}],

=begin
def outline( *args, **kwargs )
  if args.size > 0
    [kwargs, args]
  else
    [kwargs]
  end
end

outline( text: "United States",
  outline( text: "Far West", [
    outline( text: "Alaska" ),
    outline( text: "California"),
    outline( text: "Hawaii" ),
    outline( text: "Nevada", [
      outline( text: "Reno"  ]] )
    )
  )
)

pp outline
=end


