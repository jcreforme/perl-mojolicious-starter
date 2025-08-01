#!/usr/bin/env perl
use Mojolicious::Lite;
use Mojo::UserAgent;

# Alpha Vantage API key
my $api_key = '1FO6EJAG9YA9PHY9';

# UserAgent for API requests
my $ua = Mojo::UserAgent->new;

# Route to display stock monitor
get '/' => sub {
  my $c = shift;
  $c->render(template => 'stocks');
};

# WebSocket route for real-time updates
websocket '/updates' => sub {
  my $c = shift;

  # Stock symbols to monitor
  my @symbols = qw(AAPL TSLA AMZN);

  # Send stock updates every 5 seconds
  my $timer = Mojo::IOLoop->recurring(5 => sub {
    my %stock_data;

    # Add this line at the beginning of your WebSocket route
    # Add this line at the beginning of your WebSocket route
    my $log = app->log;

    # Use $log for logging
    foreach my $symbol (@symbols) {
        my $res = $ua->get("https://www.alphavantage.co/query", {
            function => 'GLOBAL_QUOTE',
            symbol   => $symbol,
            apikey   => $api_key
        })->result;

        if ($res->is_success) {
            my $data = $res->json->{'Global Quote'};
            if ($data) {
                $stock_data{$symbol} = {
                    price  => $data->{'05. price'} + 0,
                    change => $data->{'10. change percent'}
                };
            } else {
                $log->error("Unexpected API response for $symbol: " . $res->body);
                $stock_data{$symbol} = { price => 0, change => 'null' };
            }
        } else {
            $log->error("Failed to fetch data for $symbol: " . $res->message);
            $stock_data{$symbol} = { price => 0, change => 'null' };
        }
    }

    # Send stock data to the client
    $c->send({json => \%stock_data});
  });

  # Cleanup on WebSocket close
  $c->on(finish => sub {
    Mojo::IOLoop->remove($timer);
  });
};

app->start;

__DATA__

@@ stocks.html.ep
<!DOCTYPE html>
<html>
  <head>
    <title>Stock Monitor</title>
    <script>
      let ws = new WebSocket('<%= url_for('updates')->to_abs %>');
      ws.onmessage = (event) => {
        let stocks = JSON.parse(event.data);
        let table = document.getElementById('stock-table');
        table.innerHTML = '';
        for (let symbol in stocks) {
          let row = `<tr>
            <td>${symbol}</td>
            <td>${stocks[symbol].price}</td>
            <td>${stocks[symbol].change}</td>
          </tr>`;
          table.innerHTML += row;
        }
      };
    </script>
  </head>
  <body>
    <h1>Stock Monitor</h1>
    <table border="1">
      <thead>
        <tr>
          <th>Symbol</th>
          <th>Price</th>
          <th>Change</th>
        </tr>
      </thead>
      <tbody id="stock-table">
        <tr><td colspan="3">Loading...</td></tr>
      </tbody>
    </table>
  </body>
</html>