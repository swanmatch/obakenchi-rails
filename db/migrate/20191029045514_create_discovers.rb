class CreateDiscovers < ActiveRecord::Migration[5.2]
  def change
    create_table :discovers do |t|
      t.datetime :obs_at
      t.integer :trigger
      t.boolean :human
      t.integer :magnetic_vol
      t.integer :lumen_vol
      t.integer :temp_vol

      t.integer :lock_version, default: 0, null: false
      t.integer :created_by
      t.integer :updated_by
      t.integer :deleted_by

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
