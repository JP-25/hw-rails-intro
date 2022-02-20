class Movie < ActiveRecord::Base
    def self.all_ratings
        Movie.select(:rating).distinct.inject([]) { |a, b| a.push b.rating }
    end
end