import pymongo
import psycopg2


def get_row_count(table):
    cursor = conn.cursor()
    row_count = f"SELECT count(*) FROM {table}"
    cursor.execute(row_count)
    row_count_obj = cursor.fetchall()
    if row_count_obj:
        return row_count_obj[0][0]
    return None


def query_data_from_postgres(table, offset):
    try:
        cursor = conn.cursor()
        offset_query = f"SELECT array_to_json(array_agg(row_to_json ({table}))) FROM (SELECT * FROM {table} limit 10 OFFSET {offset}) {table};"
        cursor.execute(offset_query)
        result = cursor.fetchall()
        if result:
            result = result[0][0]
            return result
        else:
            return None
    except:
        print(f"This table failed --> {table}")
        return None


def dump_data_to_postgres():
    tables = fetch_all_tables_in_postgres()
    if not tables:
        print("No tables found")
    else:
        for table in tables:
            row_count = get_row_count(table)
            if not row_count:
                continue

            if row_count > 100000:
                row_count = 100000
            for row in range(0, row_count+1, 10):
                result = query_data_from_postgres(table, row)
                if result:
                    col = mydb[table]
                    x = col.insert_many(result)
                    print(x.inserted_ids)


def fetch_all_tables_in_postgres():
    cursor = conn.cursor()
    cursor.execute("select relname from pg_class where relkind='r' and relname !~ '^(pg_|sql_)';")
    result = cursor.fetchall()
    if result:
        return [ table[0] for table in result ]
    else:
        return None


if __name__ == "__main__":
    conn = psycopg2.connect(database="webapp", user='webapp', password='***REMOVED***', host='webapp-dev.c9kglzh8azo4.us-east-1.rds.amazonaws.com', port= '5432')
    myclient = pymongo.MongoClient("mongodb://alacrity:***REMOVED***@***REMOVED***:27017/")
    mydb = myclient["admin"]
    dump_data_to_postgres()
