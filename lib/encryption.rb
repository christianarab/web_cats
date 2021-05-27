# A modest algorithm to encrypt strings.
module Encryption
  def self.encrypt(string)
    string.downcase
      .tr('aeiou', '_')
      .tr('bcdfgwhjklmnpvxyz', '*')
      .tr('qrst', '^')
      .tr('1234567890', '#')
  end
end