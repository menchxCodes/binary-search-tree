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

  def insert(value)
    is_inserted = false
    pointer = root
    node = Node.new(value)
    until is_inserted
      case node <=> pointer
      # pointer > node
      when 1
        if pointer.right.nil?
          pointer.right = node
          is_inserted = true
        else
          pointer = pointer.right
        end
      # pointer == node
      when 0
        puts 'duplicate value'
        is_inserted = true
      # pointer < node
      when -1
        if pointer.left.nil?
          pointer.left = node
          is_inserted = true
        else
          pointer = pointer.left
        end
      end
    end
  end

  def find(value)
    is_found = false
    pointer = root
    node = Node.new(value)
    until is_found
      case node <=> pointer
      # pointer > node
      when 1
        if pointer.right.nil?
          is_found = true
          return nil
        else
          pointer = pointer.right
        end
      # pointer == node
      when 0
        is_found = true
        return pointer
      # pointer < node
      when -1
        if pointer.left.nil?
          is_found = true
          return nil
        else
          pointer = pointer.left
        end
      end
    end
  end

  def delete(value)
    #--TODO
    node = find(value)
    return nil if node.nil?

    is_found = false
    pointer = root
    previous = root

    until is_found
      case node <=> pointer
      # pointer > node
      when 1
        previous = pointer
        pointer = pointer.right
      # pointer == node
      when 0
        is_found = true
      # pointer < node
      when -1
        previous = pointer
        pointer = pointer.left
      end
    end
    # delete node is a leaf
    is_leaf = pointer.right.nil? && pointer.left.nil?
    if is_leaf
      if previous < pointer
        previous.right = nil
      else
        previous.left = nil
      end
      return "successfully deleted leaf #{pointer.value}"
    end
    # delete node has 1 child
    has_one_left_child = pointer.right.nil? && !pointer.left.nil? || !pointer.right.nil? && pointer.left.nil?
    has_one_right_child = !pointer.right.nil? && pointer.left.nil?

    if has_one_left_child
      if previous < pointer
        previous.right = pointer.left
      else
        previous.left = pointer.left
      end
      return "successfully deleted one-child node #{pointer.value}"
    end

    if has_one_right_child
      if previous < pointer
        previous.right = pointer.right
      else
        previous.left = pointer.right
      end
      return "successfully deleted one-child node #{pointer.value}"
    end
    # delete two child node
    # --TODO

    has_two_children = !pointer.right.nil? && !pointer.left.nil?

    return unless has_two_children

    next_biggest = pointer.right
    previous_next_biggest = pointer

    last_left = false

    until last_left
      if next_biggest.left.nil?
        last_left = true

        if next_biggest.right.nil?
          previous_next_biggest.left = nil
          next_biggest.left = pointer.left
          next_biggest.right = pointer.right

          if previous < pointer
            previous.right = next_biggest
          else
            previous.left = next_biggest
          end
        end
      else
        previous_next_biggest = next_biggest
        next_biggest = next_biggest.left
      end
      return "successfully deleted two-child node #{pointer.value}"
    end
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
# tree.insert(23)

p tree.delete(1)
tree.pretty_print
p tree.delete(4)
tree.pretty_print
