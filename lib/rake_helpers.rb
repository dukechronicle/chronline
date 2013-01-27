module RakeHelpers

  def find_command(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.each do |ext|
        exe = "#{path}#{File::SEPARATOR}#{cmd}#{ext}"
        return exe if File.executable? exe
      end
    end
    return nil
  end

  module CoreExt
    module String
      def unindent
        return dup.unindent! || self
      end
      def unindent!
        margin = 0
        self.scan(/^[ \t]*/) do |spaces|
          margin = spaces.size if spaces.size > margin
        end
        margin === 0 ? nil : gsub!(/^\s{#{margin}}/, '')
      end
    end
  end

  ::String.class_eval { include CoreExt::String }

end
