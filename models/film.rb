require_relative("../db/sql_runner")

class Film

attr_reader :id
attr_accessor :title, :price

def initialize(options)
  @id = options['id'].to_i if options['id']
  @title = options['title']
  @price = options['price'].to_i
end

# instance methods
def save()
  sql = "INSERT INTO films
  (
    title,
    price
  )
  VALUES
  (
    $1, $2
  )
  RETURNING id"
  values = [@title, @price]
  film = SqlRunner.run( sql,values ).first
  @id = film['id'].to_i
end

# updates details of given film on CCCinema database
def update # EXTENSION
  sql = "UPDATE films SET title = $1, price = $2 WHERE id = $3"
  values = [@title, @price, @id]
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

# returns the total number of customers for a given film
def customer_total()
  result = self.customers()
  return result.count
end



# returns the screening of a given film with the max number of tickets sold
def most_popular()
  sql = " SELECT screening_id,
  COUNT(*) AS Frequency
  FROM tickets WHERE tickets.film_id = $1
  GROUP BY screening_id"
  values = [@id]
  pg_result = SqlRunner.run(sql, values)

  # if gate to return string if no tickets have been sold for a particular film
  if  pg_result.count == 0
    return "No tickets have been sold for #{@title} so far."
end

# storing number of occurences of a particular screening as variables
tickets_sold = pg_result[0]['frequency']
  screening_id =  pg_result[0]['screening_id'].to_i

# SQL query to return the time of the screening the above screening_id refers to
sql = " SELECT screenings.*
FROM screenings
WHERE screenings.id = $1"
values = [screening_id]
pg_result = SqlRunner.run(sql, values)
screening = pg_result[0]

# returning result as string.
  return "The most popular screening for #{@title} is at #{screening['screening_time']} with #{tickets_sold} tickets sold."
end

# SELECT screening_id, COUNT(*) AS Frequency
# FROM tickets WHERE tickets.film_id = 33
# GROUP BY screening_id

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
