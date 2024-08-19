# BIKE SHARING DEMAND

The goal is to find the demand of rental bikes on any given day at any time to help the comapany prepare for demand

**A SHORT DESCRIPTION OF THE FEATURES.**

*datetime* - hourly date + timestamp

*season* - 1 = spring, 2 = summer, 3 = fall, 4 = winter

*holiday* - whether the day is considered a holiday

*workingday* - whether the day is neither a weekend nor holiday

*weather* -

1: Clear, Few clouds, Partly cloudy, Partly cloudy

2: Mist + Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist

3: Light Snow, Light Rain + Thunderstorm + Scattered clouds, Light Rain + Scattered clouds

4: Heavy Rain + Ice Pallets + Thunderstorm + Mist, Snow + Fog

*temp* - temperature in Celsius

*atemp* - "feels like" temperature in Celsius

*humidity* - relative humidity

*windspeed* - wind speed

*casual* - number of non-registered user rentals initiated

*registered* - number of registered user rentals initiated

*count* - number of total rentals

Here all the variables or features are numeric and the target variable that we have to predict is the *count* variable. Hence this is an example of a regression problem as the *count* variable is continuous varied.
