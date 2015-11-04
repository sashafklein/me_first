require 'me_first/version'

module MeFirst

  module ClassMethods

    def attr_orderable(*attrs)
      attrs.each do |att|

        metaclass.instance_eval do 
          define_method "by_#{att}" do
            self.order(att => :asc)
          end

          define_method "by_reverse_#{att}" do
            self.order(att => :desc)
          end
        end

        class_eval do 
          define_method "move_#{att}_to_end!" do
            others = self.class.send("by_#{att}").where.not(id: self.id).to_a
            
            save_to_db( others.concat([self]), att)
          end

          define_method "set_#{att}!" do |new_order|
            new_order = 0 if new_order < 0
            
            others = self.class.send("by_#{att}").where.not(id: self.id).to_a

            if new_order > others.length + 1
              self.send("move_#{att}_to_end!")
            else
              others.insert( new_order, self )

              save_to_db( others, att )
            end
          end

          define_method "move_#{att}_to_beginning!" do 
            send("set_#{att}!", 0)
          end

          define_method "move_#{att}_up!" do |num=1|
            send("set_#{att}!", self.order + num)
          end

          define_method "move_#{att}_down!" do |num=1|
            send("set_#{att}!", self.order - num)
          end

          define_method "save_to_db" do |items, att|
            ActiveRecord::Base.transaction do 
              items.compact.each_with_index do |item, index|
                item.send( "#{att}=", index )
                item.save!
              end
            end
          end

          private :save_to_db
        end

      end
    end

    def metaclass
      class << self; self; end
    end
  end
  
  def self.included(base)
    base.extend ClassMethods
  end
end