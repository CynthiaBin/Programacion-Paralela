require 'sequel'

Sequel.extension :migration

Sequel.migration do
  up do
    create_table(:user_has_accounts) do
      primary_key :id
      varchar :userName
      varchar :password
      varchar :salt
      foreign_key :userID, :users
      foreign_key :siteID, :sites
    end
  end


  down do
    drop_table(:users)
  end
end
