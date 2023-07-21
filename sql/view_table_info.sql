SELECT
sysi_tabs.Tabschema,
sysi_tabs.tabname,
sysc_tabs.CARD AS ROW_CNT,
sysi_tabs.TOTAL_SIZE_MB,
sysi_tabs.IS_PARTITION
FROM
(
SELECT Tabschema,tabname,
SUM(DATA_OBJECT_L_SIZE + INDEX_OBJECT_L_SIZE)/1024 AS TOTAL_SIZE_MB,
CASE
WHEN count(*)>1 THEN 'Y'
ELSE 'N'
END AS IS_PARTITION
FROM sysibmadm.ADMINTABINFO
GROUP BY tabschema,tabname
) AS sysi_tabs,
syscat.tables sysc_tabs
WHERE sysi_tabs.tabschema=sysc_tabs.tabschema AND sysi_tabs.tabname=sysc_tabs.tabname
AND (sysc_tabs.tabschema,sysc_tabs.tabname) IN ( VALUES ('SCHEMA_A','TABNAME_A'),('SCHEMA_B','TABNAME_B'))