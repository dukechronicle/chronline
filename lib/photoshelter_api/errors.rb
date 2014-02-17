class PhotoshelterAPI
  module Errors

    class PhotoshelterError < StandardError
      attr_reader :error_code

      def initialize(error_code)
        super(error_code)
      end
    end

  end
end
