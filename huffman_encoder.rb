CharVal = Struct.new(:char, :frequency) do
  def to_s
    char
  end
end

class Node
  attr_reader :left, :right

  def initialize(lower, higher=nil)
    @left = lower
    @right = higher
  end

  def frequency
    @frequency ||= @left.frequency + @right&.frequency
  end

  def to_s
    "(N)[#{@left}#{@right}]"
  end

  def build_encoding_table(table={}, current_path='')
    if @left.is_a?(Node)
      table = @left.build_encoding_table(table, "#{current_path}0")
    else
      table[@left.char] = "#{current_path}0"
    end

    if @right.is_a?(Node)
      table = @right.build_encoding_table(table, "#{current_path}1")
    else
      table[@right.char] = "#{current_path}1"
    end

    table
  end
end

class HuffmanTree
  attr_reader :encoding_table

  def initialize(root_node)
    @root_node = root_node
    @encoding_table = root_node.build_encoding_table
  end

  def encode(input_string)
    input_string.chars.map { |c| @encoding_table[c] }.join
  end

  def decode(encoded_string)
    all_chars = encoded_string.chars
    result = ''
    until all_chars.empty?
      encoded_item = all_chars.shift
      char = sorted_encodings[encoded_item.length][encoded_item]
      until char
        encoded_item += all_chars.shift
        char = sorted_encodings[encoded_item.length][encoded_item]
      end
      result += char
    end
    result
  end

  private

  def sorted_encodings
    @sorted_encodings ||= @encoding_table.reduce(Hash.new { |h, k| h[k] = {} }) do |sorted, row|
      char, encoding = row
      sorted[encoding.length][encoding] = char
      sorted
    end
  end

  def self.build_from_sorted_list(list)
    fail if list.count.zero?
    if list.count == 1
      return list[0].respond_to?(:left) ? new(list[0]) : new(Node.new(list[0]))
    end
    lower = list.shift
    higher = list.shift
    node = Node.new(lower, higher)
    new_vals = []

    while !list.length.zero? && list[0].frequency < node.frequency
      new_vals.push(list.shift)
    end
    new_vals.push(node)
    new_vals.concat(list)
    build_from_sorted_list(new_vals)
  end
end

class HuffmanEncoder
  def initialize(tree)
    @tree = tree
  end

  def self.encode(input_string)
    build_tree_from_string(input_string).encode(input_string)
  end

  def self.make_encoding_table(input_string)
    build_tree_from_string(input_string).encoding_table
  end

  def self.build_tree_from_string(input_string)
    frequencies = input_string.chars.inject(Hash.new(0)) do |frequency_table, char|
      frequency_table[char] += 1
      frequency_table
    end.map { |a| CharVal.new(*a) }.sort_by(&:frequency)

    HuffmanTree.build_from_sorted_list(frequencies)
  end
end

def is_prefix?(val, other_val)
  other_val.slice(0..val.length - 1) == val
end
