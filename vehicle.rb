module Towable
  def can_tow?(pounds)
    pounds < 2000
  end
end

class Vehicle
  @@num_vehicles = 0

  attr_accessor :color, :model, :speed
  attr_reader :year

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0

    @@num_vehicles += 1
  end

  def speed_up(speed)
    self.speed += speed
  end
  
  def brake(speed)
    self.speed -= speed
  end
  
  def shut_down
    self.speed = 0
  end

  def spray_paint(new_color)
    self.color = new_color
  end

  def current_speed
    puts "You are going #{speed} mph."
  end

  def self.gas_mileage(gallons, miles)
    miles / gallons
  end
  
  def to_s
    "This is a #{@year} #{model}, currently traveling at #{speed}"
  end

  def age
    "The #{self.model} is #{years_old} years old."
  end

  private
  
  def years_old
    curr_year = Time.now.year
    curr_year - self.year
  end
end

class MyCar < Vehicle
  include Towable
  
  NUM_DOORS = 4

  def initialize(y, c, m)
    super(y, c, m)
  end
end

class MyTruck < Vehicle
  NUM_DOORS = 2

  def initialize(y, c, m)
    super(y, c, m)
  end
end

# puts MyCar.ancestors
# puts MyTruck.ancestors
# puts Vehicle.ancestors

# lumina = MyCar.new(1997, 'chevy lumina', 'white')
# lumina.speed_up(20)
# lumina.current_speed
# lumina.speed_up(20)
# lumina.current_speed
# lumina.brake(20)
# lumina.current_speed
# lumina.brake(20)
# lumina.current_speed
# lumina.shut_down
# MyCar.gas_mileage(13, 351)
# lumina.spray_paint("red")
# puts lumina

# puts lumina.age


class Student
  attr_accessor :name

  def initialize(n, g)
    @name = n
    @grade = g
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected

  attr_reader :grade
end

joe = Student.new('Joe', 85)
bob = Student.new('Bob', 82)
puts "Well done!" if joe.better_grade_than?(bob)
