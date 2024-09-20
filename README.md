# postgresql-migration-scripts
Collection of scripts that helps doing data migration

# column_type

The directory column_type contains a python script and jinja templates
to generate SQL files usefull when you want to change the type of a
column that occurs a table rewrite.

To avoid this we will create a temporary objects in the schema
(columns, index, trigger and function) that will be play on production
on a manner that limit the locks.

HOWTO

1. edit the `migration.py` script to defin the table and column you want to change

2. run `migration.py`

3. run all the generated `0X_....sql` files, be sure the run the file
`04_update.sql` as many times as needed to update all the lines in the
tables you define