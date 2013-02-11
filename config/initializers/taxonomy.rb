unless Taxonomy.const_defined? :Tree
  File.open(File.join(Rails.root, "config", "taxonomy.yml")) do |file|
    Taxonomy::Tree = YAML.load(file)
  end
end
