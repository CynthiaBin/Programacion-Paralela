require 'sequel'

Sequel.extension :migration

Sequel.migration do
  up do
    create_table(:user_has_accounts) do
      primary_key :id
      varchar :user_name
      varchar :password
      varchar :salt
      foreign_key :user_id, :users
      foreign_key :site_id, :sites
    end
  end

  down do
    drop_table(:users)
  end
end
