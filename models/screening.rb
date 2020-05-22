require_relative("../db/sql_runner")

class Screening

attr_reader :id
attr_accessor :screening_time, :total_tickets


def initialize(options)
  @id = options['id'].to_i if options['id']
  @screening_time = options['title']
  @total_tickets = options['price'].to_i
end
