
-- =====================================================
-- BEYOND THE VANITY
-- 06 - DISCONTINUATION INSIGHTS
-- =====================================================

USE beyond_the_vanity;


-- =====================================================
-- QUERY A: DISCONTINUATION DATE COVERAGE
-- =====================================================

SELECT
    COUNT(*) AS total_records,

    SUM(discontinued_date IS NOT NULL)
        AS records_with_discontinuation_date,

    SUM(discontinued_date IS NULL)
        AS records_without_discontinuation_date,

    ROUND(
        SUM(discontinued_date IS NOT NULL)
        * 100.0 / COUNT(*),
        2
    ) AS discontinuation_date_coverage_percentage,

    ROUND(
        SUM(discontinued_date IS NULL)
        * 100.0 / COUNT(*),
        2
    ) AS missing_discontinuation_date_percentage

FROM chemical_reports;


-- =====================================================
-- QUERY B: DISCONTINUATION RECORDS PER YEAR
-- =====================================================

SELECT
    YEAR(discontinued_date) AS discontinuation_year,
    COUNT(*) AS total_records,
    COUNT(DISTINCT product_id) AS distinct_products
FROM chemical_reports
WHERE discontinued_date IS NOT NULL
GROUP BY YEAR(discontinued_date)
ORDER BY discontinuation_year;


-- =====================================================
-- QUERY C: DISCONTINUATION RECORDS BY PRIMARY CATEGORY
-- =====================================================

SELECT
    pc.primary_category_id,
    pc.primary_category,
    COUNT(cr.source_record_id) AS records_with_discontinuation,
    COUNT(DISTINCT cr.product_id) AS distinct_products
FROM primary_categories pc
LEFT JOIN chemical_reports cr
    ON pc.primary_category_id = cr.primary_category_id
    AND cr.discontinued_date IS NOT NULL
GROUP BY
    pc.primary_category_id,
    pc.primary_category
ORDER BY records_with_discontinuation DESC;


-- =====================================================
-- QUERY D: PRODUCT SUMMARY FOR RECORDED
-- DISCONTINUATION DATES
-- =====================================================

SELECT
    p.product_id,
    p.product_name,
    pc.primary_category,
    COUNT(cr.source_record_id) AS discontinued_report_records,
    MIN(cr.discontinued_date) AS earliest_discontinuation_date,
    MAX(cr.discontinued_date) AS latest_discontinuation_date
FROM products p
JOIN chemical_reports cr
    ON p.product_id = cr.product_id
LEFT JOIN primary_categories pc
    ON p.primary_category_id = pc.primary_category_id
WHERE cr.discontinued_date IS NOT NULL
GROUP BY
    p.product_id,
    p.product_name,
    pc.primary_category
ORDER BY discontinued_report_records DESC
LIMIT 20;


-- =====================================================
-- QUERY E: PRODUCT AND REPORT RECORDS WITHOUT
-- RECORDED DISCONTINUATION DATES
-- =====================================================

SELECT
    COUNT(*) AS records_without_discontinuation_date,
    COUNT(DISTINCT product_id) AS distinct_products_without_date
FROM chemical_reports
WHERE discontinued_date IS NULL;


-- =====================================================
-- QUERY F: DISCONTINUATION DATE RANGE
-- =====================================================

SELECT
    MIN(discontinued_date) AS earliest_discontinuation_date,
    MAX(discontinued_date) AS latest_discontinuation_date
FROM chemical_reports
WHERE discontinued_date IS NOT NULL;


-- =====================================================
-- QUERY G: PRODUCT-LEVEL DISCONTINUATION COVERAGE
-- =====================================================

SELECT
    COUNT(*) AS total_products_with_reports,

    SUM(has_discontinuation_date = 1)
        AS products_with_at_least_one_date,

    SUM(has_discontinuation_date = 0)
        AS products_without_any_date

FROM (
    SELECT
        product_id,
        MAX(discontinued_date IS NOT NULL)
            AS has_discontinuation_date
    FROM chemical_reports
    GROUP BY product_id
) AS product_discontinuation_status;

