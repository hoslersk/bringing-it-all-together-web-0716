require 'pry'
class Dog

  attr_accessor :name, :breed, :id
  #attr_reader :id

  def initialize(name: name, breed: breed, id: nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT);")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS dogs;")
  end

  def save
    DB[:conn].execute("INSERT INTO dogs (name, breed) VALUES (?, ?);", self.name, self.breed)
    results = DB[:conn].execute("SELECT dogs.id FROM dogs ORDER BY dogs.id DESC LIMIT 1")
    @id = results[0][0]
    self
  end

  def self.create(argument)#{:name=>"Ralph", :breed=>"lab"}
    #binding.pry
    dog = self.new(argument)
    dog.save
  end

  def self.find_by_id(id)
    results = DB[:conn].execute("SELECT * FROM dogs WHERE dogs.id = ?", id)

    if results[0][0] == id
      #binding.pry
      dog = self.create(name: results[0][1], breed: results [0][2])
      dog.id = results[0][0]
      # @name =  results[0][1]
      # @breed = results[0][2]
      dog
    end
    #dog
  end

  def self.find_or_create_by(argument)#{:name=>"teddy", :breed=>"cockapoo"}
    #binding.pry
    results = DB[:conn].execute("SELECT * FROM dogs WHERE dogs.name = ? AND dogs.breed = ?;", argument[:name], argument[:breed])
    if results.empty?
    #if DB[:conn].execute("SELECT * FROM dogs WHERE dogs.name = ? AND dogs.breed = ?;", name, breed) == nil
      self.create(argument)
    else
      #results = DB[:conn].execute("SELECT * FROM dogs WHERE dogs.name = ? AND dogs.breed = ?;", name, breed)
      dog = self.new(argument)
      dog.id = results[0][0]
      #dog.save
      dog
    end
  end

  def self.new_from_db(row)
    #binding.pry
    dog = self.new
    dog.name = row[1]
    dog.breed = row[2]
    dog.id = row[0]
    dog
  end

  def self.find_by_name(name)
    #binding.pry
    results = DB[:conn].execute("SELECT * FROM dogs WHERE dogs.name = ?", name)
    dog = self.new
    dog.name = results[0][1]
    dog.breed = results[0][2]
    dog.id = results[0][0]
    dog
  end

  def update
    #binding.pry
    DB[:conn].execute("UPDATE dogs SET name = ?, breed = ? WHERE id = ?", self.name, self.breed, self.id)
  end

end
