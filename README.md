# septa-rr-garmin
SEPTA RR widget for Garmin watches

On the Widget configuration inside of the Connect IQ app, you must enter the full station name. This is because the Next-to-arrive API takes in a station name and not a station ID.

Unfortunately the Connect IQ settings interface does not allow for non-numeric key-value pairs so I can't add a select list of all stations.

The station names to use are listed in https://github.com/djdevin/septa-rr-garmin/blob/master/stations.txt

### Coding style

`astyle *.mc --style=google --indent=spaces=2 -Y`
