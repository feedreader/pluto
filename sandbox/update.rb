require 'newscast'


News.config.database = './news.db'


feeds = INI.load_file( './planet.ini' )
pp feeds

News.subscribe( feeds )
News.update
