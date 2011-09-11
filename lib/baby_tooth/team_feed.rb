class TeamFeed < Client
  def members
    body['items']
  end
end
