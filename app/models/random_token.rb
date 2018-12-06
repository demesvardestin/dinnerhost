class RandomToken
    def self.random(len=32, character_set = ["A".."Z", "a".."z", "0".."9"])
        chars = character_set.map{|x| x.is_a?(Range) ? x.to_a : x }.flatten
        Array.new(len){ chars.sample }.join
    end
end