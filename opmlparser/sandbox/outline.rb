## todo/fix:
##   try to make nested outline generator / method work - possible? why? why not?


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



