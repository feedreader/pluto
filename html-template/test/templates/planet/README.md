# Notes on (Original) Planet HTML Templates

see <https://people.gnome.org/~jdub/bzr/planet/devel/trunk/examples/>


Slighly modernized:

- Change to simple (modern) doctype, that is, `<!DOCTYPE HTML>`
  - was: `<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">`
- Change to simple meta charset, that is, `<meta charset="utf-8">`
  - was: `<meta http-equiv="Content-Type" content="text/html; charset=utf-8">`


---

Planet HTML Template Files

In the INSTALL notes @ <https://people.gnome.org/~jdub/bzr/planet/devel/trunk/INSTALL> it reads:

```
Reading through the example templates is recommended, they're designed to
pretty much drop straight into your site with little modification
anyway.

Inside these template files, <TMPL_VAR xxx> is replaced with the content
of the 'xxx' variable.  The variables available are:

	name	....	} the value of the equivalent options
	link	....	} from the [Planet] section of your
	owner_name .	} Planet's config.ini file
	owner_email	}

	url	....	link with the output filename appended
	generator ..	version of planet being used

	date	....	                         { your date format
	date_iso ...	current date and time in { ISO date format
	date_822 ...	                         { RFC822 date format


There are also two loops, 'Items' and 'Channels'.  All of the lines of
the template and variable substitutions are available for each item or
channel.  Loops are created using <TMPL_LOOP LoopName>...</TMPL_LOOP>
and may be used as many times as you wish.

The 'Channels' loop iterates all of the channels (feeds) defined in the
configuration file, within it the following variables are available:

	name	....	value of the 'name' option in config.ini, or title
	title	....	title retreived from the channel's feed
	tagline ....	description retreived from the channel's feed
	link	....	link for the human-readable content (from the feed)
	url	....	url of the channel's feed itself

	Additionally the value of any other option specified in config.ini
	for the feed, or in the [DEFAULT] section, is available as a
	variable of the same name.

	Depending on the feed, there may be a huge variety of other
	variables may be available; the best way to find out what you
	have is using the 'planet-cache' tool to examine your cache files.

The 'Items' loop iterates all of the blog entries from all of the channels,
you do not place it inside a 'Channels' loop.  Within it, the following
variables are available:

	id	....	unique id for this entry (sometimes just the link)
	link	....	link to a human-readable version at the origin site

	title	....	title of the entry
	summary	....	a short "first page" summary
	content	....	the full content of the entry

	date	....	                              { your date format
	date_iso ...	date and time of the entry in { ISO date format
	date_822 ...                                  { RFC822 date format

	If the entry takes place on a date that has no prior entry has
	taken place on, the 'new_date' variable is set to that date.
	This allows you to break up the page by day.

	If the entry is from a different channel to the previous entry,
	or is the first entry from this channel on this day
	the 'new_channel' variable is set to the same value as the
	'channel_url' variable.  This allows you to collate multiple
	entries from the same person under the same banner.
	
	Additionally the value of any variable that would be defined
	for the channel is available, with 'channel_' prepended to the
	name (e.g. 'channel_name' and 'channel_link').

	Depending on the feed, there may be a huge variety of other
	variables may be available; the best way to find out what you
	have is using the 'planet-cache' tool to examine your cache files.


There are also a couple of other special things you can do in a template.

 -  If you want HTML escaping applied to the value of a variable, use the
    <TMPL_VAR xxx ESCAPE="HTML"> form.

 -  If you want URI escaping applied to the value of a variable, use the
    <TMPL_VAR xxx ESCAPE="URI"> form.

 -  To only include a section of the template if the variable has a
    non-empty value, you can use <TMPL_IF xxx>....</TMPL_IF>.  e.g.

    <TMPL_IF new_date>
    <h1><TMPL_VAR new_date></h1>
    </TMPL_IF>

    You may place a <TMPL_ELSE> within this block to specify an
    alternative, or may use <TMPL_UNLESS xxx>...</TMPL_UNLESS> to
    perform the opposite.
```
