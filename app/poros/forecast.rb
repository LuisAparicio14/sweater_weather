class Forecast
  attr_reader :id, :current_weather, :daily_weather, :hourly_weather

  def initialize(data)
    @id = nil
    @current_weather = set_current_weather(data[:current])
    @daily_weather = set_daily_weather(data[:forecast][:forecastday])
    @hourly_weather = set_hourly_weather(data[:forecast][:forecastday].first[:hour])
  end

  def set_current_weather(data)
    current_weather_now = {}
    current_weather_now[:last_updated] = data[:last_updated]
    current_weather_now[:temperature] = data[:temp_f]
    current_weather_now[:feels_like] = data[:feelslike_f]
    current_weather_now[:humidity] = data[:humidity]
    current_weather_now[:uvi] = data[:uv]
    current_weather_now[:visibility] = data[:vis_miles]
    current_weather_now[:condition] = data[:condition][:text]
    current_weather_now[:icon] = data[:condition][:icon]
    current_weather_now
  end

  def set_daily_weather(data)
    daily_weather = []
    data.each do |day|
      daily_weather << {
        date: day[:date],
        sunrise: day[:astro][:sunrise],
        sunset: day[:astro][:sunset],
        max_temp: day[:day][:maxtemp_f],
        min_temp: day[:day][:mintemp_f],
        condition: day[:day][:condition][:text],
        icon: day[:day][:condition][:icon]
      }
    end
    daily_weather
  end

  def set_hourly_weather(data)
    hourly_weather = []
    data.each do |hour_data|
      hour = {}
      hour[:time] = Time.parse(hour_data[:time]).to_fs(:time)
      hour[:temperature] = hour_data[:temp_f]
      hour[:conditions] = hour_data[:condition][:text]
      hour[:icon] = hour_data[:condition][:icon]
      hourly_weather << hour
    end
    hourly_weather
  end
end