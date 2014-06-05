class Hangman

	def letters
		@letters = ('a'..'z').to_a
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
		if word.include?(guess)
			puts "You guessed one!"
		else
			puts "nope"
		end
	end

	def show_guessed_word(word)
		@guessed_word = Array.new(word.size, "_")
		puts @guessed_word.inspect
	end

	def play
		word = pick_word
		show_guessed_word(word)
		guess = guess_letter
		check_guess(guess, word)
	end
end

game = Hangman.new
game.play