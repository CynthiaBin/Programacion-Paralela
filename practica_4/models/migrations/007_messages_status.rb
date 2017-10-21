require 'sequel'

Sequel.extension :migration

Sequel.migration do
  up do
    create_table(:messages_status) do
      primary_key :id
      foreign_key :message_id, :messages
      foreign_key :queue_id, :queues
      foreign_key :subscription_id, :subscriptions
      DateTime :read_at
      bool :shadowed
      bool :processed
    end
  end

  down do
    drop_table(:messages_status)
  end
end
