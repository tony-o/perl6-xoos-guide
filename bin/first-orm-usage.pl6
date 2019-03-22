#!/usr/bin/env perl6

use DB::Xoos::SQLite;
use lib 'lib';

my $xoos = DB::Xoos::SQLite.new;

$xoos.connect('sqlite://xoos.sqlite3', :options({
    model-dirs => [qw<models>], # for our yaml column definitions
    :prefix<App>,               # loads classes from App::Model::*
}));

"Successfully loaded models:\n  {$xoos.loaded-models.join("\n  ")}".say;
