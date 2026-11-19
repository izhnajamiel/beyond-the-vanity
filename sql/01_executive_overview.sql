-- =====================================================
-- BEYOND THE VANITY
-- 01 - EXECUTIVE OVERVIEW
-- =====================================================

USE beyond_the_vanity;

-- QUERY A: Executive Overview KPI Summary

SELECT
    (SELECT COUNT(DISTINCT product_id)
     FROM products) AS total_products,

    (SELECT COUNT(DISTINCT chemical_id)
     FROM chemical_reports) AS reported_chemicals,

    (SELECT COUNT(DISTINCT company_id)
     FROM companies) AS total_companies,

    (SELECT COUNT(DISTINCT brand_id)
     FROM brands) AS total_brands,

    (SELECT COUNT(*)
     FROM chemical_reports) AS total_chemical_reports,

    (SELECT COUNT(*)
     FROM product_chemical) AS total_product_chemical_records;