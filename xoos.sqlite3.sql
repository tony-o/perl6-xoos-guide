create table books (book_id integer primary key autoincrement, title varchar(64) not null, author_id integer not null, date_published date, price float not null);
create table authors (author_id integer primary key autoincrement, name varchar(64) not null, birth_date date);
create table customers (customer_id integer primary key autoincrement, email_address varchar(64) not null, name varchar(64) not null, date_registered date default (datetime('now','localtime')));
create table orders (order_id integer primary key autoincrement, customer_id integer not null, order_date date default (datetime('now','localtime')));
create table order_details (order_detail_id integer primary key autoincrement, order_id integer not null, book_id integer not null);

