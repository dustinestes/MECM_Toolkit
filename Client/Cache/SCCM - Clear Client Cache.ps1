$resman = new-object -com "UIResource.UIResourceMgr"
$cacheInfo = $resman.GetCacheInfo()
$cacheinfo.GetCacheElements()  | 
where-object {$_.LastReferenceTime -lt (get-date).AddDays(-60)} | 
foreach {$cacheInfo.DeleteCacheElement($_.CacheElementID)}