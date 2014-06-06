require "yaml"

class Hangman
	attr_reader :game_saved
	def initialize
		@letters = set_alphabet
		@word = pick_word
		@guessed_word = set_guessed_word(@word)
		@wrong_letters = []
		@game_saved = false
	end

	def save_game
		Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
		puts "What would you like to name your game?"
		filename = "saved_games/#{gets.chomp}.yml"
		File.open(filename, "w") { |file| file.puts YAML::dump(self) }
		@game_saved = true
	end

	def self.load_game
			puts "What game would you like to load?"
			filename = "saved_games/" + gets.chomp + ".yml"
			YAML::load(File.open(filename))
	end

	def set_alphabet
		('a'..'z').to_a
	end

	def pick_word
		words = []
		File.open("5desk.txt").each {|word| words << word[0,word.length - 2].downcase if word.length.between?(5,14)}
		rand_word = words[rand(0...words.size)].split('')
	end

	def guess_letter
		puts "Please guess a letter"
		letter = gets.chomp.downcase
	end

	def check_guess(guess, word)
		if guess == "save"
			save_game
		else
			unless @letters.include?(guess)
				puts "That is not a valid guess, please guess again."
				guess_letter
			else
				if word.include?(guess)
					word.each_with_index do |letter, index|
						if letter == guess
							update_guessed_word(guess, index)
						end
					end
					puts "Good job! #{show_guessed_word(@guessed_word)}"
				else
					puts "Sorry there is no #{guess}"
					add_wrong_letters(guess)
				end
				@letters.delete(guess)
			end
		end
	end

	def add_wrong_letters(letter)
		@wrong_letters << letter
	end

	def set_guessed_word(word)
		Array.new(word.size, "_")
	end

	def update_guessed_word(guess, index)
		@guessed_word[index] = guess
	end

	def show_guessed_word(guessed_word)
		puts @guessed_word.inspect
	end

	def winner?
		if !@guessed_word.include?("_")
			puts "We've got a winner!"
			true
		else
			false
		end
	end

	def guesses_remaining
		10 - @wrong_letters.size
	end

	def loser?
		if guesses_remaining == 0
			puts "You lost.  The word was #{@word.join}"
			true
		else
			false
		end
	end

	def game_over?
		winner? || loser?
	end

	def play
			show_guessed_word(@guessed_word)
			puts "#{guesses_remaining} guesses left"
			puts "Incorrect letters: #{@wrong_letters}"
			guess = guess_letter
			check_guess(guess, @word)
	end
end

puts "Would you like to load a saved game? (yes/no)"
answer = gets.chomp.downcase[0]
game = answer == "y" ? Hangman.load_game : Hangman.new
loop do
	game.play
	break if game.game_over? || game.game_saved
end






