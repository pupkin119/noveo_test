class CreateQuestionnairies < ActiveRecord::Migration[5.2]
  def change
    create_table :questionnairies do |t|
      t.column :title, :string, null: false
      t.timestamps
    end
  end
end
