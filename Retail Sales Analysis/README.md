# 🛍️ Retail Sales Analysis (Data Cleaning + Power BI Dashboard)

## 📌 Project Overview
This project demonstrates an **end-to-end data pipeline** starting from a **noisy retail dataset (~10,000 rows)** to a **clean dataset** and a **Power BI dashboard**.  

It showcases my skills in:
- **Data Cleaning & Preprocessing** (Python, Pandas)  
- **Exploratory Data Analysis (EDA)**  
- **Business Intelligence (Power BI)**  
- **Data Storytelling** through dashboards  

---

## 📂 Project Structure
    Retail-Sales-Analysis/  
    │── data/
    │   ├── retail_sales_dataset.csv            # Raw/Noisy dataset
    │   ├── retail_sales_cleaned.csv            # Cleaned dataset for BI
    │
    │── notebooks/
    │   ├── data_cleaning.ipynb                 # Python cleaning script
    │
    │── powerbi/
    │   ├── retail_sales_dashboard.pbix         # Power BI dashboard
    │
    │── images/
    │   ├── dashboard_overview.png              # Dashboard overview (screenshot)
    │   ├── category_analysis.png               # Sales by category
    │   ├── regional_sales.png                  # Sales by region
    │
    │── README.md                               # Project overview

---

## 📊 Dataset Description
- **Size:** ~10,000 rows  
- **Source:** Synthetic dataset inspired by Kaggle’s Retail & Superstore datasets  
- **Columns:**
  - `Order_ID` – Unique identifier for each order  
  - `Customer_ID` – Unique customer identifier  
  - `Order_Date` – Date of the purchase (YYYY-MM-DD)  
  - `Product_Category` – Category of the product (Electronics, Clothing, etc.)  
  - `Quantity` – Number of items purchased  
  - `Unit_Price` – Price per unit  
  - `Total_Sales` – Sales amount (Quantity × Unit Price)  
  - `Region` – Geographic region of sale (North, South, etc.)  
  - `Discount` – Discount applied (0 to 1)  
  - `Customer_Return` – Whether the customer returned (1 = retained, 0 = not)  

---

## 🧹 Data Cleaning Process
Performed in **Python (Pandas)**:
- Handling **missing values** (e.g., replacing NAs with median/mode)  
- Correcting **typos** (e.g., “Eletronics” → “Electronics”)  
- Removing **duplicates**  
- Fixing **inconsistent formats** (dates, capitalization, numeric formats)  
- Identifying and handling **outliers**  

Result → `retail_sales_cleaned.csv` (ready for analysis/BI).  

---

## 📈 Power BI Dashboard
Built in **Power BI** to provide insights into sales and customer behavior.  

### Key Visuals:
- **KPI Cards:** Revenue, Quantity Sold, Average Discount, Customer Retention  
- **Time Series:** Revenue & Returns trend over months/quarters  
- **Category Analysis:** Sales by Product Category  
- **Regional Breakdown:** Sales & Returns by Region  
- **Discount Impact:** Relationship between discount and sales  

### 📷 Dashboard Previews:
![Dashboard Overview]((images/dashboard-overview.png))  
![Total Revenue]((images/Total%20Revenue%20by%20Month%20and%20Quarter.png))  
![Return Rate]((images/ReturnRatebyMonth.png))  

📊 Final dashboard: `powerbi/retail_sales_dashboard.pbix`  

---

## 🚀 How to Use
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/Retail-Sales-Analysis.git
2. Open the Jupyter notebook in notebooks/ to see the data cleaning process.

3. Import `retail_sales_cleaned.csv` into Power BI for further analysis.

4. Open the `.pbix file` to explore the dashboard.

## 🔑 Skills Demonstrated

 - Data Cleaning & Preprocessing (Python, Pandas)

 - Data Analysis (EDA, handling missing data, outlier treatment)

 - Business Intelligence (Power BI, DAX, interactive dashboards)

 - Data Storytelling (turning raw data into insights)

## ✨ This project reflects how raw, noisy data can be transformed into actionable business insights using Data Science + BI tools.
