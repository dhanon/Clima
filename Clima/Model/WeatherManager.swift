import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,    weather: WeatherModel)
    func didFailedError(error: Error)
}
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=3f08f42cc5571fd65dfd661f5ba64f75&units=metric"
    var delegate: WeatherManagerDelegate?
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func xd(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){                  //1.Create a URL
            let session = URLSession(configuration: .default)//2.Create a URL session
            let task = session.dataTask(with: url) { (data, response, error) in//3.Give the sessionon a task
                if error != nil{
                    delegate?.didFailedError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()//4.Start the task
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decorder = JSONDecoder()
        do{
            let decodedData = try decorder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            //print(decodedData.name)
            //print(decodedData.main.temp)
            //print(decodedData.weather[0].description)
            //print(decodedData.weather[0].id)
            //print("\n",decodedData.name,"\t",decodedData.main.temp,"\t",decodedData.weather[0].description,"\t",decodedData.weather[0].id)
        }catch{
            delegate?.didFailedError(error: error)
            return nil
        }
    }
}
