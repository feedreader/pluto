# version-check gem - up-to-date? - helpers for checking for / reporting outdated gem / library versions

* home  :: [github.com/feedreader/pluto](https://github.com/feedreader/pluto)
* bugs  :: [github.com/feedreader/pluto/issues](https://github.com/feedreader/pluto/issues)
* gem   :: [rubygems.org/gems/version-check](https://rubygems.org/gems/version-check)
* rdoc  :: [rubydoc.info/gems/version-check](http://rubydoc.info/gems/version-check)
* forum :: [groups.google.com/group/wwwmake](http://groups.google.com/group/wwwmake)


## Usage 

Up-to-date? Version check all your libraries / gems on start-up at runtime.

Let's say you have a script
that depends on many libraries / gems.
How can you make sure the minimum version requirements
are fulfilled?


Use the (global) `version_check` method in your script.
Example:

``` ruby
outdated = version_check(
  ['pakman',        '1.1.0',  Pakman::VERSION],
  ['fetcher',       '0.4.5',  Fetcher::VERSION],
  ['feedparser',    '2.1.2',  FeedParser::VERSION],
  ['feedfilter',    '1.1.1',  FeedFilter::VERSION],
  ['textutils',     '1.4.0',  TextUtils::VERSION],
  ['logutils',      '0.6.1',  LogKernel::VERSION],
  ['props',         '1.2.0',  Props::VERSION],

  ['pluto-models',  '1.5.4',  Pluto::VERSION],
  ['pluto-update',  '1.6.3',  PlutoUpdate::VERSION],
  ['pluto-merge',   '1.1.0',  PlutoMerge::VERSION] )

pp outdated
```

Pass along the version check records where the record items are 1) the name of the library / gem, 2) the minimum version requirement and 3) the "live" used version - for example, 
`Pluto::VERSION` will become at runtime `1.5.3` or something - depending
on the installation / setup.

If all libraries / gems are up-to-date
this will result in an empty outdated list / array:

``` ruby
[]
```

And if some libraries / gems are NOT matching the minimum version requirement
the version record will get returned in the outdated list / array
resulting in, for example:

``` ruby
[['pluto-models',  '1.5.4', '1.5.3'],
 ['pluto-update',  '1.6.3', '1.4.1']]
```

Note: For now the version in use MUST always be greater or equal
to the minimum version requirement.

And the minimum requirement might be just a major (e.g. `2` same as `2.x.x`)
or a major plus minor (e.g. `2.1` same as  `2.1.x`) version.



### Bonus:  Sorry - Cannot continue; please update the outdated gem(s)

Use the (global) `version_check!` method (with a bang `!`) in your script
to automatically 1) check all versions, 2) report all outdated libraries / gems, 3) ask for an update and 4) exit. Example:

``` ruby
version_check!(
  ['pakman',        '1.1.0', Pakman::VERSION],
  ['fetcher',       '0.4.5', Fetcher::VERSION],
  ['feedparser',    '2.1.2', FeedParser::VERSION],
  ['feedfilter',    '1.1.1', FeedFilter::VERSION],
  ['textutils',     '1.4.0', TextUtils::VERSION],
  ['logutils',      '0.6.1', LogKernel::VERSION],
  ['props',         '1.2.0', Props::VERSION],

  ['pluto-models',  '1.5.4', Pluto::VERSION],
  ['pluto-update',  '1.6.3', PlutoUpdate::VERSION],
  ['pluto-merge',   '1.1.0', PlutoMerge::VERSION] )
```

Case 1: If all libraries / gems are up-to-date nothing happens.

Case 2: If some libraries / gems are NOT matching the minimum version requirement
this will result in, for example:

```
!!! ERROR: version check failed - 2 outdated gem(s):"
  pluto-models - min version required 1.5.4 > used/installed version 1.5.3
  pluto-update - min version required 1.6.3 > used/installed version 1.4.1     

sorry - cannot continue; please update the outdated gem(s)
```



## License

The `version-check` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake Forum/Mailing List](http://groups.google.com/group/wwwmake).
Thanks!
