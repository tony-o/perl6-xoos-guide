use DB::Xoos::Model;
unit class App::Model::Book does DB::Xoos::Model['books'];

has @.columns = [
  book_id => {
   type           => 'integer',
   is-primary-key => True,
   auto-increment => True,
  },
  title => {
    type     => 'varchar',
    nullable => False,
    length   => '64',
  },
  author_id => {
    type   => 'varchar',
    nullable => False,
    length => '64',
  },
  date_published => {
    type   => 'date',
  },
  price => {
    type   => 'float',
  },
];

has @.relations = [
  authors => {
    :has-one,
    :model<Author>,
    :relate(author_id => 'author_id'),
  },
  order_details => {
    :has-many,
    :model<OrderDetails>,
    :relate(book_id => 'book_id'),
  },
];
