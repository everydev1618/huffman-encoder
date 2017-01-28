class Tree
  #AAAABBRKAAA
  def encode(input_string)
  end

  #0110100101010101010
  def decode(encoded_string)
  end
end

class HuffmanEncoder
  def self.build_tree_from_string(raw_string)
    Tree.new
  end

  #BBBKDYYYURKKBBB
  def self.make_encoding_table(raw_string)
    char_count = {}
    #                                    x
    arr_of_chars = raw_string.chars  #[B,A,B,K,D,...]
    arr_of_chars.each do |char| # A
      # if char already exists in hash
      if char_count[char] != nil
        # go to that char position and increment it
        char_count[char] += 1
      else
        # if not, enter key value pair with value of 1
        char_count[char] = 1
      end
    end

    sorted_chars = {}

    arr_from_hash = char_count.sort_by{|k, v| v }.reverse

    binary_num = '0'

    arr_from_hash.each do |arr|
      sorted_chars[arr[0]] = binary_num
      binary_num = '1' << binary_num
    end

    # {"C" => 0,
    #  "B" =>
    # }
    sorted_chars


  end

  #AAAABBRKAAA
  def self.encode(raw_string)
    binary_string = ''
    sorted_chars = make_encoding_table(raw_string)
    arr_of_chars = raw_string.chars
    arr_of_chars.each do |letter|
      binary_string << sorted_chars[letter]
    end
      return binary_string
  end
end
