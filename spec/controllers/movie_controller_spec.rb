require "spec_helper"
require "movies_helper.rb"

describe MoviesController do
  describe "add director to existing movie" do
    it "should call update_attributes and redirect to show" do
     	@movie = mock(Movie, :title => "Black Dynamite", :director => "Shakespeare",
			                     :release_date => "10-Mar-1990",:id => 1) 
			Movie.stub!(:find).with("1").and_return(@movie)
    	@movie.stub!(:update_attributes!).and_return(true)
			put :update, {:id => "1"}
			response.should redirect_to(movie_path(@movie))
		end
  end
	describe "happy path, find movies with same director" do
		before :each do
			@movie1 = mock(Movie, :title => "Pirates of the Carribean 1", :director => "Marius",
													 :release_date => "02-Mar-1990", :id => 1)
			@movie2 = mock(Movie, :title => "Pirates of the Carribean 2", :director => "Marius",
													 :release_date => "02-Mar-1990", :id => 2)
			Movie.stub!(:get_similar_movies).with("1").and_return([@movie1,@movie2]);
			Movie.stub!(:get_director).with("1").and_return("Marius")
			Movie.stub!(:get_director).with("2").and_return("Marius")
		end
		it "should call the correct controller on each get_similar_movies request" do
			{:get  => similar_movies_path("1")}.
			should route_to(:controller => "movies", :action => "similar_movies", :id => "1")
		end
		it "should call model method to get similar movies" do
			Movie.should_receive(:get_similar_movies).with("1").and_return([@movie1,@movie2])
			get :similar_movies, {:id =>"1"}
			response.should render_template("similar_movies")
		end
	end

	describe "sad path, no director was assigned to movie" do
		before :each do
			@movie1 = mock(Movie, :title => "Pirates of the Carribean 1",
													 :release_date => "02-Mar-1990", :id => 1)
			@movie2 = mock(Movie, :title => "Pirates of the Carribean 2", 
													 :release_date => "02-Mar-1990", :id => 2)
			Movie.stub!(:get_similar_movies).with("1").and_return([@movie1,@movie2]);
			Movie.stub!(:get_director).with("1").and_return("")
			Movie.stub!(:get_director).with("2").and_return(nil)
			Movie.stub!(:find).with("1").and_return(@movie1)
			Movie.stub!(:get_title).with("1").and_return(@movie1.title)
		end	
		it "should call the get_title method on Movies to create the flash notice" do
			Movie.should_receive(:get_director).with("1").and_return("")
			get :similar_movies, {:id => "1"}
			flash[:notice].should == "'Pirates of the Carribean 1' has no director info"
		end
		it "should return a redirect to the movies_path" do
			get :similar_movies, {:id => "1"}
			response.should redirect_to(movies_path)	
		end
	end

	describe "should be able to create new movie" do
		it "should create a movie and redirect to movies_path" do
			post :create, {:id => "1",:title => "Forest Gump",:release_date => "10-Mar-1992"}
			response.should redirect_to(movies_path)
			flash[:notice].should_not be_blank
		end
	end
	describe "should be able to delete a movie" do
		it "should delete a movie and redirect to movies_path" do
		  m = mock(Movie, :id => "1", :title => "Schildren's List")
      Movie.stub!(:find).with("1").and_return(m)
      m.should_receive(:destroy)	
			delete :destroy, {:id => "1"}
			response.should redirect_to(movies_path)
			flash[:notice].should_not be_blank
		end
	end
	describe "oddness should return odd or even depending on input" do
		class DummyClass
		end
		it "should call the oddness function" do
			dummy = DummyClass.new
			dummy.extend(MoviesHelper)
			dummy.oddness(5)
		end
	end
	describe "should sort the movies on the index" do
		it "should sort by title" do
			get :index, {:sort => "title"}	
			session[:sort].should == "title"
		end
		it "should sort by release date" do
			get :index, {:sort => "release_date"}	
			session[:sort].should == "release_date"
		end
	end
end

