require_relative( 'models/customer' )
require_relative( 'models/film' )
require_relative( 'models/ticket' )
require_relative( 'models/screening' )


require( 'pry-byebug' )

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

customer1 = Customer.new({ 'name' => 'Steven Toast', 'funds' => 25})
customer1.save()
customer2 = Customer.new({ 'name' => 'Ray Purchase', 'funds' => 50})
customer2.save()
customer3 = Customer.new({ 'name' => 'Jane Plough', 'funds' => 100})
customer3.save()

film1 = Film.new({'title' => 'Macbeth', 'price' => 10})
film1.save()
film2 = Film.new({ 'title' => 'Macbeth 3D', 'price' => 15})
film2.save()


ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
ticket1.save()
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id})
ticket2.save()

screening1 = Screening.new({'screening_time' => '1700', 'total_tickets' => 10, 'film_id' => film1.id})
screening1.save()

def initialize(options)
  @id = options['id'].to_i if options['id']
  @film_id  = options['film_id'].to_i
  @screening_time = options['screening_time']
  @total_tickets = options['total_tickets'].to_i
end


binding.pry
nil
