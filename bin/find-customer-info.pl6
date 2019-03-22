#!/usr/bin/env perl6

use lib 'lib';
use DB::Xoos::SQLite;
my DB::Xoos::SQLite $db .=new;


multi MAIN(:$email?, :$name, :$customer-id) {

  $db.connect('sqlite://xoos.sqlite3', :options({
    model-dirs => [qw<models>],
    prefix     => 'App',
  }));


  my %search;
  my $customers = $db.model('Customer');

  %search<customer_id> = $customer-id if $customer-id.defined;
  %search<name>        = %(
    'like' => '%' ~ $name ~ '%',
  ) if $name.defined;
  %search<email_address>        = %(
    'like' => '%' ~ $email ~ '%',
  ) if $email.defined;

  if %search.keys {
    $customers .=search(%search);
    say "Searching with params:";
    dd %search;
  }
  say 'Customer info:';
  printf "| %-14s | %-17s | %-14s | %-12s | %-14s |\n", qw<customer_id email name orders order-items>;
  say 'x' x 87;

  for $customers.all -> $customer {
    printf "| %-14s | %-17s | %-14s | %-12s | %-14s |\n",
      $customer.customer_id,
      $customer.email_address,
      $customer.name,
      $customer.orders.count,
      $customer.total-order-items; # this uses the row level convenience method in App::Row::Customer
  }

  say 'x' x 87;

}
