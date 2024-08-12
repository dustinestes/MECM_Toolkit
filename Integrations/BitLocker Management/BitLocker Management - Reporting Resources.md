-----------------------------------------
  Database Views
-----------------------------------------
    v_GS_BITLOCKER_DETAILS
    v_HS_BITLOCKER_DETAILS
    SCCM_Ext.vex_GS_BITLOCKER_DETAILS
    BITLOCKER_DETAILS_DATA
    BITLOCKER_DETAILS_HIST
    SCCM_Ext.BITLOCKER_DETAILS_DATA_DD
    fn_listBitlockerManagementSettings_List
    fn_rbac_GS_BITLOCKER_DETAILS
    fn_rbac_HS_BITLOCKER_DETAILS

    v_BLM_AvalableCollections
    v_BLM_CI_ID_AND_COLL_ID
    v_BLM_CI_IDs
    v_BLM_ComplianceStatus
    fn_BLM_ComputerComplianceStatus
    fn_BLM_ComputerComplianceStatusInner
    fn_BLM_DashboardComplianceStatus

    v_GS_MBAM_POLICY
    v_HS_MBAM_POLICY
    SCCM_EXT.vex_GS_MBAM_POLICY
    MBAM_POLICY_DATA
    MBAM_POLICY_HIST
    SCCM_Ext.MBAM_POLICY_DATA_DD
    fn_rbac_GS_MBAM_POLICY
    fn_rbac_hS_MBAM_POLICY

    v_RecoveryKeyIdsForMachine

-----------------------------------------
  Report Structure
-----------------------------------------
    Dashboard
        Overview of the environment's current compliance status (non device specific)

    Devices
        List of devices and their basic information for compliance with slicers (device specific)
        v_R_System
        v_HS_BITLOCKER_DETAILS

    History
        Filtered display of the historical copmliance information of a device
        v_HS_BITLOCKER_DETAILS

    Recovery Key(s)
        Filtered display of the recovery key(s) associated with the selected device

-----------------------------------------
  Compliance Lookup
-----------------------------------------
    1 = "Bitlocker_Computer_Compliance_Compliant"
    3 = "Bitlocker_Computer_Compliance_Noncompliant"
    Else = "Bitlocker_Computer_Compliance_Unknown"

-----------------------------------------
  Conversion Status Lookup
-----------------------------------------
    0 = FullyDecrypted
        For a standard hard drive (HDD), the volume is fully decrypted.
        For a hardware encrypted hard drive (EHDD), the volume is perpetually unlocked.
    1 = FullyEncrypted
        For a standard hard drive (HDD), the volume is fully encrypted.
        For a hardware encrypted hard drive (EHDD), the volume is not perpetually unlocked.
    2 = EncryptionInProgress
        The volume is partially encrypted.
    3 = DecryptionInProgress
        The volume is partially encrypted
    4 = EncryptionPaused
        The volume has been paused during the encryption progress. The volume is partially encrypted.
    5 = DecryptionPaused
        The volume has been paused during the decryption progress. The volume is partially decrypted.

-----------------------------------------
  Encryption Method Lookup
-----------------------------------------
    –1 = UNKNOWN
        The volume has been fully or partially encrypted with an unknown algorithm and key size.
    0 = None
        The volume is not encrypted.
    1 = AES_128_WITH_DIFFUSER
        The volume has been fully or partially encrypted with the Advanced Encryption Standard (AES) algorithm enhanced with a diffuser layer, using an AES key size of 128 bits. This method is no longer available on devices running Windows 8.1 or higher.
    2 = AES_256_WITH_DIFFUSER
        The volume has been fully or partially encrypted with the Advanced Encryption Standard (AES) algorithm enhanced with a diffuser layer, using an AES key size of 256 bits. This method is no longer available on devices running Windows 8.1 or higher.
    3 = AES_128
        The volume has been fully or partially encrypted with the Advanced Encryption Standard (AES) algorithm, using an AES key size of 128 bits.
    4 = AES_256
        The volume has been fully or partially encrypted with the Advanced Encryption Standard (AES) algorithm, using an AES key size of 256 bits.
    5 = HARDWARE_ENCRYPTION
        The volume has been fully or partially encrypted by using the hardware capabilities of the drive.
    6 = XTS_AES_128
        The volume has been fully or partially encrypted with XTS using the Advanced Encryption Standard (AES), and an AES key size of 128 bits. This method is only available on devices running Windows 10, version 1511 or higher.
    7 = XTS_AES_256
        The volume has been fully or partially encrypted with XTS using the Advanced Encryption Standard (AES), and an AES key size of 256 bits. This method is only available on devices running Windows 10, version 1511 or higher.

