class User
  attr_accessor :name, :age, :gender, :premium

  def initialize(name, age, gender, premium)
    @name = name
    @age = age
    @gender = gender
    @premium = premium || false
  end
end
