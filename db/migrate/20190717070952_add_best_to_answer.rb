
class AddBestToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :best, :boolean
  end
end