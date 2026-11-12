# Beyond the Vanity 💄

### **Exploring Chemical Reporting Patterns Across Cosmetic Products**

**Course:** DSA4157 – Business Intelligence | **Section & Group:** 3DSA-2 Group 5  
**Institution:** University of Santo Tomas – College of Science  

---

## 📌 About the Project

**Beyond the Vanity** is a Business Intelligence capstone project designed to analyze and organize reported chemical data across cosmetic products. The platform cleans, transforms, and visualizes complex regulatory filings to reveal key patterns across reported chemicals, product categories, brands, and parent companies—improving data accessibility and transparency for consumers and researchers alike.

---

## 📊 Dataset Overview

The project is built on the **Chemicals in Cosmetics** dataset managed by the **California Safe Cosmetics Program (CSCP)** under the California Department of Public Health (CDPH).

* **Original Volume:** ~114,635 reporting records
* **Attributes:** 22 columns
* **Key Fields Tracked:** Product names, company names, brand names, product categories/subcategories, chemical names, CAS numbers, reporting dates, and discontinuation dates.
* **Source:** [Chemicals in Cosmetics – Kaggle](https://www.kaggle.com/)

---

## ⚙️ Data Preparation & Architecture

To prepare the dataset for Business Intelligence analysis, the raw data undergoes systematic inspection, cleaning, and dimensional modeling:

* **Data Cleaning & Validation:** Identifies missing values, deduplicates records, and resolves chronological anomalies (e.g., handling misformatted date entries such as removal years `2103`/`2104`).
* **Dimensional Modeling:** Restructures raw relational data into a **21-table star schema** consisting of core dimension tables, event fact tables, and analytical views for rapid querying.

---

## 👥 Project Team

* **Agustin, Izhna Jamiel Q.**
* **Domo, Simone Julia C.**
* **Guste, Maxene Andrea P.**
