declare @results table ( DBName sysname, LogMB decimal(10,2), PctUsed decimal(10,2), Status bit, FreeSpaceMB as ( 100.0 - PctUsed ) * LogMB / 100.0 )
insert into @results ( DBName, LogMB, PctUsed, Status ) exec ( 'DBCC SQLPERF(logspace)' )

declare @logFiles table ( DBName sysname, LogFileName sysname, data_space_id int, physical_name varchar(max) )
insert into @logFiles( DBName, LogFileName, data_space_id, physical_name ) exec sp_msforeachdb 'use [?];select DBName = db_name(), LogFileName = name, data_space_id, physical_name from sys.database_files (nolock) where type_desc = ''log'''

select *, FreeSpaceSQL = replace( replace( 'USE {DBName};DBCC SHRINKFILE ( {LogFile}, 10000 )', '{DBName}', r.DBName ), '{LogFile}', f.LogFileName ) from @results r join @logFiles f on r.DBName = f.DBName order by FreeSpaceMB desc

exec xp_cmdshell 'dir g:\'

/*
DBName                          LogMB     PctUsed Status FreeSpaceMB      DBName                          LogFileName                         data_space_id physical_name                                 FreeSpaceSQL
=============================== ========= ======= ====== ================ =============================== =================================== ============= ============================================= ===================================================================================================
DataSynchronizerConfig          300601.69    0.30      0 299699.884930000 DataSynchronizerConfig          DataSynchronizerConfig_log                      0 G:\Logs\DataSynchronizerConfig_1.ldf          USE DataSynchronizerConfig;          DBCC SHRINKFILE ( DataSynchronizerConfig_log,          10000 )
TruDat                          151237.56    0.32      0 150753.599808000 TruDat                          TruDat_log                                      0 G:\Logs\TruDat_1.ldf                          USE TruDat;                          DBCC SHRINKFILE ( TruDat_log,                          10000 )
Claimbot                        125680.55    1.86      0 123342.891770000 Claimbot                        Claimbot_log                                    0 G:\Logs\Claimbot_1.ldf                        USE Claimbot;                        DBCC SHRINKFILE ( Claimbot_log,                        10000 )
EmailCampaignManagement          70620.30    1.46      0  69589.243620000 EmailCampaignManagement         EmailCampaignManagement_log                     0 G:\Logs\EmailCampaignManagement_1.ldf         USE EmailCampaignManagement;         DBCC SHRINKFILE ( EmailCampaignManagement_log,         10000 )
Trupanion.Central                31618.49    0.22      0  31548.929322000 Trupanion.Central               Trupanion.Central_log                           0 G:\Logs\Trupanion.Central_1.ldf               USE Trupanion.Central;               DBCC SHRINKFILE ( Trupanion.Central_log,               10000 )
EnterpriseCatalog                31862.12    1.37      0  31425.608956000 EnterpriseCatalog               EnterpriseCatalog_log                           0 G:\Logs\EnterpriseCatalog_1.ldf               USE EnterpriseCatalog;               DBCC SHRINKFILE ( EnterpriseCatalog_log,               10000 )
Attribution                      27536.99    3.32      0  26622.761932000 Attribution                     Attribution_log                                 0 G:\Logs\Attribution_log.LDF                   USE Attribution;                     DBCC SHRINKFILE ( Attribution_log,                     10000 )
CommServices                     23810.68    5.07      0  22603.478524000 CommServices                    CommServices_log                                0 G:\Logs\CommServices_1.ldf                    USE CommServices;                    DBCC SHRINKFILE ( CommServices_log,                    10000 )
SalesLead                        21276.55    1.86      0  20880.806170000 SalesLead                       SalesLead_log                                   0 G:\Logs\SalesLead_1.ldf                       USE SalesLead;                       DBCC SHRINKFILE ( SalesLead_log,                       10000 )
Workflow                         20802.49    0.23      0  20754.644273000 Workflow                        Workflow_log                                    0 G:\Logs\Workflow_1.ldf                        USE Workflow;                        DBCC SHRINKFILE ( Workflow_log,                        10000 )
ClaimRouting                     13134.74    0.42      0  13079.574092000 ClaimRouting                    ClaimRouting_log                                0 G:\Logs\ClaimRouting_1.ldf                    USE ClaimRouting;                    DBCC SHRINKFILE ( ClaimRouting_log,                    10000 )
TrupanionExpressHospitalGateway  14535.99   18.74      0  11811.945474000 TrupanionExpressHospitalGateway TrupanionExpressHospitalGateway_log             0 G:\Logs\TrupanionExpressHospitalGateway_1.ldf USE TrupanionExpressHospitalGateway; DBCC SHRINKFILE ( TrupanionExpressHospitalGateway_log, 10000 )
Payment                          12183.99    3.18      0  11796.539118000 Payment                         Payment_log                                     0 G:\Logs\Payment_1.ldf                         USE Payment;                         DBCC SHRINKFILE ( Payment_log,                         10000 )
InboundSales                     11143.99    0.97      0  11035.893297000 InboundSales                    InboundSales_log                                0 G:\Logs\InboundSales_1.ldf                    USE InboundSales;                    DBCC SHRINKFILE ( InboundSales_log,                    10000 )
Quote                            10159.49    1.11      0  10046.719661000 Quote                           Quote_log                                       0 G:\Logs\Quote_1.ldf                           USE Quote;                           DBCC SHRINKFILE ( Quote_log,                           10000 )
Claims                            9598.74    0.58      0   9543.067308000 Claims                          Claims_log                                      0 G:\Logs\Claims_1.ldf                          USE Claims;                          DBCC SHRINKFILE ( Claims_log,                          10000 )
Product                           8151.99    0.58      0   8104.708458000 Product                         Product_log                                     0 G:\Logs\Product_1.ldf                         USE Product;                         DBCC SHRINKFILE ( Product_log,                         10000 )
Notation                          7830.18    0.16      0   7817.651712000 Notation                        Notation_log                                    0 G:\Logs\Notation_1.ldf                        USE Notation;                        DBCC SHRINKFILE ( Notation_log,                        10000 )
PetNavGateway                     6551.99    0.11      0   6544.782811000 PetNavGateway                   PetNavGateway_log                               0 G:\Logs\PetNavGateway_1.ldf                   USE PetNavGateway;                   DBCC SHRINKFILE ( PetNavGateway_log,                   10000 )
Billing                           6161.87    1.50      0   6069.441950000 Billing                         Billing_log                                     0 G:\Logs\Billing_1.ldf                         USE Billing;                         DBCC SHRINKFILE ( Billing_log,                         10000 )
LiteSpeedLocal                    4871.99    1.11      0   4817.910911000 LiteSpeedLocal                  LiteSpeedLocal_log                              0 G:\Logs\LiteSpeedLocal_log.ldf                USE LiteSpeedLocal;                  DBCC SHRINKFILE ( LiteSpeedLocal_log,                  10000 )
Telephony                         4762.80    1.31      0   4700.407320000 Telephony                       Telephony_log                                   0 G:\Logs\Telephony_1.ldf                       USE Telephony;                       DBCC SHRINKFILE ( Telephony_log,                       10000 )
Geography2                        4369.37    0.22      0   4359.757386000 Geography2                      Geography2_log                                  0 G:\Logs\Geography2_1.ldf                      USE Geography2;                      DBCC SHRINKFILE ( Geography2_log,                      10000 )
TruDTC                            3398.24    7.77      0   3134.196752000 TruDTC                          TruDTC_log                                      0 G:\Logs\TruDTC_1.ldf                          USE TruDTC;                          DBCC SHRINKFILE ( TruDTC_log,                          10000 )
ExceptionCentral                  2334.24    0.13      0   2331.205488000 ExceptionCentral                ExceptionCentral_log                            0 G:\Logs\ExceptionCentral_1.ldf                USE ExceptionCentral;                DBCC SHRINKFILE ( ExceptionCentral_log,                10000 )
tempdb                            2047.99    5.54      0   1934.531354000 tempdb                          templog                                         0 D:\tempdb\templog.ldf                         USE tempdb;                          DBCC SHRINKFILE ( templog,                             10000 )
TestData                          1704.93    0.92      0   1689.244644000 TestData                        TestData_log                                    0 G:\Logs\TestData_1.ldf                        USE TestData;                        DBCC SHRINKFILE ( TestData_log,                        10000 )
Policy                            1579.55    8.58      0   1444.024610000 Policy                          Policy_log                                      0 G:\Logs\Policy_1.ldf                          USE Policy;                          DBCC SHRINKFILE ( Policy_log,                          10000 )
WelcomeKit                        1431.99    0.17      0   1429.555617000 WelcomeKit                      WelcomeKit_log                                  0 G:\Logs\WelcomeKit_1.ldf                      USE WelcomeKit;                      DBCC SHRINKFILE ( WelcomeKit_log,                      10000 )
Hospital                          1283.12    4.21      0   1229.100648000 Hospital                        Hospital_log                                    0 G:\Logs\Hospital_1.ldf                        USE Hospital;                        DBCC SHRINKFILE ( Hospital_log,                        10000 )
TruSecurity                       1222.05    0.21      0   1219.483695000 TruSecurity                     TruSecurity_log                                 0 G:\Logs\TruSecurity_1.LDF                     USE TruSecurity;                     DBCC SHRINKFILE ( TruSecurity_log,                     10000 )
VisionMigration                   1104.49    1.94      0   1083.062894000 VisionMigration                 VisionMigration_log                             0 G:\Logs\VisionMigration_log.ldf               USE VisionMigration;                 DBCC SHRINKFILE ( VisionMigration_log,                 10000 )
Promo                             1050.18    0.18      0   1048.289676000 Promo                           Promo_log                                       0 G:\Logs\Promo_1.ldf                           USE Promo;                           DBCC SHRINKFILE ( Promo_log,                           10000 )
DevOps                            1066.24    1.84      0   1046.621184000 DevOps                          DevOps_log                                      0 G:\Logs\DevOps_1.ldf                          USE DevOps;                          DBCC SHRINKFILE ( DevOps_log,                          10000 )
MessageMeta                       1036.05    0.15      0   1034.495925000 MessageMeta                     MessageMeta_log                                 0 G:\Logs\MessageMeta_1.ldf                     USE MessageMeta;                     DBCC SHRINKFILE ( MessageMeta_log,                     10000 )
Geography                         1092.12    5.88      0   1027.903344000 Geography                       Geography_log                                   0 G:\Logs\Geography_1.ldf                       USE Geography;                       DBCC SHRINKFILE ( Geography_log,                       10000 )
BillingDataWarehouse              1041.80    1.94      0   1021.589080000 BillingDataWarehouse            BillingDataWarehouse_log                        0 G:\Logs\BillingDataWarehouse_1.ldf            USE BillingDataWarehouse;            DBCC SHRINKFILE ( BillingDataWarehouse_log,            10000 )
BankPayeeValidationStatus         1041.80    2.02      0   1020.755640000 BankPayeeValidationStatus       BankPayeeValidationStatus_log                   0 G:\Logs\BankPayeeValidationStatus_1.ldf       USE BankPayeeValidationStatus;       DBCC SHRINKFILE ( BankPayeeValidationStatus_log,       10000 )
DataPointAuthentication           1092.12    6.97      0   1015.999236000 DataPointAuthentication         DataPointAuthentication_log                     0 G:\Logs\DataPointAuthentication_1.ldf         USE DataPointAuthentication;         DBCC SHRINKFILE ( DataPointAuthentication_log,         10000 )
VisionMigration_Test              1040.49    3.75      0   1001.471625000 VisionMigration_Test            VisionMigration_Test_log                        0 G:\Logs\VisionMigration_Test_log.ldf          USE VisionMigration_Test;            DBCC SHRINKFILE ( VisionMigration_Test_log,            10000 )
AppLog                            1047.80    4.99      0    995.514780000 AppLog                          AppLog_log                                      0 G:\Logs\AppLog_1.ldf                          USE AppLog;                          DBCC SHRINKFILE ( AppLog_log,                          10000 )
Audit                             1043.62    6.64      0    974.323632000 Audit                           Audit_log                                       0 G:\Logs\Audit_1.ldf                           USE Audit;                           DBCC SHRINKFILE ( Audit_log,                           10000 )
Cart                              1066.93    9.04      0    970.479528000 Cart                            Cart_log                                        0 G:\Logs\Cart_1.LDF                            USE Cart;                            DBCC SHRINKFILE ( Cart_log,                            10000 )
DataSynchronizerCompare           1038.68    9.50      0    940.005400000 DataSynchronizerCompare         DataSynchronizerCompare_log                     0 G:\Logs\DataSynchronizerCompare_1.ldf         USE DataSynchronizerCompare;         DBCC SHRINKFILE ( DataSynchronizerCompare_log,         10000 )
CLU                               1062.37   11.76      0    937.435288000 CLU                             CLU_log                                         0 G:\Logs\CLU_1.ldf                             USE CLU;                             DBCC SHRINKFILE ( CLU_log,                             10000 )
TruTime                           1052.80   11.13      0    935.623360000 TruTime                         TruTime_log                                     0 G:\Logs\TruTime_1.ldf                         USE TruTime;                         DBCC SHRINKFILE ( TruTime_log,                         10000 )
DataAdjustment                    1043.62   12.02      0    918.176876000 DataAdjustment                  DataAdjustment_log                              0 G:\Logs\DataAdjustment_1.ldf                  USE DataAdjustment;                  DBCC SHRINKFILE ( DataAdjustment_log,                  10000 )
Site                              1038.68   12.02      0    913.830664000 Site                            Site_log                                        0 G:\Logs\Site_1.ldf                            USE Site;                            DBCC SHRINKFILE ( Site_log,                            10000 )
Bootstrap                         1028.55   11.37      0    911.603865000 Bootstrap                       Bootstrap_log                                   0 G:\Logs\Bootstrap_1.ldf                       USE Bootstrap;                       DBCC SHRINKFILE ( Bootstrap_log,                       10000 )
PurchaseProcess                    813.49    0.45      0    809.829295000 PurchaseProcess                 PurchaseProcess_log                             0 G:\Logs\PurchaseProcess_1.ldf                 USE PurchaseProcess;                 DBCC SHRINKFILE ( PurchaseProcess_log,                 10000 )
ContentGeneration                  611.12    4.01      0    586.614088000 ContentGeneration               ContentGeneration_log                           0 G:\Logs\ContentGeneration_1.ldf               USE ContentGeneration;               DBCC SHRINKFILE ( ContentGeneration_log,               10000 )
Survey                              87.99    1.44      0     86.722944000 Survey                          Survey_log                                      0 G:\Logs\Survey_1.ldf                          USE Survey;                          DBCC SHRINKFILE ( Survey_log,                          10000 )
msdb                                61.93    4.93      0     58.876851000 msdb                            MSDBLog                                         0 G:\Logs\MSDBLog.ldf                           USE msdb;                            DBCC SHRINKFILE ( MSDBLog,                             10000 )
SideBySidePriceTest                 39.99    5.00      0     37.990500000 SideBySidePriceTest             SideBySidePriceTest_log                         0 G:\Logs\SideBySidePriceTest_1.ldf             USE SideBySidePriceTest;             DBCC SHRINKFILE ( SideBySidePriceTest_log,             10000 )
DataWarehouse                       28.80    6.47      0     26.936640000 DataWarehouse                   DataWarehouse_log                               0 G:\Logs\DataWarehouse_1.ldf                   USE DataWarehouse;                   DBCC SHRINKFILE ( DataWarehouse_log,                   10000 )
master                              23.80    8.89      0     21.684180000 master                          mastlog                                         0 G:\Logs\mastlog.ldf                           USE master;                          DBCC SHRINKFILE ( mastlog,                             10000 )
model                               16.49    2.13      0     16.138763000 model                           modellog                                        0 G:\Logs\modellog.ldf                          USE model;                           DBCC SHRINKFILE ( modellog,                            10000 )
TestDB                               7.99   27.71      0      5.775971000 TestDB                          TestDB_log                                      0 G:\Logs\TestDB_log.ldf                        USE TestDB;                          DBCC SHRINKFILE ( TestDB_log,                          10000 )

 Volume in drive G is SQL Transaction Logs
 Volume Serial Number is 1054-3CFA

 Directory of g:\

05/22/2023  09:53 AM    <DIR>          Logs
               0 File(s)              0 bytes
               1 Dir(s)  101,875,318,784 bytes free
*/

