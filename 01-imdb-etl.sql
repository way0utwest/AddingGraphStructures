insert Genre (GenreName)
select distinct g.value
 from dbo.[IMDB-Movie-Data] m
  cross apply string_split(m.genre, ',') g
  
 