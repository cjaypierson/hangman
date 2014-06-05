class Hangman
	def pick_word
		words = []
		File.open("5desk.txt").each {|word| words << word if word.length.between?(5,12)}
		word = words[rand(0...words.size)]
	end

	def play
		word = pick_word
end

game = Hangman.new
puts game.pick_word