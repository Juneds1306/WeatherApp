<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Weather App - Results</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;700&display=swap" rel="stylesheet" />

  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Nunito', sans-serif;
    }

    body {
      background: #f7fbff;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      color: #333;
      padding: 20px;
    }

    .container {
      background: #ffffff;
      border-radius: 16px;
      box-shadow: 0 6px 18px rgba(0, 123, 255, 0.15);
      width: 360px;
      padding: 32px 30px;
      text-align: center;
      transition: box-shadow 0.3s ease;
    }

    .container:hover {
      box-shadow: 0 10px 30px rgba(0, 123, 255, 0.3);
    }

    form.search {
      display: flex;
      margin-bottom: 28px;
      gap: 12px;
    }

    form.search input[type='text'] {
      flex: 1;
      padding: 14px 20px;
      border-radius: 50px;
      border: 2px solid #74b9ff;
      font-size: 16px;
      outline: none;
      transition: border-color 0.3s ease;
      font-weight: 600;
      color: #333;
      background: #f0f6ff;
    }

    form.search input[type='text']::placeholder {
      color: #a0bff7;
      font-weight: 400;
    }

    form.search input[type='text']:focus {
      border-color: #0984e3;
      background: #d6eaff;
    }

    form.search button {
      background: #0984e3;
      border: none;
      border-radius: 50%;
      width: 48px;
      height: 48px;
      cursor: pointer;
      color: white;
      font-size: 20px;
      display: flex;
      justify-content: center;
      align-items: center;
      box-shadow: 0 4px 12px #0984e3aa;
      transition: background 0.3s ease, box-shadow 0.3s ease;
    }

    form.search button:hover {
      background: #065cbd;
      box-shadow: 0 6px 20px #065cbdcc;
    }

    .weather-icon {
      margin-bottom: 24px;
    }

    .weather-icon img {
      width: 110px;
      height: 110px;
      filter: drop-shadow(1px 2px 5px #74b9ff88);
      transition: transform 0.3s ease;
    }

    .weather-icon img:hover {
      transform: scale(1.1);
    }

    .temperature {
      font-size: 3.8rem;
      font-weight: 700;
      color: #0984e3;
      margin-bottom: 12px;
      letter-spacing: 1.2px;
    }

    .city-name {
      font-size: 1.9rem;
      font-weight: 700;
      color: #333;
      margin-bottom: 6px;
      letter-spacing: 0.05em;
    }

    .date {
      font-size: 1rem;
      color: #6c7a89;
      font-style: italic;
      margin-bottom: 30px;
    }

    .details {
      display: flex;
      justify-content: space-between;
      gap: 20px;
    }

    .detail-box {
      flex: 1;
      background: #e8f0ff;
      border-radius: 14px;
      padding: 16px;
      display: flex;
      align-items: center;
      gap: 12px;
      box-shadow: 0 3px 8px rgba(0, 123, 255, 0.1);
    }

    .detail-icon img {
      width: 40px;
      height: 40px;
    }

    .detail-info span {
      display: block;
      font-size: 14px;
      color: #777;
    }

    .detail-info h3 {
      margin-top: 4px;
      font-size: 1.3rem;
      color: #333;
      font-weight: 700;
    }

    @media screen and (max-width: 400px) {
      .container {
        width: 100%;
        padding: 20px;
      }

      form.search {
        flex-direction: column;
        gap: 10px;
      }

      .details {
        flex-direction: column;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <form action="WeatherServlet" method="post" class="search">
      <input type="text" name="city" placeholder="Enter City Name" value="${city != null ? city : 'New Delhi'}" required autocomplete="off" />
      <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
    </form>

    <div class="weather-icon">
      <img src="" alt="Weather Icon" id="weather-icon" />
    </div>

    <div class="temperature">${temperature != null ? temperature : '--'} °C</div>
    <div class="city-name">${city != null ? city : 'N/A'}</div>
    <div class="date">${date != null ? date : ''}</div>

    <div class="details">
      <div class="detail-box">
        <div class="detail-icon">
          <img src="https://cdn-icons-png.flaticon.com/512/728/728093.png" alt="Humidity Icon" />
        </div>
        <div class="detail-info">
          <span>Humidity</span>
          <h3>${humidity != null ? humidity : '--'}%</h3>
        </div>
      </div>

      <div class="detail-box">
        <div class="detail-icon">
          <img src="https://cdn-icons-png.flaticon.com/512/1164/1164940.png" alt="Wind Speed Icon" />
        </div>
        <div class="detail-info">
          <span>Wind Speed</span>
          <h3>${windSpeed != null ? windSpeed : '--'} km/h</h3>
        </div>
      </div>
    </div>

    <input type="hidden" id="weatherCondition" value="${weatherCondition != null ? weatherCondition : ''}" />
  </div>

  <script>
    const icon = document.getElementById('weather-icon');
    const weatherCondition = document.getElementById('weatherCondition').value;

    const iconsMap = {
      Clouds: 'https://cdn-icons-png.flaticon.com/512/414/414825.png',
      Clear: 'https://cdn-icons-png.flaticon.com/512/869/869869.png',
      Rain: 'https://cdn-icons-png.flaticon.com/512/3351/3351974.png',
      Mist: 'https://cdn-icons-png.flaticon.com/512/4005/4005906.png',
      Snow: 'https://cdn-icons-png.flaticon.com/512/642/642102.png',
      Haze: 'https://cdn-icons-png.flaticon.com/512/1197/1197102.png'
    };

    icon.src = iconsMap[weatherCondition] || 'https://cdn-icons-png.flaticon.com/512/869/869869.png';
    icon.alt = weatherCondition || 'Weather icon';
  </script>
</body>
</html>
