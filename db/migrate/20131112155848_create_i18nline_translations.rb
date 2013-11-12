class CreateI18nlineTranslations < ActiveRecord::Migration
  def self.up
    create_table :i18nline_translations do |t|
      t.string :locale
      t.string :key
      t.text   :value
      t.text   :interpolations
      t.boolean :is_proc, :default => false

      t.timestamps
    end
    add_index :i18nline_translations, [:locale, :key], unique: true
  end

  def self.down
    drop_table :i18nline_translations
  end
end
