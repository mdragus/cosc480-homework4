class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date, :director
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
	def self.get_director(id)
		Movie.find(id).director
	end
	def self.get_title(id)
		Movie.find(id).title
	end
	def self.get_similar_movies(id)
		director = self.get_director(id)
		Movie.where({:director => director})
	end
end
