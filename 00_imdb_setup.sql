create table dbo.Movie (
  MovieID int not null IDENTITY(1,1) CONSTRAINT MoviePK PRIMARY Key
, MovieTitle varchar(200)
, MovieDescription varchar(1000)
, MovieYear int
, MovieRuntime smallint
) as Node;
GO
create table dbo.Person (
PersonID int not null IDENTITY(1,1) CONSTRAINT PersonPK PRIMARY KEY
, PersonName varchar(100)
) as Node;
GO
create TABLE dbo.Genre (
 GenreID int not null IDENTITY(1,1) CONSTRAINT GenrePK PRIMARY KEY
 , GenreName varchar(30)
) as Node;
