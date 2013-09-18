class Grammar < Hash
  def learn(left_hand, right_hand)
    self[left_hand.to_sym] = right_hand
  end

  def lookup(left_hand)
    self[left_hand.to_sym]
  end
end


