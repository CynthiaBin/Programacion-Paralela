require 'sequel'

Sequel.extension :migration
Sequel.migration do
  up do
    create_table(:queues) do
      primary_key :id
      varchar :name
    end
  end

  down do
    drop_table(:queues)
  end
end


