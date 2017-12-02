require 'sequel'

Sequel.extension :migration

Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      varchar :user_name
      varchar :password
      varchar :salt
    end
  end
  down do
    drop_table(:users)
  end
end
