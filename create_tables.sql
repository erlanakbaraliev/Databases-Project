CREATE TABLE publishers (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL
);

CREATE TABLE books (
	id SERIAL PRIMARY KEY,
	title TEXT NOT NULL,
	publisher_id INT,
	format TEXT CHECK(format IN ('твердый', 'мягкий')),
	pages INT,
	published_date DATE DEFAULT CURRENT_DATE,
	FOREIGN KEY (publisher_id) REFERENCES publishers(id)
);

CREATE TABLE authors (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	country TEXT,
	birthdate DATE CHECK(birthdate < CURRENT_DATE)
);

CREATE TABLE authors_books (
	author_id INT,
	book_id INT,
	FOREIGN KEY(author_id) REFERENCES authors(id),
	FOREIGN KEY(book_id) REFERENCES books(id)
);

CREATE TABLE translators (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL
);

CREATE TABLE translators_books (
	translator_id INT,
	book_id INT,
	FOREIGN KEY(translator_id) REFERENCES translators(id),
	FOREIGN KEY(book_id) REFERENCES books(id)
);

CREATE TABLE rating (
	book_id INT,
	rating INT,
	FOREIGN KEY(book_id) REFERENCES books(id)
);