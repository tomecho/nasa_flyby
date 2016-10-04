require 'net/http'
require 'json'
require 'time'

def flyby(latitude, longitude)
  if latitude.class != Float || longitude.class != Float # strings would technically work but they are unsafe
    puts "please enter lat and lon as floats"
    return
  end
  # ideally this api key would be in a config file to increase portability and security, not just hard coded 
  url = "https://api.nasa.gov/planetary/earth/assets?api_key=9Jz6tLIeJ0yY9vjbEUWaH9fsXA930J9hspPchute&lat=#{latitude}&lon=#{longitude}"
  uri = URI(url)
  response = Net::HTTP.get(uri) # takes body into response var
  
  if (!response || response.empty?) # this is short circut 
    puts "failure to query api"
    return 
  end
  
  assets = JSON.parse(response) # parse response
  
  if (!assets["results"] || assets["results"].empty?) 
    puts "api returned no results"
    return 
  end
  
  dates = (assets["results"].collect { |x| Time.parse x["date"] }).sort # will sort ASC
  
  if (!dates || dates.empty?) # this is short circut 
    puts "api returned results missing dates"
    return 
  end
  
  if(dates.count == 1)
    puts "unable to calculate ave time with only one result"
    return 
  end
  
  last_date = dates.last
  total = 0.0
  for i in 1...(dates.count) do
    total += dates[i] - dates[i-1] # time_between = curr - prev
  end
  avg_time_delta = total / (dates.count-1) # average is total time between divided by amount of dates-1, yields ave_time_delta in seconds
  puts "Next time: " + (last_date + avg_time_delta).to_s + " (delta: #{avg_time_delta}})" # ruby adds the average into the last date 
end


# essentailly the main method of a ruby program
flyby('invalid', []) # the program will reject these params

flyby(0.0,0.0) # will warn that api returned no results

print 'Grand Canyon ' 
flyby(36.098592,-112.097796)

print 'Niagra Falls '
flyby(43.078154,-79.075891)

print 'Four Corners Monument '
flyby(36.998979,-109.045183)

print 'Delphix San Francisco '
flyby(37.7937007,-122.4039064)
