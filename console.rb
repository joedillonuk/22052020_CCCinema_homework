require_relative( 'models/customer' )
require_relative( 'models/film' )
require_relative( 'models/ticket' )

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

film1 = Film.new({ 'title' => 'Macbeth', 'price' => 10, 'total_tickets' => 20, 'screening_time' => 1700})
film1.save()
film2 = Film.new({ 'title' => 'Macbeth 3D', 'price' => 15, 'total_tickets' => 10, 'screening_time' => 1730})
film2.save()


ticket1 = Ticket.new('customer_id' => customer1.id, 'film_id' => film1.id)
ticket1.save()



binding.pry
nil
