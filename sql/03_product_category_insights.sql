
-- =====================================================
-- BEYOND THE VANITY
-- 03 - PRODUCT CATEGORY INSIGHTS
-- =====================================================

USE beyond_the_vanity;


-- =====================================================
-- PART 1: PRODUCT CATEGORY ANALYSIS
-- =====================================================

-- QUERY A: Number of Products per Primary Category

SELECT
    pc.primary_category_id,
    pc.primary_category,
    COUNT(DISTINCT p.product_id) AS total_products
FROM primary_categories pc
LEFT JOIN products p
    ON pc.primary_category_id = p.primary_category_id
GROUP BY
    pc.primary_category_id,
    pc.primary_category
ORDER BY total_products DESC;


-- =====================================================
-- PART 2: CHEMICAL REPORT CATEGORY ANALYSIS
-- =====================================================

-- QUERY B: Chemical Reports per Primary Category

SELECT
    pc.primary_category_id,
    pc.primary_category,
    COUNT(cr.source_record_id) AS total_reports,
    COUNT(DISTINCT cr.product_id) AS distinct_products
FROM primary_categories pc
LEFT JOIN chemical_reports cr
    ON pc.primary_category_id = cr.primary_category_id
GROUP BY
    pc.primary_category_id,
    pc.primary_category
ORDER BY total_reports DESC;


-- =====================================================
-- PART 3: SUBCATEGORY ANALYSIS
-- =====================================================

-- QUERY C: Top 10 Subcategories by Chemical Reports

SELECT
    sc.subcategory_id,
    sc.subcategory,
    pc.primary_category,
    COUNT(cr.source_record_id) AS total_reports,
    COUNT(DISTINCT cr.product_id) AS distinct_products
FROM subcategories sc
JOIN primary_categories pc
    ON sc.primary_category_id = pc.primary_category_id
LEFT JOIN chemical_reports cr
    ON sc.subcategory_id = cr.subcategory_id
GROUP BY
    sc.subcategory_id,
    sc.subcategory,
    pc.primary_category
ORDER BY total_reports DESC
LIMIT 10;


-- =====================================================
-- PART 4: CATEGORY CONSISTENCY INVESTIGATION
-- =====================================================

-- QUERY D: Total Records with Category Mismatches

SELECT
    COUNT(*) AS records_with_category_mismatch
FROM chemical_reports cr
JOIN products p
    ON cr.product_id = p.product_id
WHERE cr.primary_category_id <> p.primary_category_id;


-- QUERY E: Breakdown of Category Mismatch Combinations

SELECT
    cr.primary_category_id AS report_category_id,
    pc1.primary_category AS report_category,
    p.primary_category_id AS product_category_id,
    pc2.primary_category AS product_category,
    COUNT(*) AS mismatch_records
FROM chemical_reports cr
JOIN products p
    ON cr.product_id = p.product_id
LEFT JOIN primary_categories pc1
    ON cr.primary_category_id = pc1.primary_category_id
LEFT JOIN primary_categories pc2
    ON p.primary_category_id = pc2.primary_category_id
WHERE cr.primary_category_id <> p.primary_category_id
GROUP BY
    cr.primary_category_id,
    pc1.primary_category,
    p.primary_category_id,
    pc2.primary_category
ORDER BY mismatch_records DESC;


-- QUERY F: Top 20 Products with Category Mismatches

SELECT
    cr.product_id,
    p.product_name,
    p.primary_category_id AS product_category_id,
    pc1.primary_category AS product_category,
    cr.primary_category_id AS report_category_id,
    pc2.primary_category AS report_category,
    COUNT(*) AS mismatched_reports
FROM chemical_reports cr
JOIN products p
    ON cr.product_id = p.product_id
LEFT JOIN primary_categories pc1
    ON p.primary_category_id = pc1.primary_category_id
LEFT JOIN primary_categories pc2
    ON cr.primary_category_id = pc2.primary_category_id
WHERE cr.primary_category_id <> p.primary_category_id
GROUP BY
    cr.product_id,
    p.product_name,
    p.primary_category_id,
    pc1.primary_category,
    cr.primary_category_id,
    pc2.primary_category
ORDER BY mismatched_reports DESC
LIMIT 20;


-- =====================================================
-- PART 5: MULTIPLE REPORTED CATEGORY INVESTIGATION
-- =====================================================

-- QUERY G: Number of Products with Multiple
-- Distinct Report Categories

SELECT
    COUNT(*) AS products_with_multiple_report_categories
FROM (
    SELECT
        product_id
    FROM chemical_reports
    GROUP BY product_id
    HAVING COUNT(DISTINCT primary_category_id) > 1
) AS multi_category_products;


-- QUERY H: Products with One vs Multiple
-- Reported Categories

SELECT
    COUNT(*) AS total_products_with_reports,
    SUM(category_count > 1) AS products_with_multiple_categories,
    SUM(category_count = 1) AS products_with_one_category
FROM (
    SELECT
        product_id,
        COUNT(DISTINCT primary_category_id) AS category_count
    FROM chemical_reports
    GROUP BY product_id
) AS product_category_counts;


-- QUERY I: Top 20 Products with Multiple
-- Reported Categories

SELECT
    cr.product_id,
    p.product_name,
    pc.primary_category AS product_category,
    COUNT(DISTINCT cr.primary_category_id)
        AS number_of_report_categories,
    COUNT(*) AS total_reports
FROM chemical_reports cr
JOIN products p
    ON cr.product_id = p.product_id
LEFT JOIN primary_categories pc
    ON p.primary_category_id = pc.primary_category_id
GROUP BY
    cr.product_id,
    p.product_name,
    pc.primary_category
HAVING COUNT(DISTINCT cr.primary_category_id) > 1
ORDER BY
    number_of_report_categories DESC,
    total_reports DESC
LIMIT 20;
