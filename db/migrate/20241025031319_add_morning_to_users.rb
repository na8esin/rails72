class AddMorningToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :morning, :boolean
  end
end