/*
USE DataSynchronizerConfig;          DBCC SHRINKFILE ( DataSynchronizerConfig_log,         100000 )
USE TruDat;                          DBCC SHRINKFILE ( TruDat_log,                          10000 )
USE Claimbot;                        DBCC SHRINKFILE ( Claimbot_log,                        10000 )
USE EmailCampaignManagement;         DBCC SHRINKFILE ( EmailCampaignManagement_log,         10000 )
USE [Trupanion.Central];             DBCC SHRINKFILE ( [Trupanion.Central_log],             10000 )
USE EnterpriseCatalog;               DBCC SHRINKFILE ( EnterpriseCatalog_log,               10000 )
USE Attribution;                     DBCC SHRINKFILE ( Attribution_log,                     10000 )
USE CommServices;                    DBCC SHRINKFILE ( CommServices_log,                    10000 )
USE SalesLead;                       DBCC SHRINKFILE ( SalesLead_log,                       10000 )
USE Workflow;                        DBCC SHRINKFILE ( Workflow_log,                        10000 )
USE ClaimRouting;                    DBCC SHRINKFILE ( ClaimRouting_log,                    10000 )
USE TrupanionExpressHospitalGateway; DBCC SHRINKFILE ( TrupanionExpressHospitalGateway_log, 10000 )
USE Payment;                         DBCC SHRINKFILE ( Payment_log,                         10000 )
USE InboundSales;                    DBCC SHRINKFILE ( InboundSales_log,                    10000 )
USE Quote;                           DBCC SHRINKFILE ( Quote_log,                           10000 )
*/

exec xp_cmdshell 'dir g:\'

/*
 Volume in drive G is SQL Transaction Logs
 Volume Serial Number is 1054-3CFA

 Directory of g:\

05/22/2023  09:53 AM    <DIR>          Logs
               0 File(s)              0 bytes
               1 Dir(s)  481,628,389,376 bytes free
*/