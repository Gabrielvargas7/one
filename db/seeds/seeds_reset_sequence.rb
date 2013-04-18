module SeedResetSequence

   # In postgre db we need to reset the autoincrement of the id because
   # we insert the id of the tables manualy

   def self.ResetSequenceOnPostgreDb

     ActiveRecord::Base.connection.execute(%q{
            select setval('themes_id_seq', max(id))
            from themes
        })

     ActiveRecord::Base.connection.execute(%q{
            select setval('items_id_seq', max(id))
            from items
        })
     ActiveRecord::Base.connection.execute(%q{
            select setval('items_designs_id_seq', max(id))
            from items_designs
        })
     ActiveRecord::Base.connection.execute(%q{
            select setval('bundles_id_seq', max(id))
            from bundles
        })
     ActiveRecord::Base.connection.execute(%q{
            select setval('bundles_bookmarks_id_seq', max(id))
            from bundles_bookmarks
        })
     ActiveRecord::Base.connection.execute(%q{
            select setval('bookmarks_id_seq', max(id))
            from bookmarks
        })
     ActiveRecord::Base.connection.execute(%q{
            select setval('bookmarks_categories_id_seq', max(id))
            from bookmarks_categories
        })


  end

end

