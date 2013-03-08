require 'spec_helper'

describe Movie do
  describe 'searching similar directors' do
    it 'should call Movie.similar_movies the id of the movie' do
      Movie.should_receive(:similar_movies).with("1")
			Movie.similar_movies("1")
    end
  end
	describe 'get director and get title' do
  	it 'should call Movie.get_director with the id of the movie' do
			Movie.should_receive(:get_director)
			Movie.get_director("1")
		end
		it 'should call Movie.get_title with the id of the movie' do
			Movie. should_receive(:get_title).with("1")
			Movie.get_title("1")
		end
	end
end
