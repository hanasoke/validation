require 'sqlite3'

DB = SQLite3::Database.new("inventory_app.db")
DB.results_as_hash = true

# Create a table if it doesn't exist

# add email column to items table
# DB.execute("ALTER TABLE items ADD COLUMN email TEXT;")

DB.execute <<-SQL 
    CREATE TABLE IF NOT EXISTS items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        price TEXT
    );
SQL