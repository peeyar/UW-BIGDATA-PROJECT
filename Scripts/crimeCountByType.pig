CRIME_STATS = LOAD 'Chicago_Crime_Abbreviated.csv' using PigStorage(',') 
AS (Year:chararray,Type:chararray,Description:chararray,Location:chararray);

TOTAL_CRIME_TYPE = GROUP CRIME_STATS BY (Type);

TOTAL_CRIME_TYPE_COUNT = FOREACH TOTAL_CRIME_TYPE GENERATE group AS Type, COUNT(CRIME_STATS);

DUMP TOTAL_CRIME_TYPE_COUNT;

STORE TOTAL_CRIME_TYPE_COUNT into 'output/total_crimes_year';
