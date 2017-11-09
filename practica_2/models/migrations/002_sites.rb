require 'sequel'

Sequel.extension :migration

Sequel.migration do
  up do
    create_table(:sites) do
      primary_key :id
      varchar :name
      varchar :url
    end
  end

  down do
    drop_table(:users)
  end
end
