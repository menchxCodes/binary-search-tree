require_relative './lib/binary_tree.rb'

tree = Tree.new((Array.new(15) { rand(1..100) }))
tree.pretty_print

puts "\nBalanced?= #{tree.balanced?}"

puts "\nLevel order="
p tree.level_order_recursive

puts "\nPreorder:"
p tree.preorder

puts "\nPostorder:"
p tree.postorder

puts "\nInorder:"
p tree.inorder

(Array.new(10) { rand(100..300) }).each { |val| tree.insert(val)}
puts "\n"
tree.pretty_print
puts "\nBalanced?= #{tree.balanced?}"

puts "\n\nRebalancing..."
tree.rebalance
tree.pretty_print
puts "\nBalanced?= #{tree.balanced?}"

puts "\nLevel order="
p tree.level_order_recursive

puts "\nPreorder:"
p tree.preorder

puts "\nPostorder:"
p tree.postorder

puts "\nInorder:"
p tree.inorder