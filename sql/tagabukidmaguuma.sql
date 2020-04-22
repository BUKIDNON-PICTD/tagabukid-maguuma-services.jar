[getFarmerForSync]
SELECT objid 
FROM agri_farmerprofile 
WHERE objid NOT IN (SELECT refid FROM agri_syncdata WHERE syncdevice = $P{clientid}) LIMIT 0, 5
