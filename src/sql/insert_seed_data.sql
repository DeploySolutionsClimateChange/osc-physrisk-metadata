-- PHYRISK EXAMPLE DATABASE STRUCTURE
-- Intended to help standardize glossary/metadata as well as field std_names and constraints
-- to align with phys-risk/geo-indexer/other related initiatives and 
-- speed up application development, help internationalize and display the results of analyses, and more.
-- The backend schema User and Tenant tables are derived from ASP.NET Boilerplate tables (https://aspnetboilerplate.com/). That code is available under the MIT license, here: https://github.com/aspnetboilerplate/aspnetboilerplate

-- Last Updated: 2024-08-23. 

-- DATA IN ENGLISH STARTS
INSERT INTO osc_physrisk_backend.user
	(std_id, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_user_name, std_tenant_id, email_address, std_name, std_surname, std_is_active)
VALUES 
	(1,'2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'osc',1,'example@email','Open-Source','Climate','y')
;
INSERT INTO osc_physrisk_backend.tenant
	(std_id, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_tenancy_name, std_name, std_is_active)
VALUES 
	(1,'2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL,'Default','Default','y');

INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('8b3b38fd-a6f5-4878-b4b4-0a251ec0363a', 'Unknown/Not Selected', 'Unknown/Not Selected', 'Unknown/Not Selected', 'Unknown/Not Selected','{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'f098938cd8cc7c4f1c71c8e97db0f075',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_slug, std_description_full, std_description_short, std_name_display, std_name,std_tags,  std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('7faf5507-9a0a-4554-aef3-6efe5cffee63','en-climate-scenario-historical', 'History (before 2014). See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'History (before 2014)', 'History (- 2014)', 'History (- 2014)','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_slug, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('0ab07b1d-864d-4f0a-9656-29e9b088df3b','en-climate-scenario-SSP1-19', 'SSP1-1.9 -  very low GHG emissions: CO2 emissions cut to net zero around 2050. See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'SSP1-1.9', 'SSP1-1.9', 'SSP1-1.9','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_slug, std_description_full, std_description_short, std_name_display, std_name,std_tags,  std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('cb68b9c6-6dff-4f0d-8650-768249f2689d', 'en-climate-scenario-SSP1-26', 'SSP1-2.6 - low GHG emissions: CO2 emissions cut to net zero around 2075. See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'SSP1-2.6', 'SSP1-2.6', 'SSP1-2.6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_slug, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('5d1081f3-fd0e-4f53-b06b-8358be82644c', 'en-climate-scenario-SSP2-45', 'SSP2-4.5 - intermediate GHG emissions: CO2 emissions around current levels until 2050, then falling but not reaching net zero by 2100. See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'SSP2-4.5', 'SSP2-4.5', 'SSP2-4.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_slug, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('f9ba343c-78b6-426c-be56-5d845e305d58', 'en-climate-scenario-SSP3-70', 'SSP3-7.0 - high GHG emissions: CO2 emissions double by 2100. See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'SSP3-7.0', 'SSP3-7.0', 'SSP3-7.0','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_slug, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('fd76becb-28e9-424b-8c6e-c96aaf6988e5', 'en-climate-scenario-SSP5-85', 'SSP5-8.5 - very high GHG emissions: CO2 emissions triple by 2075. See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'SSP5-8.5', 'SSP5-8.5', 'SSP5-8.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_slug, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('3cd34fae-620a-47ae-862c-5349533e73b8', 'en-climate-scenario-RCP26', 'RCP2.6 - Peak in radiative forcing at ~ 3 W/m2 before 2100 and decline. See "REPRESENTATIVE CONCENTRATION PATHWAYS (RCPs)" (https://sedac.ciesin.columbia.edu/ddc/ar5_scenario_process/RCPs.html)', 'RCP2.6', 'RCP2.6', 'RCP2.6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_slug, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('e64b3f6a-69a6-403f-a4bb-e099fe099222', 'en-climate-scenario-RCP45', 'RCP4.5 - Stabilization without overshoot pathway to 4.5 W/m2 at stabilization after 2100. See "REPRESENTATIVE CONCENTRATION PATHWAYS (RCPs)" (https://sedac.ciesin.columbia.edu/ddc/ar5_scenario_process/RCPs.html)', 'RCP4.5', 'RCP4.5', 'RCP4.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_slug, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('bb01865e-2a53-48a3-9437-35764ba52639',  'en-climate-scenario-RCP6', 'RCP6 - Stabilization without overshoot pathway to 6 W/m2 at stabilization after 2100. See "REPRESENTATIVE CONCENTRATION PATHWAYS (RCPs)" (https://sedac.ciesin.columbia.edu/ddc/ar5_scenario_process/RCPs.html)', 'RCP6', 'RCP6', 'RCP6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_slug, std_description_full, std_description_short, std_name_display, std_name,std_tags,  std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('893a6b75-8660-47ff-80d3-08b4ddc259c3', 'en-climate-scenario-RCP85', 'RCP8.5 - Rising radiative forcing pathway leading to 8.5 W/m2 in 2100. See "REPRESENTATIVE CONCENTRATION PATHWAYS (RCPs)" (https://sedac.ciesin.columbia.edu/ddc/ar5_scenario_process/RCPs.html)', 'RCP8.5', 'RCP8.5', 'RCP8.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;

INSERT INTO osc_physrisk_vulnerability_analysis.vulnerability_type
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	(-1, 'Unknown Damage or Disruption', 'Unknown Damage or Disruption', 'Unknown Damage or Disruption', 'Unknown Damage or Disruption','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'f',NULL,NULL, 'en', 'std_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_vulnerability_analysis.vulnerability_type
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	(1, 'Damage as percentage of asset value', 'Damage as percentage of asset value', 'Damage as percentage of asset value', 'Damage as percentage of asset value','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'f',NULL,NULL, 'en', 'std_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_vulnerability_analysis.vulnerability_type
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	(2, 'Disruption in number of production units', 'Disruption in number of production units', 'Disruption in number of production units', 'Disruption in number of production units','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'f',NULL,NULL, 'en', 'std_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z')
;

INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	(-1, 'Unknown Damage or Disruption', 'Unknown Damage or Disruption', 'Unknown Damage or Disruption', 'Unknown Damage or Disruption','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'f',NULL,NULL, 'en', 'std_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, accounting_category)
VALUES 
	(1, 'Asset repairs and construction', 'Asset repairs and construction', 'Asset repairs and construction','Asset repairs and construction', '{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1, 'false',NULL,NULL, 'en', 'std_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z','Capex' );
INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, accounting_category)
VALUES 
	(2, 'Revenue loss due to asset restoration', 'Revenue loss due to asset restoration', 'Revenue loss due to asset restoration','Revenue loss due to asset restoration', '{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1, 'false',NULL,NULL, 'en', 'std_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z','Revenue' );
INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, accounting_category)
VALUES 
	(3, 'Revenue loss due to productivity impact', 'Revenue loss due to productivity impact', 'Revenue loss due to productivity impact','Revenue loss due to productivity impact', '{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1, 'false',NULL,NULL, 'en', 'std_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z','Revenue' );
INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, accounting_category)
VALUES 
	(4, 'Recurring cost increase (chronic)', 'Recurring cost increase (chronic)', 'Recurring cost increase (chronic)','Recurring cost increase (chronic)', '{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1, 'false',NULL,NULL, 'en', 'std_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z','OpEx' );
INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, accounting_category)
VALUES 
	(5, 'Recurring cost increase (acute)', 'Recurring cost increase (acute)', 'Recurring cost increase (acute)','Recurring cost increase (acute)', '{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1, 'false',NULL,NULL, 'en', 'std_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z','OpEx' );
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('8159d927-e596-444d-8f1a-494494339fad', 'en-climate-hazard-type-unknown', 'Unknown hazard/Not selected', 'Unknown hazard/Not selected', 'Unknown hazard/Not selected', 'Unknown hazard/Not selected', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('63ed7943-c4c4-43ea-abd2-86bb1997a094', 'en-climate-hazard-type-inundation-riverine', 'Riverine Inundation', 'Riverine Inundation', 'Riverine Inundation', 'Riverine Inundation', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y', 'y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('28a095cd-4cde-40a1-90d9-cbb0ca673c06', 'en-climate-hazard-type-inundation-coastal', 'Coastal Inundation', 'Coastal Inundation', 'Coastal Inundation', 'Coastal Inundation', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug,std_name,  std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('338ea109-828e-4aaf-b212-12d8eaf70a7e', 'en-climate-hazard-type-inundation-combined','Combined Inundation', 'Combined Inundation', 'Combined Inundation', 'Combined Inundation', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('d08db675-ee1e-48fe-b9e1-b0da27de8f2b', 'en-climate-hazard-type-chronic-heat', 'Chronic Heat', 'Chronic Heat', 'Chronic Heat', 'Chronic Heat', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('64fee0d3-b78b-49bf-911a-029695585d6a', 'en-climate-hazard-type-fire','Fire', 'Fire', 'Fire', 'Fire', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('35ace20f-86dc-4735-9536-129b51b6d25d', 'en-climate-hazard-type-drought','Drought', 'Drought', 'Drought', 'Drought', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug,std_name,  std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('2faed491-2c5d-499e-9568-fad6e3b3c0ec', 'en-climate-hazard-type-precipitation','Precipitation', 'Precipitation', 'Precipitation', 'Precipitation', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('29514258-18cb-4f2b-8798-203e0d513803', 'en-climate-hazard-type-water-risk','Water Risk', 'Water Risk', 'Water Risk', 'Water Risk', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('e4e4e199-367e-4568-824d-3f916e355567', 'en-climate-hazard-type-hail','Hail', 'Hail', 'Hail', 'Hail', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('0184b858-404d-4282-8f0d-2b4c42f7acd7', 'en-climate-hazard-type-wind','Wind', 'Wind', 'Wind', 'Wind', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(std_id, std_slug, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('4441cf3b-1460-4131-aff6-b51bf01cd084', 'en-climate-hazard-type-subsidence','subsidence', 'subsidence', 'subsidence', 'subsidence', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('57a7df66-420d-4730-9669-1547f8200272', 'Flood depth (TUDelft)', 'Flood depth (TUDelft)', 'Flood depth (TUDelft)', 'Flood depth (TUDelft)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('5fb27cc6-ee01-4133-b2e9-6c1f22ed5b40', 'Flood depth/GFDL-ESM2M (WRI)', 'Flood depth/GFDL-ESM2M (WRI)', 'Flood depth/GFDL-ESM2M (WRI)', 'Flood depth/GFDL-ESM2M (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('79555143-ba2a-47b0-bbe7-7aac3685dedb', 'Flood depth/HadGEM2-ES (WRI)', 'Flood depth/HadGEM2-ES (WRI)', 'Flood depth/HadGEM2-ES (WRI)', 'Flood depth/HadGEM2-ES (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('6fe5ccb1-5d38-4a3e-b0a5-d4cc70981035', 'Flood depth/IPSL-CM5A-LR (WRI)', 'Flood depth/IPSL-CM5A-LR (WRI)', 'Flood depth/IPSL-CM5A-LR (WRI)', 'Flood depth/IPSL-CM5A-LR (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('e4f10569-95be-4b5b-8d34-763eb95e730b', 'Flood depth/MIROC-ESM-CHEM (WRI)', 'Flood depth/MIROC-ESM-CHEM (WRI)', 'Flood depth/MIROC-ESM-CHEM (WRI)', 'Flood depth/MIROC-ESM-CHEM (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('690e01eb-f7e6-4fbf-84e4-f8195656abb3', 'Flood depth/NorESM1-M (WRI)', 'Flood depth/NorESM1-M (WRI)', 'Flood depth/NorESM1-M (WRI)', 'Flood depth/NorESM1-M (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('5f396b97-badc-40d2-b0b3-c8be8f3053ba', 'Flood depth/baseline (WRI)', 'Flood depth/baseline (WRI)', 'Flood depth/baseline (WRI)', 'Flood depth/baseline (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('901cbd14-9223-4d36-8ab4-658945d913a4', 'Standard of protection (TUDelft)', 'Standard of protection (TUDelft)', 'Standard of protection (TUDelft)', 'Standard of protection (TUDelft)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('be44d6fb-08cb-4f52-8ff2-bf1b7366a7a0', 'Flood depth/5%, no subsstd_idence (WRI)', 'Flood depth/5%, no subsstd_idence (WRI)', 'Flood depth/5%, no subsstd_idence (WRI)', 'Flood depth/5%, no subsstd_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('c87fc5c3-c2ae-4732-ba52-7d9156044d7b', 'Flood depth/5%, with subsstd_idence (WRI)', 'Flood depth/5%, with subsstd_idence (WRI)', 'Flood depth/5%, with subsstd_idence (WRI)', 'Flood depth/5%, with subsstd_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('60c90be9-5cfb-4f6a-b9eb-e84e7da5a456', 'Flood depth/50%, no subsstd_idence (WRI)', 'Flood depth/50%, no subsstd_idence (WRI)', 'Flood depth/50%, no subsstd_idence (WRI)', 'Flood depth/50%, no subsstd_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('e7623e9e-649e-460a-8b81-ae9d01711f75', 'Flood depth/50%, with subsstd_idence (WRI)', 'Flood depth/50%, with subsstd_idence (WRI)', 'Flood depth/50%, with subsstd_idence (WRI)', 'Flood depth/50%, with subsstd_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('28fbe059-a661-4fe6-8ba7-0fa626a9312b', 'Flood depth/95%, no subsstd_idence (WRI)', 'Flood depth/95%, no subsstd_idence (WRI)', 'Flood depth/95%, no subsstd_idence (WRI)', 'Flood depth/95%, no subsstd_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('ea005e03-f025-4aa4-a37e-981eea5bcfdb', 'Flood depth/95%, with subsstd_idence (WRI)', 'Flood depth/95%, with subsstd_idence (WRI)', 'Flood depth/95%, with subsstd_idence (WRI)', 'Flood depth/95%, with subsstd_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('12651bc5-04a2-4225-ba25-f1c0e09bdb90', 'Flood depth/baseline, no subsstd_idence (WRI)', 'Flood depth/baseline, no subsstd_idence (WRI)', 'Flood depth/baseline, no subsstd_idence (WRI)', 'Flood depth/baseline, no subsstd_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('6ba57474-6c7a-4ea3-aca8-25e30f27cec1', 'Flood depth/baseline, with subsstd_idence (WRI)', 'Flood depth/baseline, with subsstd_idence (WRI)', 'Flood depth/baseline, with subsstd_idence (WRI)', 'Flood depth/baseline, with subsstd_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('e0b5afc2-eed8-4760-9667-c14fdbf374db', 'Days with average temperature above 25°C/ACCESS-CM2', 'Days with average temperature above 25°C/ACCESS-CM2', 'Days with average temperature above 25°C/ACCESS-CM2', 'Days with average temperature above 25°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('b795a8af-12cc-4773-83ee-a50badd1fe74', 'Days with average temperature above 25°C/CMCC-ESM2', 'Days with average temperature above 25°C/CMCC-ESM2', 'Days with average temperature above 25°C/CMCC-ESM2', 'Days with average temperature above 25°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('81213608-0a01-42b0-a54f-a070fb104b95', 'Days with average temperature above 25°C/CNRM-CM6-1', 'Days with average temperature above 25°C/CNRM-CM6-1', 'Days with average temperature above 25°C/CNRM-CM6-1', 'Days with average temperature above 25°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('98692238-6a8f-4e58-a779-9f96eeaf1abd', 'Days with average temperature above 25°C/MIROC6', 'Days with average temperature above 25°C/MIROC6', 'Days with average temperature above 25°C/MIROC6', 'Days with average temperature above 25°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('3dbf253a-d880-4440-baa5-3e4a9fcac355', 'Days with average temperature above 25°C/ESM1-2-LR', 'Days with average temperature above 25°C/ESM1-2-LR', 'Days with average temperature above 25°C/ESM1-2-LR', 'Days with average temperature above 25°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('5fcca03b-ffff-4632-b896-78ceb9777e4b', 'Days with average temperature above 25°C/NorESM2-MM', 'Days with average temperature above 25°C/NorESM2-MM', 'Days with average temperature above 25°C/NorESM2-MM', 'Days with average temperature above 25°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('77f04d46-303f-40f2-a892-d0068d6ab64a', 'Days with average temperature above 30°C/ACCESS-CM2', 'Days with average temperature above 30°C/ACCESS-CM2', 'Days with average temperature above 30°C/ACCESS-CM2', 'Days with average temperature above 30°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('c47e4dfa-e850-4060-aed9-af9100c65986', 'Days with average temperature above 30°C/CMCC-ESM2', 'Days with average temperature above 30°C/CMCC-ESM2', 'Days with average temperature above 30°C/CMCC-ESM2', 'Days with average temperature above 30°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('ba1e06be-1cf5-4b5d-8f93-8f64e47af2b8', 'Days with average temperature above 30°C/CNRM-CM6-1', 'Days with average temperature above 30°C/CNRM-CM6-1', 'Days with average temperature above 30°C/CNRM-CM6-1', 'Days with average temperature above 30°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('b882a67c-acea-4dbe-9939-1594775e6f78', 'Days with average temperature above 30°C/MIROC6', 'Days with average temperature above 30°C/MIROC6', 'Days with average temperature above 30°C/MIROC6', 'Days with average temperature above 30°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('0ae16260-45b7-48fe-924e-a2bd2bc25f39', 'Days with average temperature above 30°C/ESM1-2-LR', 'Days with average temperature above 30°C/ESM1-2-LR', 'Days with average temperature above 30°C/ESM1-2-LR', 'Days with average temperature above 30°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('151fe933-f1be-4fb1-bcaf-d534a5023c78', 'Days with average temperature above 30°C/NorESM2-MM', 'Days with average temperature above 30°C/NorESM2-MM', 'Days with average temperature above 30°C/NorESM2-MM', 'Days with average temperature above 30°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('96e6fcc5-d843-4f59-9746-2d0d341b6bdc', 'Days with average temperature above 35°C/ACCESS-CM2', 'Days with average temperature above 35°C/ACCESS-CM2', 'Days with average temperature above 35°C/ACCESS-CM2', 'Days with average temperature above 35°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('2c485594-5220-4e5e-85f0-3e67a09bacd9', 'Days with average temperature above 35°C/CMCC-ESM2', 'Days with average temperature above 35°C/CMCC-ESM2', 'Days with average temperature above 35°C/CMCC-ESM2', 'Days with average temperature above 35°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('db9a09b3-3386-4081-bf0c-79b6c8ebd38e', 'Days with average temperature above 35°C/CNRM-CM6-1', 'Days with average temperature above 35°C/CNRM-CM6-1', 'Days with average temperature above 35°C/CNRM-CM6-1', 'Days with average temperature above 35°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('3f77c47d-9a26-4a3f-a289-ecf56678ec69', 'Days with average temperature above 35°C/MIROC6', 'Days with average temperature above 35°C/MIROC6', 'Days with average temperature above 35°C/MIROC6', 'Days with average temperature above 35°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('f197975a-acea-4514-acbf-35cb070b0b5c', 'Days with average temperature above 35°C/ESM1-2-LR', 'Days with average temperature above 35°C/ESM1-2-LR', 'Days with average temperature above 35°C/ESM1-2-LR', 'Days with average temperature above 35°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('d4d610b4-060e-4212-9b0c-05fe551a0128', 'Days with average temperature above 35°C/NorESM2-MM', 'Days with average temperature above 35°C/NorESM2-MM', 'Days with average temperature above 35°C/NorESM2-MM', 'Days with average temperature above 35°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('f38a4529-0b9e-4a31-9b16-f6e070a4f001', 'Days with average temperature above 40°C/ACCESS-CM2', 'Days with average temperature above 40°C/ACCESS-CM2', 'Days with average temperature above 40°C/ACCESS-CM2', 'Days with average temperature above 40°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('bae5ce0d-079c-44c8-87f2-705e13806371', 'Days with average temperature above 40°C/CMCC-ESM2', 'Days with average temperature above 40°C/CMCC-ESM2', 'Days with average temperature above 40°C/CMCC-ESM2', 'Days with average temperature above 40°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('19049eb2-9270-4b1b-9aea-8e2c610ea6b0', 'Days with average temperature above 40°C/CNRM-CM6-1', 'Days with average temperature above 40°C/CNRM-CM6-1', 'Days with average temperature above 40°C/CNRM-CM6-1', 'Days with average temperature above 40°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('a35f8652-5736-4b83-b9ec-2bcd53dd2b75', 'Days with average temperature above 40°C/MIROC6', 'Days with average temperature above 40°C/MIROC6', 'Days with average temperature above 40°C/MIROC6', 'Days with average temperature above 40°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('6a23417d-27fc-49f5-9147-43f9a761e13d', 'Days with average temperature above 40°C/ESM1-2-LR', 'Days with average temperature above 40°C/ESM1-2-LR', 'Days with average temperature above 40°C/ESM1-2-LR', 'Days with average temperature above 40°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('9fd1aafe-d942-4dd7-8b5f-cc3983d12616', 'Days with average temperature above 40°C/NorESM2-MM', 'Days with average temperature above 40°C/NorESM2-MM', 'Days with average temperature above 40°C/NorESM2-MM', 'Days with average temperature above 40°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('801009ff-7135-4252-a956-8f32cd9fb17d', 'Days with average temperature above 45°C/ACCESS-CM2', 'Days with average temperature above 45°C/ACCESS-CM2', 'Days with average temperature above 45°C/ACCESS-CM2', 'Days with average temperature above 45°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('ea8be4c4-a3f0-441f-b1cd-b4de8b9e885c', 'Days with average temperature above 45°C/CMCC-ESM2', 'Days with average temperature above 45°C/CMCC-ESM2', 'Days with average temperature above 45°C/CMCC-ESM2', 'Days with average temperature above 45°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('69053bee-35fd-45bd-9dd1-8fe485ae7715', 'Days with average temperature above 45°C/CNRM-CM6-1', 'Days with average temperature above 45°C/CNRM-CM6-1', 'Days with average temperature above 45°C/CNRM-CM6-1', 'Days with average temperature above 45°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('1f48f1f2-03ab-43b8-9185-038fd656ebcd', 'Days with average temperature above 45°C/MIROC6', 'Days with average temperature above 45°C/MIROC6', 'Days with average temperature above 45°C/MIROC6', 'Days with average temperature above 45°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('8960452e-86b1-4134-b03d-5bea69079fcc', 'Days with average temperature above 45°C/ESM1-2-LR', 'Days with average temperature above 45°C/ESM1-2-LR', 'Days with average temperature above 45°C/ESM1-2-LR', 'Days with average temperature above 45°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('3676521f-16ee-4ce6-b8b4-d00aaba44281', 'Days with average temperature above 45°C/NorESM2-MM', 'Days with average temperature above 45°C/NorESM2-MM', 'Days with average temperature above 45°C/NorESM2-MM', 'Days with average temperature above 45°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('8bfe29fb-85e3-4497-b340-ad3f4eadfc3f', 'Days with average temperature above 50°C/ACCESS-CM2', 'Days with average temperature above 50°C/ACCESS-CM2', 'Days with average temperature above 50°C/ACCESS-CM2', 'Days with average temperature above 50°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('fb684a2f-ce48-4d02-ba49-9c5cd49654df', 'Days with average temperature above 50°C/CMCC-ESM2', 'Days with average temperature above 50°C/CMCC-ESM2', 'Days with average temperature above 50°C/CMCC-ESM2', 'Days with average temperature above 50°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('56fb7c3a-7d9c-41d2-ab1d-37bab5544748', 'Days with average temperature above 50°C/CNRM-CM6-1', 'Days with average temperature above 50°C/CNRM-CM6-1', 'Days with average temperature above 50°C/CNRM-CM6-1', 'Days with average temperature above 50°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('12a84609-f114-4975-a90a-aed809452897', 'Days with average temperature above 50°C/MIROC6', 'Days with average temperature above 50°C/MIROC6', 'Days with average temperature above 50°C/MIROC6', 'Days with average temperature above 50°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('22ce6754-f68b-4f96-b083-8bb2a5c4deb6', 'Days with average temperature above 50°C/ESM1-2-LR', 'Days with average temperature above 50°C/ESM1-2-LR', 'Days with average temperature above 50°C/ESM1-2-LR', 'Days with average temperature above 50°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('ec4c8b74-816a-4260-8321-fc03b6850c37', 'Days with average temperature above 50°C/NorESM2-MM', 'Days with average temperature above 50°C/NorESM2-MM', 'Days with average temperature above 50°C/NorESM2-MM', 'Days with average temperature above 50°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('7f06ac9f-f6ac-467a-9a88-d14a91465141', 'Days with average temperature above 55°C/ACCESS-CM2', 'Days with average temperature above 55°C/ACCESS-CM2', 'Days with average temperature above 55°C/ACCESS-CM2', 'Days with average temperature above 55°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('c9edfa0d-5450-4de5-8680-4a26874cac2d', 'Days with average temperature above 55°C/CMCC-ESM2', 'Days with average temperature above 55°C/CMCC-ESM2', 'Days with average temperature above 55°C/CMCC-ESM2', 'Days with average temperature above 55°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('431a89ea-17bd-4dee-a2af-9ba18e737fe5', 'Days with average temperature above 55°C/CNRM-CM6-1', 'Days with average temperature above 55°C/CNRM-CM6-1', 'Days with average temperature above 55°C/CNRM-CM6-1', 'Days with average temperature above 55°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('158038b5-1f09-471a-ac5b-85aae409148b', 'Days with average temperature above 55°C/MIROC6', 'Days with average temperature above 55°C/MIROC6', 'Days with average temperature above 55°C/MIROC6', 'Days with average temperature above 55°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('a5810ce7-eec7-4881-a182-33e0e3156a26', 'Days with average temperature above 55°C/ESM1-2-LR', 'Days with average temperature above 55°C/ESM1-2-LR', 'Days with average temperature above 55°C/ESM1-2-LR', 'Days with average temperature above 55°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published, hazard_id)
VALUES 
	('41705043-bdad-4d2d-ab2b-3d884375b52d', 'Days with average temperature above 55°C/NorESM2-MM', 'Days with average temperature above 55°C/NorESM2-MM', 'Days with average temperature above 55°C/NorESM2-MM', 'Days with average temperature above 55°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;

-- DATA IN ENGLISH ENDS


-- INSERT ASSET PORTFOLIO EXAMPLE
-- INCLUDING EXAMPLE ASSET WITH OED AND NAICS std_tags
INSERT INTO osc_physrisk_assets.asset_class
	(std_id, std_abbreviation, std_name, std_slug, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('db4a14a2-a27b-4bb0-8249-a07fb78438f4', 'Residential','Residential Buildings','en-asset-class-residential', 'Residential Buildings', 'Homes, apartments, and other residential structures.', 'Homes, apartments, and other residential structures.', '{"naics":[53],"oed:occupancy:oed_code":1050,"oed:occupancy:air_code":301}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(std_id, std_abbreviation, std_name, std_slug, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('536e8cee-682f-4cd6-b23e-b32e885cc094', 'Commercial', 'Commercial Buildings','en-asset-class-commercial', 'Commercial Buildings', 'Offices, retail spaces, and other commercial properties.', 'Offices, retail spaces, and other commercial properties.', '{"naics":[44,45,49],"oed:occupancy:oed_code":1100,"oed:occupancy:air_code":311}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(std_id, std_abbreviation, std_name, std_slug, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('f2baa602-44fe-49be-a5c9-d8b8208d9499', 'Infra','Infrastructure','en-asset-class-infrastructure', 'Infrastructure', 'Roads, bridges, railways, airports, ports, and utilities (water, electricity, telecommunications).', 'Roads, bridges, railways, airports, ports, and utilities (water, electricity, telecommunications).', '{"oed:occupancy:oed_code":1256,"oed:occupancy:oed_code":1305}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(std_id, std_abbreviation, std_name, std_slug, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('a9da716f-6667-4efe-bac7-f91c1cdcc2f1', 'Agri','Agricultural Assets','en-asset-class-agricultural', 'Agricultural Assets', 'Cropland, livestock, agricultural facilities, and equipment.', 'Cropland, livestock, agricultural facilities, and equipment.', '{"oed:occupancy:oed_code":2700,"oed:occupancy:air_code":484}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(std_id, std_abbreviation, std_name, std_slug, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('1ad910c8-fba0-4f45-845e-5a1901b9ffbe', 'Industrial','Industrial Facilities', 'en-asset-class-industrial','Industrial Facilities', 'Factories, warehouses, and other industrial properties.', 'Factories, warehouses, and other industrial properties.', '{"oed:occupancy:oed_code":1150,"oed:occupancy:air_code":321}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(std_id, std_abbreviation, std_name, std_slug, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('2b5557e6-05ee-49d6-b6a6-b7ef54948af7', 'Natural','Natural Assets', 'en-asset-class-natural','Natural Assets', 'Forests, wetlands, rivers, and other natural environments.', 'Forests, wetlands, rivers, and other natural environments.', '{"oed:occupancy:oed_code":1000,"oed:occupancy:air_code":300}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(std_id, std_abbreviation, std_name, std_slug, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('beafc1fa-f6c8-4c72-9717-a243eea1a2ef', 'Cultural','Cultural Heritage Sites', 'en-asset-class-cultural','Cultural Heritage Sites', 'Historical buildings, monuments, and sites of cultural significance.', 'Historical buildings, monuments, and sites of cultural significance.', '{"oed:occupancy:oed_code":1000,"oed:occupancy:air_code":300}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');


INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('fa3d647a-4ab8-494a-b68e-6abf48404462', 'Single-family Homes', 'Single-family Homes', 'Single-family Homes', 'Single-family Homes', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','db4a14a2-a27b-4bb0-8249-a07fb78438f4');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('d1317024-2a21-4c89-8e7c-8609798dcc09', 'Multi-family apartments', 'Multi-family apartments', 'Multi-family apartments', 'Multi-family apartments', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','db4a14a2-a27b-4bb0-8249-a07fb78438f4');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('6ba2fda4-c6a7-4142-9e63-19948fe385f3', 'High-rise residential buildings', 'High-rise residential buildings', 'High-rise residential buildings', 'High-rise residential buildings', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','db4a14a2-a27b-4bb0-8249-a07fb78438f4');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('85246f30-e622-4af9-af86-16b23e8671a7', 'Retail Stores', 'Retail Stores', 'Retail Stores', 'Retail Stores', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','536e8cee-682f-4cd6-b23e-b32e885cc094');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('e9d9c1d6-915b-4450-ae2e-9fb2ad624478', 'Office buildings', 'Office buildings', 'Office buildings', 'Office buildings', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','536e8cee-682f-4cd6-b23e-b32e885cc094');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('f403566e-04eb-47aa-8327-ce6a43220867', 'Hotels and hospitality facilities', 'Hotels and hospitality facilities', 'Hotels and hospitality facilities', 'Hotels and hospitality facilities', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','536e8cee-682f-4cd6-b23e-b32e885cc094');

INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('ce606ca8-8f4c-429b-bdea-da87ed28087e', 'Highways', 'Highways', 'Highways', 'Highways', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','f2baa602-44fe-49be-a5c9-d8b8208d9499');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('20265e12-495b-46ee-af68-246216f0dacb', 'Bridges', 'Bridges', 'Bridges', 'Bridges', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','f2baa602-44fe-49be-a5c9-d8b8208d9499');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('64d4ffe2-e8b2-480d-9234-da51e53661d1', 'Railroads', 'Railroads', 'Railroads', 'Railroads', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','f2baa602-44fe-49be-a5c9-d8b8208d9499');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('3a568df0-cf71-4598-9bc7-2fb5997fb30d', 'Power transmission lines', 'Power transmission lines', 'Power transmission lines', 'Power transmission lines', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','f2baa602-44fe-49be-a5c9-d8b8208d9499');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('c7431f81-f1a7-42ca-90bd-6f43defe7931', 'Water treatment plants', 'Water treatment plants', 'Water treatment plants', 'Water treatment plants', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','f2baa602-44fe-49be-a5c9-d8b8208d9499');

INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('34ec5bde-96dc-4f50-86f4-71bef7f2271a', 'Irrigated cropland', 'Irrigated cropland', 'Irrigated cropland', 'Irrigated cropland', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','a9da716f-6667-4efe-bac7-f91c1cdcc2f1');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('9115c6ec-776f-45c2-a74b-010f7a21355c', 'Non-irrigated cropland', 'Non-irrigated cropland', 'Non-irrigated cropland', 'Non-irrigated cropland', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','a9da716f-6667-4efe-bac7-f91c1cdcc2f1');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('076c1110-a9e8-435c-994e-499bed18bc11', 'Livestock farms', 'Livestock farms', 'Livestock farms', 'Livestock farms', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','a9da716f-6667-4efe-bac7-f91c1cdcc2f1');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('8135bb62-54e7-4eb4-ad76-5b2b8e08c02e', 'Greenhouses', 'Greenhouses', 'Greenhouses', 'Greenhouses', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','a9da716f-6667-4efe-bac7-f91c1cdcc2f1');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('8bd9e90c-cfa9-404e-ad02-c3e53fad0210', 'Manufacturing plants', 'Manufacturing plants', 'Manufacturing plants', 'Manufacturing plants', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','1ad910c8-fba0-4f45-845e-5a1901b9ffbe');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('b5c703ea-336e-4a97-8883-971f1a275b69', 'Storage warehouses', 'Storage warehouses', 'Storage warehouses', 'Storage warehouses', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','1ad910c8-fba0-4f45-845e-5a1901b9ffbe');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('94face63-24ef-46ef-ac13-7565c7d81789', 'Chemical processing facilities', 'Chemical processing facilities', 'Chemical processing facilities', 'Chemical processing facilities', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','1ad910c8-fba0-4f45-845e-5a1901b9ffbe');


INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('7eb31e49-883b-4c0d-9464-404fc49b8eaa', 'Forest ecosystems', 'Forest ecosystems', 'Forest ecosystems', 'Forest ecosystems', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','2b5557e6-05ee-49d6-b6a6-b7ef54948af7');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('ae7851b9-123f-4ab6-8d26-594c88e2a6f5', 'River basins', 'River basins', 'River basins', 'River basins', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','2b5557e6-05ee-49d6-b6a6-b7ef54948af7');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('ef7cbcbc-adec-462f-84e6-d49de80fb882', 'Coastal wetlands', 'Coastal wetlands', 'Coastal wetlands', 'Coastal wetlands', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','2b5557e6-05ee-49d6-b6a6-b7ef54948af7');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('27628236-0486-4816-9487-dd9d9ccc9c5d', 'Historic buildings', 'Historic buildings', 'Historic buildings', 'Historic buildings', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','beafc1fa-f6c8-4c72-9717-a243eea1a2ef');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('82a14f2d-4db9-4df4-b62b-11b4aa157ebf', 'Archaeological Sites', 'Archaeological Sites', 'Archaeological Sites', 'Archaeological Sites', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','beafc1fa-f6c8-4c72-9717-a243eea1a2ef');
INSERT INTO osc_physrisk_assets.asset_type
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published,asset_class_id)
VALUES 
	('bdea3237-f764-4907-98cd-e0d131e099c5', 'Museums', 'Museums', 'Museums', 'Museums', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','beafc1fa-f6c8-4c72-9717-a243eea1a2ef');



INSERT INTO osc_physrisk_assets.portfolio
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_tenant_id, std_is_published, std_publisher_id, std_datetime_utc_published, value_total, value_currency_alphabetic_code)
VALUES 
	('07c629be-42c6-4dbe-bd56-83e64253368d', 'Example Portfolio 1', 'Example Portfolio 1', 'Example Portfolio 1', 'Example Portfolio 1', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y', 1,'y',1,'2024-07-25T00:00:01Z', 12345678.90, 'USD');

INSERT INTO osc_physrisk_assets.asset_realestate
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active,std_tenant_id, std_is_published, std_publisher_id, std_datetime_utc_published, portfolio_id, std_geo_location_name, std_geo_location_coordinates, std_geo_overture_features, std_geo_h3_index, std_geo_h3_resolution, asset_type_id, owner_bloomberg_id, owner_lei_id, value_total, value_currency_alphabetic_code, value_ltv)
VALUES 
	('281d68cc-ffd3-4740-acd6-1ea23bce902f', 'Commercial Real Estate asset example', 'Commercial Real Estate asset example', 'Commercial Real Estate asset example', 'Commercial Real Estate asset example', '{"naics":[531111],"oed:occupancy:oed_code":1050,"oed:occupancy:air_code":301}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y', 1,'y',1,'2024-07-25T00:00:01Z' , '07c629be-42c6-4dbe-bd56-83e64253368d', 'Fake location', ST_GeomFromText('POINT(-71.064544 42.28787)'), '{}', '1234', 12, '85246f30-e622-4af9-af86-16b23e8671a7', 'BBG000BLNQ16', '', 12345678.90, 'USD','{LTV value ratio}')
;
INSERT INTO osc_physrisk_assets.asset_powergeneratingutility
	(std_id, std_name, std_name_display, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_tenant_id, std_is_published, std_publisher_id, std_datetime_utc_published, portfolio_id, std_geo_location_name, std_geo_location_coordinates, std_geo_overture_features, std_geo_h3_index, std_geo_h3_resolution,asset_type_id,  owner_bloomberg_id, owner_lei_id, value_total, value_currency_alphabetic_code, production, capacity, availability_rate)
VALUES 
	('78cb5382-5e4f-4762-b2e8-7cb33954f788', 'Electrical Power Generating Utility example', 'Electrical Power Generating Utility example', 'Electrical Power Generating Utility example', 'Electrical Power Generating Utility example', '{"naics":[22111],"oed:occupancy:oed_code":1300,"oed:occupancy:air_code":361}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL, 'y', 1,'y',1,'2024-07-25T00:00:01Z' , '07c629be-42c6-4dbe-bd56-83e64253368d', 'Fake location', ST_GeomFromText('POINT(-71.064544 42.28787)'), '{}', '1234', 12, '3a568df0-cf71-4598-9bc7-2fb5997fb30d', 'BBG000BLNQ16', '', 12345678.90, 'USD', 12345.0,100.00,95.00)
;

-- INSERT EXPOSURE, VULNERABILITY, AND FINANCIAL MODELS
INSERT INTO osc_physrisk.osc_physrisk_vulnerability_analysis.exposure_function
	(std_id, std_name, std_name_display, std_slug, std_abbreviation, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_active, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_tenant_id, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_published, std_publisher_id, std_datetime_utc_published, std_version, std_dataset_id)
VALUES 
	('3f2a5033-cd68-4a04-93a6-a1ce2b5270eb', 'OS-C Phys Risk Flood Exposure & Vulnerability Model', 'OS-C Phys Risk Flood Exposure & Vulnerability Model', 'osc-physrisk-model-vulnerability-flooda','OS-C Flood', 'OS-C Phys Risk Flood Vulnerability Model', 'OS-C Phys Risk Flood Vulnerability Model', '{}', '2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'y','n',NULL,NULL, 1,'en', 'std_checksum',1,NULL, 'y', 1,'2024-07-25T00:00:01Z','1.0',NULL)
;

INSERT INTO osc_physrisk.osc_physrisk_vulnerability_analysis.vulnerability_function
	(std_id, std_name, std_name_display, std_slug, std_abbreviation, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_active, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_tenant_id, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_published, std_publisher_id, std_datetime_utc_published, std_version, std_dataset_id)
VALUES 
	('0a980ae7-5c2c-4996-8d87-e0337d92c13b', 'OS-C Phys Risk Flood Vulnerability Model', 'OS-C Phys Risk Flood Vulnerability Model', 'osc-physrisk-model-vulnerability-flooda','OS-C Flood', 'OS-C Phys Risk Flood Vulnerability Model', 'OS-C Phys Risk Flood Vulnerability Model', '{}', '2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'y','n',NULL,NULL, 1,'en', 'std_checksum',1,NULL, 'y', 1,'2024-07-25T00:00:01Z','1.0',NULL)
;

-- INSERT PRECALCULATED IMPACT EXAMPLE
INSERT INTO osc_physrisk_vulnerability_analysis.geolocated_precalculated_vulnerability
	(std_id, std_name, std_name_display, std_abbreviation, std_description_full, std_description_short, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_tenant_id,std_is_published, std_publisher_id, std_datetime_utc_published, hazard_indicator_id, scenario_id, scenario_year, std_geo_location_name, std_geo_location_address, std_geo_location_coordinates, std_geo_overture_features, std_geo_h3_index, std_geo_h3_resolution, vulnerability_level, vulnerability_historically, std_datetime_utc_start, std_datetime_utc_end, exposure_function_id, exposure_level, exposure_data_raw, vulnerability_function_id, vulnerability_type_id, vulnerability_data_raw)
VALUES 
	('3bbb4a0e-f719-4e78-864b-3962e7f9e3a4', 'Example stored precalculated impact damage curve for Utility', 'Example stored precalculated impact damage curve for Utility', NULL, 'Example stored precalculated impact damage curve for Utility','Example stored precalculated impact damage curve for Utility', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'std_checksum',1,NULL,'y', 1,'y',1,'2024-07-15T00:00:01Z','57a7df66-420d-4730-9669-1547f8200272', '5d1081f3-fd0e-4f53-b06b-8358be82644c', 2040, '07c629be-42c6-4dbe-bd56-83e64253368d', 'Fake location', ST_GeomFromText('POINT(-71.064544 42.28787)'), '{}', '1234', 12, 0.5, 'n',NULL ,NULL ,	
	'3f2a5033-cd68-4a04-93a6-a1ce2b5270eb',
	0.6,
	'{ "some":"exposure_data"}',
	'0a980ae7-5c2c-4996-8d87-e0337d92c13b',
	1,	
	'{
    "items": [
        {
            "asset_type": "Steam/OnceThrough",
            "event_type": "Inundation",
            "impact_mean": [
                0.0,
                1.0,
                2.0,
                7.0,
                14.0,
                30.0,
                60.0,
                180.0,
                365.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                0.1,
                0.2,
                0.3,
                0.4,
                0.5,
                0.6,
                0.7,
                1.0
            ],
            "intensity_units": "Metres",
            "location": "Global"
        },
        {
            "asset_type": "Steam/Dry",
            "event_type": "Inundation",
            "impact_mean": [
                0.0,
                1.0,
                2.0,
                7.0,
                14.0,
                30.0,
                60.0,
                180.0,
                365.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                0.1,
                0.2,
                0.3,
                0.4,
                0.5,
                0.6,
                0.7,
                1.0
            ],
            "intensity_units": "Metres",
            "location": "Global"
        },
        {
            "asset_type": "Gas",
            "event_type": "Inundation",
            "impact_mean": [
                0.0,
                1.0,
                2.0,
                7.0,
                14.0,
                30.0,
                60.0,
                180.0,
                365.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                0.1,
                0.2,
                0.3,
                0.4,
                0.5,
                0.6,
                0.7,
                1.0
            ],
            "intensity_units": "Metres",
            "location": "Global"
        },
        {
            "asset_type": "Steam/Recirculating",
            "event_type": "Inundation",
            "impact_mean": [
                0.0,
                1.0,
                2.0,
                7.0,
                14.0,
                30.0,
                60.0,
                180.0,
                365.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                0.1,
                0.2,
                0.3,
                0.4,
                0.5,
                0.6,
                0.7,
                1.0
            ],
            "intensity_units": "Metres",
            "location": "Global"
        },
        {
            "asset_type": "Steam/Dry",
            "event_type": "AirTemperature",
            "impact_mean": [
                0.0,
                0.02,
                0.04,
                0.08,
                0.11,
                0.15,
                1.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                6.0,
                12.0,
                18.0,
                24.0,
                30.0,
                198.0
            ],
            "intensity_units": "DegreesCelsius",
            "location": "Global"
        },
        {
            "asset_type": "Gas",
            "event_type": "AirTemperature",
            "impact_mean": [
                0.0,
                0.1,
                0.25,
                0.5,
                0.8,
                1.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                10.0,
                20.0,
                30.0,
                40.0,
                50.0
            ],
            "intensity_units": "DegreesCelsius",
            "location": "Global"
        },
        {
            "asset_type": "Steam/OnceThrough",
            "event_type": "Drought",
            "impact_mean": [
                0.0,
                0.0,
                0.1,
                0.2,
                1.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                -2.0,
                -2.5,
                -3.0,
                -3.6
            ],
            "intensity_units": "Unitless",
            "location": "Global"
        },
        {
            "asset_type": "Steam/Recirculating",
            "event_type": "Drought",
            "impact_mean": [
                0.0,
                0.0,
                0.1,
                0.2,
                1.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                -2.0,
                -2.5,
                -3.0,
                -3.6
            ],
            "intensity_units": "Unitless",
            "location": "Global"
        },
        {
            "asset_type": "Steam/OnceThrough",
            "event_type": "WaterTemperature",
            "impact_mean": [
                0.0,
                0.003,
                0.009,
                0.017,
                0.027,
                0.041,
                0.061,
                0.089,
                0.118,
                0.157,
                0.205,
                0.257,
                0.327,
                0.411,
                0.508,
                0.629,
                0.775,
                1.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                1.0,
                2.0,
                3.0,
                4.0,
                5.0,
                6.0,
                7.0,
                8.0,
                9.0,
                10.0,
                11.0,
                12.0,
                13.0,
                14.0,
                15.0,
                16.0,
                17.0
            ],
            "intensity_units": "DegreesCelsius",
            "location": "Global"
        },
        {
            "asset_type": "Steam/Recirculating",
            "event_type": "WaterTemperature",
            "impact_mean": [
                0.0,
                0.003,
                0.009,
                0.017,
                0.027,
                0.041,
                0.061,
                0.089,
                0.118,
                0.157,
                0.205,
                0.257,
                0.327,
                0.411,
                0.508,
                0.629,
                0.775,
                1.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                1.0,
                2.0,
                3.0,
                4.0,
                5.0,
                6.0,
                7.0,
                8.0,
                9.0,
                10.0,
                11.0,
                12.0,
                13.0,
                14.0,
                15.0,
                16.0,
                17.0
            ],
            "intensity_units": "DegreesCelsius",
            "location": "Global"
        },
        {
            "asset_type": "Steam/OnceThrough",
            "event_type": "WaterStress",
            "impact_mean": [
                0.0,
                0.02,
                0.1,
                0.2,
                0.5,
                1.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                0.1,
                0.25,
                0.5,
                0.75,
                1.0
            ],
            "intensity_units": "Unitless",
            "location": "Global"
        },
        {
            "asset_type": "Steam/Recirculating",
            "event_type": "WaterStress",
            "impact_mean": [
                0.0,
                0.02,
                0.1,
                0.2,
                0.5,
                1.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                0.0,
                0.1,
                0.25,
                0.5,
                0.75,
                1.0
            ],
            "intensity_units": "Unitless",
            "location": "Global"
        },
        {
            "asset_type": "Steam/OnceThrough",
            "event_type": "RegulatoryDischargeWaterLimit",
            "impact_mean": [
                0.0,
                0.1,
                0.2,
                0.4,
                0.5,
                1.0
            ],
            "impact_std": [],
            "financial_impact_type": "Disruption",
            "impact_units": "Days",
            "intensity": [
                27.0,
                28.0,
                29.0,
                30.0,
                31.0,
                32.0
            ],
            "intensity_units": "DegreesCelsius",
            "location": "Global"
        }
    ]
}
');


	-- DATA IN FRENCH STARTS
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('0c438638-0ce2-4be1-b669-4d3e0d0e97e5', 'Inconnu/Aucun selection', 'Inconnu/Aucun selection', 'Inconnu/Aucun selection', 'Inconnu/Aucun selection','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'std_checksum',1,'8b3b38fd-a6f5-4878-b4b4-0a251ec0363a', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('c7450c04-42d3-41bf-a2a7-eb9af0e70873', 'Historique (avant 2014). Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'Historique (avant 2014)', 'Historique (avant 2014)', 'Historique (avant 2014)','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'std_checksum',1,'7faf5507-9a0a-4554-aef3-6efe5cffee63', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('08501b6b-92eb-407b-8b37-e6d23645a2d8', 'SSP1-1,9 — émissions de GES en baisse dès 2025, zéro émission nette de CO2 avant 2050, émissions négatives ensuite. Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'SSP1-1,9', 'SSP1-1,9', 'SSP1-1,9','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'std_checksum',1,'0ab07b1d-864d-4f0a-9656-29e9b088df3b', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('cb86a7f4-7116-497a-8f7b-14b8b5710e6a', 'SSP1-2,6 — similaire au précédent, mais le zéro émission nette de CO2 est atteint après 2050. Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'SSP1-2,6', 'SSP1-2,6', 'SSP1-2,6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'std_checksum',1,'cb68b9c6-6dff-4f0d-8650-768249f2689d', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('877f33ef-bfc9-47ff-80ed-9fe4bc20f873', 'SSP2-4,5 — maintien des émissions courantes jusqu''en 2050, division par quatre d''ici 2100. Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'SSP2-4,5', 'SSP2-4,5', 'SSP2-4,5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'std_checksum',1,'5d1081f3-fd0e-4f53-b06b-8358be82644c', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('a29cf80d-3c13-4be4-989f-afb8e0ae4a1a', 'SSP3-7,0 — doublement des émissions de GES en 2100. Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'SSP3-7,0', 'SSP3-7,0', 'SSP3-7,0','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'std_checksum',1,'f9ba343c-78b6-426c-be56-5d845e305d58', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('8568c7aa-6052-42f0-9c7d-fb2b0962571a', 'SSP5-8,5 — émissions de GES en forte augmentation, doublement en 2050. Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'SSP5-8,5', 'SSP5-8,5', 'SSP5-8,5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'std_checksum',1,'fd76becb-28e9-424b-8c6e-c96aaf6988e5', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('38fa655f-7caf-4102-968f-f4d9420e143e', 'RCP2.6 - le scénario d''émissions faibles, nous présente un futur où nous limitons les changements climatiques d''origine humaine. Le maximum des émissions de carbone est atteint rapstd_idement, suivi d''une réduction qui mène vers une valeur presque nulle bien avant la fin du siècle. Voir « Scénarios d''émissions : les RCP » (https://donneesclimatiques.ca/interactive/scenarios-demissions-les-rcp/)', 'RCP2.6', 'RCP2.6', 'RCP2.6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'std_checksum',1,'3cd34fae-620a-47ae-862c-5349533e73b8', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('6cd8cb27-7682-4340-95c3-eec02dc69d07', 'RCP4.5 - un scénario d''émissions modérées, nous présente un futur où nous incluons des mesures pour limiter les changements climatiques d''origine humaine. Ce scénario exige que les émissions mondiales de carbone soient stabilisées d''ici la fin du siècle. Voir « Scénarios d''émissions : les RCP » (https://donneesclimatiques.ca/interactive/scenarios-demissions-les-rcp/)', 'RCP4.5', 'RCP4.5', 'RCP4.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'std_checksum',1,'e64b3f6a-69a6-403f-a4bb-e099fe099222', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('980ae46b-f6e6-408c-8536-0794e1e2f7a9', 'RCP6 -  Voir « Scénarios d''émissions : les RCP » (https://donneesclimatiques.ca/interactive/scenarios-demissions-les-rcp/)', 'RCP6', 'RCP6', 'RCP6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'std_checksum',1,'bb01865e-2a53-48a3-9437-35764ba52639', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('ab959faf-edd2-4ea1-ac1e-b824c3b8f4d8', 'RCP8.5 - le scénario d''émissions élevées, nous présente un futur où peu de restrictions aux émissions ont été mises en place. Les émissions continuent d''augmenter rapstd_idement au cours de ce siècle, et se stabilisent seulement après 2250. Voir « Scénarios d''émissions : les RCP » (https://donneesclimatiques.ca/interactive/scenarios-demissions-les-rcp/)', 'RCP8.5', 'RCP8.5', 'RCP8.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'std_checksum',1,'893a6b75-8660-47ff-80d3-08b4ddc259c3', 'y','y', 1,'2024-07-15T00:00:01Z')
;
-- DATA IN FRENCH ENDS

-- DATA IN SPANISH BEGINS
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('ad206f5e-865c-4f8c-a837-3ea65a894e07', 'Desconocstd_ido/no seleccionado', 'Desconocstd_ido/no seleccionado', 'Desconocstd_ido/no seleccionado', 'Desconocstd_ido/no seleccionado','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'std_checksum',1,'8b3b38fd-a6f5-4878-b4b4-0a251ec0363a', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('9a50e648-2619-48af-94cb-e18cbe9b07bd', 'Histórico (antes 2014). Ver "El Grupo Interguberstd_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'Histórico (antes 2014)', 'Histórico (antes 2014)', 'Histórico (antes 2014)','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'std_checksum',1,'7faf5507-9a0a-4554-aef3-6efe5cffee63', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('0cd4961c-2f86-4a3c-94c9-817eb0e53028', 'SSP1-1.9 — Las trayectorias socioeconómicas compartstd_idas (SSP, por sus siglas en inglés) son escenarios de cambios socioeconómicos globales proyectados hasta 2100. Ver "El Grupo Interguberstd_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'SSP1-1,9', 'SSP1-1,9', 'SSP1-1,9','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'std_checksum',1,'0ab07b1d-864d-4f0a-9656-29e9b088df3b', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('c4176c8b-be83-4e2d-8fcb-1e5660a0224e', 'SSP1-2.6 - Las trayectorias socioeconómicas compartstd_idas (SSP, por sus siglas en inglés) son escenarios de cambios socioeconómicos globales proyectados hasta 2100. Ver "El Grupo Interguberstd_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'SSP1-2.6', 'SSP1-2.6', 'SSP1-2.6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'std_checksum',1,'cb68b9c6-6dff-4f0d-8650-768249f2689d', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name,std_tags,  std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('41ab06bc-506e-4d73-ba2d-20f2b48075e1', 'SSP2-4.5 Las trayectorias socioeconómicas compartstd_idas (SSP, por sus siglas en inglés) son escenarios de cambios socioeconómicos globales proyectados hasta 2100. Ver "El Grupo Interguberstd_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'SSP2-4.5', 'SSP2-4.5', 'SSP2-4.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'std_checksum',1,'5d1081f3-fd0e-4f53-b06b-8358be82644c', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('0190968c-5146-4bec-a3bb-c710d192517e', 'SSP3-7.0 - Las trayectorias socioeconómicas compartstd_idas (SSP, por sus siglas en inglés) son escenarios de cambios socioeconómicos globales proyectados hasta 2100. Ver "El Grupo Interguberstd_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'SSP3-7.0', 'SSP3-7.0', 'SSP3-7.0','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'std_checksum',1,'f9ba343c-78b6-426c-be56-5d845e305d58', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('f200a91a-bdbe-4983-a423-de84026b729e', 'SSP5-8.5 - Las trayectorias socioeconómicas compartstd_idas (SSP, por sus siglas en inglés) son escenarios de cambios socioeconómicos globales proyectados hasta 2100. Ver "El Grupo Interguberstd_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'SSP5-8.5', 'SSP5-8.5', 'SSP5-8.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'std_checksum',1,'fd76becb-28e9-424b-8c6e-c96aaf6988e5', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('50a460ce-3eff-404c-bd51-73e8df75c2af', 'RCP2.6 Una trayectoria de concentración representativa (RCP, por sus siglas en inglés) es una proyección teórica de una trayectoria de concentración de gases de efecto invernadero (no emisiones) adoptada por el IPCC. Ver "El Grupo Interguberstd_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'RCP2.6', 'RCP2.6', 'RCP2.6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'std_checksum',1,'3cd34fae-620a-47ae-862c-5349533e73b8', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('61421647-083e-4f1a-8aa7-60314caec48c', 'RCP4.5 - Una trayectoria de concentración representativa (RCP, por sus siglas en inglés) es una proyección teórica de una trayectoria de concentración de gases de efecto invernadero (no emisiones) adoptada por el IPCC. Ver "El Grupo Interguberstd_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'RCP4.5', 'RCP4.5', 'RCP4.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'std_checksum',1,'e64b3f6a-69a6-403f-a4bb-e099fe099222', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name,std_tags,  std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('1eb58f59-7e05-4e80-b226-2034e18fe8ac', 'RCP6 - Una trayectoria de concentración representativa (RCP, por sus siglas en inglés) es una proyección teórica de una trayectoria de concentración de gases de efecto invernadero (no emisiones) adoptada por el IPCC. Ver "El Grupo Interguberstd_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'RCP6', 'RCP6', 'RCP6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'std_checksum',1,'bb01865e-2a53-48a3-9437-35764ba52639', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(std_id, std_description_full, std_description_short, std_name_display, std_name, std_tags, std_datetime_utc_created, std_creator_user_id, std_datetime_utc_last_modified, std_last_modifier_user_id, std_is_deleted, std_deleter_user_id, std_datetime_utc_deleted, std_culture, std_checksum, std_seq_num, std_translated_from_id, std_is_active, std_is_published, std_publisher_id, std_datetime_utc_published)
VALUES 
	('5faf38ce-ad9a-4cce-a2a8-807f61b7ec5f', 'RCP8.5 - Una trayectoria de concentración representativa (RCP, por sus siglas en inglés) es una proyección teórica de una trayectoria de concentración de gases de efecto invernadero (no emisiones) adoptada por el IPCC. Ver "El Grupo Interguberstd_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'RCP8.5', 'RCP8.5', 'RCP8.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'std_checksum',1,'893a6b75-8660-47ff-80d3-08b4ddc259c3', 'y','y', 1,'2024-07-15T00:00:01Z')
;

-- DATA IN SPANISH ENDS

-- EXAMPLE QUERIES
-- VIEW SCENARIOS IN DIFFERENT LANGUAGES
SELECT * FROM osc_physrisk_scenarios.scenario WHERE std_culture='en';
SELECT * FROM osc_physrisk_scenarios.scenario WHERE std_culture='fr';
SELECT * FROM osc_physrisk_scenarios.scenario WHERE std_culture='es';

SELECT a.std_name as "English std_name",  b.std_culture as "Translated std_culture",  b.std_name as "Translated std_name", b.std_description_full as "Translated Description", b.std_tags as "Translated std_tags" FROM osc_physrisk_scenarios.scenario a 
INNER JOIN osc_physrisk_scenarios.scenario b ON a.std_id = b.std_translated_from_id
WHERE b.std_culture='es'  ;

-- QUERY BY std_tags EXAMPLE: FIND ASSETS WITH A CERTAIN NAICS OR OED OCCUPANCY VALUE (SHOWS HOW TO SUPPORT MULTIPLE STANDARDS)
SELECT a.std_name,  a.std_description_full, a.std_tags, b.std_name as asset_class FROM osc_physrisk_assets.asset_powergeneratingutility a INNER JOIN osc_physrisk_assets.asset_class b ON a.std_id = b.std_id
--WHERE a.std_tags -> 'naics'='22111' OR a.std_tags -> 'oed:occupancy:oed_code'='1300' OR a.std_tags -> 'oed:occupancy:air_code'='361' 
;

SELECT a.std_name,  a.std_description_full, a.std_tags, b.std_name as asset_class FROM osc_physrisk_assets.asset_powergeneratingutility a INNER JOIN osc_physrisk_assets.asset_class b ON a.std_id = b.std_id
WHERE a.std_tags -> 'naics' =  '53'
 ;

-- QUERY BY std_tags EXAMPLE: FIND SCENARIOS WITH CERTAIN std_tags
SELECT a.std_name,  a.std_description_full, a.std_tags FROM osc_physrisk_scenarios.scenario a
WHERE a.std_tags -> 'key1'='"value1"' OR a.std_tags -> 'key2'='"value4"'  
;

-- SHOW IMPACT ANALYSIS EXAMPLE (CURRENTLY EMPTY - TODO MISSING TEST DATA)
SELECT	* FROM	osc_physrisk_financial_analysis.portfolio_financial_impact;
SELECT * FROM osc_physrisk_financial_analysis.asset_financial_impact;

-- VIEW RIVERINE INUNDATION HAZARD INDICATORS
SELECT	*
FROM
	osc_physrisk_scenarios.hazard haz INNER JOIN osc_physrisk_scenarios.hazard_indicator hi ON hi.hazard_id = haz.std_id
WHERE haz.std_name = 'Riverine Inundation' -- more likely written as WHERE haz.std_id = '63ed7943-c4c4-43ea-abd2-86bb1997a094'
;

-- VIEW COASTAL INUNDATION HAZARD INDICATORS
SELECT	*
FROM
	 osc_physrisk_scenarios.hazard haz INNER JOIN osc_physrisk_scenarios.hazard_indicator hi ON hi.hazard_id = haz.std_id
WHERE haz.std_id = '28a095cd-4cde-40a1-90d9-cbb0ca673c06'
;

-- VIEW CHRONIC HEAT HAZARD INDICATORS
SELECT	*
FROM
	 osc_physrisk_scenarios.hazard haz INNER JOIN osc_physrisk_scenarios.hazard_indicator hi ON hi.hazard_id = haz.std_id
WHERE haz.std_id = 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b'
;

-- SAMPLE std_checksum UPDATE
--UPDATE osc_physrisk_scenarios.scenario
--	SET std_checksum = md5(concat('Unknown/Not Selected', 'Unknown/Not Selected', 'Unknown/Not Selected', 'Unknown/Not Selected')) WHERE scenario_std_id = -1
--;

-- SELECT DIFFERENT ASSET TYPES
SELECT b.std_name as "Asset Class", a.std_name as "Asset Type", a.std_description_full as "Asset Type Description", b.std_tags as "Asset Class Tags", a.std_tags as "Asset Type Tags" FROM osc_physrisk_assets.asset_type a INNER JOIN osc_physrisk_assets.asset_class b ON a.asset_class_id = b.std_id
WHERE b.std_tags -> 'naics' @>  '45'
--WHERE b.std_tags ->> 'oed:occupancy:oed_code' = '1100'
ORDER BY b.std_name ASC
;

SELECT * from osc_physrisk_assets.generic_asset; -- NOTICE THESE ARE THE GENERIC ASSET COLUMNS AND ALL ASSETS ARE RETURNED
SELECT std_name, value_loan, value_ltv from osc_physrisk_assets.asset_realestate; -- NOTICE THE COLUMNS INCLUDE RE-SPECIFIC FIELDS AND ONLY RE ASSETS ARE RETURNED
SELECT std_name, production, capacity, availability_rate from osc_physrisk_assets.asset_powergeneratingutility; -- NOTICE THE COLUMNS INCLUDE UTILITY-SPECIFIC FIELDS AND ONLY UTILITY ASSETS ARE RETURNED

-- WE CAN ALSO DO A JOIN BY ASSET CLASS TO FILTER THE RESULTS
SELECT * from osc_physrisk_assets.generic_asset a INNER JOIN osc_physrisk_assets.asset_class b ON a.std_id = b.std_id
WHERE b.std_name LIKE '%Utility%'
; -- NOTICE ONLY UTILITY ROW IS RETURNED

-- QUERY PRECALCULATED DAMAGE CURVES AT A CERTAIN LOCATION
SELECT
	std_geo_h3_index, std_geo_h3_resolution, ST_X(std_geo_location_coordinates::geometry) as Long, ST_Y(std_geo_location_coordinates::geometry) as Lat, std_geo_overture_features, vulnerability_level, vulnerability_historically, vulnerability_data_raw
FROM
	osc_physrisk_vulnerability_analysis.geolocated_precalculated_vulnerability
WHERE std_geo_h3_index = '1234'
	;
