# SQLGlot Explainer: Snowflake to BigQuery Transpilation

A comprehensive guide and demonstration of using SQLGlot to transpile SQL queries from Snowflake syntax to BigQuery syntax.

## 🎯 Overview

This project provides a hands-on exploration of SQLGlot, a powerful SQL parser, transpiler, and optimizer. The main focus is on demonstrating how to convert SQL queries written for Snowflake into BigQuery-compatible SQL.

### What is SQLGlot?

SQLGlot is a no-dependency SQL parser, transpiler, optimizer, and engine. It can:
- Parse SQL from various dialects (Snowflake, BigQuery, PostgreSQL, MySQL, etc.)
- Convert SQL between different dialects
- Optimize SQL queries
- Work with Abstract Syntax Trees (AST) programmatically

## 📋 Prerequisites

- Python 3.10 or higher
- [UV package manager](https://github.com/astral-sh/uv)

## 🚀 Getting Started

### Installation

1. **Clone or navigate to this repository**

2. **Install dependencies using UV:**

```bash
uv sync
```

This will create a virtual environment and install all required dependencies.

### Running the Notebook

1. **Activate the virtual environment:**

```bash
source .venv/bin/activate  # On Linux/Mac
# or
.venv\Scripts\activate  # On Windows
```

2. **Start Jupyter Notebook:**

```bash
jupyter notebook sqlglot_explainer.ipynb
```

Or if you prefer JupyterLab:

```bash
jupyter lab sqlglot_explainer.ipynb
```

## 📚 What's Inside

### Main Notebook: `sqlglot_explainer.ipynb`

The notebook contains 13 comprehensive examples covering:

1. **Basic Transpilation** - Simple SELECT queries
2. **Data Type Differences** - Type conversions between dialects
3. **String Functions** - Concatenation operators (`||` vs `CONCAT()`)
4. **Date and Time Functions** - Date arithmetic and formatting
5. **Window Functions** - Ranking, aggregations, and partitions
6. **JOINs** - Inner, outer, and cross joins
7. **Array and JSON Functions** - Handling semi-structured data
8. **CTEs** - Common Table Expressions
9. **Conditional Logic** - CASE statements and IF functions
10. **Identifier Quoting** - Double quotes vs backticks
11. **Complex Queries** - Combining multiple features
12. **AST Inspection** - Working with Abstract Syntax Trees
13. **Error Handling** - Edge cases and limitations

## 🔍 Key Features Demonstrated

### ✅ Automatically Handled Conversions

SQLGlot automatically converts many syntax differences:

- **String Concatenation**: `||` → `CONCAT()`
- **Date Functions**: `DATEADD()`, `DATEDIFF()` → `DATE_ADD()`, `DATE_DIFF()`
- **Conditional Functions**: `IFF()` → `IF()`
- **Identifier Quoting**: Double quotes → Backticks
- **Data Types**: `NUMBER`, `VARCHAR`, `TEXT` → `INT64`, `NUMERIC`, `STRING`

### ⚠️ Manual Adjustments Needed

Some constructs may require manual conversion:

- Array functions (different syntax)
- JSON functions (different API)
- PIVOT operations (dialect-specific)
- QUALIFY clause (Snowflake-specific)
- Variant type handling

## 📖 Usage Example

```python
from sqlglot import transpile
from sqlglot.dialects import Snowflake, BigQuery

# Snowflake SQL
snowflake_sql = """
SELECT 
    id,
    first_name || ' ' || last_name AS full_name,
    DATEADD(day, -7, CURRENT_DATE()) AS last_week
FROM users
WHERE active = TRUE
"""

# Transpile to BigQuery
bigquery_sql = transpile(
    snowflake_sql,
    read=Snowflake,
    write=BigQuery,
    pretty=True
)[0]

print(bigquery_sql)
```

Output:
```sql
SELECT
  id,
  CONCAT(first_name, ' ', last_name) AS full_name,
  DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) AS last_week
FROM users
WHERE active = TRUE
```

## 🗂️ Project Structure

```
sqlglot-explainer/
├── sqlglot_explainer.ipynb  # Main Jupyter notebook
├── pyproject.toml            # Project configuration (UV)
├── README.md                 # This file
├── .gitignore               # Git ignore rules
└── examples/                # Example SQL files (optional)
```

## 📝 Notes

- This project does **NOT** connect to any databases
- All examples work with SQL strings only
- Transpiled SQL should always be reviewed before execution
- Some edge cases may require manual conversion

## 🔗 Resources

- [SQLGlot Documentation](https://github.com/tobymao/sqlglot)
- [SQLGlot GitHub Repository](https://github.com/tobymao/sqlglot)
- [Snowflake SQL Reference](https://docs.snowflake.com/en/sql-reference/)
- [BigQuery SQL Reference](https://cloud.google.com/bigquery/docs/reference/standard-sql)
- [UV Package Manager](https://github.com/astral-sh/uv)

## 📄 License

UNLICENSE

## 🙏 Acknowledgments

- [SQLGlot](https://github.com/tobymao/sqlglot) by Toby Mao and contributors
- [UV](https://github.com/astral-sh/uv) by Astral-sh

---

**Happy Transpiling! 🚀**
