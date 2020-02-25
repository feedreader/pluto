# Notes

## Todos

- [ ] add `>=` to minimum requirement version e.g. `>=6`, `>=6.0`, `>=6.0.0` - why? why not? - optional? is more readable / explicit?
- [ ] add `x` to minimum requiremet version e.g. `>=6.x`, `>=6.0.x` - why? why not? is more readable / explicit?
- [ ] support "sem version" e.g. 2.0.0-beta.3 e.g. split by (`-`) first lets you add alpha, beta etc. - why? why not?
- [ ] validate minimum requirement version with a regex / text pattern - why? why not?
- [ ] allow customize exit_code :-)?
- [ ] use ruby gems style spliting in parts / segements ? - why? why not?

```ruby
# File rubygems/version.rb, line 375
def _segments
  # segments is lazy so it can pick up version values that come from
  # old marshaled versions, which don't go through marshal_load.
  # since this version object is cached in @@all, its @segments should be frozen

  @segments ||= @version.scan(/[0-9]+|[a-z]+/i).map do |s|
    /^\d+$/ =~ s ? s.to_i : s
  end.freeze
end

 # File rubygems/version.rb, line 385
def _split_segments
  string_start = _segments.index {|s| s.is_a?(String) }
  string_segments  = segments
  numeric_segments = string_segments.slice!(0, string_start || string_segments.size)
  return numeric_segments, string_segments
end
```

- [ ] allow more customize e.g. message etc.

```js
pleaseUpgradeNode(pkg, {
  exitCode: 0, // Default: 1
  message: function(requiredVersion) {
    return 'Oops this program require Node ' +  requiredVersion
  }
})

// `notifier.update` contains some useful info about the update
console.log(notifier.update);
/*
{
	latest: '1.0.1',
	current: '1.0.0',
	type: 'patch', // Possible values: latest, major, minor, patch, prerelease, build
	name: 'pageres'
}
*/
```


## Ideas

- add a versions method to version.rb module?
- add a dependencies method to version.rb module? for use in gemspec - why? why not?


## Manage Dependencies (Beyond RubyGems)

- Bundler
  - see <https://bundler.io/guides/bundler_in_a_single_file_ruby_script.html>

- Isolate - <https://github.com/jbarnette/isolate>
  



## Alternatives

Update-to-Date / Version Checker

### Ruby

- sem_version <https://rubygems.org/gems/sem_version>, source: <https://github.com/canton7/sem_version>

Search rubygem for version check <https://rubygems.org/search?query=version+check>

### Node

- version-check <https://www.npmjs.com/package/version-check>
- npm-check <https://www.npmjs.com/package/npm-check>


