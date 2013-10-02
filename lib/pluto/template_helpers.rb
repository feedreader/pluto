# encoding: UTF-8

module Pluto


module TemplateHelper

  def strip_tags( ht )
    ### tobe done
    ## strip markup tags; return plain text
    ht.gsub( /<[^>]+>/, '' )
  end


  def whitelist( ht, tags, opts={} )

    # note: assumes properly escaped <> in ht/hypertext

    ###############################################
    # step one - save whitelisted tags use ‹tag›
    tags.each do |tag|
      # note: we strip all attribues
      # note: match all tags case insensitive e.g. allow a,A or br,BR,bR etc.
      #   downcase all tags

      # convert xml-style empty tags to simple html emtpty tags
      #  e.g. <br/> or <br /> becomses <br>
      ht = ht.gsub( /<(#{tag})\s*\/>/i )       { |_| "‹#{$1.downcase}›" }   # eg. <br /> or <br/> becomes ‹br›

      # make sure we won't swall <br> for <b> for example, thus use \s+ before [^>]
      ht = ht.gsub( /<(#{tag})(\s+[^>]*)?>/i ) { |_| "‹#{$1.downcase}›" }   # opening tag <p>
      ht = ht.gsub( /<\/(#{tag})\s*>/i )       { |_| "‹/#{$1.downcase}›" }  # closing tag e.g. </p>
    end

    ############################
    # step two - clean tags

    #   strip images - special treatment for debugging
    ht = ht.gsub( /<img[^>]*>/i, '♦' )   # for debugging use black diamond e.g. ♦
    ht = ht.gsub( /<\/img>/i, '' )   # should not exists

    # strip all remaining tags
    ht = ht.gsub( /<[^>]+>/, '' )
    
    pp ht  # fix: debugging indo - remove
    
    ############################################
    # step three - restore whitelisted tags

    return ht if opts[:skip_restore].present?   # skip step 3 for debugging

    tags.each do |tag|
#      ht = ht.gsub( /‹(#{tag})›/, "<\1>" )  # opening tag e.g. <p>
#      ht = ht.gsub( /‹\/(#{tag})›/, "<\/\1>" )  # closing tag e.g. </p>
      ht = ht.gsub( /‹(#{tag})›/ )   { |_| "<#{$1}>" }
      ht = ht.gsub( /‹\/(#{tag})›/ ) { |_| "<\/#{$1}>" }  # closing tag e.g. </p>
    end

    ht
  end  # method whitelist




  ## move into own helper module???
  ##  - any helper already for easy reuse
  ##
  #   rails style asset tag helpers and friends

  def stylesheet_link_tag( href )
    href = "#{href}.css"  unless href.ends_with?( '.css' )   # auto-add .css if not present
    "<link rel='stylesheet' type='text/css' href='#{href}'>"
  end

  def image_tag( src, opts={} )
    attributes = ""
    opts.each do |key,value|
      attributes << "#{key}='#{value}' "
    end
    "<img src='#{src}' #{attributes}>"
  end

  def link_to( text, href, opts={} )
    attributes = ""
    opts.each do |key,value|
      attributes << "#{key}='#{value}' "
    end
    "<a href='#{href}' #{attributes}>#{text}</a>"
  end


  ##  change to simple_hypertext or
  #     hypertext_simple or
  #     sanitize ???

  

  def textify( ht, opts={} )   # ht -> hypertext
    ## turn into text
    # todo: add options for
    #   keep links, images, lists (?too), code, codeblocks

    ht = whitelist( ht, [:br, :p, :ul, :ol, :li, :pre, :code, :blockquote, :q, :cite], opts )

   # strip bold
#    ht = ht.gsub( /<b[^>]*>/, '**' )  # fix: will also swallow bxxx tags - add b space
#    ht = ht.gsub( /<\/b>/, '**' )

    # strip em
#   ht = ht.gsub( /<em[^>]*>/, '__' )
#   ht = ht.gsub( /<\/em>/, '__' )

    # clean (prettify) literal urls (strip protocoll) 
    ht = ht.gsub( /(http|https):\/\//, '' )

#    ht = ht.gsub( /&nbsp;/, ' ' )

#    # try to cleanup whitespaces
#    # -- keep no more than two spaces
#    ht = ht.gsub( /[ \t]{3,}/, '  ' )
#    # -- keep no more than two new lines
#    ht = ht.gsub( /\n{2,}/m, "\n\n" ) 
#    # -- remove all trailing spaces
#    ht = ht.gsub( /[ \t\n]+$/m, '' )
#    # -- remove all leading spaces
#    ht = ht.gsub( /^[ \t\n]+/m, '' ) 

    ht
  end


####
# fix: move to DateHelper  ??


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
      when 45...90          then  "an hour ago"   ## use one instead of 1 ?? why? why not?
      # 90 mins up to 24 hours
      when 90...1440        then  "%d hours ago" % (distance_in_minutes.to_f / 60.0).round
      # 24 hours up to 42 hours
      when 1440...2520      then "a day ago"   ## use one day ago - why? why not?
      # 42 hours up to 30 days
      when 2520...43200     then "%d days ago" % (distance_in_minutes.to_f / 1440.0).round
      # 30 days up to 60 days
      #  fix: use pluralize for months  - fix: change when - use just for a month ago
      when 43200...86400    then "%d months ago" % (distance_in_minutes.to_f / 43200.0).round
      # 60 days up to 365 days
      when 86400...525600   then "%d months ago" % (distance_in_minutes.to_f / 43200.0).round
      ## fix - add number of years ago
      else                       "over a year ago"  #todo: use over a year ago???
                                                    # fix: split into two - use
                                                    #  1) a year ago
                                                    #  2) (x) years ago
    end
  end


end # module TemplateHelper
end # module Pluto
