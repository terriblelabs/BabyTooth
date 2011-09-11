module BabyTooth
  class User < Client
    exposes_keys 'fitness_activities'

    def initialize(access_token)
      super access_token, '/user'
    end

    def fitness_activity_feed
      @fitness_activity_feed ||= FitnessActivityFeed.new(access_token, fitness_activities)
    end

    def street_team
      @street_team ||= TeamFeed.new(access_token, self['team']).members
    end

    def profile
      @profile ||= Profile.new(access_token, self['profile'])
    end
  end
end
