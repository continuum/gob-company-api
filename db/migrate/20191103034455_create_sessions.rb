class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.string :email
      t.string :password
      t.string :token

      t.timestamps
    end
  end
end
