/*
Adding Graph Structures - Kevin Bacon Queries

I have code for the IMDB database loaded into a SQL Server database named IMDB. This 
should run in SQL Server 2019, but I have had issues with the relational code and some
patch levels of SQL Server 2019. The equivalent Neo4J query is shown for the sample Movie 
database.

Steve Jones, copyright 2022

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.

You are free to use this code inside of your own organization.
*/
USE IMDB
GO
/*
Relational code
*/
declare @actor varchar(100) = 'A Pacino'
	SET NOCOUNT ON;
	DECLARE @actor1 nvarchar(1000), @movie1 nvarchar(1000), @year1 nvarchar(5),
		@actor2 nvarchar(1000), @movie2 nvarchar(1000), @year2 nvarchar(5),
		@actor3 nvarchar(1000), @movie3 nvarchar(1000), @year3 nvarchar(5),
		@actor4 nvarchar(1000), @movie4 nvarchar(1000), @year4 nvarchar(5),
		@actor5 nvarchar(1000), @movie5 nvarchar(1000), @year5 nvarchar(5),
		@actor6 nvarchar(1000), @movie6 nvarchar(1000), @year6 nvarchar(5),
		@actor7 nvarchar(1000);
	select top 1 @actor1 = actor.name, @movie1 = movie.name, @year1 = movie.year, 
	@actor2 = actor2.name, @movie2 = movie2.name, @year2 = movie2.year,
	@actor3 = actor3.name, @movie3 = movie3.name, @year3 = movie3.year,
	@actor4 = actor4.name, @movie4 = movie4.name, @year4 = movie4.year,
	@actor5 = actor5.name, @movie5 = movie5.name, @year5 = movie5.year,
	@actor6 = actor6.name, @movie6 = movie6.name, @year6 = movie6.year,
	@actor7 = actor7.name
	FROM actor, actedIn, movie, [cast], 
	actor actor2, actedIn actedIn2, [cast] cast2, movie movie2,
	actor actor3, actedIn actedIn3, [cast] cast3, movie movie3,
	actor actor4, actedIn actedIn4, [cast] cast4, movie movie4,
	actor actor5, actedIn actedIn5, [cast] cast5, movie movie5,
	actor actor6, actedIn actedIn6, [cast] cast6, movie movie6,
	actor actor7

	WHERE MATCH (actor-(actedIn)->movie-([cast])->actor2-(actedIn2)->movie2-(cast2)->actor3-(actedIn3)->movie3-(cast3)->actor4-(actedIn4)->movie4-(cast4)->actor5-(actedIn5)->movie5-(cast5)->actor6-(actedIn6)->movie6-(cast6)->actor7) 
	AND actor.name = 'Kevin Bacon' AND 
	(
		actor2.name = @Actor OR 
		actor3.name = @Actor OR
		actor4.name = @Actor OR
		actor5.name = @Actor OR
		actor6.name = @Actor OR
		actor7.name = @Actor
	) OPTION (MAXDOP 1)

	DROP TABLE IF EXISTS #Route;
	CREATE TABLE #Route
	(
		actor nvarchar(1000),
		movie nvarchar(1000),
		[year] nvarchar(5)
	);
	
	INSERT INTO #Route VALUES
		(@actor1, @movie1, @year1),
		(@actor2, @movie2, @year2),
		(@actor3, @movie3, @year3),
		(@actor4, @movie4, @year4),
		(@actor5, @movie5, @year5),
		(@actor6, @movie6, @year6);

	SELECT DISTINCT * FROM #Route;


/*
SQL Server 2017+ Graph Query
*/
SELECT PersonName, Friends
 FROM (
	SELECT p.PrimaryName AS PersonName
         , STRING_AGG(p2.PrimaryName, '->') WITHIN GROUP (graph PATH) AS Friends
	     , LAST_VALUE(p2.PrimaryName) within GROUP (GRAPH PATH) AS LastNode
    FROM IMDB.Person AS p
       , IMDB.Title FOR PATH AS t
       , IMDB.Person FOR PATH AS p2
	   , IMDB.ContributedTo FOR PATH AS ct
	   , IMDB.ContributedTo FOR PATH AS ct2
 WHERE 
    MATCH(SHORTEST_PATH(P(-(ct)->t<-(ct2)-p2){1,4}))
    AND p.PrimaryName = 'Kevin Bacon'
 ) AS q
 WHERE q.LastNode = 'Tom Hanks'

/*
Neo4J

MATCH p=shortestPath(
              (bacon:Person {name:"Kevin Bacon"})-[*]-(a:Person {name:'Al Pacino'})
            )
RETURN p
*/