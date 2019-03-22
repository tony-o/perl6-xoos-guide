#!/usr/bin/env perl6

use DB::Xoos::SQLite;
use lib 'lib';

my $xoos = DB::Xoos::SQLite.new;

$xoos.connect('sqlite://xoos.sqlite3', :options({
  :prefix<App>,               # loads classes from App::Model::*
  model-dirs => [qw<models>], # for our yaml column definitions
}));




use Text::CSV;

my @rows    = csv(:in('data/books.csv'));

my $book = $xoos.model('Book');
my $auth = $xoos.model('Author');
my $customer = $xoos.model('Customer');
my $order = $xoos.model('Order');
my $order-detail = $xoos.model('OrderDetail');

my %book-ids;

$book.delete;
$order-detail.delete;


# generate book and author data from csv
for @rows[1..*] -> $row {

  # determine whether an author by that name exists, this isn't
  # robust as there may be many authors by the same name
  my $author = $auth.search({
    name => $row[1] eq '' ?? 'unknown' !! $row[1];
  });

  # if an author was found, use it
  if $author.count {
    $author .=first;
  } else {
    $author = $auth.new-row;
    $author.name($row[1] eq '' ?? 'unknown' !! $row[1]);
    $author.update;
  }
  
  # create our book and generate a random price
  my $nb = $book.new-row({
    author_id => $author.author_id,
    title     => $row[0],
    price     => (299 .. 5000).pick(1)[0] / 100,
  });

  $nb.update;

  %book-ids{$nb.book_id} = 1;
}


# generate 10 - 20 customers
for 0 .. (10.rand.Int + 10) {
  my $data = {
    email_address => "xyz+$_\@perl6.dev",
    name          => "person x$_",
  };
  my $c = $customer.new-row($data);
  $c.update;

  # generate 0 to 5 orders
  for 0 .. 5.rand.Int {
    my $o = $order.new-row({
      customer_id => $c.customer_id,
    });
    $o.update;

    # generate 1 to 3 order details
    for 1 .. (1 + 3.rand.Int) {
      $order-detail.new-row({
        order_id => $o.order_id,
        book_id  => %book-ids.keys.pick(1)[0],
      }).update;
    }
  }
}
