require 'sequel'

Sequel.extension :migration

Sequel.migration do
  up do
    create_table(:subscriptions) do
      primary_key :id
      foreign_key :queue_id, :queues
      foreign_key :user_id, :users
    end
  end

  down do
    drop_table(:subscriptions)
  end
end
