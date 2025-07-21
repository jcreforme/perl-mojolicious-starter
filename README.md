# Mojolicious Starter App

This is a simple starter application built with [Mojolicious::Lite](https://mojolicious.org/), a lightweight Perl web framework.

## Features

- **Home Page**: Displays a welcome message at the root route (`/`).
- **Dynamic Greeting**: A route (`/hello/:name`) that greets the user with their name using an embedded template.

## Routes

1. `/`  
   Displays a plain text welcome message.

2. `/hello/:name`  
   Renders an HTML page with a personalized greeting. Replace `:name` with any value in the URL.

## Example

Start the application:
```bash
perl my_mojo_app.pl daemon