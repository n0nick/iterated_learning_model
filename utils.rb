class Utils
  # adopted from http://stackoverflow.com/a/2158481/107085
  def self.longest_common_substr(strings, disallow = nil)
    shortest = strings.min_by(&:length)
    maxlen = shortest.length
    maxlen.downto(0) do |len|
      0.upto(maxlen - len) do |start|
        substr = shortest[start, len]
        if disallow.nil? || (substr =~ disallow) == nil
          return substr if strings.all? { |str| str.include? substr }
        end
      end
    end
  end
end
