class CreateClippings < ActiveRecord::Migration
  def change
    create_table :clippings do |t|
      t.string :clipping_title
      t.text :clipping_description
      t.text :clipping_url

      t.timestamps null: false
    end
  end
end
