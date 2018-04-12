require 'pry'
require 'rubygems'
require 'nokogiri'  
require 'open-uri'

def load_incubateurs
	url="http://www.alloweb.org/annuaire-startups/annuaire-incubateurs-startups/page/1/"
	result=[]
	continue=true

	while (continue==true) do
		binding.pry
		links = collect_links(url)
		links.each{ |url_page|
			name_site, url_incubateur, city = extract_data(url_page)
			result.push({:name => name_site , :url => url_incubateur, :city => city})
			puts {:name => name_site , :url => url_incubateur, :city => city}
			}
		page = Nokogiri::HTML(open(url))
		object = page.css('.next')
		unless object == nil
			url=object[0]["href"]
		else
			continue=false
		end
	end
end


def collect_links(url)
	page = Nokogiri::HTML(open(url))
	links = page.xpath('//div[@id="primary"]//h2/a').map { |object| object["href"]}
end

def extract_data(url)
	page = Nokogiri::HTML(open(url))
	
	object = page.xpath('//h1')
	unless object == nil
			name_site = object.text
		else
			name_site = nil
	end

	object = page.xpath('//div/p[5]/a')
	unless object == nil
		url_incubateur = object.first["href"]
	else
		url_incubateur = nil
	end
	
	object = page.xpath('//*[@id="listing-detail-map"]')
	unless object == nil
		city = object.first["data-marker-content"][29..-8]
	else
		city = nil
	end

	return name_site,url_incubateur,city
end

def process 
	result = load_incubateurs
	puts result
	puts result.count
end

process


# Liste incubateurs : http://www.alloweb.org/annuaire-startups/annuaire-incubateurs-startups/page/1/
# puis /page/2/... jusqu'à p37. A la fin, plus de bouton suivant. 
# Lien : '//div[@id="primary"]//h2/a' ["href"]
# Boutton : page.css('.next')[0]["href"]

# Sur page de l'incubateur : 
# Nom : '//h1'.text
# Ville : '//*[@id="listing-detail-map"]' ["data-marker-content"][29..-8]
# "hello".delete_prefix '<span class="marker-content">', '</span>'
# Site : '//div/p[5]/a' ["href"]
# /html/body/div[1]/div[3]/div/div/div[2]/div[1]/div/div/div/div[1]/div/div[1]/div/div/div/div/div/p[5]/a[1] dont le texte est "site Internet"

