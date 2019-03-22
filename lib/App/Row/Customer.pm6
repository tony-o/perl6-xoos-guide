use DB::Xoos::Row;
unit class App::Row::Customer does DB::Xoos::Row;

method total-order-items {
  my $items = 0;
  for $.orders.all -> $order {
    $items += $order.order_details.count;
  }
  $items;
}
