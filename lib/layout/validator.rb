# This is a custom JSON::Validator that is hacked to perform transformations
# on the data through the validate method.

class Layout
  class Validator < JSON::Validator

    def validate
      @validation_options[:apply_transformations] = {}
      super
      apply_transformations(@validation_options[:apply_transformations])
    end

    private

    def apply_transformations(transformations)
      transformations.each_pair do |trans, pairs|
        paths, items = pairs.first.zip(*pairs.drop(1))  # Sorry to whoever is reading this
        transformed_items = Layout.transform(trans, items)
        paths.zip(transformed_items) do |pair|
          assign_path(@data, pair[0], pair[1])
        end
      end
      @data
    end

    def assign_path(obj, path, value)
      parent = path[0...-1].reduce(obj) do |data, property|
        data.is_a?(Array) ? data[property.to_i] : data[property]
      end
      key = parent.is_a?(Array) ? path.last.to_i : path.last
      parent[key] = value
    end

  end
end
