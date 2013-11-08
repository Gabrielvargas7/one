class AddStepUniqueToTutorial < ActiveRecord::Migration
  def change
    add_index :tutorials, :step, unique: true
  end
end
