def find_default_config_path
  candidates =  [ 'pluto.ini',
                  'planet.ini'
                   ]

  candidates.each do |candidate|
    return candidate  if File.exists?( candidate )   ## todo: use ./candidate -- why? why not??
  end

  puts "*** note: no default planet configuration found, that is, no #{candidates.join('|')} found in working folder"
  nil  # return nil; no conifg existing candidate found/present; sorry
end


def find_config_path( name )
  extname    = File.extname( name )   # return '' or '.ini' or '.conf' or '.cfg' or '.txt -???' etc.

  return name  if extname.present?    # nothing to do; extension already present

  candidates = [ '.ini' ]

  candidates.each do |candidate|
    return "#{name}#{candidate}"  if File.exists?( "#{name}#{candidate}" )
  end

  # no extensions matching; sorry
  puts "*** note: no configuration found w/ extensions #{candidates.join('|')} for '#{name}'"
  # todo/check/fix - ?? -skip; remove from arg  - or just pass through ???
  nil  # return nil; no config found/present; sorry
end

# end
#  move to pluto for reuse (e.g. in rakefile)
###########################



def expand_config_args( args )

  # 1) no args - try to find default config e.g. pluto.ini etc.
  if args.length == 0
    new_arg = find_default_config_path

    return [] if new_arg.nil?
    return [new_arg] # create a new args w/ one item e.g. ['pluto.yml']
  end

  # 2) expand extname if no extname and config present

  new_args = []
  args.each do |arg|
    new_arg = find_config_path( arg )
    if new_arg.nil?
      # skip for now
    else
      new_args << new_arg
    end
  end
  new_args

end # method expand_config_args
