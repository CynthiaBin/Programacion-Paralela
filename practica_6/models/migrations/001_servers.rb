require 'sequel'

Sequel.extension :migration

Sequel.migration do
  up do
    create_table(:servers) do
      primary_key :id
      varchar :uri
    end
  end
  down do
    drop_table(:servers)
  end
end
