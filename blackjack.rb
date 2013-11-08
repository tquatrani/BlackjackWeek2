class Card
	attr_accessor :suit, :value
	def initialize(suit, value)
		@suit = suit
		@value = value
	end

	def card_def
		puts "Card is #{value} of #{suit}"
	end
end

class Deck
	attr_accessor :cards

	def initialize
		@cards = []
	
		['H', 'D', 'S', 'C'].each do |suit| 
			['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value| @cards << Card.new(suit,face_value)
      end
   end
  end
  
  def scramble
  	@cards.shuffle!
  end

  def deal
  	cards.pop
  end
  
end

class Player
	attr_accessor :name, :my_cards
  def initialize
    puts "What is your name"
    @name = gets.chomp
    @my_cards = []

  end
end

class Dealer
	attr_accessor :name, :my_cards
	def initialize
		@name = "The Dealer"
		@my_cards = []
	end
end

class Hand
	attr_accessor :cards_held
	def initialize
		@cards_held =[]
	end

	def calculate_value
		total = 0
	  index = 0
	  first_ace = 'true'
	  while index < @cards_held.length
	  	if @cards_held[index].value == 'A'
		  	if first_ace
			  	if (total < 11)
			      total += 11
			    else
			      total += 1
			    end
			    first_ace = 'false'
			  else
			    total += 1
			  end
			elsif @cards_held[index].value.to_i == 0
				total += 10
			else
				total += @cards_held[index].value.to_i
			end
      index = index + 1
     end
     return total
	end
end

class Blackjack
	  attr_accessor :the_deck, :the_player, :the_dealer
	
	def initialize
		@the_deck = Deck.new
		@the_deck.scramble
	end

	def set_participants
		@the_player = Player.new
		puts "Welcome #{the_player.name}"

		@the_dealer = Dealer.new
	end
 	
 	def first_hand
 		@the_player.my_cards = Hand.new
		@the_player.my_cards.cards_held << @the_deck.deal
		
		@the_dealer.my_cards = Hand.new
		@the_dealer.my_cards.cards_held << @the_deck.deal

		@the_player.my_cards.cards_held << @the_deck.deal
		@the_dealer.my_cards.cards_held << @the_deck.deal
	
		puts "Player hand"
		@the_player.my_cards.cards_held[0].card_def
		@the_player.my_cards.cards_held[1].card_def

		puts "Dealer hand"
		@the_dealer.my_cards.cards_held[0].card_def
		@the_dealer.my_cards.cards_held[1].card_def
	end

	def player_turn
		puts the_player.name +  " - Do you want another card?"
    answer = gets.chomp
    my_value = the_player.my_cards.calculate_value
    while answer == 'yes' && my_value < 22
		  the_player.my_cards.cards_held << the_deck.deal
		  my_value = the_player.my_cards.calculate_value
		  puts the_player.name + " - You have a value of #{my_value}"
	    
		  if my_value == 21
				puts "BLACKJACK!  Congratulations " + the_player.name + " you win"
				game_over
			elsif my_value > 21
				puts "Sorry you lose"
				game_over
			else
				puts the_player.name + " - do you want another card?"
				answer = gets.chomp
		  end
		end
		return my_value
	end

	def dealer_turn(player_value)
		
    dealer_value = 0
    while dealer_value <= player_value
		  the_dealer.my_cards.cards_held << the_deck.deal
		  dealer_value = the_dealer.my_cards.calculate_value
		  puts "The dealer has a value of #{dealer_value}"
	    
		  if dealer_value == 21
				puts "Dealer has Blackjack"
			elsif dealer_value > 21
				puts "Dealer loses"
				game_over
			end
		end
	end

	def who_won?
		dealer_value = the_dealer.my_cards.calculate_value
		player_value = the_player.my_cards.calculate_value
		puts "Dealer value is #{dealer_value}"
		puts "Player value is #{player_value}"
		if player_value > dealer_value
			puts "Player wins"
		else
			puts "Dealer wins"
		end
		game_over
	end

	def game_over
		puts "Thank you for playing Blackjack"
		exit
	end
end

the_game = Blackjack.new
the_game.set_participants
the_game.first_hand
dealer_value = the_game.the_dealer.my_cards.calculate_value
player_value = the_game.the_player.my_cards.calculate_value
puts "Dealer value is #{dealer_value}"
puts "Player value is #{player_value}"

if player_value == 21
	puts "Congratulations, you have blackjack.  You win"
	the_game.game_over
end

if dealer_value == 21
	puts "Sorry the dealer has blackjack.  You lose"
	the_game.game_over
end

player_value = the_game.player_turn
puts "player value is #{player_value}"
the_game.dealer_turn(player_value)
the_game.who_won?
