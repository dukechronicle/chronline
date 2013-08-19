class PhotoshelterAPI
  module Errors

    class PhotoshelterError < StandardError
      attr_reader :error_code

      def initialize(error_code)
        @error_code = error_code
      end
    end

  end
end
