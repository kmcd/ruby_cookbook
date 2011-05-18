

def pick_random_numbers(min, max, limit)
  limit.times { yield min+rand(max+1) }
end

def lottery_style_numbers(&block)
  pick_random_numbers(1, 49, 6, &block)
end

lottery_style_numbers { |n| puts "Lucky number: #{n}" }


class Tree
  # How do you do bredth first, depth first & in-order
  def each
    yield value
    
    @children.each do |child_node|
      child_node.each {|e| yield e }
    end
    
    # yield value here for post order / bottom up
  end
end

class Array
  # Closes in from either end, eg [ 1, 3, 5, 4, 2 ]
  def each_from_both_sides
    front_index = 0
    back_index = length-1
    
    while front_index <= back_index
      yield self[front_index]
      front_index += 1
      
      if front_index <= back_index
        yield self[back_index]
        back_index -= 1
      end
    end
  end
end

module Enumerable
  def each_randomly
    (sort_by { rand }).each { |e| yield e }
  end
end

def interosculate(*enumerables)
  generators = enumerables.collect { |x| Generator.new(x) }
  done = false
  until done
    done = true
    generators.each do |g|

      # How does this switch to the next array?
      if g.next?
        yield g.next
        done = false
      end
    end
  end
end

interosculate(%w{Four and}, %w{score seven years ago}) do |x|
  puts x
end
# Four
# score
# and
# seven
# years
# ago


l = ["junk1", 1, "junk2", 2, "junk3", "junk4", 3, "junk5"]

g = Generator.new do |g|
  l.each { |e| g.yield e unless e =~ /^junk/ } 
end

# Wrap around method
def write_html(out, doctype=nil, &block)
  doctype ||= %{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">}
  out.puts doctype
  out.puts '<html>'
  begin
    out.instance_eval &block
  ensure
    out.puts '</html>'
  end
end

write_html($stdout) do
  puts '<h1>Sorry, the Web is closed.</h1>'
end

module EventDispatcher
  def self.included(klass)
    klass.instance_eval do
      alias initialize original_initialize
      
      def initialize(*args, &block)
        original_initialize(args, &block)
        setup_listeners
      end
    end
  end
  
  def setup_listeners
    @event_dispatcher_listeners = {}
  end
  
  def subscribe(event, &callback)
    (@event_dispatcher_listeners[event] ||= []) << callback
  end
  
  protected
  
  def notify(event, *args)
    return unless @event_dispatcher_listeners[event]
    
    @event_dispatcher_listeners[event].each do |m|
      next unless m.respond_to? :call
      yield m.call(*args) 
    end
    
    nil
  end
end

class Factory
  include EventDispatcher
  
  def produce_widget(color)
    #Widget creation code goes here...
    notify(:new_widget, color)
  end
end

class WidgetCounter
  def initialize(factory)
    @counts = Hash.new(0)
    
    factory.subscribe(:new_widget) do |color|
      # This block is added to event_dispatcher_listeners[:new_widget]
      @counts[color] += 1
      puts "#{@counts[color]} #{color} widget(s) created since I started watching."
    end
  end
end
