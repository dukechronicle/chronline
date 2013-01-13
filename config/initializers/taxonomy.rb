unless Rails.env.test?
  Settings.add_source! "#{Rails.root}/config/taxonomy.yml"
  Settings.reload!
end
