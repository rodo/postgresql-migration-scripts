"""
Manage huge and sometimes complex data migration in 3 steps

- Edit the variable tables 10 lines below in this script
- Run the script
- Enjoy the SQL files generated

"""
from jinja2 import Environment, FileSystemLoader

#
# Describe here the column you want to change
#

tables = [
    {"name": "boats", "column": "price", "type": "numeric(8,3)"},
    {"name": "cars", "column": "price", "type": "numeric(8,3)"},
]


def generate_file(template_test, filename, data, nbstep):
    """
    Load a jinja template and generate the associated file
    """
    with open(filename, mode="w", encoding="utf-8") as message:
        message.write(template_test.render(tables=data, nbstep=nbstep))
        print(f"... wrote {filename}")


environment = Environment(loader=FileSystemLoader("templates/"))

#
# Generate files
generate_file(
    environment.get_template("test_before.sql"),
    "01_test_before.sql",
    tables,
    2 * len(tables),
)

generate_file(
    environment.get_template("addcolumns.sql"),
    "02_add_columns.sql",
    tables,
    2 * len(tables),
)


generate_file(
    environment.get_template("test_after.sql"),
    "03_test_after.sql",
    tables,
    6 * len(tables),
)

generate_file(environment.get_template("update.sql"), "04_update.sql", tables, 10000)

generate_file(
    environment.get_template("vacuum.sql"), "05_vacuum.sql", tables, 6 * len(tables)
)

generate_file(
    environment.get_template("test_final.sql"),
    "06_check_datas.sql",
    tables,
    6 * len(tables),
)

generate_file(
    environment.get_template("switch_columns.sql"),
    "07_switch.sql",
    tables,
    6 * len(tables),
)

generate_file(
    environment.get_template("drop_objects.sql"), "08_drop.sql", tables, 6 * len(tables)
)

generate_file(
    environment.get_template("test_clean.sql"),
    "09_test_clean.sql",
    tables,
    6 * len(tables),
)
