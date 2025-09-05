import requests
from bs4 import BeautifulSoup
import pandas as pd

rows = []

# Loop through all 50 pages
for page in range(1, 51):
    if page == 1:
        url = "https://books.toscrape.com/"
    else:
        url = f"https://books.toscrape.com/catalogue/page-{page}.html"
    
    print(f"Scraping {url} ...")   # progress log
    
    res = requests.get(url, timeout=10)
    res.raise_for_status()
    soup = BeautifulSoup(res.text, "html.parser")
    
    books = soup.select("article.product_pod")
    for book in books:
        title = book.h3.a["title"]
        price = book.select_one(".price_color").text
        rating = book.p["class"][1]
        availability = book.select_one(".availability").text.strip()
        
        rows.append({
            "title": title,
            "price": price,
            "rating": rating,
            "availability": availability
        })

# Create DataFrame
df = pd.DataFrame(rows)
print(df.head())
print(f"✅ Scraped {len(df)} books in total")

# Save to CSV
df.to_csv("books_all.csv", index=False)
print("📂 Saved to books_all.csv")
