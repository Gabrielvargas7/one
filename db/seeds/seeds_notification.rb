module SeedNotificationModule

  def self.InsertNotification(ws)
    Notification.delete_all

    # insert the Notification Table
    for row in 1..ws.num_rows
      if ws[row,1]!='id'
        p "Inserting notification id "+ws[row,1] +" name: "+ ws[row,2]
        Notification.create(name:ws[row,2])

      end
    end

  end



end