
-- =====================================================
-- BEYOND THE VANITY
-- 04 - BRAND & COMPANY INSIGHTS
-- =====================================================

USE beyond_the_vanity;


-- =====================================================
-- QUERY A: TOP 10 COMPANIES BY DISTINCT PRODUCTS
-- =====================================================

SELECT
    c.company_id,
    c.company_name,
    COUNT(DISTINCT p.product_id) AS total_products
FROM companies c
LEFT JOIN products p
    ON c.company_id = p.company_id
GROUP BY
    c.company_id,
    c.company_name
ORDER BY total_products DESC
LIMIT 10;


-- =====================================================
-- QUERY B: TOP 10 BRANDS BY DISTINCT PRODUCTS
-- =====================================================

SELECT
    b.brand_id,
    b.brand_name,
    c.company_name,
    COUNT(DISTINCT p.product_id) AS total_products
FROM brands b
LEFT JOIN companies c
    ON b.company_id = c.company_id
LEFT JOIN products p
    ON b.brand_id = p.brand_id
GROUP BY
    b.brand_id,
    b.brand_name,
    c.company_name
ORDER BY total_products DESC
LIMIT 10;


-- =====================================================
-- QUERY C: NUMBER OF BRANDS PER COMPANY
-- =====================================================

SELECT
    c.company_id,
    c.company_name,
    COUNT(DISTINCT b.brand_id) AS total_brands
FROM companies c
LEFT JOIN brands b
    ON c.company_id = b.company_id
GROUP BY
    c.company_id,
    c.company_name
ORDER BY total_brands DESC
LIMIT 10;


-- =====================================================
-- QUERY D: TOP 10 COMPANIES BY CHEMICAL REPORTS
-- =====================================================

SELECT
    c.company_id,
    c.company_name,
    COUNT(cr.source_record_id) AS total_chemical_reports,
    COUNT(DISTINCT cr.product_id) AS distinct_products
FROM companies c
LEFT JOIN chemical_reports cr
    ON c.company_id = cr.company_id
GROUP BY
    c.company_id,
    c.company_name
ORDER BY total_chemical_reports DESC
LIMIT 10;
