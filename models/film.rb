require_relative("../db/sql_runner")

class Film

attr_reader :id
attr_accessor :title, :price, :total_tickets, :screening_time

def initialize(options)
  @id = options['id'].to_i if options['id']
  @title = options['title']
  @price = options['price'].to_i
  @total_tickets = options['total_tickets'].to_i
  @screening_time = options['screening_time'].to_i
end

# instance methods
def save()
  sql = "INSERT INTO films
  (
    title,
    price,
    total_tickets,
    screening_time
  )
  VALUES
  (
    $1, $2, $3, $4
  )
  RETURNING id"
  values = [@title, @price, @total_tickets, @screening_time]
  film = SqlRunner.run( sql,values ).first
  @id = film['id'].to_i
end

# updates details of given film on CCCinema database
def update # EXTENSION
  sql = "UPDATE films SET title = $1, price = $2, total_tickets = $3, screening_time = $4 WHERE id = $5"
  values = [@title, @price, @total_tickets, @screening_time, @id]
  SqlRunner.run(sql, values)
end

# deletes a given film from CCCinema database
def delete() # EXTENSION
  sql = "DELETE FROM films WHERE id = $1"
  values = [@id]
  SqlRunner.run(sql, values)
end

# returns all customers who've bought tickets for a given film
def customers()
  sql = " SELECT customers.*
  FROM customers
  INNER JOIN tickets ON customer_id = customers.id
  WHERE tickets.film_id = $1"
  values = [@id]
  pg_result = SqlRunner.run(sql, values)
  customers = pg_result.map{|customer_hash| Customer.new(customer_hash)}
  return customers
end



# Class methods

def self.all()
  sql = "SELECT * FROM films"
  pg_result = SqlRunner.run(sql)
  result = pg_result.map { |film| Film.new( film ) }
  return result
end

def self.delete_all()
  sql = "DELETE FROM films"
  SqlRunner.run(sql)
end









end