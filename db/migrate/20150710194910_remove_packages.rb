class RemovePackages < ActiveRecord::Migration
  def up
    rename_column :products, :package_id, :reviewable_id
    add_column :products, :reviewable_type, :string

    sql = <<-EOS
      UPDATE products AS pr
      SET reviewable_id = pa.reviewable_id,
          reviewable_type = pa.reviewable_type
      FROM packages AS pa
      WHERE pa.id = pr.reviewable_id
    EOS
    ActiveRecord::Base.connection.execute(sql)


    drop_table :packages
  end

   def down
     raise ActiveRecord::IrreversibleMigration
   end
end
