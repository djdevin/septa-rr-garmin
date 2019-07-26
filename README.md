# septa-rr-garmin
SEPTA RR widget for Garmin watches

A widget designed for commuters that shows upcoming SEPTA Regional Rail trips and delays between a configured start and end station.

Hold up/press menu/long tap to switch the start and end. Press select/tap to refresh the trips.

Unfortunately the Connect IQ settings interface does not allow for non-numeric key-value pairs so I can't add a select list of all stations.

For now, you must type in the exact station name in the configuration. The list of stations to use is on https://github.com/djdevin/septa-rr-garmin/blob/master/stations.txt

Uses the SEPTA Next to Arrive JSON API: http://www3.septa.org/hackathon/

Roadmap:
- automatic station switch based on GPS
- configurable refresh time
- better art
- more devices

### Coding style

`astyle *.mc --style=google --indent=spaces=2 -Y`
