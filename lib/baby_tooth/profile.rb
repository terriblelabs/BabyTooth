module BabyTooth
  class Profile < Client
    exposes_keys "name",
      "small_picture",
      "large_picture",
      "medium_picture",
      "elite",
      "gender",
      "athlete_type",
      "normal_picture",
      "profile"
  end
end
