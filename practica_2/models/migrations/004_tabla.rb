require 'sequel'

Sequel.extension :migration

Sequel.migration do
  up do
    create_table(:tabla) do
      primary_key :id
      varchar :alias
      varchar :name
      varchar :link
    end
  end
  down do
    drop_table(:tabla)
  end
end