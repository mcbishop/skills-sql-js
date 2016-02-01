-- Note: Please consult the directions for this assignment 
-- for the most explanatory version of each question.

-- 1. Select all columns for all brands in the Brands table.

select * from brands;


-- 2. Select all columns for all car models made by Pontiac in the Models table.

select * from models where (brand_name = 'Pontiac');

-- 3. Select the brand name and model 
--    name for all models made in 1964 from the Models table.

select brand_name, name from models where (brand_name = 'Pontiac') and (year = 1964);

-- 4. Select the model name, brand name, and headquarters for the Ford Mustang 
--    from the Models and Brands tables.

select brand_name, models.name, brands.headquarters
from models left join brands on 
(models.brand_name=brands.name)
where (models.name = 'Mustang');


-- 5. Select all rows for the three oldest brands 
--    from the Brands table (Hint: you can use LIMIT and ORDER BY).

select * from brands
order by founded desc
limit 3;

-- 6. Count the Ford models in the database (output should be a number).

select count(name)
from models
where brand_name = 'Ford'
;

-- 7. Select the name of any and all car brands that are not discontinued.

select name
from brands
where discontinued is null; 

-- 8. Select rows 15-25 of the models DB in alphabetical order by model name.
select *
from models
order by name
limit 10 offset 15;


-- 9. Select the brand, name, and year the model's brand was 
--    founded for all of the models from 1960. Include row(s)
--    for model(s) even if its brand is not in the Brands table.
--    (The year the brand was founded should be NULL if 
--    the brand is not in the Brands table.)

select brand_name
, models.name
, founded
from models
left join brands
on (brands.name=models.brand_name)
where models.year=1960
;



-- Part 2: Change the following queries according to the specifications. 
-- Include the answers to the follow up questions in a comment below your
-- query.

-- 1. Modify this query so it shows all brands that are not discontinued
-- regardless of whether they have any models in the models table.
-- before:
-- quickest solution:
    SELECT b.name,
           b.founded,
           m.name
    FROM models AS m
      RIGHT JOIN brands AS b
        ON b.name = m.brand_name
    WHERE b.discontinued IS NULL;

-- another query returning same result:

    SELECT b.name,
           b.founded,
           m.name
    FROM brands AS b
      left JOIN models AS m
        ON b.name = m.brand_name
    WHERE b.discontinued IS NULL;



-- 2. Modify this left join so it only selects models that have brands in the Brands table.
-- before: 
    SELECT m.name,
           m.brand_name,
           b.founded
    FROM Models AS m
      inner JOIN Brands AS b
        ON b.name = m.brand_name;

-- followup question: In your own words, describe the difference between 
-- left joins and inner joins.
In this example:
Inner join selects only records which refer to both Brands and Models tables.

Left join includes all records in the left table, regardless if they also join record(s) in the second table.

-- 3. Modify the query so that it only selects brands that don't have any models in the models table. 
-- (Hint: it should only show Tesla's row.)
-- before: 
    SELECT name,
           founded
    FROM Brands
      LEFT JOIN Models
        ON brands.name = Models.brand_name
    WHERE Models.name is null;

-- 4. Modify the query to add another column to the results to show 
-- the number of years from the year of the model until the brand becomes discontinued
-- Display this column with the name years_until_brand_discontinued.
-- before: 
    SELECT b.name,
           m.name,
           m.year,
           b.discontinued,
           (b.founded-b.discontinued) years_until_brand_discontinued
    FROM Models AS m
      LEFT JOIN brands AS b
        ON m.brand_name = b.name
    WHERE b.discontinued is NOT NULL;


-- Part 3: Further Study

-- 1. Select the name of any brand with more than 5 models in the database.


select brands.name
from brands inner join models on
(brands.name=models.brand_name)
group by brands.name
having count(brands.name) > 5;

-- 2. Add the following rows to the Models table.

-- year    name       brand_name
-- ----    ----       ----------
-- 2015    Chevrolet  Malibu
-- 2015    Subaru     Outback

INSERT INTO models (year, name, brand_name)
VALUES ('2015','Chevrolet','Malibu'),
('2015','Suburu','Outback');

-- 3. Write a SQL statement to crate a table called `Awards`
--    with columns `name`, `year`, and `winner`. Choose
--    an appropriate datatype and nullability for each column
--   (no need to do subqueries here).

create table Awards
    (name varchar(255) not null,
        year int,
        winner_id int not null,
        foreign key (winner_id) references models(id));

-- 4. Write a SQL statement that adds the following rows to the Awards table:

--   name                 year      winner_model_id
--   ----                 ----      ---------------
--   IIHS Safety Award    2015      the id for the 2015 Chevrolet Malibu
--   IIHS Safety Award    2015      the id for the 2015 Subaru Outback
insert into Awards (name, year, winner_id)
    values('IIHS Safety Award','2015',
        (select models.id
            from models
            where name='Malibu')),
        ('IIHS Safety Award','2015',
            (select models.id
                from models
                where name = 'Outback'));


-- 5. Using a subquery, select only the *name* of any model whose 
-- year is the same year that *any* brand was founded.

select models.name from models
inner join brands on (models.brand_name=brands.name)
where models.year in (
select brands.founded from brands);



