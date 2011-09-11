module BabyTooth
  class FitnessActivityFeed < Client
    exposes_keys "items"

    def fitness_activities
      items.map do |item|
        FitnessActivity.new access_token, item['uri']
      end
    end
  end
end
