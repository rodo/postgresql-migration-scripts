from jinja2 import Environment, FileSystemLoader

tables = [
    {"name": "boats", "column": "price"},
    {"name": "cars", "column": "price"}
]

def test_files(template_test, filename, tables, nbstep):

    with open(filename, mode="w", encoding="utf-8") as message:
        message.write(template_test.render(
            tables=tables,
            nbstep=nbstep
        ))
        print(f"... wrote {filename}")



environment = Environment(loader=FileSystemLoader("templates/"))
template = environment.get_template("addcolumns.sql")

filename = "02_first_step.sql"

with open(filename, mode="w", encoding="utf-8") as message:
    for table in tables:

        content = template.render(table=table["name"], column=table["column"])

        message.write(content)
        print(f"... wrote {filename}")

#
# write test file
test_files(environment.get_template("test_before.sql"),
           "01_test_before.sql",
           tables,
           2 * len(tables))

test_files(environment.get_template("test_after.sql"),
           "03_test_after.sql",
           tables,
           6 * len(tables))

test_files(environment.get_template("update.sql"),
           "04_update.sql",
           tables,
           10000)

test_files(environment.get_template("vacuum.sql"),
           "05_vacuum.sql",
           tables,
           6 * len(tables))

test_files(environment.get_template("switch_columns.sql"),
           "06_switch.sql",
           tables,
           6 * len(tables))

test_files(environment.get_template("drop_objects.sql"),
           "07_drop.sql",
           tables,
           6 * len(tables))

test_files(environment.get_template("test_final.sql"),
           "08_test_final.sql",
           tables,
           6 * len(tables))
