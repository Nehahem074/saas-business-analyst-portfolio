import pandas as pd
import numpy as np
from faker import Faker
import random
from datetime import datetime, timedelta

fake = Faker()
random.seed(42)
np.random.seed(42)

# --- Settings ---
NUM_CUSTOMERS = 500
PLANS = ['Free', 'Starter', 'Pro', 'Enterprise']
PLAN_PRICES = {'Free': 0, 'Starter': 29, 'Pro': 99, 'Enterprise': 499}
REGIONS = ['India', 'USA', 'Europe', 'SEA']

customers = []
for i in range(NUM_CUSTOMERS):
    signup = fake.date_between(start_date='-18m', end_date='today')
    plan = random.choices(PLANS, weights=[40, 30, 20, 10])[0]
    region = random.choices(REGIONS, weights=[35, 30, 25, 10])[0]
    churned = random.random() < (0.45 if plan == 'Free' else
                                  0.25 if plan == 'Starter' else
                                  0.12 if plan == 'Pro' else 0.05)
    churn_date = None
    if churned:
        days_active = random.randint(7, 180)
        churn_date = signup + timedelta(days=days_active)

    customers.append({
        'customer_id': f'CS{i+1001}',
        'company_name': fake.company(),
        'signup_date': signup,
        'plan': plan,
        'monthly_revenue': PLAN_PRICES[plan],
        'region': region,
        'team_size': random.randint(2, 500),
        'is_churned': churned,
        'churn_date': churn_date,
        'nps_score': random.randint(1, 10),
        'features_used': random.randint(1, 12),
        'support_tickets': random.randint(0, 20)
    })

df = pd.DataFrame(customers)
df.to_csv('customers.csv', index=False)
print(f"✓ Created {len(df)} customers")
print(df.head(3))