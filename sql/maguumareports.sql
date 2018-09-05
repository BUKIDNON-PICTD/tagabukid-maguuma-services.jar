[getFarmersListByCommodity]
SELECT
af.`farmer_objid`,
af.`farmer_name`,
afl.`location_text`,
afl.`areasqm`,
mc.`name` AS commodityname,
mct.`name` AS commoditytypename,
mcv.`name` AS commodityvariety,
mct.`unit` AS commodityunit,
aflc.`qty` AS quantity,
afl.`location_barangay_objid`,
aflc.`variety_objid`,
ea.`municipality`,
ea.`barangay_name` AS baranga

FROM agri_farmerprofile af
INNER JOIN etracs254_bukidnon.`entityindividual` ei ON ei.`objid` = af.`farmer_objid`
INNER JOIN etracs254_bukidnon.`entity` ee ON ee.`objid` = ei.`objid`
INNER JOIN etracs254_bukidnon.`entity_address` ea ON ea.`objid` = ee.`address_objid`
INNER JOIN agri_farmerprofile_location afl ON afl.`farmerprofileid` = af.`objid`
INNER JOIN agri_farmerprofile_location_commodity aflc ON aflc.`locationid` = afl.`objid`
INNER JOIN master_commodity_variety mcv ON mcv.`objid` = aflc.`variety_objid`
INNER JOIN master_commodity_type mct ON mct.`objid` = mcv.`commoditytype_objid`
INNER JOIN master_commodity mc ON mc.`objid` = mct.`commodity_objid`
WHERE ${filter}
ORDER BY af.`farmer_name`

[getCommodity]
SELECT * FROM master_commodity ORDER BY name;

[getCommodityType]
SELECT * FROM master_commodity_type WHERE commodity_objid = $P{objid} ORDER BY name;

[getCommodityVariety]
SELECT * FROM master_commodity_variety WHERE commoditytype_objid = $P{objid} ORDER BY name;

[getCommodityList]
SELECT 
pc.`name` AS commodityname,
pc.`code` AS commoditycode,
pc.`description` AS commoditydescription,
pct.`name` AS commoditytypename,
pct.`code` AS commoditytypecode,
pct.`description` AS commoditytypedescription,
pct.`unit` AS commoditytypeunit,
(SELECT SUM(qty) FROM agri_farmerprofile_location WHERE commoditytype_objid = pc.objid 
    AND address_barangay_parent_objid LIKE $P{lguid}
    AND address_barangay_objid LIKE $P{barangayid}
) AS totalqty,
(SELECT COUNT(*) FROM agri_farmerprofile_location WHERE variety_objid = pc.objid
    AND address_barangay_parent_objid LIKE $P{lguid}
    AND address_barangay_objid LIKE $P{barangayid}
) AS farmeritemcount
FROM master_commodity pc
INNER JOIN master_commodity_type pct ON pct.parentid = pc.`objid`
WHERE pc.objid LIKE $P{commodityid} 
AND pct.objid LIKE $P{commoditytypeid}
ORDER BY pc.`name`,pct.`name`

[getFarmersList]
SELECT
xx.`farmer_name` AS farmername,
xx.`farmer_address_text` AS farmeraddress,
xx.`farmer_birthdate` AS birthdate,
ee.`gender`
FROM agri_farmerprofile xx
INNER JOIN etracs254_bukidnon.`entityindividual` ee ON ee.`objid` = xx.`farmer_objid`
LIMIT 500

[findEntity]
SELECT * FROM entityindividual WHERE objid = $P{objid}

[getCommoditySummary]
SELECT pfi.objid,
pfi.`address_text` AS addresstext,
pfi.`address_barangay_objid` AS addressbarangayobjid,
pfi.`address_barangay_name` AS addressbarangayname,
pfi.`address_barangay_parent_objid` AS addressbarangayparentobjid,
pfi.`address_barangay_parent_name` AS addressbarangayparentname,
pfi.`commodity_objid` AS commodityobjid,
pfi.`commodity_name` AS commodityname,
1 AS commoditycount FROM test_pagrifarmeritems pfi
WHERE pfi.`address_barangay_parent_objid` LIKE $P{lguid}
AND pfi.`address_barangay_objid` LIKE $P{barangayid}