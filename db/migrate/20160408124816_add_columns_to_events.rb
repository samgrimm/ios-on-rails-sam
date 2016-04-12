class AddColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :address, :string
    add_column :events, :ended_at, :datetime
    add_column :events, :started_at, :datetime
    add_column :events, :name, :string
    add_column :events, :lat, :float
    add_column :events, :lon, :float
    add_column :events, :user_id, :integer
    add_index :events, :user_id
  end
end
