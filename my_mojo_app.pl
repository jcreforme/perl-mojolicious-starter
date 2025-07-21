#!/usr/bin/env perl
use Mojolicious::Lite;

# Route for the home page
get '/' => {text => 'Welcome to your Mojolicious app!'};

# Example route with a template
get '/hello/:name' => sub {
  my $c = shift;
  $c->stash(name => $c->param('name'));
  $c->render(template => 'hello');
};

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