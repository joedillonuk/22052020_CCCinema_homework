require_relative("../db/sql_runner")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end





# instance methods
def save()
  sql = "INSERT INTO customers
  (
    name,
    funds
  )
  VALUES
  (
    $1, $2
  )
  RETURNING id"
  values = [@name, @funds]
  customer = SqlRunner.run( sql,values ).first
  @id = customer['id'].to_i
end

# updates details of given customer on CCCinema database
def update # EXTENSION
  sql = "UPDATE customers SET name = $1, funds = $2 WHERE id = $3"
  values = [@name, @funds, @id]
  SqlRunner.run(sql, values)
end

# deletes a given customer from CCCinema database
def delete() # EXTENSION
  sql = "DELETE FROM customers WHERE id = $1"
  values = [@id]
  SqlRunner.run(sql, values)
end


# return all films a customer has bought tickets for
def films()
    sql = " SELECT films.*
              FROM films
              INNER JOIN tickets ON tickets.film_id = films.id
              WHERE customer_id = $1"
    values = [@id]
    pg_result = SqlRunner.run(sql, values)
    films = pg_result.map{|film_hash| Film.new(film_hash)}
    return films
  end



  # Class methods

  def self.all()
    sql = "SELECT * FROM customers"
    pg_result = SqlRunner.run(sql)
    result = pg_result.map { |customer| Customer.new( customer ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end









end
