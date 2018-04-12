require 'pry'
require 'rubygems'
require 'nokogiri'  
require 'open-uri'

# Fonction get_price_of_crypto
# @params : none
# return : 
#   array_of-crypto : un tableau de hash contenant le nom de la crypto et son prix
def get_price_of_crypto 
	array_of_crypto = []
	url = "https://coinmarketcap.com/all/views/all/"
	page = Nokogiri::HTML(open(url))   

	# On récupère chaque ligne du tableau (sauf la première qui n'est pas une crypto)
	page.xpath('//tr')[1..-1].each { |ligne_tableau| 
		# On utilise XPATH : 
		# => le . permet de commencer au node en question (ici représenté par 
		# ligne_tableau)
		# => // remplace le chemin exacte. Ainsi, tous les éléments ciblés seront concernés. 
		# => Enfin, * indique qu'on sélectionne n'importe quel élément, tant qu'il est 
		# de la classe en question
		#
		# 1) On cherche dans la ligne le nom de la crypto
		name_temp = ligne_tableau.xpath('.//*[@class="currency-name-container"]').text
		# 2) On cherche dans la ligne le prix de la crypto
		price_temp = ligne_tableau.xpath('.//*[@class="price"]').text
		# 3) On rajoute les informations au tableau de hash
		array_of_crypto.push({:nom => name_temp, :prix => price_temp})
	}
	return array_of_crypto
end

def init_timer
	puts "Ce programme va vous permettre de visualiser le prix des cryptomonnaies"
	puts "Par défaut, il se rafraichit toutes les heures. Mais vous pouvez choisir le nombre de minutes entre deux itérations"
	puts "Si vous entrez autre chose qu'un integer, la valeur par défaut sera 60 minutes. Le minimum est 1 minute"
	begin 
		guess = gets.chomp.to_i
		guess = guess.is_a? Integer && guess > 0 ? (puts "Vous avez choisi #{guess} minutes") : (guess = 60; puts "Je n'ai pas compris. Je règle donc le timer à 60 minutes")
	rescue => e  

	end
	puts "Pour terminer le programme, cliquer sur CTRL + C. C'est parti ?"
	gets(1)
	return guess
end

def process
	number_minutes = init_timer 
	# Permet de capturer l'exception levée lors du CTRL + C
	begin 
		while true do
				array = get_price_of_crypto
				puts array
				puts "Le tableau contient #{array.count} éléments"
				puts Time.new
				sleep number_minutes*60
		end
	rescue SystemExit, Interrupt, Exception => e
		puts "\nAu revoir"
	end
end

process