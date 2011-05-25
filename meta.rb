s = "sample string"
replacements = { "a" => "i", "tring" => "ubstitution" }

# WTF - how is gsub called with replacements key/value entries?

replacements.collect(&s.method(:gsub))
# => ["simple string", "sample substitution"]

# Fix a bug by overwriting the incorrect implementation
class Multiplier
  def double_your_pleasure(pleasure)
    return pleasure * 3 # FIXME: Actually triples your pleasure.
  end
end
m = Multiplier.new
m.double_your_pleasure(6)

class Multiplier
  alias :double_your_pleasure_BUGGY :double_your_pleasure
  def double_your_pleasure(pleasure)
    return pleasure * 2
  end
end

# Define the class methods method_added, method_removed, and/or method_undefined.
# Whenever the class gets a method added, removed, or undefined, Ruby will pass its
# symbol into the appropriate callback method.

class Module
  alias_method :include_no_hook, :include
  
  def include(*modules)
    include_no_hook(*modules) # Run the old implementation.
    modules.each {|mod| self.included mod } # Then run the hook.
  end
  
  def included
    # Do nothing by default, just like Module#method_added et al.
    # This method must be overridden in a subclass to do something useful.
  end
end

class Tracker
  def self.included(mod)
    puts %{"#{mod}" was included in #{self}.}
  end
end

class Tracker
  include Enumerable
end

class String
  def method_missing(name, *args)
    puts name.to_s.gsub(/^puts_/,'') if name.to_s =~ /^puts_(.*)$/
  end
end

class Object
  private
  def set_instance_variables(binding, *variables)
    variables.each do |var|
      instance_variable_set("@#{var}", eval(var, binding))
    end
  end
end

class Foo
  initialize_with :writer => [:bar, :baz], :reader => :bar
end

class Object
  def self.initialize_with(options)
    [ options[:reader] ].flatten.each {|attribute| attr_reader attribute }
    [ options[:writer] ].flatten.each {|attribute| attr_writer attribute }
  end
end

class Foo
  initialize_with :writer => [:bar, :baz], :reader => :bar
end

def broken_print_variable(var_name)
  eval %{puts "The value of #{var_name} is " + #{var_name}.to_s}
end

tin_snips = 5
broken_print_variable('tin_snips')

var_name = 'tin_snips'
eval %{puts "The value of #{var_name} is " + #{var_name}.to_s}


def print_variable(var_name, binding)
  eval %{puts "The value of #{var_name} is " + #{var_name}.to_s}, binding
end

print_variable 'tin_snips'

# A Binding object is a bookmark of the Ruby interpreter’s state. It tracks the values of
# any local variables you have defined, whether you are inside a class or method defini-
# tion, and so on.
#
# Once you have a Binding object, you can pass it into eval to run code in the same
# context as when you created the Binding. All the local variables you had back then
# will be available. If you called Kernel#binding within a class definition, you’ll also be
# able to define new methods of that class, and set class and instance variables.
#
# Since a Binding object contains references to all the objects that were in scope when
# it was created, those objects can’t be garbage-collected until both they and the
# Binding object have gone out of scope.

class String
  alias :length :size
end

# Use wrap around mehtod instead of AspectR
# WTF - blowing up all over the place
class Array
  alias_method :size_original, :size
  
  def size
    puts "Pre"
    # size_original
  end
end
