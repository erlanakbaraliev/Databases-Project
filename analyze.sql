-- Решите вопросы 1-3 используя подзапросы (subqueries)
-- 1. Выведите все книги автора 'Ариана Арвис'
SELECT * FROM books
WHERE id IN (
	SELECT book_id FROM authors_books
	WHERE author_id= (
		SELECT id FROM authors
		WHERE name='Ариана Арвис'
	)
);

-- 2. Выведите все авторы книги 'Валун'
SELECT * FROM authors
WHERE id IN (
	SELECT author_id FROM authors_books
	WHERE book_id = (
		SELECT id FROM books
		WHERE title='Валун'
	)
);

-- 3. Выведите все рейтинги книги 'Пока мы мечтали'
SELECT * FROM rating
WHERE book_id = (
	SELECT id FROM books
	WHERE title='Пока мы мечтали'
);


-- Решите вопросы 4-8 используя JOIN
-- 4. Объедините таблицы books и publishers
SELECT *
FROM books
JOIN publishers ON books.publisher_id=publishers.id;

-- 5. Объедините таблицы books и publishers и выведите все книги опубликованные издателем у которого название начинается с 'And'
SELECT *
FROM books
JOIN publishers ON books.publisher_id=publishers.id
WHERE publishers.name LIKE 'And%';

-- 6. Объедините таблицы books и rating и выведите все рейтинги книги 'Парадайс'
SELECT *
FROM books b
JOIN rating r ON b.id = r.book_id
WHERE b.title='Парадайс';

-- 7. Объедините таблицы authors и books по третьей таблице authors_books
SELECT *
FROM authors a
JOIN authors_books ab ON a.id=ab.author_id
JOIN books b ON b.id=ab.book_id;

-- 8. Объедините таблицы authors и books по таблице authors_books, 
   -- выведите столбцы name из таблицы authors, 
   -- title, pages, published_date из таблицы books
SELECT a.name, b.title, b.pages, b.published_date
FROM authors a
JOIN authors_books ab ON a.id=ab.author_id
JOIN books b ON b.id=ab.book_id;


-- Aggregate функции, GROUP BY, ORDER BY
-- 9. Выведите средний рейтинг каждой книги (таблицы books, rating)
SELECT b.title, ROUND(AVG(r.rating),2) AS "средний_рейтинг"
FROM books b
JOIN rating r ON b.id = r.book_id
GROUP BY b.title;

-- 10. Выведите средний рейтинг книги 'Парадайс'
SELECT b.title, ROUND(AVG(r.rating),2) AS "средний_рейтинг"
FROM books b
JOIN rating r ON b.id = r.book_id
GROUP BY b.title
HAVING b.title='Парадайс';

-- 11. Выведите средний рейтинг каждой книги и сортируйте их по средний_рейтинг по убыванию
SELECT b.title, ROUND(AVG(r.rating),2) AS "средний_рейтинг"
FROM books b
JOIN rating r ON b.id = r.book_id
GROUP BY b.title
ORDER BY средний_рейтинг DESC;


-- View (Представление)
-- 12. Объедините таблицы authors и books по таблице authors_books, 
   --  выведите столбцы name из таблицы authors, 
   --  title, pages, published_date из таблицы books,
   --  и создайте View (представление) authors_books_view
CREATE VIEW authors_books_view AS
	SELECT a.name, b.title, b.pages, b.published_date
	FROM authors a
	JOIN authors_books ab ON a.id=ab.author_id
	JOIN books b ON b.id=ab.book_id;

-- 13. Из представлении authors_books_view, выведите книги которые были опубликованы в 2020 году и сортируйте по количеству страниц (pages) по убыванию
SELECT * FROM authors_books_view
WHERE published_date>='2020-01-01' AND published_date<='2020-12-12'
ORDER BY pages DESC;

-- 14. Объедините таблицы books и rating, 
	-- выведите столбцы id, title, pages, published_date из таблицы books, средниц рейтинг из таблицы rating,
	-- сгруппируйте по id книги и сортируйте по среднему рейтингу по обыванию (DESC)
	-- и создайте временное(Temporary) View(представление) books_ratings_view,
CREATE TEMPORARY VIEW books_ratings_view AS
	SELECT b.id, b.title, b.pages, b.published_date, ROUND(AVG(r.rating),2) AS "средний_рейтинг"
	FROM books b
	JOIN rating r ON b.id = r.book_id
	GROUP BY b.id
	ORDER BY средний_рейтинг DESC;

-- 15. Из представлении books_ratings_view, выведите топ 5 книг с самым высоким средним рейтингом
SELECT * 
FROM books_ratings_view LIMIT 5;

-- 16. Объедините таблицы books и publishers
	-- выведите столбцы title из таблицы books и name из таблицы publishers, 
	-- создайте CTE(Common Table Expression, одноразовое) View(представление) books_publishers_view
WITH books_publishers_view AS (
	SELECT b.title, p.name
	FROM books b
	JOIN publishers p ON b.publisher_id = p.id
)
SELECT * FROM books_publishers_view;


-- Insert, Update, Delete
-- 17. Добавьте новый автор в таблицу authors с именем 'Ким Чен Ын', country: 'Korea', birthdate: '1984-01-08'
INSERT INTO authors(name, country, birthdate)
VALUES ('Ким Чен Ын', 'Korea', '1984-01-08');

-- 18. Обновите имя авторы 'Ким Чын Ын' на 'Rumi', country на: Persian, birthdate: '1273-09-30'
UPDATE authors
SET name='Rumi', country='Persia', birthdate='1273-09-30'
WHERE name='Ким Чен Ын';

-- 19. Удалите автор с именем 'Rumi'
DELETE FROM authors
WHERE name='Rumi';


-- CASE
-- 20. Выведите столбцы title, pages, 
	-- и в новом столбце 
		-- если количество страниц больше 0 и меньше 100, напишите 'маленькая книги'
		-- если количество страниц больше 100 и меньше 200, напишите 'средняя книги'
		-- в ином случае напишите 'большая книги' (ELSE)
	--  из таблицы books
SELECT title, pages,
	CASE
		WHEN pages <= 100 THEN 'маленькая книга'
		WHEN pages <= 200 THEN 'средняя книги'
		ELSE 'большая книга'
	END
FROM books;

-- 21. Выведите столбцы title и
	-- если формат='мягкий', то 'м'
	-- если формат='твердый', то т'
	-- из таблицы books
SELECT title,
	CASE 
		WHEN format='мягкий' THEN 'м'
		WHEN format='твердый' THEN 'т'
	END
FROM books;


-- INDEX
-- 22. Создайте индекс с названием books_title_index для столбца title из таблицы books чтобы получение данных по названию книги было очень быстрым
CREATE INDEX books_title_index
ON books(title);

-- Процедура (Procedure)
-- 23. Создайте процедуру add_author(name text, country text, birthdate date), используя которого сможем добавить данные в таблицу authors
CREATE PROCEDURE add_author(name text, country text, birthdate date)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO authors (name, country, birthdate)
	VALUES (name, country, birthdate);
END;
$$;

CALL add_author('Касымалы Баялинов', 'Кыргызстан', '1902-09-25');

-- 24. Создайте процедуру add_book(title text, publisher_id int, format text, pages int, published_date date), используя которого сможем добавить данные в таблицу books
CREATE PROCEDURE add_book(title text, publisher_id int, format text, pages int, published_date date)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO books (title, publisher_id, format, pages, published_date)
	VALUES (title, publisher_id, format, pages, published_date);
END;
$$;

CALL add_book('Ажар', NULL, 'твердый', 18, '1928-01-01');

