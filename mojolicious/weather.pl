use Mojolicious::Lite;
use Mojo::UserAgent;
use Dotenv;

# Load environment variables from .env file
Dotenv->load('../.env');

# Root route to render the weather template
get '/' => sub {
  my $c = shift;
  $c->stash(weather_data => {});
  $c->render(template => 'weather');
};

# Route to display weather data
get '/weather' => sub {
  my $c = shift;

  # Use environment variable for API key or fallback to a placeholder
  my $api_key = $ENV{'WEATHER_API_KEY'} || die "API key not found in environment";


  # Get city from query parameter or default to 'London'
  my $city = $c->param('city') || 'London';

  # Fetch weather data
  my $ua = Mojo::UserAgent->new;
  my $res = $ua->get("http://api.weatherapi.com/v1/current.json?key=$api_key&q=$city")->result;

  my $weather_data;
  if ($res->is_success) {
    $weather_data = $res->json;
    $c->app->log->debug("Weather data fetched successfully: " . $res->body);
  } else {
    $weather_data = { error => "Failed to fetch weather data: " . $res->message };
    $c->app->log->debug("Failed to fetch weather data: " . $res->message);
  }

  # Pass data to the template
  $c->stash(weather_data => $weather_data || {}, city => $city);
  $c->render(template => 'weather');
};

# Start the Mojolicious application
app->start;

__DATA__

@@ weather.html.ep
% my $weather_data = stash('weather_data') || {};
% if (exists $weather_data->{error}) {
  <p><strong>Error:</strong> <%= $weather_data->{error} %></p>
% } elsif ($weather_data->{current}) {
  <h1>Weather for <%= stash('city') %></h1>
  <p><strong>Temperature:</strong> <%= $weather_data->{current}->{temp_c} %>°C</p>
  <p><strong>Condition:</strong> <%= $weather_data->{current}->{condition}->{text} %></p>
% } else {
  <p>No weather data available. Please enter a city to get the weather.</p>
% }
<form method="get" action="/weather">
  <label for="city">Enter city:</label>
  <input type="text" id="city" name="city" placeholder="e.g., New York">
  <button type="submit">Get Weather</button>
</form>