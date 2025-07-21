#!/usr/bin/env perl
use Mojolicious::Lite;

# Add CORS headers for all routes
hook before_dispatch => sub {
  my $c = shift;
  $c->res->headers->header('Access-Control-Allow-Origin'  => '*');
  $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, OPTIONS, PUT, DELETE');
  $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type, Authorization');
};

options '/api/*' => sub {
  my $c = shift;
  $c->res->headers->header('Access-Control-Allow-Origin'  => '*');
  $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, OPTIONS, PUT, DELETE');
  $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type, Authorization');
  $c->respond_to(any => {data => '', status => 200});
};

# Route for the home page
get '/' => {text => 'Welcome to your Mojolicious app!'};

# Example route with a template
get '/hello/:name' => sub {
  my $c = shift;
  $c->stash(name => $c->param('name'));
  $c->render(template => 'hello');
};

# Route to fetch data from Laravel backend
get '/api/data' => sub {
  my $c = shift;

  # Create a user agent to make the HTTP request
  my $ua = Mojo::UserAgent->new;

  # Make a GET request to the Laravel endpoint
  my $res = $ua->get('http://127.0.0.1:8000/fetch-data')->result;

  if ($res->is_success) {
    # Return the response from Laravel as JSON
    $c->render(json => $res->json);
  } else {
    # Handle errors
    $c->render(json => {error => 'Failed to fetch data', details => $res->message}, status => 500);
  }
};

# Route for the home page
get '/' => {text => 'Welcome to your Mojolicious app!'};

app->start;

__DATA__

@@ hello.html.ep
<!DOCTYPE html>
<html>
  <head><title>Hello!</title></head>
  <body>
    <h1>Mojo Starter!</h1>
    <h1>Hello, <%= $name %>!</h1>
    <a href="/">Back to home</a>
  </body>
</html>

