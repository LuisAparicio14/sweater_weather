class RoadTripFacade
  def self.road_trip_details(origin, destination)
    time_and_coordinates = RoadTripService.time_and_coordinates(origin, destination)
    coord = time_and_coordinates[:locations].last[:latLng]
    eta = format_eta(time_and_coordinates)
    weather = RoadTripService.get_road_trip_weather(coord, eta)
    RoadTrip.new(origin, destination, time_and_coordinates, weather)
  end

  def self.format_eta(time_and_coordinates)
    arrival_time = Time.now + time_and_coordinates[:time].last
    time = {}
    time[:date] = arrival_time.to_date.to_fs(:iso8601)
    time[:hour] = arrival_time.hour
    time[:hour] += 1 if arrival_time.min >= 30
    time
  end
end