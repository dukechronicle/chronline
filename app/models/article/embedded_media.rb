require 'set'

class Article::EmbeddedMedia

  def initialize(body)
    @body = body
  end

  def render_media()
    tag_list = @body.scan(/{{([a-zA-z]*):([0-9]*)}} ?/).to_a
    tags = []
    unless tag_list.empty?
      tag_list.each do |tag_data|
        case tag_data[0]
        when 'Image'
          tags.push EmbeddedImageTag.new(tag_data[1])
        end
      end
    end

    class_ids_hash = map_class_to_ids(tags)

    class_objects = get_class_objects(class_ids_hash)

    @body.gsub!(/{{([a-zA-z]*):([0-9]*)}} ?/) do |t|
      tag = tags.shift
      tag.to_html(class_objects)
    end
  end

  def to_s
    @body
  end

  private

  def map_class_to_ids(tags)
    class_ids_hash = {}
    tags.each do |tag|
      tag.ids.each do |id|
        unless class_ids_hash.has_key? id[:class]
          class_ids_hash[id[:class]] = Set.new
        end
        class_ids_hash[id[:class]].add id[:id]
      end
    end
    class_ids_hash.keys.each do |key|
      class_ids_hash[key] = class_ids_hash[key].to_a
    end
    class_ids_hash
  end

  def get_class_objects(class_ids_hash)
    class_objects = {}
    class_ids_hash.keys.each do |class_sym|
      objs = class_sym.to_s.constantize.find_all_by_id(class_ids_hash[class_sym])
      objs.each do |obj|
        unless class_objects.has_key? class_sym
          class_objects[class_sym] = {}
        end
        class_objects[class_sym][obj.id] = obj
      end
    end
    class_objects
  end

end
