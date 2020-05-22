require_relative("../db/sql_runner")

class Screening

attr_reader :id
attr_accessor :screening_time, :total_tickets, :film_id


def initialize(options)
  @id = options['id'].to_i if options['id']
  @screening_time = options['screening_time'].to_i
  @total_tickets = options['total_tickets'].to_i
  @film_id  = options['film_id'].to_i
end


# instance methods
def save()
  sql = "INSERT INTO screenings
  (
    screening_time,
    total_tickets,
    film_id
  )
  VALUES
  (
    $1, $2, $3
  )
  RETURNING id"
  values = [@screening_time, @total_tickets, @film_id]
  screening = SqlRunner.run( sql,values ).first
  @id = screening['id'].to_i
end




# updates details of given screening on CCCinema database
def update # EXTENSION
  sql = "UPDATE screenings SET screening_time = $1, total_tickets = $2, film_id = $3 WHERE id = $4"
  values = [@screening_time, @total_tickets, @film_id, @id]
  SqlRunner.run(sql, values)
end

# deletes a given screening from CCCinema database
def delete() # EXTENSION
  sql = "DELETE FROM screenings WHERE id = $1"
  values = [@id]
  SqlRunner.run(sql, values)
end

# return the film this screening is for
def film()
  sql = "SELECT * FROM films WHERE id = $1"
  values = [@film_id]
  pg_result = SqlRunner.run(sql, values)
  film = Film.new(pg_result.first)
  return film
end



# Class methods

def self.all()
  sql = "SELECT * FROM screenings"
  pg_result = SqlRunner.run(sql)
  result = pg_result.map { |screening| Screening.new( screening ) }
  return result
end

def self.delete_all()
  sql = "DELETE FROM screenings"
  SqlRunner.run(sql)
end










end
