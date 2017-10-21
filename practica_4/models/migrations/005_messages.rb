require 'sequel'

Sequel.extension :migration

Sequel.migration do
  up do
    create_table(:messages) do
      primary_key :id
      text        :content
      DateTime    :created_at
      foreign_key :queue_id, :queues
    end
  end

  down do
    drop_table(:messages)
  end
end

