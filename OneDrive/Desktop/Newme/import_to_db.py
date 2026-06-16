import pandas as pd
import sqlite3

df = pd.read_csv('customers.csv')
conn = sqlite3.connect('cloudsync.db')
df.to_sql('customers', conn, if_exists='replace', index=False)
conn.close()
print("✓ Database created: cloudsync.db")