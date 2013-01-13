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
        unindent_base false
      end

      def unindent!
        unindent_base true
      end

      private

      def unindent_base(in_place = false)
        m_first = nil
        m_min = nil
        self.scan(/^[ \t]*/) do |m|
          ms = m.size
          m_first ||= ms
          m_min = ms if !m_min || ms < m_min
          # break if ms == 0 ## only worth if the probability of marginless line above certain threshold
        end
        if m_first != m_min && warn_first_not_min
          puts "warning: margin of the first line differs from minimum margin"
        end
        return in_place ? nil : self.dup unless m_min > 0
        re = Regexp.new('^\s{' + m_min.to_s + '}'  )
        in_place ? gsub!(re, '') : gsub(re, '')
      end
    end
  end

  ::String.class_eval { include CoreExt::String }

end
