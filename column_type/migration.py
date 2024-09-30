"""
Manage huge and sometimes complex data migration in 3 steps

- Edit the variable tables 10 lines below in this script
- Run the script
- Enjoy the SQL files generated

"""

import os
import argparse
from jinja2 import Environment, FileSystemLoader

#
# Describe here the column you want to change
#
# name : the table name
# column : the column name
# source_type : the original type of the column
# dest_type : the new type of the column

tables = [
    {
        "name": "boats",
        "columns": [
            {
                "column": "price",
                "source_type": "numeric(7,2)",
                "dest_type": "numeric(8,3)"
            },
            {
                "column": "discount_price",
                "source_type": "numeric(7,2)",
                "dest_type": "numeric(8,3)"
            }
        ]
    },
    {
        "name": "cars",
        "columns": [
            {"column": "price",
             "source_type": "numeric(7,2)", "dest_type": "numeric(8,3)"
             }
        ]
    },
]


def generate_file(template_test, filename, data, nbstep, timeout=50):
    """
    Load a jinja template and generate the associated file
    """
    with open(filename, mode="w", encoding="utf-8") as message:
        message.write(template_test.render(tables=data, nbstep=nbstep, timeout=timeout))
        print(f"... wrote {filename}")


environment = Environment(loader=FileSystemLoader("templates/"))

def tap_elements_size(table_element, column_element, table_list):
    """
    Return the number of elements
    """

    nb = table_element * len(table_list)

    for table in table_list:
        nb = nb + column_element * len(table['columns'])



    return nb


def generate_global_file(path, table_list, batch_size, timeout):
    """
    Generate files in the specified directory `path`
    """
    generate_file(
        environment.get_template("test_before.sql"),
        os.path.join(path, "01_test_before.sql"),
        table_list,
        tap_elements_size(4, 4, table_list)
    )

    generate_file(
        environment.get_template("addcolumns.sql"),
        os.path.join(path, "02_add_columns.sql"),
        table_list,
        tap_elements_size(3, 1, table_list),
        timeout
    )

    generate_file(
        environment.get_template("test_after.sql"),
        os.path.join(path, "03_test_after.sql"),
        table_list,
        tap_elements_size(4, 3, table_list)
    )

    generate_file(
        environment.get_template("update.sql"),
        os.path.join(path, "04_update.sql"),
        table_list,
        batch_size,
    )

    generate_file(
        environment.get_template("vacuum.sql"),
        os.path.join(path, "05_vacuum.sql"),
        table_list,
        6 * len(table_list),
    )

    generate_file(
        environment.get_template("test_final.sql"),
        os.path.join(path, "06_check_datas.sql"),
        table_list,
        len(table_list),
    )

    generate_file(
        environment.get_template("switch_columns.sql"),
        os.path.join(path, "07_switch.sql"),
        table_list,
        6 * len(table_list),
        timeout
    )

    generate_file(
        environment.get_template("drop_objects.sql"),
        os.path.join(path, "08_drop.sql"),
        table_list,
        6 * len(table_list),
        timeout
    )

    generate_file(
        environment.get_template("test_clean.sql"),
        os.path.join(path, "09_test_clean.sql"),
        table_list,
        tap_elements_size(4, 4, table_list)
    )


def main(table_list, batch_size, timeout):
    """
    Do the generation of files in the global directory and in a drectory per table
    """

    # generate the SQL command in global files
    generate_global_file("output", table_list, batch_size, timeout)

    # genreate the SQL command in one directory per table
    for table in table_list:
        ltable = []
        ltable.append(table)
        try:
            os.makedirs(os.path.join("output", table['name']))
        except OSError:
            pass
        generate_global_file(os.path.join("output", table['name']), ltable, batch_size, timeout)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-b", "--batch", help="the batch size of updates", type=int, default=10000)
    parser.add_argument("-t", "--timeout", help="statement timeout in ms", type=int, default=50)
    args = parser.parse_args()
    main(tables, args.batch, args.timeout)
