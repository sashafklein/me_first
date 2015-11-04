$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'me_first'
require 'active_record'
require 'pry'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", 
                                       :database => ":memory:")

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :fake_models, :force => true do |t|
    t.string :name
    t.integer :order
  end
end

class FakeModel < ActiveRecord::Base
  include MeFirst
  attr_orderable :order
end