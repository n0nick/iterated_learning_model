class Utils
  # http://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Longest_common_substring#Ruby
  def self.longest_common_substring(s1, s2)
    if (s1 == "" || s2 == "")
      return ""
    end
    m = Array.new(s1.length){ [0] * s2.length }
    longest_length, longest_end_pos = 0,0
    (0 .. s1.length - 1).each do |x|
      (0 .. s2.length - 1).each do |y|
        if s1[x] == s2[y]
          unless Utils.is_digit(s1[x])
            m[x][y] = 1
            if (x > 0 && y > 0)
              m[x][y] += m[x-1][y-1]
            end
            if m[x][y] > longest_length
              longest_length = m[x][y]
              longest_end_pos = x
            end
          end
        end
      end
    end
    return s1[longest_end_pos - longest_length + 1 .. longest_end_pos]
  end

  def self.is_digit(c)
    (c =~ /[0-9]/) == 0
  end
end
