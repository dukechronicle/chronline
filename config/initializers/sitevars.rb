File.open(Rails.root.join("config", "sitevars.yml")) do |file|
  Sitevar.config.sitevars = YAML.load(file)
  Sitevar.config.redis = promise { $redis }
end
