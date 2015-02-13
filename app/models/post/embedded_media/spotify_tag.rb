class Post
  class EmbeddedMedia
    class SpotifyTag < EmbeddedMedia::Tag
      def initialize(_embedded_media, spotify_uri)
        @uri = spotify_uri
      end

      def self.parse_url(url)
        return nil unless url =~ %r[^https?://open\.spotify\.com/]
        spotify_path = /com\/(.*?)$/.match(url)[1]
        spotify_uri = spotify_path.split('/').reject(&:empty?).join(':')
        self.new(Post::EmbeddedMedia, spotify_uri)
      end

      def to_html
        content_tag(
          :iframe,
          nil,
          width: 300,
          height: 380,
          frameborder: 0,
          allowtransparency: true,
          src: "//embed.spotify.com/?uri=spotify:#{@uri}"
        )
      end

      def to_s
        "{{Spotify:#{@uri}}}"
      end
    end
  end
end
