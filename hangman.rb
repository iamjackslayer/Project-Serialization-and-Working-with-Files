
require 'yaml'
class Game
	def initialize
		puts "To save game, please type 'save'. To load saved game, please type 'load'. To start new game, please type 'new".
		input = case gets.chomp.downcase
				when 'new'
					Player.new.start_game
				when 'save'
					puts "You haven't loaded or started the game yet."
				when 'load'
					Game.load
				end

	end


	def self.load
		if File.exist?'saved.yaml'
			@yaml_file = File.read('saved.yaml') 
			obj = YAML::load(@yaml_file)
			print obj.word_display_array
			obj.in_game
		else
			puts "game not saved yet."
		end
	end

end

class Player
	attr_reader :word_display_array
	def initialize
		@count = 0
		@game_over = false
		@word_display_array = []
	end

	def start_game
		puts "Welcome to HangMan 2017!"
		puts "What is the word?"

		contents = File.readlines('dictionary.txt')
		while true
			@word = contents[rand(0..61406)]
			if (5..12).include?@word.length 
				@count = @word.length - 1
				break
			end
		end
		@word = @word.chomp.split("")
		@word.length.times do 
			@word_display_array << " _ "
		end
		puts
		print @word_display_array
		print "\n"
		in_game
	end
		#loop for user input now 
	def in_game
		while !@game_over
			puts "You have #{@count} chances left."
			@input = gets.chomp
			@count -= 1
			if @word.include? @input
				@word.each_with_index do |e,i|
					if e == @input
						@word_display_array[i] = " #{e} "
					end
				end
			elsif @input.downcase == "load"
				Game.load
			elsif @input.downcase == "save"
				self.save
				puts "See you."
				exit
			elsif @input == @word.join
				puts "You did it!"
				exit
			end
			print @word_display_array 
			print "\n"
			check_game_over
		end
	end

	def check_game_over
		if !@word_display_array.include?" _ "
			@game_over = true
			puts "Victory!"
			exit
		elsif @count == 0
			@game_over = true
			puts "Game over. You have no chance left. The word is #{@word.join}"
			exit

		end
	end

	def save
		@yaml_file = YAML::dump(self)
		file = File.open('saved.yaml','w')
		file.write(@yaml_file)
		file.close
	end
end

a = Game.new
