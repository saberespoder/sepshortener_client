$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shorten_url_client'

require 'minitest/autorun'

class Object
  def metaclass
    class << self; self; end
  end

  def self.stub_method_chain(chain, &blk)
    chain = chain.split('.') if chain.is_a? String
    metaclass.instance_eval do
      define_method chain.first do |*values|
        Object.new.tap do |o|
          o.stub_method_chain chain.slice(1..-1), &blk
        end
      end
    end
  end
  
  def stub_method_chain(chain, &blk)
    chain = chain.split('.') if chain.is_a? String
    metaclass.instance_eval do
      define_method chain.first do |*values|
        if chain.size == 1
          blk.call *values
        else
          Object.new.tap do |o|
            o.stub_method_chain chain.slice(1..-1), &blk
          end
        end
      end
    end
  end
end
