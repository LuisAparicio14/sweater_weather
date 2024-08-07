# Sweater Weather
## Development setup

First, clone the repository to your computer

```sh
git clone git@github.com:LuisAparicio14/sweater_weather.git
```

Next, install all of the Gems

```sh
bundle install
```

Create the necessary databases -

```sh
rails db:{create,migrate,seed}
```

Finally, start the development server

```sh
rails s
```


## Endpoints

<details>
<summary><b> Retrieve weather for a city</b></summary>

Request:
```http
GET /api/v1/forecast?location=cincinatti,oh
Content-Type: application/json
Accept: application/json
```

Response: 
`status: 200`

```json
{
    "data": {
        "id": null,
        "type": "forecast",
        "attributes": {
            "current_weather": {
                "last_updated": "2024-08-06 20:15",
                "temperature": 76.8,
                "feels_like": 81.1,
                "humidity": 86,
                "uvi": 1.0,
                "visibility": 6.0,
                "condition": "Patchy rain nearby",
                "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png"
            },
            "daily_weather": [
                {
                    "date": "2024-08-06",
                    "sunrise": "05:46 AM",
                    "sunset": "06:19 PM",
                    "max_temp": 84.7,
                    "min_temp": 75.6,
                    "condition": "Moderate rain",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/302.png"
                },
                {
                    "date": "2024-08-07",
                    "sunrise": "05:46 AM",
                    "sunset": "06:19 PM",
                    "max_temp": 83.0,
                    "min_temp": 74.4,
                    "condition": "Moderate rain",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/302.png"
                },
                {
                    "date": "2024-08-08",
                    "sunrise": "05:46 AM",
                    "sunset": "06:19 PM",
                    "max_temp": 83.8,
                    "min_temp": 75.2,
                    "condition": "Moderate rain",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/302.png"
                },
                {
                    "date": "2024-08-09",
                    "sunrise": "05:46 AM",
                    "sunset": "06:18 PM",
                    "max_temp": 84.1,
                    "min_temp": 76.5,
                    "condition": "Moderate rain",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/302.png"
                },
                {
                    "date": "2024-08-10",
                    "sunrise": "05:46 AM",
                    "sunset": "06:18 PM",
                    "max_temp": 83.9,
                    "min_temp": 75.8,
                    "condition": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                }
            ],
            "hourly_weather": [
                {
                    "time": "00:00",
                    "temperature": 78.5,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png"
                },
                {
                    "time": "01:00",
                    "temperature": 78.4,
                    "conditions": "Clear ",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png"
                },
                {
                    "time": "02:00",
                    "temperature": 78.4,
                    "conditions": "Partly Cloudy ",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png"
                },
                {
                    "time": "03:00",
                    "temperature": 78.4,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png"
                },
                {
                    "time": "04:00",
                    "temperature": 78.2,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png"
                },
                {
                    "time": "05:00",
                    "temperature": 78.2,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png"
                },
                {
                    "time": "06:00",
                    "temperature": 78.2,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                },
                {
                    "time": "07:00",
                    "temperature": 80.4,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                },
                {
                    "time": "08:00",
                    "temperature": 83.3,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                },
                {
                    "time": "09:00",
                    "temperature": 84.4,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                },
                {
                    "time": "10:00",
                    "temperature": 84.2,
                    "conditions": "Light rain shower",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/353.png"
                },
                {
                    "time": "11:00",
                    "temperature": 82.7,
                    "conditions": "Light rain shower",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/353.png"
                },
                {
                    "time": "12:00",
                    "temperature": 83.8,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                },
                {
                    "time": "13:00",
                    "temperature": 84.7,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                },
                {
                    "time": "14:00",
                    "temperature": 84.3,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                },
                {
                    "time": "15:00",
                    "temperature": 84.3,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                },
                {
                    "time": "16:00",
                    "temperature": 81.7,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                },
                {
                    "time": "17:00",
                    "temperature": 78.9,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                },
                {
                    "time": "18:00",
                    "temperature": 77.4,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                },
                {
                    "time": "19:00",
                    "temperature": 76.6,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png"
                },
                {
                    "time": "20:00",
                    "temperature": 76.8,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png"
                },
                {
                    "time": "21:00",
                    "temperature": 76.8,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png"
                },
                {
                    "time": "22:00",
                    "temperature": 76.5,
                    "conditions": "Patchy rain nearby",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png"
                },
                {
                    "time": "23:00",
                    "temperature": 75.6,
                    "conditions": "Patchy light drizzle",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/263.png"
                }
            ]
        }
    }
}
```
</details>

<details>
<summary><b> User Regristration</b></summary>

Request:
```http
POST /api/v1/users
Content-Type: application/json
Accept: application/json
```

Body:
```json
{
    "email": "luis@email.com",
    "password": "most_secure_password",
    "password_confirmation": "most_secure_password"
}
```

Response: `status: 200`
```json
{
    "data": {
        "id": "1",
        "type": "users",
        "attributes": {
            "email": "luis@email.com",
            "api_key": "a9576a3ff520073edfeae28df98d4e96"
        }
    }
}
```
</details>

<details>
<summary><b> User Login</b></summary>

Request:
```http
POST /api/v1/sessions
Content-Type: application/json
Accept: application/json
```

Body:
```json
{
    "email": "luis@email.com",
    "password": "most_secure_password"

}
```

Response: `status: 200`
```json
{
    "data": {
        "id": "1",
        "type": "users",
        "attributes": {
            "email": "luis@email.com",
            "api_key": "a9576a3ff520073edfeae28df98d4e96"
        }
    }
}
```
</details>

<details>
<summary><b> Road Trip </b></summary>

Request
```http
POST /api/v1/road_trip
Content-Type: application/json
Accept: application/json

Body:
{
  "origin": "Cincinatti,OH",
  "destination": "Chicago,IL",
  "api_key": "t1h2i3s4_i5s6_l7e8g9i10t11"
}
```

Response
```json
{
    "data": {
        "id": null,
        "type": "road_trip",
        "attributes": {
            "start_city": "Cincinnati, OH",
            "end_city": "Chicago, IL",
            "travel_time": "4 hrs, 20 min",
            "weather_at_eta": {
                "datetime": "2024-08-07 02:00",
                "temperature": 68.4,
                "condition": "Cloudy "
            }
        }
    }
}
```
</details>


