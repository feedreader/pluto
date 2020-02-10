# Template Name Reference Usage


```
--- basic/index.html.tmpl:
{"name"=>{"$VAR"=>2},
 "generator"=>{"$VAR"=>1},
 "Channels"=>
  {"$LOOP"=>1,
   "link"=>{"$VAR"=>1},
   "title"=>{"$VAR"=>1},
   "name"=>{"$VAR"=>1},
   "url"=>{"$VAR"=>1}},
 "Items"=>
  {"$LOOP"=>1,
   "new_date"=>{"$IF"=>1, "$VAR"=>1},
   "new_channel"=>{"$IF"=>1},
   "channel_link"=>{"$VAR"=>1},
   "channel_title"=>{"$VAR"=>1},
   "channel_name"=>{"$VAR"=>1},
   "title"=>{"$IF"=>1, "$VAR"=>1},
   "link"=>{"$VAR"=>2},
   "content"=>{"$VAR"=>1},
   "author"=>{"$IF"=>1, "$VAR"=>1},
   "date"=>{"$VAR"=>1}},
 "date"=>{"$VAR"=>1}}


--- fancy/index.html.tmpl:
{"name"=>{"$VAR"=>2},
 "generator"=>{"$VAR"=>1},
 "feedtype"=>{"$IF"=>1, "$VAR"=>1},
 "feed"=>{"$VAR"=>1},
 "channel_title_plain"=>{"$VAR"=>1},
 "Items"=>
  {"$LOOP"=>1,
   "new_date"=>{"$IF"=>1, "$VAR"=>1, "$UNLESS"=>1},
   "__FIRST__"=>{"$UNLESS"=>1},
   "new_channel"=>{"$IF"=>1},
   "channel_link"=>{"$VAR"=>1},
   "channel_title_plain"=>{"$VAR"=>1},
   "channel_name"=>{"$VAR"=>1},
   "channel_face"=>{"$IF"=>1, "$VAR"=>1},
   "channel_facewidth"=>{"$VAR"=>1},
   "channel_faceheight"=>{"$VAR"=>1},
   "id"=>{"$VAR"=>1},
   "channel_language"=>{"$IF"=>1, "$VAR"=>1},
   "title"=>{"$IF"=>1, "$VAR"=>1},
   "title_language"=>{"$IF"=>1, "$VAR"=>1},
   "link"=>{"$VAR"=>2},
   "content_language"=>{"$IF"=>1, "$VAR"=>1},
   "content"=>{"$VAR"=>1},
   "author"=>{"$IF"=>1, "$VAR"=>1},
   "date"=>{"$VAR"=>1},
   "category"=>{"$IF"=>1, "$VAR"=>1},
   "__LAST__"=>{"$IF"=>1}},
 "Channels"=>
  {"$LOOP"=>1,
   "url"=>{"$VAR"=>1},
   "link"=>{"$IF"=>1, "$VAR"=>1},
   "message"=>{"$IF"=>1, "$VAR"=>1, "$UNLESS"=>1},
   "title_plain"=>{"$VAR"=>1},
   "name"=>{"$VAR"=>1}},
 "date"=>{"$VAR"=>1}}


--- atom.xml.tmpl:
{"name"=>{"$VAR"=>1},
 "feed"=>{"$VAR"=>2},
 "link"=>{"$VAR"=>1},
 "date_iso"=>{"$VAR"=>1},
 "generator"=>{"$VAR"=>1},
 "Items"=>
  {"$LOOP"=>1,
   "channel_language"=>{"$IF"=>1, "$VAR"=>1},
   "title_language"=>{"$IF"=>1, "$VAR"=>1},
   "title"=>{"$VAR"=>1},
   "link"=>{"$VAR"=>1},
   "id"=>{"$VAR"=>1},
   "date_iso"=>{"$VAR"=>1},
   "content_language"=>{"$IF"=>1, "$VAR"=>1},
   "content"=>{"$VAR"=>1},
   "author_name"=>{"$IF"=>1, "$VAR"=>1},
   "author_email"=>{"$IF"=>1, "$VAR"=>1},
   "channel_author_name"=>{"$IF"=>1, "$VAR"=>1},
   "channel_author_email"=>{"$IF"=>1, "$VAR"=>1},
   "channel_name"=>{"$VAR"=>2},
   "channel_link"=>{"$VAR"=>1},
   "channel_title"=>{"$IF"=>1, "$VAR"=>1},
   "channel_subtitle"=>{"$IF"=>1, "$VAR"=>1},
   "channel_url"=>{"$VAR"=>2},
   "channel_id"=>{"$IF"=>1, "$VAR"=>1},
   "channel_updated_iso"=>{"$IF"=>1, "$VAR"=>1},
   "channel_rights"=>{"$IF"=>1, "$VAR"=>1}}}

--- foafroll.xml.tmpl:
{"name"=>{"$VAR"=>1},
 "link"=>{"$VAR"=>1},
 "url"=>{"$VAR"=>1},
 "Channels"=>
  {"$LOOP"=>1,
   "name"=>{"$VAR"=>1},
   "link"=>{"$VAR"=>1},
   "title_plain"=>{"$VAR"=>1},
   "url"=>{"$VAR"=>1}}}


--- opml.xml.tmpl:
{"name"=>{"$VAR"=>1},
 "date_822"=>{"$VAR"=>1},
 "owner_name"=>{"$VAR"=>1},
 "owner_email"=>{"$VAR"=>1},
 "Channels"=>
  {"$LOOP"=>1,
   "name"=>{"$VAR"=>2},
   "url"=>{"$VAR"=>1},
   "title"=>{"$IF"=>1, "$VAR"=>1, "$UNLESS"=>1},
   "channel_link"=>{"$IF"=>1, "$VAR"=>1}}}

--- rss10.xml.tmpl:
{"link"=>{"$VAR"=>3},
 "name"=>{"$VAR"=>2},
 "Items"=>
  {"$LOOP"=>2,
   "id"=>{"$VAR"=>2},
   "channel_name"=>{"$VAR"=>1},
   "title"=>{"$IF"=>1},
   "title_plain"=>{"$VAR"=>1},
   "link"=>{"$VAR"=>1},
   "content"=>{"$IF"=>1, "$VAR"=>1},
   "date_iso"=>{"$VAR"=>1},
   "author_name"=>{"$IF"=>1, "$VAR"=>1}}}


--- rss20.xml.tmpl:
{"name"=>{"$VAR"=>2},
 "link"=>{"$VAR"=>2},
 "Items"=>
  {"$LOOP"=>1,
   "channel_name"=>{"$VAR"=>1},
   "title"=>{"$IF"=>1},
   "title_plain"=>{"$VAR"=>1},
   "id"=>{"$VAR"=>1},
   "link"=>{"$VAR"=>1},
   "content"=>{"$IF"=>1, "$VAR"=>1},
   "date_822"=>{"$VAR"=>1},
   "author_email"=>{"$IF"=>1, "$VAR"=>2},
   "author_name"=>{"$IF"=>1, "$VAR"=>1}}}
```

