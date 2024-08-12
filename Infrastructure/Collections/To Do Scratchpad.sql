Collection of clients not approved.
1
2
3
4
select SMS_R_SYSTEM.ResourceID, SMS_R_SYSTEM.ResourceType, SMS_R_SYSTEM.Name, SMS_R_SYSTEM.SMSUniqueIdentifier,
SMS_R_SYSTEM.ResourceDomainORWorkgroup, SMS_R_SYSTEM.Client from SMS_R_System
inner join SMS_CM_RES_COLL_SMS00001 on SMS_CM_RES_COLL_SMS00001.ResourceId = SMS_R_System.ResourceId
where SMS_CM_RES_COLL_SMS00001.IsApproved= "2"


Collection of ConfigMgr clients waiting for another installation to finish.
1
2
3
select SMS_R_SYSTEM.ResourceID, SMS_R_SYSTEM.ResourceType, SMS_R_SYSTEM.Name, SMS_R_SYSTEM.SMSUniqueIdentifier,
SMS_R_SYSTEM.ResourceDomainORWorkgroup, SMS_R_SYSTEM.Client from sms_r_system AS sms_r_system
inner join SMS_UpdateC


Collection of computers ending with odd numbers
Note: This query may be heavy on the SCCM server.

select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,
SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,
SMS_R_SYSTEM.ResourceDomainORWorkgroup,
SMS_R_SYSTEM.Client from SMS_R_System
where SMS_R_System.Name like "%[13579]"



Collection of computers ending with even numbers
Note: This query may be heavy on the SCCM server.

select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,
SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,
SMS_R_SYSTEM.ResourceDomainORWorkgroup,
SMS_R_SYSTEM.Client from SMS_R_System
where SMS_R_System.Name like "%[02468]"


SQL Server Collections
Collection of all SQL Servers 2008.

1
2
3
4
select SMS_R_SYSTEM.ResourceID, SMS_R_SYSTEM.ResourceType, SMS_R_SYSTEM.Name, SMS_R_SYSTEM.SMSUniqueIdentifier,
SMS_R_SYSTEM.ResourceDomainORWorkgroup, SMS_R_SYSTEM.Client from SMS_R_System
where SMS_R_System.ResourceId in (select distinct SMS_G_System_ADD_REMOVE_PROGRAMS.ResourceID
from SMS_G_System_ADD_REMOVE_PROGRAMS where SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName = 'Microsoft SQL Server 2008')

Collection of all SQL Servers 2005.

1
2
3
4
select SMS_R_SYSTEM.ResourceID, SMS_R_SYSTEM.ResourceType, SMS_R_SYSTEM.Name, SMS_R_SYSTEM.SMSUniqueIdentifier,
SMS_R_SYSTEM.ResourceDomainORWorkgroup, SMS_R_SYSTEM.Client from SMS_R_System
where SMS_R_System.ResourceId in (select distinct SMS_G_System_ADD_REMOVE_PROGRAMS.ResourceID from SMS_G_System_ADD_REMOVE_PROGRAMS
where SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName = 'Microsoft SQL Server 2005')




-- Show Breakdown of Odds/Evens and Alphabet in 1/3rds
use CM_[SiteCode]

SELECT
	sum(case when Name0 like '%[13579]' then 1 else 0 end) AS 'Odds',
	sum(case when Name0 like '%[02468]' then 1 else 0 end) AS 'Evens',
	sum(case when Name0 like '%[A-I]' then 1 else 0 end) AS 'A-I',
	sum(case when Name0 like '%[J-R]' then 1 else 0 end) AS 'J-R',
	sum(case when Name0 like '%[S-Z]' then 1 else 0 end) AS 'S-Z',
    count(*) AS Total
FROM
	v_R_System

-- Show Breakdown of Resource ID in 50/50* Split
use CM_[SiteCode]

SELECT
	sum(case when ResourceID like '%[13579]' then 1 else 0 end) AS 'Odds',
	sum(case when ResourceID like '%[02468]' then 1 else 0 end) AS 'Evens',
	count(*) AS 'Total'
FROM
	v_R_System

-- Show Breakdown of Resource ID in Offset Split
use CM_[SiteCode]

SELECT
    'MECM Engineering' AS 'Wave_0',
    'Early Adopters' AS 'Wave_1'
    'Business Testers' AS 'Wave_2'
	sum(case when ResourceID like '%[0123]' then 1 else 0 end) AS 'Wave_3',
	sum(case when ResourceID like '%[456789]' then 1 else 0 end) AS 'Wave_4',
	count(*) AS 'Total'
FROM
	v_R_System

The resultant query returned only devices ending in odd numbers or letters:
/* Odd Numbers and Odd Letters */
select * from SMS_R_System where SMS_R_System.Name like "%[13579acegikmoqsuwy]"

select * from v_R_System where v_R_System.Name0 like '%[13579acegikmoqsuwy]'

/* Even Numbers and Even Letters */
select * from SMS_R_System where SMS_R_System.Name like "%[02468bdfhjlnprtvxz]"

select * from v_R_System where v_R_System.Name0 like '%[02468bdfhjlnprtvxz]'








-- Approved / Unapproved Clients

select IsApproved from vSMS_CombinedDeviceResources
IsApproved
Data type: UInt32

Access type: Read/Write

Qualifiers: none

true if system is able to accept secure policy. Unapproved (anonymous) clients will not get policy. Clients that registered via windows authentication, or using PKI certificate chain trust, will be automatically approved.

-- Client is Internet Enabled
IsInternetEnabled
Data type: Boolean

Access type: Read/Write

Qualifiers: none

true if a client is enabled for communication with an internet facing management point.

-- Client is Obsolete
IsObsolete
Data type: Boolean

Access type: Read/Write

Qualifiers: none

true if the client has been marked obsolete.

-- Client using Slef-Signed Certificate
SMS_CombinedDeviceResources.ClientCertTypeValue	Client certificate type
1	Self-signed Certificate
2	PKI Certificate

-- Client using PKI Certificate
SMS_CombinedDeviceResources.ClientCertTypeValue	Client certificate type
1	Self-signed Certificate
2	PKI Certificate