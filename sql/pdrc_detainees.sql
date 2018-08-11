[getTest]
SELECT xx.*,xxx.`gender`,ccc.`name` FROM pdrc_detainees xx
INNER JOIN pdrc_detainees_details_case cc ON cc.`detaineeid` = xx.`objid`
INNER JOIN pdrc_cases ccc ON ccc.`objid` = cc.`casefile_objid`
INNER JOIN etracs254_bukidnon.`entityindividual` xxx ON xxx.`objid` = xx.`objid`
WHERE xxx.`gender` IN ('M','MALE')
AND cc.`casefile_objid` = 'cd7d05b6-9c6a-11e8-9521-8cec4b1f1d95'
GROUP BY xx.`objid`;
