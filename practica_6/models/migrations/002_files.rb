require 'sequel'

Sequel.extension :migration

Sequel.migration do
  up do
    create_table(:files) do
      primary_key :id
      varchar :path
      varchar :hash
      varchar :status
      DateTime :updated_at
    end
  end
  down do
    drop_table(:files)
  end
end