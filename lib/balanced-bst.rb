class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value = nil, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  def <=>(other)
    value <=> other.value
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    #-TODO-

    if array.length == 1
      node = Node.new(array[0])
      return node
    end

    mid = array.length / 2

    array_left = array[0..mid - 1]
    left = build_tree(array_left) unless array_left.empty?

    array_right = array[mid + 1..array.length]
    right = build_tree(array_right) unless array_right.empty?

    node = Node.new(array[mid], left, right)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
# --tests--
test = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

tree = Tree.new(test)
tree.pretty_print
