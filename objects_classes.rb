# Customise #inspect for useful debugging
class Dog
  def initialize(name, age)
    @name = name
    @age = age * 7 #Compensate for dog years
  end
end

spot = Dog.new("Spot", 2.1)
spot.inspect

class Dog
  def inspect
    "<A Dog named #{@name} who's #{@age} in dog years.>"
  end
end

spot.inspect

# #freeze an object to prevent changes
a = "foo"
a[0] = 99 
# => TypeError
