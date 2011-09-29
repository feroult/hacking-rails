# see: http://jonathanleighton.com/articles/2011/awesome-active-record-bug-reports/
require 'test/unit'
require 'ruby-debug'
require 'active_record'

puts "Active Record #{ActiveRecord::VERSION::STRING}"

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Schema.define do
  create_table :products, :force => true do |t|
    t.string  :name
    t.integer :category_id
 
    t.timestamps
  end

  create_table :categories, :force => true do |t|
    t.string  :name
 
    t.timestamps
  end

end

class Product < ActiveRecord::Base
  belongs_to :category
  validates_associated :category, :if => :false_method

  def false_method
    false
  end
end

class Category < ActiveRecord::Base
  validates :name, :presence => true 
end


class BoomTest < Test::Unit::TestCase
  def test_save_ok
    p = Product.new
    p.category = Category.new
    assert p.save
  end
end


