# https://gist.github.com/dignoe/2485272

module ActionController

  class Metal
    attr_internal :cached_content_for
  end

  module Caching
    module Actions
      def _save_fragment(name, options)
        return unless caching_allowed?

        content = response_body
        content = content.join if content.is_a?(Array)
        content = cached_content_for.merge(:layout => content) if cached_content_for.is_a?(Hash)

        write_fragment(name, content, options)
      end
    end

    module Fragments
      def write_fragment_with_content_to_cache(key, content, options = nil)
        # return_content = write_fragment_without_content_to_cache(key, content, options)
        #         return_content.is_a?(Hash) ? return_content[:layout] : return_content

        return content unless cache_configured?

        key = fragment_cache_key(key)
        instrument_fragment_cache :write_fragment, key do
          cache_store.write(key, content, options)
        end
        content.is_a?(Hash) ? content[:layout] : content
      end

      def read_fragment_with_content_to_cache(key, options = nil)
        result = read_fragment_without_content_to_cache(key, options)
        if (result.is_a?(Hash))
          result = result.dup if result.frozen?
          fragment = result.delete(:layout)
          self.cached_content_for = {}.merge(result)#(self.cached_content_for || {}).merge(result)
          result = fragment
        end

        result.respond_to?(:html_safe) ? result.html_safe : result
      end

      alias_method_chain :write_fragment, :content_to_cache
      alias_method_chain :read_fragment, :content_to_cache
    end
  end
end

module ActionView

  class TemplateRenderer < AbstractRenderer

    # Added to support implementation of action caching
    def render_template_with_cached_content_for(template, layout_name = nil, locals = {})
      controller = @view.controller
      if controller.respond_to?('caching_allowed?') && controller.caching_allowed? && controller.is_a?(ApplicationController)
        controller.cached_content_for.each { |k, v| @view.content_for(k, v) unless @view.content_for?(k) } if controller.cached_content_for.is_a?(Hash)
        return_value = render_template_without_cached_content_for(template, layout_name, locals)
        controller.cached_content_for = @view.content_to_cache
      elsif
        return_value = render_template_without_cached_content_for(template, layout_name, locals)
      end
      return_value
    end

    alias_method_chain :render_template, :cached_content_for
  end

  module Helpers
    module CaptureHelper
      # Added to support implementation of fragment caching
      def cache_with_content_for #:nodoc:#
        @_content_for_to_cache = Hash.new { |h,k| h[k] = ActiveSupport::SafeBuffer.new }
        yield
      ensure
        @_content_for_to_cache = nil
      end

      # Added to support implementation of action caching
      def content_to_cache #:nodoc:#
        cache_this = @_content_for_to_cache || @view_flow.content.except(:layout)
        # cache_this = @view_flow.except(:layout)
        cache_this.dup.tap {|h| h.default = nil }
      end

      # Overwrite content_for to support fragment caching
      def content_for(name, content = nil, &block)
        content = capture(&block) if block_given?
        if content
          @_content_for_to_cache[name] << content if @_content_for_to_cache
          @view_flow.append(name, content)
          nil
        else
          @view_flow.get(name)
        end
      end
    end

    module CacheHelper
      def fragment_for(name = {}, options = nil, &block) #:nodoc:
        if fragment = controller.read_fragment(name, options)
          controller.cached_content_for.each { |k, v| content_for(k, v) } if controller.cached_content_for.is_a?(Hash)
          fragment
        else
          pos = output_buffer.length
          hash_to_cache = nil
          cache_with_content_for do
            yield
            output_safe = output_buffer.html_safe?
            fragment = output_buffer.slice!(pos..-1)
            if output_safe
              self.output_buffer = output_buffer.class.new(output_buffer)
            end
            hash_to_cache = {:layout => fragment}.merge(@_content_for_to_cache)
          end
          controller.write_fragment(name, hash_to_cache, options)
        end
      end
    end
  end
end
