SELECT 'runstats on table '||ltrim(rtrim(TABSCHEMA) || '.' || rtrim(TABNAME))||' with distribution and detailed indexes all allow write access;'
FROM (
SELECT tabschema,tabname,stats_time
FROM syscat.tables
WHERE stats_time IS NOT NULL AND TYPE='T'
AND tabname NOT LIKE 'IBMQREP%')
WHERE TO_TIMESTAMP(stats_time,'YYYY-MM-DD-HH24.MI.SS.FF') < CURRENT timestamp - 3 month