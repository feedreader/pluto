# Notes

## Todos

- add `>=` to minimum requirement version e.g. `>=6`, `>=6.0`, `>=6.0.0` - why? why not? - optional? is more readable / explicit?
- add `x` to minimum requiremet version e.g. `>=6.x`, `>=6.0.x` - why? why not? is more readable / explicit?
- support "sem version" e.g. 2.0.0-beta.3 e.g. split by (`-`) first lets you add alpha, beta etc. - why? why not?
- validate minimum requirement version with a regex / text pattern - why? why not?
- allow customize exit_code :-)?
- allow more customize e.g. message etc.

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



## Alternatives

### Ruby

- sem_version <https://rubygems.org/gems/sem_version>, source: <https://github.com/canton7/sem_version>

Search rubygem for version check <https://rubygems.org/search?query=version+check>

### Node

- version-check <https://www.npmjs.com/package/version-check>
- npm-check <https://www.npmjs.com/package/npm-check>


