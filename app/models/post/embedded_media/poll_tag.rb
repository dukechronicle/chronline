class Post
  class EmbeddedMedia
    class PollTag < self::Tag
      def initialize(embedded_media, poll_id)
        @poll_id = poll_id
      end

      def to_html
        content_tag(
          :div,
          content_tag(
            :div,
            nil,
            class: 'poll',
            'data-poll-id' => @poll_id
          ),
          class: 'poll-container'
        )
      end

      def to_s
        "{{Poll:#{@poll_id}}}"
      end

      def full_width?
        false
      end
    end
  end
end
