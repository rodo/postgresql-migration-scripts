--
-- Vacuum all tables
--
\timing on
{% for table in tables -%}
VACUUM {{ table.name }};
{% endfor %}
