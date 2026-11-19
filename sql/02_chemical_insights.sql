-- =====================================================
-- BEYOND THE VANITY
-- 02 - CHEMICAL INSIGHTS
-- =====================================================

USE beyond_the_vanity;


-- QUERY A: Top 10 Chemicals by Total Reports

SELECT
    chemical_id,
    MAX(chemical_name_source) AS chemical_name,
    COUNT(*) AS total_reports,
    COUNT(DISTINCT product_id) AS distinct_products
FROM chemical_reports
GROUP BY chemical_id
ORDER BY total_reports DESC
LIMIT 10;


-- QUERY B: Top 10 Chemicals by Distinct Products

SELECT
    chemical_id,
    MAX(chemical_name_source) AS chemical_name,
    COUNT(DISTINCT product_id) AS distinct_products,
    COUNT(*) AS total_reports
FROM chemical_reports
GROUP BY chemical_id
ORDER BY distinct_products DESC
LIMIT 10;