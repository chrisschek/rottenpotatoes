require 'spec_helper'

describe MoviesController do
	describe 'easy stuff' do
		before :each do
			@testMovie = mock(Movie, :title => "Up", :id => "1")
			Movie.stub(:find).with("1").and_return(@testMovie)
		end
		it 'should create a new movie' do
			Movie.stub(:create!).and_return(@testMovie)
			post(:create)
			response.should redirect_to(movies_path)
		end
		it 'should update movie with new info' do
			@testMovie.stub(:update_attributes!).and_return(true)
			put(:update, {:id => "1", :movie => @testMovie})
			response.should redirect_to(movie_path(Movie.find("1")))
		end
		it 'should destroy a movie' do
			@testMovie.stub(:destroy)
			delete(:destroy, {:id => "1"})
			response.should redirect_to(movies_path)
		end
		it 'should go to edit' do
			get(:edit, {:id => "1"})
			response.should render_template('movies/edit')
		end
		it 'should show a movie' do
			get(:show, {:id => "1"})
			response.should render_template('movies')
		end
	end

	describe 'index' do
		before :each do
			@testMovie = mock(Movie, :title => "Up", :id => "1")
			Movie.stub(:find).with("1").and_return(@testMovie)
			Movie.stub(:find_all_by_rating).and_return([@testMovie])
		end
		it 'should do the first thing' do
			get(:index, {:sort => "title"})
		end
		it 'should do something else' do
			get(:index, {:sort => "release_date", :ratings => ['G']})
		end
		it 'should do another thing' do
			get(:index)
		end
	end


	describe 'find movies with same director' do
		before :each do
			@testMovie1 = mock(Movie, :title => "Up", :id => "1", :director => "Bob")
			@testMovie2 = mock(Movie, :title => "Down", :id => "2", :director => "Bob")
			@testMovie3 = mock(Movie, :title => "Sideways", :id => "3", :director => "")
			Movie.stub(:find).with("1").and_return(@testMovie1)
			Movie.stub(:find).with("2").and_return(@testMovie2)
			Movie.stub(:find).with("3").and_return(@testMovie3)
		end
		it 'should redirect to same director page' do
			Movie.stub(:where).and_return([@testMovie1, @testMovie2])
			get :samedirector, {:id => "1"}
			response.should render_template('samedirector')
		end
		it 'should redirect to movies page if no director' do
			get :samedirector, {:id => "3"}
			response.should redirect_to(movies_path)
		end
	end
end
