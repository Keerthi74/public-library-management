--Kerthana Cheruvu
--G01160202
--Final Project sql queries for the Questions.


--1. Which materials are currently available in the library?

select distinct(m.material_id), m.title from library."Material" m
inner join library."Borrow" b on b.material_id=m.material_id 
where b.return_date is not null
order by m.material_id;

--2. Which materials are currently overdue?
--(Suppose today is 04/01/2023, and show the borrow date and due date of each material)

select br.borrow_date, br.due_date, br.return_date, mr.title as material_title 
from library."Borrow" br
inner join library."Material" mr on mr.material_id = br.material_id
where br.due_date < '2023-04-01' and br.return_date is NULL;

--3. What are the top 10 most borrowed materials in the library?
--(Show the title of each material and order them based on their available counts)

select mt.material_id, mt.title as material_title, count(mt.material_id) as material_count from library."Borrow" bw
join library."Material" mt on mt.material_id=bw.material_id 
where bw.return_date is NOT NULL 
group by mt.material_id
order by material_count desc
limit 10;

--4.How many books has the author Lucas Piki written?

select m.title, au.name, count(a.authorship_id) as books_count from library."Authorship" a
join library."Material" m on m.material_id=a.material_id
join library."Author" au on au.author_id=a.author_id
where au.name='Lucas Piki'
group by m.title, au.name;

--5.How many books were written by two or more authors?

select count(*) as count_auth from (select material_id
from library."Authorship"
group by material_id
having count(*) >1) as count_auth;

--6. What are the most popular genres in the library?

select count(m.genre_id) as genre_count, g.name from library."Borrow" b
join library."Material" m on m.material_id=b.material_id 
join library."Genre" g on g.genre_id = m.genre_id
group by m.genre_id, g.name
order by genre_count desc;

--7. How many materials have been borrowed from 09/2020-10/2020?

select m.title, count(m.material_id) as materials_borrowed from library."Borrow" b
join library."Material" m on m.material_id=b.material_id
where b.borrow_date between '2020-09-01' and '2020-10-31'
group by m.material_id, m.title;

--8. How do you update the “Harry Potter and the Philosopher's Stone” when it is returned on 04/01/2023?

update library."Borrow"
set return_date='2023-04-01'
where material_id = (select material_id from library."Material" where title='Harry Potter and the Philosophers Stone');


select * from library."Borrow";

--9. How do you delete the member Emily Miller and all her related records from the database?

alter table library."Borrow" 
	drop constraint fk_member,
	add constraint fk_member
	foreign key(member_id)
	references library."Member"(member_id) on delete cascade;

delete from library."Member"
where name='Emily Miller';


select * from library."Member";

--10.How do you add the following material to the database?
--Title: New book
--Date: 2020-08-01
--Catalog: E-Books
--Genre: Mystery & Thriller
--Author: Lucas Pipi

insert into library."Material"(material_id, title, publication_date, catalog_id, genre_id) 
values(32, 'New book', '2020-08-01', 
		(select catalog_id from library."Catalog" where name = 'E-Books'), 
		(select genre_id from library."Genre" where name = 'Mystery & Thriller'));

insert into library."Authorship"(Authorship_ID, Author_ID, Material_ID) 
values(34,(select author_id from library."Author" where name = 'Lucas Piki'), 
	   (select material_id from library."Material" where title = 'New book'));

select * from library."Material";

select * from library."Authorship";














