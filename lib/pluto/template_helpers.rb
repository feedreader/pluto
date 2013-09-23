module Pluto

####
# fix: rename to DateHelper

module TemplateHelper

  def strip_tags( hypertext )
    ### tobe done
    ## strip markup tags; return plain text (to be done)
    hypertext
  end


  def time_ago_in_words( from_time )
    from_time = from_time.to_time
    to_time   = Time.now
    
    ### todo: will not handle future dates??
    ## what todo do??
    ## use -1..-50000000000 ??  "future"

    ## from_time, to_time = to_time, from_time if from_time > to_time

    distance_in_minutes = ((to_time - from_time)/60.0).round

    case distance_in_minutes
      when 0..1             then  "just now"
      when 2...45           then  "%d minutes ago" % distance_in_minutes
      when 45...90          then  "about 1 hour ago"   ## use one instead of 1 ?? why? why not?
      # 90 mins up to 24 hours
      when 90...1440        then  "about %d hours ago" % (distance_in_minutes.to_f / 60.0).round
      # 24 hours up to 42 hours
      when 1440...2520      then "1 day ago"   ## use one day ago - why? why not?
      # 42 hours up to 30 days
      when 2520...43200     then "%d days ago" % (distance_in_minutes.to_f / 1440.0).round
      # 30 days up to 60 days
      #  fix: use pluralize for months
      when 43200...86400    then "about %d months ago" % (distance_in_minutes.to_f / 43200.0).round
      # 60 days up to 365 days
      when 86400...525600   then "%d months ago" % (distance_in_minutes.to_f / 43200.0).round
      ## fix - add number of years ago
      else                       "about a year ago"  #todo: use over a year ago???
    end
  end


end # module TemplateHelper
end # module Pluto