#!/usr/bin/env bash
#  Author: AndyJ      2023/12
#  Purpose: generate db2 normal user's privileges to grant script (Roles & schema object's)
#  
#
DB_NAME=$1
SRC_USR=$2
OUT_USR=$3


Usage() {
    echo
    echo "Usage: `basename $0`  [DB_NAME] [SRC_USR] [OUT_USR] ";
}


Main() {
db2 -x connect to ${DB_NAME} > /dev/null 2>&1
db2 -x "SELECT 'GRANT ROLE '||ROLENAME||' TO USER ${OUT_USR};' FROM SYSCAT.ROLEAUTH WHERE GRANTEE='${SRC_USR}'"
db2 -x "
SELECT 'GRANT SELECT ON TABLE '||RTRIM(TABSCHEMA)||'.'||TABNAME||' TO USER ${OUT_USR};'
FROM SYSCAT.TABAUTH
WHERE GRANTEE='${SRC_USR}' AND SELECTAUTH ='Y'
UNION ALL
SELECT 'GRANT UPDATE ON TABLE '||RTRIM(TABSCHEMA)||'.'||TABNAME||' TO USER ${OUT_USR};'
FROM SYSCAT.TABAUTH
WHERE GRANTEE='${SRC_USR}' AND UPDATEAUTH ='Y'
UNION ALL
SELECT 'GRANT DELETE ON TABLE '||RTRIM(TABSCHEMA)||'.'||TABNAME||' TO USER ${OUT_USR};'
FROM SYSCAT.TABAUTH
WHERE GRANTEE='${SRC_USR}' AND DELETEAUTH ='Y'
UNION ALL
SELECT 'GRANT INSERT ON TABLE '||RTRIM(TABSCHEMA)||'.'||TABNAME||' TO USER ${OUT_USR};'
FROM SYSCAT.TABAUTH
WHERE GRANTEE='${SRC_USR}' AND INSERTAUTH ='Y'
"
db2 -x terminate > /dev/null 2>&1
}

if [ $# -ne 3 ];
then
    Usage
    exit 1
fi

Main
