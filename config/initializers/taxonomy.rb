if Settings.taxonomy.nil?
  Settings.add_source! File.join(Rails.root, "config", "taxonomy.yml")
  Settings.reload!
end
