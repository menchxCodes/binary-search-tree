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
  # Creates a binary search tree from an Array and returns the root.
  def build_tree(array)
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
        # puts 'duplicate value'
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

    has_two_children = !pointer.right.nil? && !pointer.left.nil?

    return nil unless has_two_children

    next_biggest = pointer.right
    previous_next_biggest = pointer
    last_left = false

    until last_left
      if next_biggest.left.nil?
        last_left = true

        # detach next_biggest from previous node if there is a right tree
        previous_next_biggest.left = next_biggest.right unless previous_next_biggest == pointer

        next_biggest.right = pointer.right unless previous_next_biggest == pointer
        next_biggest.left = pointer.left

        unless pointer == root
          case previous <=> next_biggest
          when 1
            previous.left = next_biggest
          when -1
            previous.right = next_biggest
          end
        else
          @root = next_biggest
          return "successfully deleted root #{pointer.value}"
        end

        return "successfully deleted two-child node #{pointer.value}"
      else
        previous_next_biggest = next_biggest
        next_biggest = next_biggest.left
      end
    end
  end

  def level_order_iteration
    queue = []
    queue.push(root)
    result = []
    until queue.empty?
      queue.push(queue.first.left) unless queue.first.left.nil?
      queue.push(queue.first.right) unless queue.first.right.nil?

      node = queue.shift
      block_given? ? yield(node) : result.push(node.value)
    end
    result unless block_given?
  end

  def level_order_recursive(queue = [@root], result = [], &block)
    return result if queue.empty?

    queue.push(queue.first.left) unless queue.first.left.nil?
    queue.push(queue.first.right) unless queue.first.right.nil?

    node = queue.shift
    block_given? ? block.call(node) : result.push(node.value)

    level_order_recursive(queue, result, &block)
  end

  def inorder(pointer = @root, result = [], &block)
    return result if pointer.nil?

    inorder(pointer.left, result, &block)
    block_given? ? block.call(pointer) : result.push(pointer.value)
    inorder(pointer.right, result, &block)
  end

  def preorder(pointer = @root, result = [], &block)
    return result if pointer.nil?

    block_given? ? block.call(pointer) : result.push(pointer.value)
    preorder(pointer.left, result, &block)
    preorder(pointer.right, result, &block)
  end

  def postorder(pointer = @root, result = [], &block)
    return result if pointer.nil?

    postorder(pointer.left, result, &block)
    postorder(pointer.right, result, &block)
    block_given? ? block.call(pointer) : result.push(pointer.value)
  end

  def height(value, node = find(value))
    pointer = node
    count = 0
    until pointer.left.nil? && pointer.right.nil?
      case preorder(pointer.left).size <=> preorder(pointer.right).size
      when 1
        pointer = pointer.left
        count += 1
      when 0
        pointer = pointer.left
        count += 1
      when -1
        pointer = pointer.right
        count += 1
      end
    end
    count
  end

  def depth(value)
    count = 0
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
          count += 1
        end
      # pointer == node
      when 0
        is_found = true
        return count
      # pointer < node
      when -1
        if pointer.left.nil?
          is_found = true
          return nil
        else
          pointer = pointer.left
          count += 1
        end
      end
    end
  end

  def balanced?
    level_order_recursive do |node|
      node.left.nil? ? left_height = 0 : left_height = height(node.left.value)
      node.right.nil? ? right_height = 0 : right_height = height(node.right.value)

      if (left_height - right_height).abs > 1
        return false
      else
        next
      end
    end
    true
  end

  def rebalance
    unless balanced?
      @root = build_tree(self.inorder)
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
