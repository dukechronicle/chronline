Taxonomy.set_taxonomy_tree(
  :sections,
  YAML.load_file(Rails.root.join('config', 'taxonomy.yml'))
)
