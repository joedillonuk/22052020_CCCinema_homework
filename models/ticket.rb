require_relative("../db/sql_runner")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id


def initialize(options)
  @id = options['id'].to_i if options['id']
  @customer_id = options['customer_id'].to_i
  @film_id  = options['film_id'].to_i
end

# instance methods
def save()
  sql = "INSERT INTO tickets
  (
    customer_id,
    film_id
  )
  VALUES
  (
    $1, $2
  )
  RETURNING id"
  values = [@customer_id, @film_id]
  ticket = SqlRunner.run( sql,values ).first
  @id = ticket['id'].to_i
end

# updates details of given ticket on CCCinema database
def update # EXTENSION
  sql = "UPDATE tickets SET customer_id = $1, film_id = $2 WHERE id = $3"
  values = [@customer_id, @film_id, @id]
  SqlRunner.run(sql, values)
end

# deletes a given ticket from CCCinema database
def delete() # EXTENSION
  sql = "DELETE FROM films WHERE id = $1"
  values = [@id]
  SqlRunner.run(sql, values)
end


# return the film this ticket is for
def film()
  sql = "SELECT * FROM films WHERE id = $1"
  values = [@film_id]
  pg_result = SqlRunner.run(sql, values)
  film_hash = pg_result[0]
  film = Film.new(film_hash)
  return film
end


# return the customer who bought this ticket
def customer()
  sql = "SELECT * FROM customers WHERE id = $1"
  values = [@customer_id]
  pg_result = SqlRunner.run(sql, values)
  customer_hash = pg_result[0]
  customer = Customer.new(customer_hash)
  return customer
end




# Class methods

def self.all()
  sql = "SELECT * FROM tickets"
  pg_result = SqlRunner.run(sql)
  result = pg_result.map { |ticket| Ticket.new( ticket ) }
  return result
end

def self.delete_all()
  sql = "DELETE FROM tickets"
  SqlRunner.run(sql)
end





end
