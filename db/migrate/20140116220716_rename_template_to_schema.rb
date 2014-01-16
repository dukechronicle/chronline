class RenameTemplateToSchema < ActiveRecord::Migration
  def change
    rename_column :pages, :layout_template, :layout_schema
  end
end