-----------------------------------------
  Protection Status Lookup
-----------------------------------------
    0 = PROTECTION OFF
        The volume is not encrypted, partially encrypted, or the volume's encryption key for the volume is available in the clear on the hard disk.
    1 = PROTECTION ON
        The volume is fully encrypted and the encryption key for the volume is not available in the clear on the hard disk.
    2 = PROTECTION UNKNOWN
        The volume protection status cannot be determined. One potential cause is that the volume is in a locked state.

-----------------------------------------
  MBAM Volume Type Lookup
-----------------------------------------
    0 = Unknown
    1 = Operating System Drive
    2 = Fixed Data Drive
    3 = Removable Data Drive

-----------------------------------------
  Key Protector Types Lookup
-----------------------------------------
    0 = Unknown
    1 = Trusted Platform Module (TPM)
    2 = External key
    3 = Numeric password
    4 = TPM And PIN
    5 = TPM And Startup Key
    6 = TPM And PIN And Startup Key
    7 = Public Key
    8 = Passphrase
    9 = TPM Certificate
    10 = Security Identifier (SID)

-----------------------------------------
  Is Auto Unlock Enabled Lookup
-----------------------------------------
  0 = False
  1 = True

-----------------------------------------
  Reasons for Noncompliance Lookup
-----------------------------------------
    0 = Cipher strength not AES 256.
    1 = MBAM Policy requires this volume to be encrypted but it is not.
    2 = MBAM Policy requires this volume to NOT be encrypted, but it is.
    3 = MBAM Policy requires this volume use a TPM protector, but it does not.
    4 = MBAM Policy requires this volume use a TPM+PIN protector, but it does not.
    5 = MBAM Policy does not allow non TPM machines to report as compliant.
    6 = Volume has a TPM protector but the TPM is not visible (booted with recover key after disabling TPM in BIOS?).
    7 = MBAM Policy requires this volume use a password protector, but it does not have one.
    8 = MBAM Policy requires this volume NOT use a password protector, but it has one.
    9 = MBAM Policy requires this volume use an auto-unlock protector, but it does not have one.
    10 = MBAM Policy requires this volume NOT use an auto-unlock protector, but it has one.
    11 = Policy conflict detected preventing MBAM from reporting this volume as compliant.
    12 = A system volume is needed to encrypt the OS volume but it is not present.
    13 = Protection is suspended for the volume.
    14 = AutoUnlock unsafe unless the OS volume is encrypted.
    15 = Policy requires minimum cypher strength is XTS-AES-128 bit, actual cypher strength is weaker than that.
    16 = Policy requires minimum cypher strength is XTS-AES-256 bit, actual cypher strength is weaker than that.
























# MBAM - Sample Encryption Output

The below is some sample output data for checking on encryption of drives. This can be helpful if you need to see what properties might be available to you.

## PowerShell

This data is what you see when you run the following PowerShell command:

```powershell
Get-BitLockerVolume | Select * | Format-List
```

### C: Drive PowerShell Output

| Property | Value |
| -------- | ----- |
| ComputerName         | HT6-SCCMTST-800 |
| MountPoint           | C: |
| EncryptionMethod     | XtsAes256 |
| AutoUnlockEnabled    |  |
| AutoUnlockKeyStored  | False |
| MetadataVersion      | 2 |
| VolumeStatus         | FullyEncrypted |
| ProtectionStatus     | On |
| LockStatus           | Unlocked |
| EncryptionPercentage | 100 |
| WipePercentage       | 0 |
| VolumeType           | OperatingSystem |
| CapacityGB           | 476.0322 |
| KeyProtector         | {RecoveryPassword, Tpm} |

&nbsp;

### D: Drive Powershell Output

| Property | Value |
| -------- | ----- |
| ComputerName         | HT6-SCCMTST-800 |
| MountPoint           | D: |
| EncryptionMethod     | None |
| AutoUnlockEnabled    |  |
| AutoUnlockKeyStored  |  |
| MetadataVersion      | 0 |
| VolumeStatus         | FullyDecrypted |
| ProtectionStatus     | Off |
| LockStatus           | Unlocked |
| EncryptionPercentage | 0 |
| WipePercentage       | 0 |
| VolumeType           | Data |
| CapacityGB           | 953.6299 |
| KeyProtector         | {}|  |

