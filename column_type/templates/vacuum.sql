--
-- Vacuum all tables
--
{% for table in tables -%}
VACUUM {{ table.name }};
{% endfor %}
