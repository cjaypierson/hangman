class Hangman

	def set_alphabet
		('a'..'z').to_a
	end

	def pick_word
		words = []
		File.open("5desk.txt").each {|word| words << word[0,word.length - 2] if word.length.between?(5,14)}
		rand_word = words[rand(0...words.size)].split('')
	end

	def guess_letter
		puts "Please guess a letter"
		letter = gets.chomp.downcase
	end

	def check_guess(guess, word)
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
		@letters = set_alphabet
		@word = pick_word
		@guessed_word = set_guessed_word(@word)
		@wrong_letters ||= []
		until game_over?
			show_guessed_word(@guessed_word)
			puts "#{guesses_remaining} guesses left"
			puts "Incorrect letters: #{@wrong_letters}"
			guess = guess_letter
			check_guess(guess, @word)
		end
	end
end

game = Hangman.new
game.play