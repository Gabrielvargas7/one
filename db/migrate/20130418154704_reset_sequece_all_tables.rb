class ResetSequeceAllTables < ActiveRecord::Migration
  def up
    connection.execute(%q{
            select setval('themes_id_seq', max(id))
            from themes
        })

    connection.execute(%q{
            select setval('items_id_seq', max(id))
            from items
        })
    connection.execute(%q{
            select setval('items_designs_id_seq', max(id))
            from items_designs
        })
    connection.execute(%q{
            select setval('bundles_id_seq', max(id))
            from bundles
        })
    connection.execute(%q{
            select setval('bundles_bookmarks_id_seq', max(id))
            from bundles_bookmarks
        })
    connection.execute(%q{
            select setval('bookmarks_id_seq', max(id))
            from bookmarks
        })
    connection.execute(%q{
            select setval('bookmarks_categories_id_seq', max(id))
            from bookmarks_categories
        })

  end

  def down
  end
end