&nbsp;

## Windows Management Instrumentation (WMI)

You can pull an incredible amount of data out of WMI as well.

```powershell
Get-WmiObject -Class mbam_Volume -Namespace root\microsoft\mbam
```

### C: Drive WMI Output

| Property | Value |
| -------- | ----- |
| __GENUS                               | 2 |
| __CLASS                               | mbam_Volume |
| __SUPERCLASS                          |  |
| __DYNASTY                             | mbam_Volume |
| __RELPATH                             | mbam_Volume.DeviceId="\\\\?\\Volume{27aac25f-c02b-496e-a7a7-464fd640e9b5}\\" |
| __PROPERTY_COUNT                      | 20 |
| __DERIVATION                          | {} |
| __SERVER                              | HT6-SCCMTST-800 |
| __NAMESPACE                           | root\microsoft\mbam |
| __PATH                                | \\HT6-SCCMTST-800\root\microsoft\mbam:mbam_Volume.DeviceId="\\\\?\\Volume{27aac25f-c02b-496e-a7a7-464fd640e9b5}\\" |
| BitLockerManagementPersistentVolumeId | 537f9f2e-7652-4bd3-8143-83119097f56c |
| BitLockerManagementVolumeType         | 1 |
| BitLockerPersistentVolumeId           | {6B76B990-3AFE-462D-A178-A3878AC126AC} |
| Compliant                             | 2 |
| ConversionPercentage                  | 100 |
| ConversionStatus                      | 1 |
| DeviceId                              | \\?\Volume{27aac25f-c02b-496e-a7a7-464fd640e9b5}\ |
| DriveLetter                           | C: |
| EncryptionMethod                      | 7 |
| EnforcePolicyDate                     |  |
| IsAutoUnlockEnabled                   | False |
| IsHardwareTestPending                 | False |
| KeyProtectorTypes                     | {3, 1} |
| LockStatus                            | 0 |
| NoncomplianceDetectedDate             |  |
| NumericalPasswordKeyProtectorIDs      | {{0B9207C1-934F-4F0B-827C-5738F52FDAD2}} |
| ProtectionStatus                      | 1 |
| ReasonsForNoncompliance               | {} |
| VolumeLabel                           | Windows |
| VolumeName                            | C:\ |
| PSComputerName                        | HT6-SCCMTST-800 |

&nbsp;

### D: Drive WMI Output

| Property | Value |
| -------- | ----- |
| __GENUS                               | 2 |
| __CLASS                               | mbam_Volume |
| __SUPERCLASS                          |  |
| __DYNASTY                             | mbam_Volume |
| __RELPATH                             | mbam_Volume.DeviceId="\\\\?\\Volume{8e317c6c-4b55-4bc6-b440-3802f4200933}\\" |
| __PROPERTY_COUNT                      | 20 |
| __DERIVATION                          | {} |
| __SERVER                              | HT6-SCCMTST-800 |
| __NAMESPACE                           | root\microsoft\mbam |
| __PATH                                | \\HT6-SCCMTST-800\root\microsoft\mbam:mbam_Volume.DeviceId="\\\\?\\Volume{8e317c6c-4b55-4bc6-b440-3802f4200933}\\" |
| BitLockerManagementPersistentVolumeId | 9faed635-a6b6-4554-b838-5f4fb6fc96d3 |
| BitLockerManagementVolumeType         | 2 |
| BitLockerPersistentVolumeId           |  |
| Compliant                             | 2 |
| ConversionPercentage                  | 0 |
| ConversionStatus                      | 0 |
| DeviceId                              | \\?\Volume{8e317c6c-4b55-4bc6-b440-3802f4200933}\ |
| DriveLetter                           | D: |
| EncryptionMethod                      | 0 |
| EnforcePolicyDate                     |  |
| IsAutoUnlockEnabled                   | False |
| IsHardwareTestPending                 | False |
| KeyProtectorTypes                     | {} |
| LockStatus                            | 0 |
| NoncomplianceDetectedDate             |  |
| NumericalPasswordKeyProtectorIDs      | {} |
| ProtectionStatus                      | 0 |
| ReasonsForNoncompliance               | {} |
| VolumeLabel                           | New Volume |
| VolumeName                            | D:\ |
| PSComputerName                        | HT6-SCCMTST-800 |