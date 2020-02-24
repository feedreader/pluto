require 'pp'


## goal - avoid duplication for version requirement
##          how to (best) add dependencies to gemspec using a VERSIONS list or something?


## put version in proc to defer evaluation
##   (lets you use VERSIONS w/o requiring all gems) - why? why not?
VERSIONS = [
  ['pluto-models', '>= 1.5.4',  ->{ Pluto::VERSION } ],
  ['pluto-update', '>= 1.6.3',  ->{ PlutoUpdate::VERSION } ],
  ['pluto-merge',  '>= 1.1.0',  ->{ PlutoMerge::VERSION} ],
]

##
## or add all dependencies and check version live only if third item is present (either as string or proc) - why? why not?
# VERSIONS = [
#  ['pluto-models', '>= 1.5.4',  ->{ Pluto::VERSION } ],
#  ['pluto-update', '>= 1.6.3',  ->{ PlutoUpdate::VERSION } ],
#  ['pluto-merge',  '>= 1.1.0',  ->{ PlutoMerge::VERSION} ],
#  ['gli',          '>= 2.12.2'],   ## do NOT check
#  ['sqlite3']                      ## do NOT check and open (ANY) version / no min version requirement
# ]


## or split VERSIONS into two arrays / lists - why? why not?
=begin
VERSIONS = [
  ['pluto-models', '>= 1.5.4' ],
  ['pluto-update', '>= 1.6.3' ],
  ['pluto-merge',  '>= 1.1.0' ],
]

CURRENT_VERSION = [
  ['pluto-models',  Pluto::VERSION ]
  ['pluto-update',  PlutoUpdate::VERSION ]
  ['pluto-merge',   PlutoMerge::VERSION ]
]

# or use a hash structure
CURRENT_VERSION = {
  'pluto-models':  Pluto::VERSION,
  'pluto-update':  PlutoUpdate::VERSION,
  'pluto-merge':   PlutoMerge::VERSION
}
=end


class Package
  def initialize( versions )
    @versions = versions
  end

  ##
  ## auto-fill dependency version info from VERSIONS
  def dependencies( *args )
    names = args    # note: for now assume all args are just names
    #  e.g. 'pluto-models', 'pluto-update', etc.
    deps = @versions.select do |rec| names.include?( rec[0] ) end
                    .map    do |rec| [rec[0], rec[1]] end

    ## todo/fix: throw exception if dependency is missing!
    ##   names.size == deps.size
    puts "names.size == deps.size  #{names.size} == #{deps.size}"
    deps
  end
end


##  in the gemspec MUST
## require 'version/check'

##
## auto-fill dependency version info from VERSIONS
pp DEPENDENCIES = Package.new( VERSIONS ).dependencies(
    'pluto-models',
    'pluto-update',
    'pluto-merge' ) +
  [['gli',         '>= 2.12.2'],
   ['sqlite3']]


=begin
self.extra_deps = [
  ['pluto-models', '>= 1.5.4'],
  ['pluto-update', '>= 1.6.3'],
  ['pluto-merge',  '>= 1.1.0'],
  ['pluto-tasks',  '>= 1.5.3'],
  ['gli',          '>= 2.12.2'],
  ['sqlite3'],
=end
