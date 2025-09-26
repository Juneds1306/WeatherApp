
package MyPackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Date;
import java.util.Scanner;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet("/WeatherServlet")
public class MyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String apiKey = "6d0203494874535dd0f5e31d385667ec";  
        String city = request.getParameter("city");

        String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=" +
                URLEncoder.encode(city, "UTF-8") + "&appid=" + apiKey;

        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            InputStreamReader reader = new InputStreamReader(conn.getInputStream());
            Scanner scanner = new Scanner(reader);
            StringBuilder responseData = new StringBuilder();
            while (scanner.hasNext()) {
                responseData.append(scanner.nextLine());
            }
            scanner.close();

            Gson gson = new Gson();
            JsonObject json = gson.fromJson(responseData.toString(), JsonObject.class);

            long dateTimestamp = json.get("dt").getAsLong() * 1000;
            String date = new Date(dateTimestamp).toString();

            double tempKelvin = json.getAsJsonObject("main").get("temp").getAsDouble();
            double tempCelsius = tempKelvin - 273.15;
            double roundedTemp = Math.round(tempCelsius * 10.0) / 10.0;

            int humidity = json.getAsJsonObject("main").get("humidity").getAsInt();
            double windSpeed = json.getAsJsonObject("wind").get("speed").getAsDouble();
            String weatherCondition = json.getAsJsonArray("weather").get(0).getAsJsonObject().get("main").getAsString();

            request.setAttribute("date", date);
            request.setAttribute("city", city);
            request.setAttribute("temperature", roundedTemp);
            request.setAttribute("humidity", humidity);
            request.setAttribute("windSpeed", windSpeed);
            request.setAttribute("weatherCondition", weatherCondition);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to fetch weather for: " + city);
        }

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
