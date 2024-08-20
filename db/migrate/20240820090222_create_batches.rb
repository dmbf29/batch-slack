class CreateBatches < ActiveRecord::Migration[7.1]
  def change
    create_table :batches do |t|
      t.integer :number
      t.date :start_date
      t.date :end_date
      t.string :slack_channel
      t.boolean :data_science
      t.boolean :part_time

      t.timestamps
    end
  end
end
