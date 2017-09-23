require 'sequel'

Sequel.extension :migration

Sequel.migration do
    up do
      create_table(:users) do
        primary_key :id
        varchar :userName
        varchar :email
      end
    end
    down do
        drop_table(:users)
      end
end

