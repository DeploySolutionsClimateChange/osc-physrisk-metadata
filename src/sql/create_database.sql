-- PHYRISK EXAMPLE DATABASE STRUCTURE
-- Intended to help standardize glossary/metadata as well as field core_names and constraints
-- to align with phys-risk/geo-indexer/other related initiatives and 
-- speed up application development, help internationalize and display the results of analyses, and more.
-- The backend schema User and Tenant tables are derived from ASP.NET Boilerplate tables (https://aspnetboilerplate.com/). That code is available under the MIT license, here: https://github.com/aspnetboilerplate/aspnetboilerplate

-- Last Updated: 2024-09-19. 

-- SETUP EXTENSIONS
CREATE EXTENSION IF NOT EXISTS postgis; -- used for geolocation
CREATE EXTENSION IF NOT EXISTS h3; -- used for Uber H3 geolocation
CREATE EXTENSION IF NOT EXISTS pgcrypto; -- used for random UUID generation

-- SETUP SCHEMAS
CREATE SCHEMA IF NOT EXISTS osc_physrisk_backend;
CREATE SCHEMA IF NOT EXISTS osc_physrisk_scenarios;
CREATE SCHEMA IF NOT EXISTS osc_physrisk_assets;
CREATE SCHEMA IF NOT EXISTS osc_physrisk_vulnerability_analysis;
CREATE SCHEMA IF NOT EXISTS osc_physrisk_financial_analysis;

-- SETUP TABLES
-- SCHEMA osc_physrisk_backend

CREATE TABLE osc_physrisk_backend.user (
	core_id bigint NOT NULL,
	core_datetime_utc_created       timestamptz  NOT NULL  ,
	core_creator_user_id      bigint    ,
	core_datetime_utc_last_modified timestamptz    ,
	core_last_modifier_user_id bigint    ,
	core_is_deleted          boolean  NOT NULL  ,
	core_deleter_user_id      bigint    ,
	core_datetime_utc_deleted       timestamptz    ,
	core_user_name VARCHAR(255) NOT NULL,
	core_tenant_id INTEGER NOT NULL,
	email_address VARCHAR(255) NOT NULL,
	core_name        VARCHAR(255)  NOT NULL  ,
	core_surname        VARCHAR(255)  NOT NULL  ,
	core_is_active       boolean  NOT NULL  ,
	PRIMARY KEY (core_id)
);

ALTER TABLE osc_physrisk_backend.user
	ADD FOREIGN KEY (core_creator_user_id) 
	REFERENCES osc_physrisk_backend.user (core_id);

ALTER TABLE osc_physrisk_backend.user
	ADD FOREIGN KEY (core_deleter_user_id) 
	REFERENCES osc_physrisk_backend.user (core_id);

ALTER TABLE osc_physrisk_backend.user
	ADD FOREIGN KEY (core_last_modifier_user_id) 
	REFERENCES osc_physrisk_backend.user (core_id);

CREATE INDEX "ix_osc_physrisk_backend_users_core_creator_user_id" ON osc_physrisk_backend.user USING btree (core_creator_user_id);
CREATE INDEX "ix_osc_physrisk_backend_users_core_deleter_user_id" ON osc_physrisk_backend.user USING btree (core_deleter_user_id);
CREATE INDEX "ix_osc_physrisk_backend_users_core_last_modifier_user_id" ON osc_physrisk_backend.user USING btree (core_last_modifier_user_id);
CREATE INDEX "ix_osc_physrisk_backend_users_email_address" ON osc_physrisk_backend.user USING btree (core_tenant_id, email_address);
CREATE INDEX "ix_osc_physrisk_backend_users_core_tenant_id_core_user_name" ON osc_physrisk_backend.user USING btree (core_tenant_id, core_user_name);

COMMENT ON TABLE osc_physrisk_backend.user IS 'Stores user information.';

CREATE TABLE osc_physrisk_backend.tenant (
	core_id bigint NOT NULL,
	core_datetime_utc_created       timestamptz  NOT NULL  ,
	core_creator_user_id      bigint    ,
	core_datetime_utc_last_modified timestamptz    ,
	core_last_modifier_user_id bigint    ,
	core_is_deleted          boolean  NOT NULL  ,
	core_deleter_user_id      bigint    ,
	core_datetime_utc_deleted       timestamptz    ,
	core_name varchar(64) NOT NULL,
	core_tenancy_name VARCHAR(255) NOT NULL,
	core_is_active       boolean  NOT NULL  ,
	PRIMARY KEY (core_id),
	CONSTRAINT fk_tenants_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_tenants_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_tenants_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)
);

CREATE INDEX "ix_osc_physrisk_backend_tenants_core_datetime_utc_created" ON osc_physrisk_backend.tenant USING btree (core_datetime_utc_created);
CREATE INDEX "ix_osc_physrisk_backend_tnants_core_creator_user_id" ON osc_physrisk_backend.tenant USING btree (core_creator_user_id);
CREATE INDEX "ix_osc_physrisk_backend_tenants_core_deleter_user_id" ON osc_physrisk_backend.tenant USING btree (core_deleter_user_id);
CREATE INDEX "ix_osc_physrisk_backend_tenants_core_last_modifier_user_id" ON osc_physrisk_backend.tenant USING btree (core_last_modifier_user_id);
CREATE INDEX "ix_osc_physrisk_backend_tenants_core_tenancy_name" ON osc_physrisk_backend.tenant USING btree (core_tenancy_name);

COMMENT ON TABLE osc_physrisk_backend.tenant IS 'Stores tenant information to support multi-tenancy data (where appropriate). A default tenant is always provcore_ided.';

CREATE TABLE osc_physrisk_backend.dataset ( 
	core_id UUID  DEFAULT gen_random_UUID ()  NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	data_contact TEXT NOT NULL, -- Contact information for inquiries about the dataset.
	data_quality TEXT NOT NULL, -- Information on the accuracy, completeness, and source of the data.
	data_format TEXT NOT NULL, -- Formats in which the data is available.
	data_schema TEXT NOT NULL, -- Describe the data schema, or reference the Json Schema or Frictionless CSV schema. Can be a hyperlink to a relevant schema file.
	data_access_rights TEXT NOT NULL, -- Information on who can access the dataset.
	data_license TEXT NOT NULL, -- The licensing terms under which the dataset is released. License(s) of the data as SPDX License identifier, SPDX License expression, or other. Link to the license text. 
	data_usage_notes TEXT NOT NULL, -- Notes on how the dataset can be used.
	data_related TEXT NOT NULL, -- Links to related datasets for further information or analysis. Could be a list of UUIDs or a textual description, or hyperlinks
	CONSTRAINT pk_scenario PRIMARY KEY ( core_id ),
	CONSTRAINT fk_scenario_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_scenario_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_scenario_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)
 ); 

 COMMENT ON TABLE osc_physrisk_backend.dataset IS 'Contains a list of the data sets that are in use in this database, facilitating rigourous data hygeine, governance, and reporting tasks.';


CREATE TABLE osc_physrisk_backend.geo_country ( 
	core_id UUID  DEFAULT gen_random_UUID ()  NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	un_global_code NUMERIC NOT NULL, -- Numeric but zero padded
	un_global_name VARCHAR(255) NOT NULL,
	un_region_code NUMERIC NOT NULL, -- Numeric but zero padded
	un_region_name VARCHAR(255) NOT NULL,
	un_subregion_code NUMERIC NOT NULL, -- Numeric but zero padded
	un_subregion_name VARCHAR(255) NOT NULL,
	un_intermediateregion_code NUMERIC, -- Numeric but zero padded
	un_intermediateregion_name VARCHAR(255),
	un_code_m49 NUMERIC NOT NULL, -- Numeric but zero padded
	un_is_ldc BOOLEAN, -- True if listed on UN Least Developed Countries (LDC)
	un_is_lldc BOOLEAN, -- True if listed on Land Locked Developing Countries (LLDC)
	un_is_sids BOOLEAN, -- True if listed on Small Island Developing States (SIDS)
	iso_code_alpha2 CHAR(2) NOT NULL, -- Alpha-2
	iso_code_alpha3 CHAR(3) NOT NULL, -- Alpha-3
	CONSTRAINT pk_geo_country PRIMARY KEY ( core_id ),
	CONSTRAINT fk_geo_country_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_geo_country_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_geo_country_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
 	CONSTRAINT fk_geo_country_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id)
	); 

 COMMENT ON TABLE osc_physrisk_backend.geo_country IS 'Contains a list of country ISO codes as described in ISO 3166 standard.';

-- SCHEMA osc_physrisk_scenarios
CREATE TABLE osc_physrisk_scenarios.scenario ( 
	core_id UUID  DEFAULT gen_random_UUID ()  NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	CONSTRAINT pk_scenario PRIMARY KEY ( core_id ),
	CONSTRAINT fk_scenario_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_scenario_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_scenario_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_scenario_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)
 ); 

 COMMENT ON TABLE osc_physrisk_scenarios.scenario IS 'Contains a list of the United Nations Intergovernmental Panel on Climate Change (IPCC)-defined climate scenarios (SSPs and RCPs).';

CREATE TABLE osc_physrisk_scenarios.hazard ( 
	core_id	UUID  DEFAULT gen_random_UUID ()  NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	-- is_chronic BOOLEAN NOT NULL,
	-- is_acute BOOLEAN NOT NULL,
	oed_peril_code integer,
	oed_input_abbreviation      varchar(5) ,
	oed_grouped_peril_code boolean,
	CONSTRAINT pk_hazard PRIMARY KEY ( core_id ),	
	CONSTRAINT fk_hazard_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_hazard_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_hazard_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_hazard_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)
 );
COMMENT ON TABLE osc_physrisk_scenarios.hazard IS 'Contains a list of the physical hazards supported by OS-Climate.';

CREATE TABLE osc_physrisk_scenarios.hazard_indicator ( 
	core_id	UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	hazard_id	UUID  NOT NULL,
	CONSTRAINT pk_hazard_indicator PRIMARY KEY ( core_id ),
	CONSTRAINT fk_hazard_indicator_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_hazard_indicator_hazard_id FOREIGN KEY ( hazard_id ) REFERENCES osc_physrisk_scenarios.hazard(core_id),
	CONSTRAINT fk_hazard_indicator_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_hazard_indicator_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_hazard_indicator_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)	
 );
COMMENT ON TABLE osc_physrisk_scenarios.hazard_indicator IS 'Contains a list of the physical hazard indicators that are supported by OS-Climate. An indicator must always relate to one particular hazard.';


-- SCHEMA osc_physrisk_assets
CREATE TABLE osc_physrisk_assets.asset_class ( 
	core_id UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	CONSTRAINT pk_asset_class PRIMARY KEY (core_id ),
	CONSTRAINT fk_asset_class_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_asset_class_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_class_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_class_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)	
 );
COMMENT ON TABLE osc_physrisk_assets.asset_class IS 'A physical financial asset (infrastructure, utilities, property, buildings) category, that may impact the modeling (ex real estate vs power generating utilities).';


CREATE TABLE osc_physrisk_assets.asset_type ( 
	core_id UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	asset_class_id UUID,
	CONSTRAINT pk_asset_type PRIMARY KEY (core_id ),
	CONSTRAINT fk_asset_type_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_asset_type_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_type_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_type_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id),	
    CONSTRAINT fk_asset_type_asset_class_id FOREIGN KEY ( asset_class_id ) REFERENCES osc_physrisk_assets.asset_class(core_id)
 );
COMMENT ON TABLE osc_physrisk_assets.asset_type IS 'A physical financial asset (infrastructure, utilities, property, buildings) specific classification within an overarching asset class, that may impact the modeling (ex commercial real estate vs residential real, both of which types belong to the same real estate class).';


CREATE TABLE osc_physrisk_assets.portfolio ( 
	core_id UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_tenant_id BIGINT NOT NULL DEFAULT 1,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
    value_total numeric,
    value_currency_alphabetic_code char(3),
	CONSTRAINT pk_portfolio PRIMARY KEY (core_id ),
	CONSTRAINT fk_portfolio_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_portfolio_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_portfolio_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_portfolio_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_portfolio_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id)
 );
COMMENT ON TABLE osc_physrisk_assets.portfolio IS 'A financial portfolio that contains 1 or more physical financial assets (infrastructure, utilities, property, buildings).';

CREATE TABLE osc_physrisk_assets.generic_asset ( 
	core_id UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_tenant_id BIGINT NOT NULL DEFAULT 1,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	core_geo_country_id UUID,
    core_geo_location_name      	VARCHAR(255),
    core_geo_location_address      	text,
    core_geo_location_coordinates      	GEOGRAPHY  NOT NULL  ,
	core_geo_altitude numeric DEFAULT NULL, 
	core_geo_altitude_confidence numeric DEFAULT NULL,
	core_geo_overture_features			jsonb[], -- This asset can be described in 0 or more Overture Map schemas to cover its land use, infrastructure, building extents, etc
	core_geo_h3_index H3INDEX NOT NULL,
    core_geo_h3_resolution INT2 NOT NULL,
	asset_type_id UUID,
    portfolio_id UUID NOT NULL,
	owner_bloomberg_id	varchar(12) DEFAULT NULL,
	owner_lei_id varchar(20) DEFAULT NULL,
	value_total numeric,
    value_dynamics jsonb, -- Asset Value Dynamics over time, example real estate appreciation
	value_currency_alphabetic_code char(3),
	CONSTRAINT pk_generic_asset PRIMARY KEY ( core_id ),
	CONSTRAINT fk_generic_asset_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_generic_asset_portfolio_id FOREIGN KEY ( portfolio_id ) REFERENCES osc_physrisk_assets.portfolio(core_id),
	CONSTRAINT fk_generic_asset_geo_country_id FOREIGN KEY ( core_geo_country_id ) REFERENCES osc_physrisk_backend.geo_country(core_id),
	CONSTRAINT ck_generic_asset_geo_h3_resolution CHECK (core_geo_h3_resolution >= 0 AND core_geo_h3_resolution <= 15),
	CONSTRAINT fk_generic_asset_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_generic_asset_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_generic_asset_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_generic_asset_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id),
    CONSTRAINT fk_generic_asset_asset_type_id FOREIGN KEY ( asset_type_id ) REFERENCES osc_physrisk_assets.asset_type(core_id)
 );
COMMENT ON TABLE osc_physrisk_assets.generic_asset IS 'A physical financial asset (infrastructure, utilities, property, buildings) that is contained within a financial portfolio and not further classified by its Asset Type (otherwise use a more specific, relevant table). The lowest unit of assessment for physical risk & resilience (currently).';

CREATE INDEX "ix_osc_physrisk_assets_asset_portfolio_id" ON osc_physrisk_assets.generic_asset USING btree (portfolio_id);

CREATE TABLE osc_physrisk_assets.asset_realestate ( 
	value_cashflows numeric ARRAY,-- Sequence of the associated cash flows (for cash flow generating assets only).
    value_loan text ARRAY, -- Sequence of Loans by date, representing the mortgage lines
	value_ltv text ARRAY, -- Sequence of Loan-to-Value results by date, representing the ratio of the first mortgage line as a percentage of the total appraised value of real property.
	CONSTRAINT pk_asset_realestate PRIMARY KEY ( core_id ),
	CONSTRAINT fk_asset_realestate_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_asset_realestate_portfolio_id FOREIGN KEY ( portfolio_id ) REFERENCES osc_physrisk_assets.portfolio(core_id),
    CONSTRAINT ck_asset_realestate_h3_resolution CHECK (core_geo_h3_resolution >= 0 AND core_geo_h3_resolution <= 15),
	CONSTRAINT fk_asset_realestate_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_realestate_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_realestate_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_realestate_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id),	
    CONSTRAINT fk_asset_realestate_asset_type_id FOREIGN KEY ( asset_type_id ) REFERENCES osc_physrisk_assets.asset_type(core_id)
 ) INHERITS (osc_physrisk_assets.generic_asset);
COMMENT ON TABLE osc_physrisk_assets.asset_realestate IS 'A physical financial asset (infrastructure, utilities, property, buildings) that is of the Real Estate asset type and contained within a financial portfolio. The lowest unit of assessment for physical risk & resilience (currently).';

CREATE TABLE osc_physrisk_assets.asset_powergeneratingutility ( 
	production numeric NOT NULL, -- Real annual production of a power plant in Wh.
	capacity numeric NOT NULL, -- Capacity of the power plant in W.
	availability_rate numeric NOT NULL, -- Availability factor of production.
	CONSTRAINT pk_asset_powergeneratingutility PRIMARY KEY ( core_id ),
	CONSTRAINT fk_asset_powergeneratingutility_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_asset_powergeneratingutility_portfolio_id FOREIGN KEY ( portfolio_id ) REFERENCES osc_physrisk_assets.portfolio(core_id),
    CONSTRAINT ck_asset_powergeneratingutility_h3_resolution CHECK (core_geo_h3_resolution >= 0 AND core_geo_h3_resolution <= 15),
	CONSTRAINT fk_asset_powergeneratingutility_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_powergeneratingutility_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_powergeneratingutilitycore_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_powergeneratingutility_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id),	
    CONSTRAINT fk_asset_powergeneratingutility_asset_type_id FOREIGN KEY ( asset_type_id ) REFERENCES osc_physrisk_assets.asset_type(core_id)
 ) INHERITS (osc_physrisk_assets.generic_asset);
COMMENT ON TABLE osc_physrisk_assets.asset_powergeneratingutility IS 'A physical financial asset (infrastructure, utilities, property, buildings) that is of the Power Generating Utility asset type and contained within a financial portfolio. The lowest unit of assessment for physical risk & resilience (currently).';

-- SCHEMA osc_physrisk_vulnerability_analysis
CREATE TABLE osc_physrisk_vulnerability_analysis.exposure_function ( 
	core_id	UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_tenant_id BIGINT NOT NULL DEFAULT 1,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	CONSTRAINT pk_exposure_function PRIMARY KEY ( core_id ),
	CONSTRAINT fk_exposure_function_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_exposure_function_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_exposure_function_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_exposure_function_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_exposure_function_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id)
 );
 COMMENT ON TABLE osc_physrisk_vulnerability_analysis.exposure_function IS 'The model used to determine whether a particular asset is exposed to a particular hazard indicator.';

CREATE TABLE osc_physrisk_vulnerability_analysis.vulnerability_function ( 
	core_id	UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_tenant_id BIGINT NOT NULL DEFAULT 1,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	CONSTRAINT pk_vulnerability_function PRIMARY KEY ( core_id ),
	CONSTRAINT fk_vulnerability_function_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_vulnerability_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_vulnerability_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_vulnerability_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_vulnerability_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id)
 );
COMMENT ON TABLE osc_physrisk_vulnerability_analysis.vulnerability_function IS 'The model used to determine the degree by which a particular asset is vulnerable to a particular hazard indicator. If an asset is vulnerable to a peril, it must necessarily be exposed to it (see exposure_function).';

CREATE TABLE osc_physrisk_vulnerability_analysis.vulnerability_type ( 
	core_id INTEGER NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
    accounting_category VARCHAR(255),
	CONSTRAINT pk_vulnerability_type PRIMARY KEY ( core_id ),
	CONSTRAINT fk_vulnerability_type_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_vulnerability_type_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_vulnerability_type_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_vulnerability_type_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)
 ); 
COMMENT ON TABLE osc_physrisk_vulnerability_analysis.vulnerability_type IS 'A lookup table to classify and constrain types of damage/disruption that could occur to an asset due to its vulnerability to a hazard.';


CREATE TABLE osc_physrisk_vulnerability_analysis.hazard_data_request ( 
	core_id	UUID  DEFAULT gen_random_UUID ()  NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
    core_geo_location_coordinates      	GEOGRAPHY  NOT NULL  ,
	scenario_id UUID NOT NULL,
    scenario_year smallint,
	hazard_id	UUID NOT NULL,
	hazard_indicator_id UUID NOT NULL,
	CONSTRAINT pk_hazard_data_request PRIMARY KEY ( core_id ),	
	CONSTRAINT fk_hazard_data_request_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_hazard_data_request_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_hazard_data_request_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_hazard_data_request_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
 	CONSTRAINT fk_hazard_data_request_scenario_id FOREIGN KEY ( scenario_id ) REFERENCES osc_physrisk_scenarios.scenario(core_id),
	CONSTRAINT fk_hazard_data_request_hazard_id FOREIGN KEY ( hazard_id ) REFERENCES osc_physrisk_scenarios.hazard(core_id),
 	CONSTRAINT fk_hazard_data_request_hazard_indicator_id FOREIGN KEY ( hazard_indicator_id ) REFERENCES osc_physrisk_scenarios.hazard_indicator(core_id)
	
 );
COMMENT ON TABLE osc_physrisk_vulnerability_analysis.hazard_data_request IS 'Contains a request to evaluate the physical hazard of a particular location.';


CREATE TABLE osc_physrisk_vulnerability_analysis.portfolio_vulnerability ( 
	core_id UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_tenant_id BIGINT NOT NULL DEFAULT 1,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 1,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	portfolio_id            UUID  NOT NULL  ,
	scenario_id UUID NOT NULL,
    scenario_year smallint,
	CONSTRAINT pk_portfolio_vulnerability PRIMARY KEY ( core_id ),
	CONSTRAINT fk_portfolio_vulnerability_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_portfolio_vulnerability_core_id FOREIGN KEY ( portfolio_id ) REFERENCES osc_physrisk_assets.portfolio(core_id),
	CONSTRAINT fk_portfolio_vulnerability_scenario_id FOREIGN KEY ( scenario_id ) REFERENCES osc_physrisk_scenarios.scenario(core_id),
	CONSTRAINT fk_portfolio_vulnerability_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_portfolio_vulnerability_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_portfolio_vulnerability_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)  ,
	CONSTRAINT fk_portfolio_vulnerability_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id)
 );
COMMENT ON TABLE osc_physrisk_vulnerability_analysis.portfolio_vulnerability IS 'The result of a physical risk & resilience vulnerability analysis. The result is determined by the chosen scenario, year, and hazard, aggregating the results for all of the assets in a given portfolio. If multiple scenarios/years/hazards were chosen, there will be multiple other rows containing the combined set of results. For financial impact, see portfolio_financial_impact table.';

CREATE TABLE osc_physrisk_vulnerability_analysis.asset_vulnerability ( 
	core_id UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_tenant_id BIGINT NOT NULL DEFAULT 1,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 1,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	core_geo_country_id UUID,
	core_geo_location_name      	VARCHAR(255),
    core_geo_location_address      	text ,
    core_geo_location_coordinates      	GEOGRAPHY  NOT NULL  ,
	core_geo_altitude numeric DEFAULT NULL, 
	core_geo_altitude_confidence numeric DEFAULT NULL,
	core_geo_overture_features			jsonb[], -- This location can be described in 0 or more Overture Map schemas to cover its land use, infrastructure, building extents, etc
	core_geo_h3_index H3INDEX NOT NULL,
    core_geo_h3_resolution INT2 NOT NULL,
	core_datetime_utc_start timestamptz,
	core_datetime_utc_end timestamptz,	
	asset_id            UUID  NOT NULL  ,
	hazard_indicator_id UUID NOT NULL,
    hazard_intensity numeric[], -- Assume this includes intensity units
	scenario_id UUID NOT NULL,
    scenario_year smallint,
    vulnerability_type_id integer NOT NULL,
	exposure_function_id text NOT NULL,
	exposure_data_raw jsonb NOT NULL, -- STORE RAW JSON, MAYBE OVERLAP WITH SOME COLUMNS BELOW?
	exposure_probability numeric,
	exposure_level numeric, -- 0.0 = not exposed at all 1.0 = fully exposed across whole area. In  between = some level of exposure, finer geographic granularity is required	
	vulnerability_function_id UUID NOT NULL,	
	vulnerability_historically boolean,
	vulnerability_data_raw jsonb NOT NULL, -- we recommend that this json includes schema references so a consuming application can use json schema for parsing.	
    vulnerability_level numeric NOT NULL, -- 0.0 = not vulnerable at all 1.0 = highly vulnerable across whole area. In  between = some level of vulnerability, finer geographic granularity is required	
	vulnerability_mean    numeric[],
	vulnerability_std    numeric[],
	vulnerability_distribution_bin_edges    numeric[],
    vulnerability_distribution_probabilities    numeric[],
	vulnerability_exceedance_probabilities    numeric[], -- X axis info, redundant but useful
	vulnerability_return_periods jsonb, -- useful?	
    --parameter    numeric,
    CONSTRAINT pk_asset_vulnerability PRIMARY KEY ( core_id ),
	CONSTRAINT fk_asset_vulnerability_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
    CONSTRAINT fk_asset_vulnerability_geo_country_id FOREIGN KEY ( core_geo_country_id ) REFERENCES osc_physrisk_backend.geo_country(core_id),
	CONSTRAINT ck_asset_vulnerability_geo_h3_resolution CHECK (core_geo_h3_resolution >= 0 AND core_geo_h3_resolution <= 15),
	CONSTRAINT fk_asset_vulnerability_asset_id FOREIGN KEY ( asset_id ) REFERENCES osc_physrisk_assets.generic_asset(core_id),
	CONSTRAINT fk_asset_vulnerability_scenario_id FOREIGN KEY ( scenario_id ) REFERENCES osc_physrisk_scenarios.scenario(core_id),
	CONSTRAINT fk_asset_vulnerability_vulnerability_type_id FOREIGN KEY ( vulnerability_type_id ) REFERENCES osc_physrisk_vulnerability_analysis.vulnerability_type(core_id),
	CONSTRAINT fk_asset_vulnerability_hazard_indicator_id FOREIGN KEY ( hazard_indicator_id ) REFERENCES osc_physrisk_scenarios.hazard_indicator(core_id)    ,
	CONSTRAINT fk_asset_vulnerability_core_vulnerability_function_id FOREIGN KEY ( vulnerability_function_id ) REFERENCES osc_physrisk_vulnerability_analysis.vulnerability_function(core_id),	
	CONSTRAINT fk_asset_vulnerability_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_vulnerability_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_vulnerability_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)   ,
	CONSTRAINT fk_asset_vulnerability_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id)
 );
COMMENT ON TABLE osc_physrisk_vulnerability_analysis.asset_vulnerability IS 'The result of a physical risk & resilience analysis for a particular asset. The result is determined by the chosen scenario, year, and hazard. If multiple scenarios/years/hazards were chosen, there will be multiple other rows containing the combined set of results.';

CREATE TABLE osc_physrisk_vulnerability_analysis.geolocated_precalculated_vulnerability ( 
	core_id	UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_tenant_id BIGINT NOT NULL DEFAULT 1,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	core_geo_country_id UUID,
	core_geo_location_name      	VARCHAR(255),
    core_geo_location_address      	text ,
    core_geo_location_coordinates      	GEOGRAPHY  NOT NULL  ,
	core_geo_altitude numeric DEFAULT NULL, 
	core_geo_altitude_confidence numeric DEFAULT NULL,
	core_geo_overture_features			jsonb[], -- This location can be described in 0 or more Overture Map schemas to cover its land use, infrastructure, building extents, etc
	core_geo_h3_index H3INDEX NOT NULL,
    core_geo_h3_resolution INT2 NOT NULL,
    hazard_indicator_id UUID NOT NULL,
    hazard_intensity numeric[], -- Assume this includes intensity units
	scenario_id UUID NOT NULL,
    scenario_year smallint,
    vulnerability_type_id integer NOT NULL,
	exposure_function_id text NOT NULL,
	exposure_data_raw jsonb NOT NULL, -- STORE RAW JSON, MAYBE OVERLAP WITH SOME COLUMNS BELOW?
	exposure_probability numeric,
	exposure_level numeric, -- 0.0 = not exposed at all 1.0 = fully exposed across whole area. In  between = some level of exposure, finer geographic granularity is required	
	vulnerability_function_id UUID NOT NULL,
	vulnerability_data_raw jsonb NOT NULL, -- we recommend that this json includes schema references so a consuming application can use json schema for parsing.	
    vulnerability_level numeric NOT NULL, -- 0.0 = not vulnerable at all 1.0 = highly vulnerable across whole area. In  between = some level of vulnerability, finer geographic granularity is required	
	vulnerability_mean    numeric[],
	vulnerability_std    numeric[],
	vulnerability_distribution_bin_edges    numeric[],
    vulnerability_distribution_probabilities    numeric[],
	vulnerability_exceedance_probabilities    numeric[], -- X axis info, redundant but useful
	vulnerability_return_periods jsonb, -- useful?	
	vulnerability_historically boolean,
	core_datetime_utc_start timestamptz,
	core_datetime_utc_end timestamptz,
	CONSTRAINT pk_geolocated_precalculated_vulnerability_core_id PRIMARY KEY ( core_id ),
	CONSTRAINT fk_geolocated_precalculated_vulnerability_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_geolocated_precalculated_vulnerability_scenario_id FOREIGN KEY ( scenario_id ) REFERENCES osc_physrisk_scenarios.scenario(core_id),
	CONSTRAINT fk_geolocated_precalculated_vulnerability_vulnerability_type_id FOREIGN KEY ( vulnerability_type_id ) REFERENCES osc_physrisk_vulnerability_analysis.vulnerability_type(core_id),
	CONSTRAINT fk_geolocated_precalculated_vulnerability_hazard_indicator_id FOREIGN KEY ( hazard_indicator_id ) REFERENCES osc_physrisk_scenarios.hazard_indicator(core_id)    ,
	CONSTRAINT fk_geolocated_precalculated_vulnerability_core_vulnerability_function_id FOREIGN KEY ( vulnerability_function_id ) REFERENCES osc_physrisk_vulnerability_analysis.vulnerability_function(core_id),	
	CONSTRAINT fk_geolocated_precalculated_vulnerability_geo_country_id FOREIGN KEY ( core_geo_country_id ) REFERENCES osc_physrisk_backend.geo_country(core_id),
	CONSTRAINT ck_geolocated_precalculated_vulnerability_geo_h3_resolution CHECK (core_geo_h3_resolution >= 0 AND core_geo_h3_resolution <= 15),
	CONSTRAINT fk_geolocated_precalculated_vulnerability_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_geolocated_precalculated_vulnerability_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_geolocated_precalculated_vulnerability_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id) ,
	CONSTRAINT fk_geolocated_precalculated_vulnerability_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id)
 );
COMMENT ON TABLE osc_physrisk_vulnerability_analysis.geolocated_precalculated_vulnerability IS 'To help with indexing and searching, geographic locations may have precalculated information for hazard impacts. This can be historic (it actually happened) or projected (it is likely to happen). Note that this information is not aware of or concerned by whether or which physical assets may be present inscore_ide its borders.';


-- SCHEMA osc_physrisk_financial_analysis;
CREATE TABLE osc_physrisk_financial_analysis.financial_function ( 
	core_id	UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_tenant_id BIGINT NOT NULL DEFAULT 1,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	CONSTRAINT pk_financial_function PRIMARY KEY ( core_id ),
	CONSTRAINT fk_financial_function_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_financial_function_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_financial_function_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_financial_function_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_financial_function_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id)
 );
COMMENT ON TABLE osc_physrisk_financial_analysis.financial_function IS 'Related to osc_physrisk_financial_analysis';

CREATE TABLE osc_physrisk_financial_analysis.financial_impact_type ( 
	core_id INTEGER NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
    accounting_category VARCHAR(255),
	CONSTRAINT pk_financial_impact_type PRIMARY KEY ( core_id ),
	CONSTRAINT fk_financial_impact_type_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_financial_impact_type_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_financial_impact_type_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_financial_impact_type_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)
 ); 
COMMENT ON TABLE osc_physrisk_financial_analysis.financial_impact_type IS 'A lookup table to classify and constrain types of damage/disruption that could occur to an asset due to its vulnerability to a hazard.';

CREATE TABLE osc_physrisk_financial_analysis.portfolio_financial_impact ( 
	core_id UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_tenant_id BIGINT NOT NULL DEFAULT 1,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	portfolio_id            UUID  NOT NULL  ,
	scenario_id UUID NOT NULL,
    scenario_year smallint,
	hazard_id	UUID NOT NULL,
	annual_exceedence_probability numeric,
	average_annual_loss numeric,
    value_total numeric,
    value_at_risk numeric,
    value_currency_alphabetic_code char(3),
	CONSTRAINT pk_portfolio_financial_impact PRIMARY KEY ( core_id ),
	CONSTRAINT fk_portfolio_financial_impact_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
	CONSTRAINT fk_portfolio_financial_impact_analysis_core_id FOREIGN KEY ( portfolio_id ) REFERENCES osc_physrisk_assets.portfolio(core_id),
	CONSTRAINT fk_portfolio_financial_impact_analysis_scenario_id FOREIGN KEY ( scenario_id ) REFERENCES osc_physrisk_scenarios.scenario(core_id),
	CONSTRAINT fk_portfolio_financial_impact_analysis_hazard_id FOREIGN KEY ( hazard_id ) REFERENCES osc_physrisk_scenarios.hazard(core_id)   ,
	CONSTRAINT fk_portfolio_financial_impact_analysis_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_portfolio_financial_impact_analysis_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_portfolio_financial_impact_analysis_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)  ,
	CONSTRAINT fk_portfolio_financial_impact_analysis_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id)
 );
COMMENT ON TABLE osc_physrisk_financial_analysis.portfolio_financial_impact IS 'The result of a physical risk & resilience analysis. The result is determined by the chosen scenario, year, and hazard, aggregating the results for all of the assets in a given portfolio. If multiple scenarios/years/hazards were chosen, there will be multiple other rows containing the combined set of results.';

CREATE TABLE osc_physrisk_financial_analysis.asset_financial_impact ( 
	core_id UUID  DEFAULT gen_random_UUID () NOT NULL,
	core_name VARCHAR(255) NOT NULL,
	core_name_display VARCHAR(255),
	core_slug VARCHAR(255),
	core_abbreviation VARCHAR(12),
	core_description_full  TEXT NOT NULL,
	core_description_short  VARCHAR(255) NOT NULL,
    core_tags jsonb DEFAULT NULL,
	core_datetime_utc_created TIMESTAMPTZ NOT NULL,
	core_creator_user_id BIGINT NOT NULL,
	core_datetime_utc_last_modified TIMESTAMPTZ NOT NULL,
	core_last_modifier_user_id BIGINT NOT NULL,
	core_is_deleted BOOLEAN NOT NULL DEFAULT 'n',
	core_deleter_user_id BIGINT DEFAULT NULL,
	core_datetime_utc_deleted TIMESTAMPTZ DEFAULT NULL,
	core_tenant_id BIGINT NOT NULL DEFAULT 1,
	core_culture VARCHAR(5) NOT NULL DEFAULT 'en',
	core_checksum VARCHAR(40) DEFAULT NULL,
	core_seq_num SMALLINT  NOT NULL Default 0,
	core_translated_from_id UUID DEFAULT NULL,
	core_is_active BOOLEAN NOT NULL DEFAULT 'y',
	core_is_published BOOLEAN DEFAULT 'n',
	core_publisher_id BIGINT DEFAULT NULL,
	core_datetime_utc_published TIMESTAMPTZ DEFAULT NULL,
	core_version TEXT DEFAULT '1.0',
	core_dataset_id UUID,
	core_geo_country_id UUID,
	core_geo_location_name      	VARCHAR(255),
    core_geo_location_address      	text ,
    core_geo_location_coordinates      	GEOGRAPHY  NOT NULL  ,
	core_geo_altitude numeric DEFAULT NULL, 
	core_geo_altitude_confidence numeric DEFAULT NULL,
	core_geo_overture_features			jsonb[], -- This location can be described in 0 or more Overture Map schemas to cover its land use, infrastructure, building extents, etc
	core_geo_h3_index H3INDEX NOT NULL,
    core_geo_h3_resolution INT2 NOT NULL,
	core_datetime_utc_start timestamptz,
	core_datetime_utc_end timestamptz,	
	asset_id            UUID  NOT NULL  ,
	hazard_indicator_id UUID NOT NULL,
    hazard_intensity numeric[], -- Assume this includes intensity units
	scenario_id UUID NOT NULL,
    scenario_year smallint,
    vulnerability_type_id integer NOT NULL,
	financial_impact_type_id integer NOT NULL, -- this design assumes one row per impact type. If there are multiple potential impact types, there would be multiple rows.
	impact_data_raw jsonb NOT NULL, -- we recommend that this json includes schema references so a consuming application can use json schema for parsing.	
    impact_level numeric NOT NULL, -- 0.0 = not vulnerable at all 1.0 = highly vulnerable across whole area. In  between = some level of vulnerability, finer geographic granularity is required	
	impact_mean    numeric[],
	impact_std    numeric[],
	impact_distribution_bin_edges    numeric[],
    impact_distribution_probabilities    numeric[],
	impact_exceedance_probabilities    numeric[], -- X axis info, redundant but useful
	impact_return_periods jsonb, -- useful?	
	value_total numeric,
    value_at_risk numeric,
    value_currency_alphabetic_code char(3),
    --parameter    numeric,
    exposure_function_id text NOT NULL,
	exposure_result_raw jsonb NOT NULL, -- STORE RAW JSON, MAYBE OVERLAP WITH SOME COLUMNS BELOW?
	exposure_probability numeric,
	exposure_level bool,	
	vulnerability_function_id UUID NOT NULL,
	CONSTRAINT pk_asset_financial_impact PRIMARY KEY ( core_id ),
	CONSTRAINT fk_asset_financial_impact_core_dataset_id FOREIGN KEY ( core_dataset_id ) REFERENCES osc_physrisk_backend.dataset(core_id),
    CONSTRAINT fk_asset_financial_impact_geo_country_id FOREIGN KEY ( core_geo_country_id ) REFERENCES osc_physrisk_backend.geo_country(core_id),
	CONSTRAINT ck_asset_financial_impact_geo_h3_resolution CHECK (core_geo_h3_resolution >= 0 AND core_geo_h3_resolution <= 15),
	CONSTRAINT fk_asset_financial_impact_asset_id FOREIGN KEY ( asset_id ) REFERENCES osc_physrisk_assets.generic_asset(core_id),
	CONSTRAINT fk_asset_financial_impact_scenario_id FOREIGN KEY ( scenario_id ) REFERENCES osc_physrisk_scenarios.scenario(core_id),
	CONSTRAINT fk_asset_financial_impact_vulnerability_type_id FOREIGN KEY ( vulnerability_type_id ) REFERENCES osc_physrisk_vulnerability_analysis.vulnerability_type(core_id),
	CONSTRAINT fk_asset_financial_impact_financial_impact_type_id FOREIGN KEY ( financial_impact_type_id ) REFERENCES osc_physrisk_financial_analysis.financial_impact_type(core_id),
	CONSTRAINT fk_asset_financial_impact_hazard_indicator_id FOREIGN KEY ( hazard_indicator_id ) REFERENCES osc_physrisk_scenarios.hazard_indicator(core_id)    ,
	CONSTRAINT fk_asset_financial_impact_core_vulnerability_function_id FOREIGN KEY ( vulnerability_function_id ) REFERENCES osc_physrisk_vulnerability_analysis.vulnerability_function(core_id),	
	CONSTRAINT fk_asset_financial_impact_core_creator_user_id FOREIGN KEY ( core_creator_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_financial_impact_core_last_modifier_user_id FOREIGN KEY ( core_last_modifier_user_id ) REFERENCES osc_physrisk_backend.user(core_id),
	CONSTRAINT fk_asset_financial_impact_core_deleter_user_id FOREIGN KEY ( core_deleter_user_id ) REFERENCES osc_physrisk_backend.user(core_id)   ,
	CONSTRAINT fk_asset_financial_impact_core_tenant_id FOREIGN KEY ( core_tenant_id ) REFERENCES osc_physrisk_backend.tenant(core_id)
 );
COMMENT ON TABLE osc_physrisk_financial_analysis.asset_financial_impact IS 'The financial impact result of a physical risk & resilience analysis for a particular asset. The result is determined by the chosen scenario, year, and hazard. If multiple scenarios/years/hazards were chosen, there will be multiple other rows containing the combined set of results. A financial impact can only occur if there is a corresponding impact row (see asset_vulnerability table)';


-- SETUP PERMISSIONS FOR A READER SQL SERVICE ACCOUNT (CREATE THAT USING A DATABASE TOOL)
--GRANT USAGE ON SCHEMA "osc_physrisk_backend" TO physrisk_reader_service;
--GRANT SELECT ON ALL TABLES IN SCHEMA "osc_physrisk_backend" TO physrisk_reader_service;
--GRANT USAGE ON SCHEMA "osc_physrisk_scenarios" TO physrisk_reader_service;
--GRANT SELECT ON ALL TABLES IN SCHEMA "osc_physrisk_scenarios" TO physrisk_reader_service;
--GRANT USAGE ON SCHEMA "osc_physrisk_assets" TO physrisk_reader_service;
--GRANT SELECT ON ALL TABLES IN SCHEMA "osc_physrisk_assets" TO physrisk_reader_service;
--GRANT USAGE ON SCHEMA "osc_physrisk_vulnerability_analysis" TO physrisk_reader_service;
--GRANT SELECT ON ALL TABLES IN SCHEMA "osc_physrisk_vulnerability_analysis" TO physrisk_reader_service;

-- SETUP PERMISSIONS FOR A READER/WRITER SQL SERVICE ACCOUNT (CREATE THAT USING A DATABASE TOOL)
--GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA "osc_physrisk_backend" TO physrisk_readerwriter_service;
--GRANT ALL ON ALL TABLES IN SCHEMA "osc_physrisk_backend" TO physrisk_readerwriter_service;
--GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA "osc_physrisk_scenarios" TO physrisk_readerwriter_service;
--GRANT ALL ON ALL TABLES IN SCHEMA "osc_physrisk_scenarios" TO physrisk_readerwriter_service;
--GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA "osc_physrisk_assets" TO physrisk_readerwriter_service;
--GRANT ALL ON ALL TABLES IN SCHEMA "osc_physrisk_assets" TO physrisk_readerwriter_service;
--GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA "osc_physrisk_vulnerability_analysis" TO physrisk_readerwriter_service;
--GRANT ALL ON ALL TABLES IN SCHEMA "osc_physrisk_vulnerability_analysis" TO physrisk_readerwriter_service;

-- DATA IN ENGLISH STARTS

INSERT INTO osc_physrisk_backend.user
	(core_id, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_user_name, core_tenant_id, email_address, core_name, core_surname, core_is_active)
VALUES 
	(1,'2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'osc',1,'example@email','Open-Source','Climate','y')
;
INSERT INTO osc_physrisk_backend.tenant
	(core_id, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_tenancy_name, core_name, core_is_active)
VALUES 
	(1,'2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL,'Default','Default','y');



-- INSERT COUNTRIES (DATA SOURCE FROM UNITED NATIONS STATISTICS DIVISION: https://unstats.un.org/unsd/methodology/m49/overview/)
INSERT INTO osc_physrisk.osc_physrisk_backend.dataset
	(core_id, core_name, core_name_display, core_slug, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, core_version, data_contact, data_quality, data_format, data_schema, data_access_rights, data_license, data_usage_notes, data_related)
VALUES 
	('7c03ca95-efbc-406a-a245-9870cf54fedf', 'UN Statistics Division - Standard country or area codes for statistical use (M49)', 'UN Statistics Division - Standard country or area codes for statistical use (M49)', '/data/unitednations/m49', 'UN M49', 'UN Statistics Division - Standard country or area codes for statistical use (M49). Originally exported from https://unstats.un.org/unsd/methodology/m49/overview/ on 2024-09-04 with standard OSC columns appended.', 'UN Statistics Division - Standard country or area codes for statistical use (M49). Originally exported from https://unstats.un.org/unsd/methodology/m49/overview/', '{}', '2024-07-14 20:00',1,'2024-07-14 20:00',1,'n',null,null,'en',' core_checksum',1,null,'y','y',1,'2024-07-14 20:00',1, 'United Nations Statistics Division', 'See "Accuracy and Currency of Data" section of Undata webpage: http://data.un.org/Host.aspx?Content=UNdataUse','text/csv', '',  'See UNdata terms and conditions of use page: http://data.un.org/Host.aspx?Content=UNdataUse',  'See UNdata terms and conditions of use page: http://data.un.org/Host.aspx?Content=UNdataUse', 'See UNdata terms and conditions of use page: http://data.un.org/Host.aspx?Content=UNdataUse', '');

INSERT INTO osc_physrisk.osc_physrisk_backend.geo_country(core_id, core_name, core_name_display, core_slug, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, core_version, core_dataset_id, un_global_code, un_global_name, un_region_code, un_region_name, un_subregion_code, un_subregion_name, un_intermediateregion_code, un_intermediateregion_name, un_code_m49, un_is_ldc, un_is_lldc, un_is_sids, iso_code_alpha2, iso_code_alpha3) VALUES ('f86bd5e5-716a-45fe-a3f8-014fdc4db5c5', 'Algeria', 'Algeria', '/countries/africa/algeria', null, 'Algeria', 'Algeria', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 15, 'Northern Africa', null, 'Algeria', 12, 'f', 'f', 'f', 'DZ', 'DZA'),('ef80f4c8-8a6a-4ba8-bc64-6e138f301eb1', 'Egypt', 'Egypt', '/countries/africa/egypt', null, 'Egypt', 'Egypt', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 15, 'Northern Africa', null, null, 818, 'f', 'f', 'f', 'EG', 'EGY'),('e303fd87-bcd3-45b0-b065-d2213981d1e9', 'Libya', 'Libya', '/countries/africa/libya', null, 'Libya', 'Libya', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 15, 'Northern Africa', null, null, 434, 'f', 'f', 'f', 'LY', 'LBY'),('d4d3850d-c16c-490f-8255-a155e4e0c646', 'Morocco', 'Morocco', '/countries/africa/morocco', null, 'Morocco', 'Morocco', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 15, 'Northern Africa', null, null, 504, 'f', 'f', 'f', 'MA', 'MAR'),('1d5d0ea0-3281-42e0-af7b-242d6ee08bd2', 'Sudan', 'Sudan', '/countries/africa/sudan', null, 'Sudan', 'Sudan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 15, 'Northern Africa', null, null, 729, 't', 'f', 'f', 'SD', 'SDN'),('94201d8e-2e87-4457-a51f-823bb6156e15', 'Tunisia', 'Tunisia', '/countries/africa/tunisia', null, 'Tunisia', 'Tunisia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 15, 'Northern Africa', null, null, 788, 'f', 'f', 'f', 'TN', 'TUN'),('cbb2c4c3-437f-47bf-a378-e73c60756ccc', 'Western Sahara', 'Western Sahara', '/countries/africa/western%20sahara', null, 'Western Sahara', 'Western Sahara', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 15, 'Northern Africa', null, null, 732, 'f', 'f', 'f', 'EH', 'ESH'),('5c0a74c8-9f81-46ee-b3a6-a3d0c0e063f7', 'British Indian Ocean Territory', 'British Indian Ocean Territory', '/countries/africa/british%20indian%20ocean%20territory', null, 'British Indian Ocean Territory', 'British Indian Ocean Territory', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 86, 'f', 'f', 'f', 'IO', 'IOT'),('ebae70dd-4945-4bc2-b6e2-80f01f2315c0', 'Burundi', 'Burundi', '/countries/africa/burundi', null, 'Burundi', 'Burundi', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 108, 't', 't', 'f', 'BI', 'BDI'),('9967b39c-c53f-4f41-9181-efcc13987648', 'Comoros', 'Comoros', '/countries/africa/comoros', null, 'Comoros', 'Comoros', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 174, 't', 'f', 't', 'KM', 'COM'),('dfa0f0dd-7db4-449f-961d-3ec34fa157f1', 'Djibouti', 'Djibouti', '/countries/africa/djibouti', null, 'Djibouti', 'Djibouti', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 262, 't', 'f', 'f', 'DJ', 'DJI'),('211ad59a-d047-416e-8272-3d8ca3d941ac', 'Eritrea', 'Eritrea', '/countries/africa/eritrea', null, 'Eritrea', 'Eritrea', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 232, 't', 'f', 'f', 'ER', 'ERI'),('2d7c90eb-998b-40c1-bd18-b0d14a66a787', 'Ethiopia', 'Ethiopia', '/countries/africa/ethiopia', null, 'Ethiopia', 'Ethiopia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 231, 't', 't', 'f', 'ET', 'ETH'),('4dee1c82-8bd0-402b-90dd-ca2c8c6874f1', 'French Southern Territories', 'French Southern Territories', '/countries/africa/french%20southern%20territories', null, 'French Southern Territories', 'French Southern Territories', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 260, 'f', 'f', 'f', 'TF', 'ATF'),('8a96cc2f-f38a-462d-b37c-c234a1185baa', 'Kenya', 'Kenya', '/countries/africa/kenya', null, 'Kenya', 'Kenya', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 404, 'f', 'f', 'f', 'KE', 'KEN'),('b976713e-7169-41cd-8bb6-9fad32901315', 'Madagascar', 'Madagascar', '/countries/africa/madagascar', null, 'Madagascar', 'Madagascar', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 450, 't', 'f', 'f', 'MG', 'MDG'),('97a4b208-62d8-49f4-9376-04a2843d04e7', 'Malawi', 'Malawi', '/countries/africa/malawi', null, 'Malawi', 'Malawi', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 454, 't', 't', 'f', 'MW', 'MWI'),('8cb2a819-967b-49f2-b67e-f55c90086e7c', 'Mauritius', 'Mauritius', '/countries/africa/mauritius', null, 'Mauritius', 'Mauritius', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 480, 'f', 'f', 't', 'MU', 'MUS'),('17af651d-cac7-4690-815e-1902c2d30ce7', 'Mayotte', 'Mayotte', '/countries/africa/mayotte', null, 'Mayotte', 'Mayotte', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 175, 'f', 'f', 'f', 'YT', 'MYT'),('d87d3998-4c67-4cf9-b13b-92dfdaad4bef', 'Mozambique', 'Mozambique', '/countries/africa/mozambique', null, 'Mozambique', 'Mozambique', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 508, 't', 'f', 'f', 'MZ', 'MOZ'),('1a7c438b-dd6f-4a79-a214-2ffc9d8c7ba8', 'Réunion', 'Réunion', '/countries/africa/reunion', null, 'Réunion', 'Réunion', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 638, 'f', 'f', 'f', 'RE', 'REU'),('664f8a5f-0cce-4e7c-90e7-a5e56346f843', 'Rwanda', 'Rwanda', '/countries/africa/rwanda', null, 'Rwanda', 'Rwanda', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 646, 't', 't', 'f', 'RW', 'RWA'),('75be2148-320f-4a79-9b9f-e7470a0cdd87', 'Seychelles', 'Seychelles', '/countries/africa/seychelles', null, 'Seychelles', 'Seychelles', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 690, 'f', 'f', 't', 'SC', 'SYC'),('c09922f2-8f9c-4fb2-b729-9c4beafb9c92', 'Somalia', 'Somalia', '/countries/africa/somalia', null, 'Somalia', 'Somalia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 706, 't', 'f', 'f', 'SO', 'SOM'),('95d2ed38-d954-4c6d-8ca7-1df948b06f12', 'South Sudan', 'South Sudan', '/countries/africa/south%20sudan', null, 'South Sudan', 'South Sudan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 728, 't', 't', 'f', 'SS', 'SSD');
INSERT INTO osc_physrisk.osc_physrisk_backend.geo_country(core_id, core_name, core_name_display, core_slug, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, core_version, core_dataset_id, un_global_code, un_global_name, un_region_code, un_region_name, un_subregion_code, un_subregion_name, un_intermediateregion_code, un_intermediateregion_name, un_code_m49, un_is_ldc, un_is_lldc, un_is_sids, iso_code_alpha2, iso_code_alpha3) VALUES ('5121ea8b-fe50-444e-9139-59399798fa72', 'Uganda', 'Uganda', '/countries/africa/uganda', null, 'Uganda', 'Uganda', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 800, 't', 't', 'f', 'UG', 'UGA'),('5411d512-141c-4911-85c5-26d6b2964b5d', 'United Republic of Tanzania', 'United Republic of Tanzania', '/countries/africa/united%20republic%20of%20tanzania', null, 'United Republic of Tanzania', 'United Republic of Tanzania', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 834, 't', 'f', 'f', 'TZ', 'TZA'),('06c714e4-b620-4720-b053-97e2894bba21', 'Bahrain', 'Bahrain', '/countries/asia/bahrain', null, 'Bahrain', 'Bahrain', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 48, 'f', 'f', 'f', 'BH', 'BHR'),('e72f1754-479a-4904-a8ef-0f82ac4262a5', 'Zambia', 'Zambia', '/countries/africa/zambia', null, 'Zambia', 'Zambia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 894, 't', 't', 'f', 'ZM', 'ZMB'),('9552e062-f777-4123-a018-56b83d5a6d3a', 'Zimbabwe', 'Zimbabwe', '/countries/africa/zimbabwe', null, 'Zimbabwe', 'Zimbabwe', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 14, 'Eastern Africa', 716, 'f', 't', 'f', 'ZW', 'ZWE'),('cc7ee3e2-1cba-42a3-a430-9a8460955e4d', 'Angola', 'Angola', '/countries/africa/angola', null, 'Angola', 'Angola', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 17, 'Middle Africa', 24, 't', 'f', 'f', 'AO', 'AGO'),('f2428251-c17f-4cd6-8f2f-ca8c92333daf', 'Cameroon', 'Cameroon', '/countries/africa/cameroon', null, 'Cameroon', 'Cameroon', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 17, 'Middle Africa', 120, 'f', 'f', 'f', 'CM', 'CMR'),('a594e719-fea9-4bcd-9b38-595a6c4b2d6c', 'Central African Republic', 'Central African Republic', '/countries/africa/central%20african%20republic', null, 'Central African Republic', 'Central African Republic', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 17, 'Middle Africa', 140, 't', 't', 'f', 'CF', 'CAF'),('d72d363a-7f4a-440c-8d58-5c0c8fab4565', 'Chad', 'Chad', '/countries/africa/chad', null, 'Chad', 'Chad', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 17, 'Middle Africa', 148, 't', 't', 'f', 'TD', 'TCD'),('2ee91603-8c99-48af-9bd7-83ed928cde7e', 'Congo', 'Congo', '/countries/africa/congo', null, 'Congo', 'Congo', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 17, 'Middle Africa', 178, 'f', 'f', 'f', 'CG', 'COG'),('d44ef19c-94c0-4b1d-bbeb-246ee689c418', 'Democratic Republic of the Congo', 'Democratic Republic of the Congo', '/countries/africa/democratic%20republic%20of%20the%20congo', null, 'Democratic Republic of the Congo', 'Democratic Republic of the Congo', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 17, 'Middle Africa', 180, 't', 'f', 'f', 'CD', 'COD'),('ee761884-bd15-4fae-b30b-2133f29c8895', 'Equatorial Guinea', 'Equatorial Guinea', '/countries/africa/equatorial%20guinea', null, 'Equatorial Guinea', 'Equatorial Guinea', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 17, 'Middle Africa', 226, 'f', 'f', 'f', 'GQ', 'GNQ'),('5f3be45b-03ad-44a5-9a59-987565e20661', 'Gabon', 'Gabon', '/countries/africa/gabon', null, 'Gabon', 'Gabon', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 17, 'Middle Africa', 266, 'f', 'f', 'f', 'GA', 'GAB'),('f2f1f21a-a33f-4d85-bfd4-cd5415ca33f6', 'Sao Tome and Principe', 'Sao Tome and Principe', '/countries/africa/sao%20tome%20and%20principe', null, 'Sao Tome and Principe', 'Sao Tome and Principe', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 17, 'Middle Africa', 678, 't', 'f', 't', 'ST', 'STP'),('cd071391-697d-4e69-9e9b-2db1838db724', 'Botswana', 'Botswana', '/countries/africa/botswana', null, 'Botswana', 'Botswana', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 18, 'Southern Africa', 72, 'f', 't', 'f', 'BW', 'BWA'),('708487db-33c3-4644-9492-d2b5be70c00b', 'Eswatini', 'Eswatini', '/countries/africa/eswatini', null, 'Eswatini', 'Eswatini', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 18, 'Southern Africa', 748, 'f', 't', 'f', 'SZ', 'SWZ'),('53189013-d1b8-4724-af42-96afcd57f2bb', 'Lesotho', 'Lesotho', '/countries/africa/lesotho', null, 'Lesotho', 'Lesotho', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 18, 'Southern Africa', 426, 't', 't', 'f', 'LS', 'LSO'),('47a3ee0c-1d7e-4091-9950-090147611b22', 'Namibia', 'Namibia', '/countries/africa/namibia', null, 'Namibia', 'Namibia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 18, 'Southern Africa', 516, 'f', 'f', 'f', 'NA', 'NAM'),('69e9be50-6152-42de-9c5d-b9724c4c99f2', 'South Africa', 'South Africa', '/countries/africa/south%20africa', null, 'South Africa', 'South Africa', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 18, 'Southern Africa', 710, 'f', 'f', 'f', 'ZA', 'ZAF'),('55cd4365-df11-46f4-a16b-676810496200', 'Benin', 'Benin', '/countries/africa/benin', null, 'Benin', 'Benin', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 204, 't', 'f', 'f', 'BJ', 'BEN'),('6a71c214-d4aa-4ac1-b2dc-6a084ffb96fb', 'Burkina Faso', 'Burkina Faso', '/countries/africa/burkina%20faso', null, 'Burkina Faso', 'Burkina Faso', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 854, 't', 't', 'f', 'BF', 'BFA'),('518f263f-c54c-4e11-8295-3e170e9742f2', 'Cabo Verde', 'Cabo Verde', '/countries/africa/cabo%20verde', null, 'Cabo Verde', 'Cabo Verde', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 132, 'f', 'f', 't', 'CV', 'CPV'),('27121256-b1ac-49b1-927f-adb2b665bfdb', 'Côte d''Ivoire', 'Côte d''Ivoire', '/countries/africa/cote%20divoire', null, 'Côte d''Ivoire', 'Côte d''Ivoire', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 384, 'f', 'f', 'f', 'CI', 'CIV'),('9243c0a4-d2a1-43e4-a791-e66316274fff', 'Gambia', 'Gambia', '/countries/africa/gambia', null, 'Gambia', 'Gambia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 270, 't', 'f', 'f', 'GM', 'GMB'),('aa5f07ef-9783-4d35-9306-5129855e3519', 'Ghana', 'Ghana', '/countries/africa/ghana', null, 'Ghana', 'Ghana', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 288, 'f', 'f', 'f', 'GH', 'GHA');
INSERT INTO osc_physrisk.osc_physrisk_backend.geo_country(core_id, core_name, core_name_display, core_slug, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, core_version, core_dataset_id, un_global_code, un_global_name, un_region_code, un_region_name, un_subregion_code, un_subregion_name, un_intermediateregion_code, un_intermediateregion_name, un_code_m49, un_is_ldc, un_is_lldc, un_is_sids, iso_code_alpha2, iso_code_alpha3) VALUES ('9d404a11-083a-473e-bc7f-097cbdb403fa', 'Guinea', 'Guinea', '/countries/africa/guinea', null, 'Guinea', 'Guinea', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 324, 't', 'f', 'f', 'GN', 'GIN'),('5e59bc64-aa9a-47b0-bff4-bc0dbfde1b33', 'Guinea-Bissau', 'Guinea-Bissau', '/countries/africa/guinea-bissau', null, 'Guinea-Bissau', 'Guinea-Bissau', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 624, 't', 'f', 't', 'GW', 'GNB'),('65555d8e-3691-43af-9677-665dc84c05c6', 'Liberia', 'Liberia', '/countries/africa/liberia', null, 'Liberia', 'Liberia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 430, 't', 'f', 'f', 'LR', 'LBR'),('057efe8b-53ab-4aa6-9a1b-cbf40c3a9484', 'Mali', 'Mali', '/countries/africa/mali', null, 'Mali', 'Mali', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 466, 't', 't', 'f', 'ML', 'MLI'),('c011ffc3-1dff-46c4-8734-75b737cfc765', 'Mauritania', 'Mauritania', '/countries/africa/mauritania', null, 'Mauritania', 'Mauritania', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 478, 't', 'f', 'f', 'MR', 'MRT'),('24d7def7-76b6-4d63-8288-147d6d27fe13', 'Niger', 'Niger', '/countries/africa/niger', null, 'Niger', 'Niger', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 562, 't', 't', 'f', 'NE', 'NER'),('44368695-9a36-47b2-aaa7-b1f43fedba78', 'Nigeria', 'Nigeria', '/countries/africa/nigeria', null, 'Nigeria', 'Nigeria', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 566, 'f', 'f', 'f', 'NG', 'NGA'),('ebe31d40-2a11-41f0-990a-3af975d2b85e', 'Saint Helena', 'Saint Helena', '/countries/africa/saint%20helena', null, 'Saint Helena', 'Saint Helena', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 654, 'f', 'f', 'f', 'SH', 'SHN'),('6a15b7ac-54b0-4051-adb1-2fe49801437b', 'Senegal', 'Senegal', '/countries/africa/senegal', null, 'Senegal', 'Senegal', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 686, 't', 'f', 'f', 'SN', 'SEN'),('56f70035-9fbb-4dab-9342-2d39e2f8cd3e', 'Sierra Leone', 'Sierra Leone', '/countries/africa/sierra%20leone', null, 'Sierra Leone', 'Sierra Leone', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 694, 't', 'f', 'f', 'SL', 'SLE'),('9bea13e0-0be0-41c1-a08f-8ef3acc2afa6', 'Togo', 'Togo', '/countries/africa/togo', null, 'Togo', 'Togo', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 2, 'Africa', 202, 'Sub-Saharan Africa', 11, 'Western Africa', 768, 't', 'f', 'f', 'TG', 'TGO'),('bf3d91ff-9cbe-4d51-abce-d25b9f5df15a', 'Anguilla', 'Anguilla', '/countries/americas/anguilla', null, 'Anguilla', 'Anguilla', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 660, 'f', 'f', 't', 'AI', 'AIA'),('15292c97-4937-45fc-9c05-a0c1e674b686', 'Antigua and Barbuda', 'Antigua and Barbuda', '/countries/americas/antigua%20and%20barbuda', null, 'Antigua and Barbuda', 'Antigua and Barbuda', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 28, 'f', 'f', 't', 'AG', 'ATG'),('5c0c2b17-3646-4efb-a309-ac4b25d21120', 'Aruba', 'Aruba', '/countries/americas/aruba', null, 'Aruba', 'Aruba', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 533, 'f', 'f', 't', 'AW', 'ABW'),('97dd2e12-b771-4368-b130-6258db8aaeab', 'Bahamas', 'Bahamas', '/countries/americas/bahamas', null, 'Bahamas', 'Bahamas', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 44, 'f', 'f', 't', 'BS', 'BHS'),('423ad10e-5471-4299-b29e-3fdb8f2bbf91', 'Barbados', 'Barbados', '/countries/americas/barbados', null, 'Barbados', 'Barbados', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 52, 'f', 'f', 't', 'BB', 'BRB'),('d144ca54-8874-47c1-8db4-d40858d53c54', 'Bonaire, Sint Eustatius and Saba', 'Bonaire, Sint Eustatius and Saba', '/countries/americas/bonaire,%20sint%20eustatius%20and%20saba', null, 'Bonaire, Sint Eustatius and Saba', 'Bonaire, Sint Eustatius and Saba', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 535, 'f', 'f', 't', 'BQ', 'BES'),('5851ed79-6d3d-4e10-a742-10d2baf0bea5', 'British Virgin Islands', 'British Virgin Islands', '/countries/americas/british%20virgin%20islands', null, 'British Virgin Islands', 'British Virgin Islands', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 92, 'f', 'f', 't', 'VG', 'VGB'),('b16aaf64-3051-47b5-b862-b81fc5d1577c', 'Cayman Islands', 'Cayman Islands', '/countries/americas/cayman%20islands', null, 'Cayman Islands', 'Cayman Islands', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 136, 'f', 'f', 'f', 'KY', 'CYM'),('c943e101-47f4-43bc-9f47-1611a6b7e514', 'Cuba', 'Cuba', '/countries/americas/cuba', null, 'Cuba', 'Cuba', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 192, 'f', 'f', 't', 'CU', 'CUB'),('14529dea-b702-4b07-af11-b9e7b3b939ea', 'Cura?ao', 'Cura?ao', '/countries/americas/cura?ao', null, 'Cura?ao', 'Cura?ao', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 531, 'f', 'f', 't', 'CW', 'CUW'),('c1f413ea-99d0-4ea4-a0aa-34adaec27888', 'Dominica', 'Dominica', '/countries/americas/dominica', null, 'Dominica', 'Dominica', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 212, 'f', 'f', 't', 'DM', 'DMA'),('6d6534f8-6e2c-473f-83c3-98bf9f933ba0', 'Dominican Republic', 'Dominican Republic', '/countries/americas/dominican%20republic', null, 'Dominican Republic', 'Dominican Republic', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 214, 'f', 'f', 't', 'DO', 'DOM'),('3980501b-2af6-4fdb-a4a2-f66dfcc08607', 'Grenada', 'Grenada', '/countries/americas/grenada', null, 'Grenada', 'Grenada', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 308, 'f', 'f', 't', 'GD', 'GRD'),('a2535008-1051-4baf-ae58-0059bd1713aa', 'Guadeloupe', 'Guadeloupe', '/countries/americas/guadeloupe', null, 'Guadeloupe', 'Guadeloupe', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 312, 'f', 'f', 'f', 'GP', 'GLP');
INSERT INTO osc_physrisk.osc_physrisk_backend.geo_country(core_id, core_name, core_name_display, core_slug, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, core_version, core_dataset_id, un_global_code, un_global_name, un_region_code, un_region_name, un_subregion_code, un_subregion_name, un_intermediateregion_code, un_intermediateregion_name, un_code_m49, un_is_ldc, un_is_lldc, un_is_sids, iso_code_alpha2, iso_code_alpha3) VALUES ('f720786e-54e6-4048-a9ce-29f93e9e9a1b', 'Haiti', 'Haiti', '/countries/americas/haiti', null, 'Haiti', 'Haiti', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 332, 't', 'f', 't', 'HT', 'HTI'),('e6d5d799-a076-40eb-a473-179926168ba0', 'Jamaica', 'Jamaica', '/countries/americas/jamaica', null, 'Jamaica', 'Jamaica', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 388, 'f', 'f', 't', 'JM', 'JAM'),('5df78338-8460-4a52-9e50-4a506228605f', 'Martinique', 'Martinique', '/countries/americas/martinique', null, 'Martinique', 'Martinique', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 474, 'f', 'f', 'f', 'MQ', 'MTQ'),('20b3935a-575b-42c1-b3d8-cbd36a7a4534', 'Montserrat', 'Montserrat', '/countries/americas/montserrat', null, 'Montserrat', 'Montserrat', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 500, 'f', 'f', 't', 'MS', 'MSR'),('b493aae5-cb66-4ef5-bed9-0948034bf88b', 'Puerto Rico', 'Puerto Rico', '/countries/americas/puerto%20rico', null, 'Puerto Rico', 'Puerto Rico', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 630, 'f', 'f', 't', 'PR', 'PRI'),('088634f8-4612-40f3-90a4-8bfdcbe2c2e3', 'Saint Barthélemy', 'Saint Barthélemy', '/countries/americas/saint%20barth?lemy', null, 'Saint Barthélemy', 'Saint Barthélemy', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 652, 'f', 'f', 'f', 'BL', 'BLM'),('cfb28404-d8e8-452f-afad-be0f0fc2741a', 'Saint Kitts and Nevis', 'Saint Kitts and Nevis', '/countries/americas/saint%20kitts%20and%20nevis', null, 'Saint Kitts and Nevis', 'Saint Kitts and Nevis', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 659, 'f', 'f', 't', 'KN', 'KNA'),('261d29b6-e17d-4b9f-b723-49fe557e8a33', 'Saint Lucia', 'Saint Lucia', '/countries/americas/saint%20lucia', null, 'Saint Lucia', 'Saint Lucia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 662, 'f', 'f', 't', 'LC', 'LCA'),('d160f5d0-1731-4daf-83e3-d884b0b9b2b1', 'Saint Martin (French Part)', 'Saint Martin (French Part)', '/countries/americas/saint%20martin%20&#40;french%20part&#41;', null, 'Saint Martin (French Part)', 'Saint Martin (French Part)', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 663, 'f', 'f', 'f', 'MF', 'MAF'),('f011cc45-d976-468b-8691-19a31809280b', 'Saint Vincent and the Grenadines', 'Saint Vincent and the Grenadines', '/countries/americas/saint%20vincent%20and%20the%20grenadines', null, 'Saint Vincent and the Grenadines', 'Saint Vincent and the Grenadines', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 670, 'f', 'f', 't', 'VC', 'VCT'),('ae68663b-c856-47bb-a46c-6dada8c55205', 'Sint Maarten (Dutch part)', 'Sint Maarten (Dutch part)', '/countries/americas/sint%20maarten%20&#40;dutch%20part&#41;', null, 'Sint Maarten (Dutch part)', 'Sint Maarten (Dutch part)', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 534, 'f', 'f', 't', 'SX', 'SXM'),('d33f7c7b-a0b2-4d7b-a7f5-67328f4281fb', 'Trinidad and Tobago', 'Trinidad and Tobago', '/countries/americas/trinidad%20and%20tobago', null, 'Trinidad and Tobago', 'Trinidad and Tobago', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 780, 'f', 'f', 't', 'TT', 'TTO'),('6fae5280-8acc-460a-b4b9-62b31624bd99', 'Turks and Caicos Islands', 'Turks and Caicos Islands', '/countries/americas/turks%20and%20caicos%20islands', null, 'Turks and Caicos Islands', 'Turks and Caicos Islands', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 796, 'f', 'f', 'f', 'TC', 'TCA'),('ecfb8eba-b7ff-43d6-ac4b-8891e0818204', 'United States Virgin Islands', 'United States Virgin Islands', '/countries/americas/united%20states%20virgin%20islands', null, 'United States Virgin Islands', 'United States Virgin Islands', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 29, 'Caribbean', 850, 'f', 'f', 't', 'VI', 'VIR'),('aa83ed47-9d9e-46bd-a1d4-2ebe3adfc8a6', 'Belize', 'Belize', '/countries/americas/belize', null, 'Belize', 'Belize', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 13, 'Central America', 84, 'f', 'f', 't', 'BZ', 'BLZ'),('77e1c1da-1922-4a85-b898-2e674b2b1e42', 'Costa Rica', 'Costa Rica', '/countries/americas/costa%20rica', null, 'Costa Rica', 'Costa Rica', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 13, 'Central America', 188, 'f', 'f', 'f', 'CR', 'CRI'),('bff838df-f7f5-450f-a188-14c047f2162f', 'El Salvador', 'El Salvador', '/countries/americas/el%20salvador', null, 'El Salvador', 'El Salvador', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 13, 'Central America', 222, 'f', 'f', 'f', 'SV', 'SLV'),('0f079c05-8041-4cd3-b337-1a67839db318', 'Guatemala', 'Guatemala', '/countries/americas/guatemala', null, 'Guatemala', 'Guatemala', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 13, 'Central America', 320, 'f', 'f', 'f', 'GT', 'GTM'),('cc3fecf3-b6a4-4b64-b635-a65e87d5e5a8', 'Honduras', 'Honduras', '/countries/americas/honduras', null, 'Honduras', 'Honduras', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 13, 'Central America', 340, 'f', 'f', 'f', 'HN', 'HND'),('373c29d8-aa68-47e4-a53d-c45f6cc3bcc3', 'Mexico', 'Mexico', '/countries/americas/mexico', null, 'Mexico', 'Mexico', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 13, 'Central America', 484, 'f', 'f', 'f', 'MX', 'MEX'),('fe3ce408-5a23-4f55-abe8-7e12ae219c31', 'Nicaragua', 'Nicaragua', '/countries/americas/nicaragua', null, 'Nicaragua', 'Nicaragua', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 13, 'Central America', 558, 'f', 'f', 'f', 'NI', 'NIC'),('9d4961c7-9796-41d1-8bf1-3122d7c70d90', 'Panama', 'Panama', '/countries/americas/panama', null, 'Panama', 'Panama', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 13, 'Central America', 591, 'f', 'f', 'f', 'PA', 'PAN'),('42c94d56-5616-4be5-9105-4a9b393e64a5', 'Argentina', 'Argentina', '/countries/americas/argentina', null, 'Argentina', 'Argentina', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 32, 'f', 'f', 'f', 'AR', 'ARG'),('fc6e7e0a-6370-469f-b6b0-f02a89183220', 'Bolivia (Plurinational State of)', 'Bolivia (Plurinational State of)', '/countries/americas/bolivia%20&#40;plurinational%20state%20of&#41;', null, 'Bolivia (Plurinational State of)', 'Bolivia (Plurinational State of)', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 68, 'f', 't', 'f', 'BO', 'BOL'),('79075f1a-e651-4b0f-9d29-318f7eeda448', 'Bouvet Island', 'Bouvet Island', '/countries/americas/bouvet%20island', null, 'Bouvet Island', 'Bouvet Island', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 74, 'f', 'f', 'f', 'BV', 'BVT');
INSERT INTO osc_physrisk.osc_physrisk_backend.geo_country(core_id, core_name, core_name_display, core_slug, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, core_version, core_dataset_id, un_global_code, un_global_name, un_region_code, un_region_name, un_subregion_code, un_subregion_name, un_intermediateregion_code, un_intermediateregion_name, un_code_m49, un_is_ldc, un_is_lldc, un_is_sids, iso_code_alpha2, iso_code_alpha3) VALUES ('8f003529-f360-42f7-90ca-5bac5185cde5', 'Brazil', 'Brazil', '/countries/americas/brazil', null, 'Brazil', 'Brazil', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 76, 'f', 'f', 'f', 'BR', 'BRA'),('cae1b9ff-0dc2-4182-b4b8-4019076eb653', 'Chile', 'Chile', '/countries/americas/chile', null, 'Chile', 'Chile', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 152, 'f', 'f', 'f', 'CL', 'CHL'),('09e407d5-3389-4044-bcb1-c6859d1eaff3', 'Colombia', 'Colombia', '/countries/americas/colombia', null, 'Colombia', 'Colombia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 170, 'f', 'f', 'f', 'CO', 'COL'),('300ac0fd-29f9-4f4a-b4ae-eff84ecbdb1f', 'Ecuador', 'Ecuador', '/countries/americas/ecuador', null, 'Ecuador', 'Ecuador', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 218, 'f', 'f', 'f', 'EC', 'ECU'),('bc2db8da-19d7-45f1-a124-a442dc198392', 'Falkland Islands (Malvinas)', 'Falkland Islands (Malvinas)', '/countries/americas/falkland%20islands%20&#40;malvinas&#41;', null, 'Falkland Islands (Malvinas)', 'Falkland Islands (Malvinas)', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 238, 'f', 'f', 'f', 'FK', 'FLK'),('5832ab1a-8ab3-49b6-b9df-83e99f5387ee', 'French Guiana', 'French Guiana', '/countries/americas/french%20guiana', null, 'French Guiana', 'French Guiana', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 254, 'f', 'f', 'f', 'GF', 'GUF'),('cc03f941-790c-4896-8073-cdcde4d1475b', 'Guyana', 'Guyana', '/countries/americas/guyana', null, 'Guyana', 'Guyana', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 328, 'f', 'f', 't', 'GY', 'GUY'),('5aea8ccc-ed72-462b-bda9-67e01f4c0237', 'Paraguay', 'Paraguay', '/countries/americas/paraguay', null, 'Paraguay', 'Paraguay', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 600, 'f', 't', 'f', 'PY', 'PRY'),('715b207c-26e1-4263-a063-b1522085bc4e', 'Peru', 'Peru', '/countries/americas/peru', null, 'Peru', 'Peru', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 604, 'f', 'f', 'f', 'PE', 'PER'),('45db8552-dfb9-4a31-9bc9-2f5e411e14d8', 'South Georgia and the South Sandwich Islands', 'South Georgia and the South Sandwich Islands', '/countries/americas/south%20georgia%20and%20the%20south%20sandwich%20islands', null, 'South Georgia and the South Sandwich Islands', 'South Georgia and the South Sandwich Islands', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 239, 'f', 'f', 'f', 'GS', 'SGS'),('602a3ed4-0fe5-4922-99bb-a3db4dcd8e3e', 'Suriname', 'Suriname', '/countries/americas/suriname', null, 'Suriname', 'Suriname', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 740, 'f', 'f', 't', 'SR', 'SUR'),('3045c834-b609-4cad-a17d-96e7aa17f6a1', 'Uruguay', 'Uruguay', '/countries/americas/uruguay', null, 'Uruguay', 'Uruguay', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 858, 'f', 'f', 'f', 'UY', 'URY'),('2cd3d90e-1d98-4ffb-86f2-b15d5ec5d8ee', 'Venezuela (Bolivarian Republic of)', 'Venezuela (Bolivarian Republic of)', '/countries/americas/venezuela%20&#40;bolivarian%20republic%20of&#41;', null, 'Venezuela (Bolivarian Republic of)', 'Venezuela (Bolivarian Republic of)', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 419, 'Latin America and the Caribbean', 5, 'South America', 862, 'f', 'f', 'f', 'VE', 'VEN'),('40148e28-7b96-4452-8fc5-b797f1e1bf8a', 'Bermuda', 'Bermuda', '/countries/americas/bermuda', null, 'Bermuda', 'Bermuda', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 21, 'Northern America', null, null, 60, 'f', 'f', 'f', 'BM', 'BMU'),('9969b580-6b16-4962-9b74-243acd1d55d1', 'Canada', 'Canada', '/countries/americas/canada', null, 'Canada', 'Canada', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 21, 'Northern America', null, null, 124, 'f', 'f', 'f', 'CA', 'CAN'),('10fe4a3e-1f6a-4f32-82f8-d6fd8cd0fe9a', 'Greenland', 'Greenland', '/countries/americas/greenland', null, 'Greenland', 'Greenland', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 21, 'Northern America', null, null, 304, 'f', 'f', 'f', 'GL', 'GRL'),('be19d19e-1da6-4388-b38e-b6aacae9dbb7', 'Saint Pierre and Miquelon', 'Saint Pierre and Miquelon', '/countries/americas/saint%20pierre%20and%20miquelon', null, 'Saint Pierre and Miquelon', 'Saint Pierre and Miquelon', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 21, 'Northern America', null, null, 666, 'f', 'f', 'f', 'PM', 'SPM'),('bbbf853e-e9f6-40e2-ac67-0f09532a010b', 'United States of America', 'United States of America', '/countries/americas/united%20states%20of%20america', null, 'United States of America', 'United States of America', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 19, 'Americas', 21, 'Northern America', null, null, 840, 'f', 'f', 'f', 'US', 'USA'),('1dc7cbd0-1a3e-472a-84dd-eec9675072f8', 'Antarctica', 'Antarctica', '/countries/antarctica', null, 'Antarctica', 'Antarctica', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 0, 'Antarctica', 0, 'Antarctica', null, 'Antarctica', 10, 'f', 'f', 'f', 'AQ', 'ATA'),('8bbf0262-cbbe-483e-a8fd-12850556de6d', 'Kazakhstan', 'Kazakhstan', '/countries/asia/kazakhstan', null, 'Kazakhstan', 'Kazakhstan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 143, 'Central Asia', null, null, 398, 'f', 't', 'f', 'KZ', 'KAZ'),('1af97b84-4c7a-43db-a5e9-95ab39d93fe0', 'Kyrgyzstan', 'Kyrgyzstan', '/countries/asia/kyrgyzstan', null, 'Kyrgyzstan', 'Kyrgyzstan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 143, 'Central Asia', null, null, 417, 'f', 't', 'f', 'KG', 'KGZ'),('798d48f8-da8b-4a5c-8988-ccdd3f733afa', 'Tajikistan', 'Tajikistan', '/countries/asia/tajikistan', null, 'Tajikistan', 'Tajikistan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 143, 'Central Asia', null, null, 762, 'f', 't', 'f', 'TJ', 'TJK'),('59bf5eaf-e6ad-4b91-bcda-821732adcf02', 'Turkmenistan', 'Turkmenistan', '/countries/asia/turkmenistan', null, 'Turkmenistan', 'Turkmenistan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 143, 'Central Asia', null, null, 795, 'f', 't', 'f', 'TM', 'TKM'),('a29a5a4a-daee-46af-9281-531c6955b457', 'Uzbekistan', 'Uzbekistan', '/countries/asia/uzbekistan', null, 'Uzbekistan', 'Uzbekistan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 143, 'Central Asia', null, null, 860, 'f', 't', 'f', 'UZ', 'UZB'),('1d827228-b5f1-4592-8fcc-e69cfceaa4b4', 'China', 'China', '/countries/asia/china', null, 'China', 'China', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 30, 'Eastern Asia', null, null, 156, 'f', 'f', 'f', 'CN', 'CHN');
INSERT INTO osc_physrisk.osc_physrisk_backend.geo_country(core_id, core_name, core_name_display, core_slug, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, core_version, core_dataset_id, un_global_code, un_global_name, un_region_code, un_region_name, un_subregion_code, un_subregion_name, un_intermediateregion_code, un_intermediateregion_name, un_code_m49, un_is_ldc, un_is_lldc, un_is_sids, iso_code_alpha2, iso_code_alpha3) VALUES ('75e60e29-85e2-4838-a54d-8b0f42f57a83', 'China, Hong Kong Special Administrative Region', 'China, Hong Kong Special Administrative Region', '/countries/asia/china,%20hong%20kong%20special%20administrative%20region', null, 'China, Hong Kong Special Administrative Region', 'China, Hong Kong Special Administrative Region', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 30, 'Eastern Asia', null, null, 344, 'f', 'f', 'f', 'HK', 'HKG'),('7e00cebd-adad-4979-88f0-94da65d1a1ba', 'Cyprus', 'Cyprus', '/countries/asia/cyprus', null, 'Cyprus', 'Cyprus', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 196, 'f', 'f', 'f', 'CY', 'CYP'),('d8a9eda5-e531-477d-8d62-569c12f05ea4', 'China, Macao Special Administrative Region', 'China, Macao Special Administrative Region', '/countries/asia/china,%20macao%20special%20administrative%20region', null, 'China, Macao Special Administrative Region', 'China, Macao Special Administrative Region', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 30, 'Eastern Asia', null, null, 446, 'f', 'f', 'f', 'MO', 'MAC'),('f1b7ef27-4725-40ec-913c-9a5ea10488ce', 'Democratic People''s Republic of Korea', 'Democratic People''s Republic of Korea', '/countries/asia/democratic%20peoples%20republic%20of%20korea', null, 'Democratic People''s Republic of Korea', 'Democratic People''s Republic of Korea', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 30, 'Eastern Asia', null, null, 408, 'f', 'f', 'f', 'KP', 'PRK'),('3ef193e8-ec89-442f-b2eb-0e18d30c837c', 'Japan', 'Japan', '/countries/asia/japan', null, 'Japan', 'Japan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 30, 'Eastern Asia', null, null, 392, 'f', 'f', 'f', 'JP', 'JPN'),('6a812069-9759-4b9b-928a-61cd4a8b0f7f', 'Mongolia', 'Mongolia', '/countries/asia/mongolia', null, 'Mongolia', 'Mongolia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 30, 'Eastern Asia', null, null, 496, 'f', 't', 'f', 'MN', 'MNG'),('74eac5fb-96f1-4fa6-b9a8-4791a8b6bb5b', 'Republic of Korea', 'Republic of Korea', '/countries/asia/republic%20of%20korea', null, 'Republic of Korea', 'Republic of Korea', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 30, 'Eastern Asia', null, null, 410, 'f', 'f', 'f', 'KR', 'KOR'),('3c896894-3835-4dc4-8c20-f06cde96f582', 'Brunei Darussalam', 'Brunei Darussalam', '/countries/asia/brunei%20darussalam', null, 'Brunei Darussalam', 'Brunei Darussalam', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 35, 'South-eastern Asia', null, null, 96, 'f', 'f', 'f', 'BN', 'BRN'),('2a0540d4-f7db-4b42-8634-1aa1d6309ad2', 'Cambodia', 'Cambodia', '/countries/asia/cambodia', null, 'Cambodia', 'Cambodia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 35, 'South-eastern Asia', null, null, 116, 't', 'f', 'f', 'KH', 'KHM'),('426b87a7-c716-4f86-9f96-be3ffca00e31', 'Indonesia', 'Indonesia', '/countries/asia/indonesia', null, 'Indonesia', 'Indonesia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 35, 'South-eastern Asia', null, null, 360, 'f', 'f', 'f', 'ID', 'IDN'),('dac65c36-84fa-48bd-83c9-9ec18a0fdcc8', 'Lao People''s Democratic Republic', 'Lao People''s Democratic Republic', '/countries/asia/lao%20peoples%20democratic%20republic', null, 'Lao People''s Democratic Republic', 'Lao People''s Democratic Republic', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 35, 'South-eastern Asia', null, null, 418, 't', 't', 'f', 'LA', 'LAO'),('d8498772-d4c0-48c6-9d3d-27c0ca0a0951', 'Malaysia', 'Malaysia', '/countries/asia/malaysia', null, 'Malaysia', 'Malaysia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 35, 'South-eastern Asia', null, null, 458, 'f', 'f', 'f', 'MY', 'MYS'),('e12ae313-2902-447d-a4ca-f425a1453679', 'Myanmar', 'Myanmar', '/countries/asia/myanmar', null, 'Myanmar', 'Myanmar', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 35, 'South-eastern Asia', null, null, 104, 't', 'f', 'f', 'MM', 'MMR'),('1e8b89f0-d851-4a4a-9451-ff270c0bccd0', 'Philippines', 'Philippines', '/countries/asia/philippines', null, 'Philippines', 'Philippines', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 35, 'South-eastern Asia', null, null, 608, 'f', 'f', 'f', 'PH', 'PHL'),('3e79e98c-1209-4d44-8516-f0583535e04d', 'Singapore', 'Singapore', '/countries/asia/singapore', null, 'Singapore', 'Singapore', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 35, 'South-eastern Asia', null, null, 702, 'f', 'f', 't', 'SG', 'SGP'),('a4cd8d64-77da-4572-b892-3dbcd02125f9', 'Thailand', 'Thailand', '/countries/asia/thailand', null, 'Thailand', 'Thailand', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 35, 'South-eastern Asia', null, null, 764, 'f', 'f', 'f', 'TH', 'THA'),('e13e9154-cb4f-4342-b32f-f3e365c68fdb', 'Timor-Leste', 'Timor-Leste', '/countries/asia/timor-leste', null, 'Timor-Leste', 'Timor-Leste', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 35, 'South-eastern Asia', null, null, 626, 't', 'f', 't', 'TL', 'TLS'),('872c4162-e72a-48bd-b770-b036669314b8', 'Viet Nam', 'Viet Nam', '/countries/asia/viet%20nam', null, 'Viet Nam', 'Viet Nam', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 35, 'South-eastern Asia', null, null, 704, 'f', 'f', 'f', 'VN', 'VNM'),('dca25bf3-8079-45c8-ac2a-7f214e70e747', 'Afghanistan', 'Afghanistan', '/countries/asia/afghanistan', null, 'Afghanistan', 'Afghanistan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 34, 'Southern Asia', null, null, 4, 't', 't', 'f', 'AF', 'AFG'),('57266f2c-b41c-43d3-86e7-96ede8a125b2', 'Bangladesh', 'Bangladesh', '/countries/asia/bangladesh', null, 'Bangladesh', 'Bangladesh', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 34, 'Southern Asia', null, null, 50, 't', 'f', 'f', 'BD', 'BGD'),('57a495bd-3f55-41ee-9655-0084be732bc1', 'Bhutan', 'Bhutan', '/countries/asia/bhutan', null, 'Bhutan', 'Bhutan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 34, 'Southern Asia', null, null, 64, 'f', 't', 'f', 'BT', 'BTN'),('5fe0ca1b-8f69-488e-b0d1-e108c10ce738', 'India', 'India', '/countries/asia/india', null, 'India', 'India', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 34, 'Southern Asia', null, null, 356, 'f', 'f', 'f', 'IN', 'IND'),('3284b067-f512-4a6b-88f6-b6a7e4fc2cd6', 'Iran (Islamic Republic of)', 'Iran (Islamic Republic of)', '/countries/asia/iran%20&#40;islamic%20republic%20of&#41;', null, 'Iran (Islamic Republic of)', 'Iran (Islamic Republic of)', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 34, 'Southern Asia', null, null, 364, 'f', 'f', 'f', 'IR', 'IRN'),('9e2961fe-cc9e-41a0-b852-1c63483a0ea9', 'Maldives', 'Maldives', '/countries/asia/maldives', null, 'Maldives', 'Maldives', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 34, 'Southern Asia', null, null, 462, 'f', 'f', 't', 'MV', 'MDV'),('f2ff4220-b968-46bf-a522-fea25cfd8fe9', 'Nepal', 'Nepal', '/countries/asia/nepal', null, 'Nepal', 'Nepal', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 34, 'Southern Asia', null, null, 524, 't', 't', 'f', 'NP', 'NPL');
INSERT INTO osc_physrisk.osc_physrisk_backend.geo_country(core_id, core_name, core_name_display, core_slug, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, core_version, core_dataset_id, un_global_code, un_global_name, un_region_code, un_region_name, un_subregion_code, un_subregion_name, un_intermediateregion_code, un_intermediateregion_name, un_code_m49, un_is_ldc, un_is_lldc, un_is_sids, iso_code_alpha2, iso_code_alpha3) VALUES ('eb4c6e23-a206-41f6-98cf-479bacc52cc3', 'Pakistan', 'Pakistan', '/countries/asia/pakistan', null, 'Pakistan', 'Pakistan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 34, 'Southern Asia', null, null, 586, 'f', 'f', 'f', 'PK', 'PAK'),('685c580d-9a6b-4716-8cda-c3b616c6feab', 'Sri Lanka', 'Sri Lanka', '/countries/asia/sri%20lanka', null, 'Sri Lanka', 'Sri Lanka', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 34, 'Southern Asia', null, null, 144, 'f', 'f', 'f', 'LK', 'LKA'),('475c2971-a6b5-4fb2-959d-43135f34d89e', 'Armenia', 'Armenia', '/countries/asia/armenia', null, 'Armenia', 'Armenia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 51, 'f', 't', 'f', 'AM', 'ARM'),('ac3cf78e-f78c-44cc-8548-86c32485cff1', 'Azerbaijan', 'Azerbaijan', '/countries/asia/azerbaijan', null, 'Azerbaijan', 'Azerbaijan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 31, 'f', 't', 'f', 'AZ', 'AZE'),('5cb73314-4c1f-4e3b-8930-b06a7354fc7c', 'Georgia', 'Georgia', '/countries/asia/georgia', null, 'Georgia', 'Georgia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 268, 'f', 'f', 'f', 'GE', 'GEO'),('35a87edb-1710-4935-8fcd-9b30fe49819e', 'Iraq', 'Iraq', '/countries/asia/iraq', null, 'Iraq', 'Iraq', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 368, 'f', 'f', 'f', 'IQ', 'IRQ'),('fafd54fa-9f25-4b57-a27e-d790a4ba7acd', 'Israel', 'Israel', '/countries/asia/israel', null, 'Israel', 'Israel', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 376, 'f', 'f', 'f', 'IL', 'ISR'),('5f653333-7ff9-41d4-a8b8-9976fa6bfce3', 'Jordan', 'Jordan', '/countries/asia/jordan', null, 'Jordan', 'Jordan', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 400, 'f', 'f', 'f', 'JO', 'JOR'),('297f2eba-4c10-48c5-923d-6f2d2d1e1423', 'Kuwait', 'Kuwait', '/countries/asia/kuwait', null, 'Kuwait', 'Kuwait', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 414, 'f', 'f', 'f', 'KW', 'KWT'),('20d9b01b-d72c-4a7e-afb9-fb090396ec4e', 'Lebanon', 'Lebanon', '/countries/asia/lebanon', null, 'Lebanon', 'Lebanon', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 422, 'f', 'f', 'f', 'LB', 'LBN'),('bd46cbf3-e8c2-47dd-bd5d-b84362f30706', 'Oman', 'Oman', '/countries/asia/oman', null, 'Oman', 'Oman', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 512, 'f', 'f', 'f', 'OM', 'OMN'),('92246ddc-adc9-4cfd-b72a-6fec70894e2a', 'Qatar', 'Qatar', '/countries/asia/qatar', null, 'Qatar', 'Qatar', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 634, 'f', 'f', 'f', 'QA', 'QAT'),('4407084d-4bfe-4636-8857-791b85d15018', 'Saudi Arabia', 'Saudi Arabia', '/countries/asia/saudi%20arabia', null, 'Saudi Arabia', 'Saudi Arabia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 682, 'f', 'f', 'f', 'SA', 'SAU'),('99df885b-c47f-4c14-b135-67ab40f95b81', 'State of Palestine', 'State of Palestine', '/countries/asia/state%20of%20palestine', null, 'State of Palestine', 'State of Palestine', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 275, null, 'f', 'f', 'PS', 'PSE'),('3a43a9f5-3858-4a3c-93dd-9a9e28c97665', 'Syrian Arab Republic', 'Syrian Arab Republic', '/countries/asia/syrian%20arab%20republic', null, 'Syrian Arab Republic', 'Syrian Arab Republic', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 760, null, 'f', 'f', 'SY', 'SYR'),('5f93392e-ba13-49ce-ba85-3554002b769f', 'Türkiye', 'Türkiye', '/countries/asia/turkiye', null, 'Türkiye', 'Türkiye', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 792, null, 'f', 'f', 'TR', 'TUR'),('42b00923-bd6c-4465-9a10-87f1f40b90fc', 'United Arab Emirates', 'United Arab Emirates', '/countries/asia/united%20arab%20emirates', null, 'United Arab Emirates', 'United Arab Emirates', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 784, null, 'f', 'f', 'AE', 'ARE'),('bcce717a-6a60-4c60-af93-0a986394f959', 'Yemen', 'Yemen', '/countries/asia/yemen', null, 'Yemen', 'Yemen', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 142, 'Asia', 145, 'Western Asia', null, null, 887, 't', 'f', 'f', 'YE', 'YEM'),('d598fcde-ae96-40be-9cf0-3429e471e593', 'Belarus', 'Belarus', '/countries/europe/belarus', null, 'Belarus', 'Belarus', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 151, 'Eastern Europe', null, null, 112, 'f', 'f', 'f', 'BY', 'BLR'),('9e17ea07-590c-4501-a355-84fdc3e04324', 'Bulgaria', 'Bulgaria', '/countries/europe/bulgaria', null, 'Bulgaria', 'Bulgaria', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 151, 'Eastern Europe', null, null, 100, 'f', 'f', 'f', 'BG', 'BGR'),('890e3b73-dfda-4e69-aa10-22f4b33a2067', 'Czechia', 'Czechia', '/countries/europe/czechia', null, 'Czechia', 'Czechia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 151, 'Eastern Europe', null, null, 203, 'f', 'f', 'f', 'CZ', 'CZE'),('d1292c55-37df-4ef4-895f-d45df8643272', 'Hungary', 'Hungary', '/countries/europe/hungary', null, 'Hungary', 'Hungary', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 151, 'Eastern Europe', null, null, 348, 'f', 'f', 'f', 'HU', 'HUN'),('08831470-2c66-4e7a-a92f-dab3283f1679', 'Poland', 'Poland', '/countries/europe/poland', null, 'Poland', 'Poland', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 151, 'Eastern Europe', null, null, 616, 'f', 'f', 'f', 'PL', 'POL'),('43a18eba-91f6-4417-8898-7b461ef532f1', 'Republic of Moldova', 'Republic of Moldova', '/countries/europe/republic%20of%20moldova', null, 'Republic of Moldova', 'Republic of Moldova', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 151, 'Eastern Europe', null, null, 498, 'f', 't', 'f', 'MD', 'MDA'),('376b2dd2-0a48-41d5-9a58-674f125da437', 'Romania', 'Romania', '/countries/europe/romania', null, 'Romania', 'Romania', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 151, 'Eastern Europe', null, null, 642, 'f', 'f', 'f', 'RO', 'ROU');
INSERT INTO osc_physrisk.osc_physrisk_backend.geo_country(core_id, core_name, core_name_display, core_slug, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, core_version, core_dataset_id, un_global_code, un_global_name, un_region_code, un_region_name, un_subregion_code, un_subregion_name, un_intermediateregion_code, un_intermediateregion_name, un_code_m49, un_is_ldc, un_is_lldc, un_is_sids, iso_code_alpha2, iso_code_alpha3) VALUES ('987076e5-485f-4763-b424-cc85b2d826f4', 'Russian Federation', 'Russian Federation', '/countries/europe/russian%20federation', null, 'Russian Federation', 'Russian Federation', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 151, 'Eastern Europe', null, null, 643, 'f', 'f', 'f', 'RU', 'RUS'),('9a72ee19-b113-492e-87f2-07868e714c9d', 'Slovakia', 'Slovakia', '/countries/europe/slovakia', null, 'Slovakia', 'Slovakia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 151, 'Eastern Europe', null, null, 703, 'f', 'f', 'f', 'SK', 'SVK'),('d765379b-9080-418c-a9c0-e231942c3403', 'Ukraine', 'Ukraine', '/countries/europe/ukraine', null, 'Ukraine', 'Ukraine', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 151, 'Eastern Europe', null, null, 804, 'f', 'f', 'f', 'UA', 'UKR'),('ee18720b-127f-4aa7-96c6-ea14286d8b28', 'Åland Islands', 'Åland Islands', '/countries/europe/aland%20islands', null, 'Åland Islands', 'Åland Islands', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 248, 'f', 'f', 'f', 'AX', 'ALA'),('581b9523-dfee-4b2c-8df1-5b6b4050ceb4', 'Denmark', 'Denmark', '/countries/europe/denmark', null, 'Denmark', 'Denmark', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 208, 'f', 'f', 'f', 'DK', 'DNK'),('48fb9b5c-e5a7-4ca4-9890-bb8230889fd4', 'Estonia', 'Estonia', '/countries/europe/estonia', null, 'Estonia', 'Estonia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 233, 'f', 'f', 'f', 'EE', 'EST'),('9b7ee5f8-26b2-4045-a901-33579b518df1', 'Faroe Islands', 'Faroe Islands', '/countries/europe/faroe%20islands', null, 'Faroe Islands', 'Faroe Islands', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 234, 'f', 'f', 'f', 'FO', 'FRO'),('7d3337fb-9068-44b0-98fc-600e0596d89e', 'Finland', 'Finland', '/countries/europe/finland', null, 'Finland', 'Finland', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 246, 'f', 'f', 'f', 'FI', 'FIN'),('5a43f155-40e8-4ef1-b91e-65d4487c0560', 'Guernsey', 'Guernsey', '/countries/europe/guernsey', null, 'Guernsey', 'Guernsey', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 831, 'f', 'f', 'f', 'GG', 'GGY'),('cfb0e29e-f17a-48b8-a978-9aedacbe65bf', 'Iceland', 'Iceland', '/countries/europe/iceland', null, 'Iceland', 'Iceland', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 352, 'f', 'f', 'f', 'IS', 'ISL'),('2b7ff205-b0b5-48af-923f-cbc5316b628b', 'Ireland', 'Ireland', '/countries/europe/ireland', null, 'Ireland', 'Ireland', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 372, 'f', 'f', 'f', 'IE', 'IRL'),('3eee56ed-0ac0-4fa5-8594-85b9a743ed95', 'Isle of Man', 'Isle of Man', '/countries/europe/isle%20of%20man', null, 'Isle of Man', 'Isle of Man', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 833, 'f', 'f', 'f', 'IM', 'IMN'),('6d9fe606-556d-478c-9f31-41ca8688350b', 'Jersey', 'Jersey', '/countries/europe/jersey', null, 'Jersey', 'Jersey', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 832, 'f', 'f', 'f', 'JE', 'JEY'),('3716deb2-f881-498b-877e-5b03243a232d', 'Latvia', 'Latvia', '/countries/europe/latvia', null, 'Latvia', 'Latvia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 428, 'f', 'f', 'f', 'LV', 'LVA'),('47d787e4-fcfc-46c8-99a1-2095675acf95', 'Lithuania', 'Lithuania', '/countries/europe/lithuania', null, 'Lithuania', 'Lithuania', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 440, 'f', 'f', 'f', 'LT', 'LTU'),('541f741e-7c8e-4b93-b047-c12a842d5ced', 'Norway', 'Norway', '/countries/europe/norway', null, 'Norway', 'Norway', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 578, 'f', 'f', 'f', 'NO', 'NOR'),('80101108-d7d6-4eb3-89c8-8c24c2e737f0', 'Svalbard and Jan Mayen Islands', 'Svalbard and Jan Mayen Islands', '/countries/europe/svalbard%20and%20jan%20mayen%20islands', null, 'Svalbard and Jan Mayen Islands', 'Svalbard and Jan Mayen Islands', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 744, 'f', 'f', 'f', 'SJ', 'SJM'),('6031e3d5-1f2a-444c-9fa1-81ada0996223', 'Sweden', 'Sweden', '/countries/europe/sweden', null, 'Sweden', 'Sweden', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 752, 'f', 'f', 'f', 'SE', 'SWE'),('a593fc11-ac1a-4b5d-abd2-4471103e67dd', 'United Kingdom of Great Britain and Northern Ireland', 'United Kingdom of Great Britain and Northern Ireland', '/countries/europe/united%20kingdom%20of%20great%20britain%20and%20northern%20ireland', null, 'United Kingdom of Great Britain and Northern Ireland', 'United Kingdom of Great Britain and Northern Ireland', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 154, 'Northern Europe', null, null, 826, 'f', 'f', 'f', 'GB', 'GBR'),('0233d466-72da-4e22-919e-604804f924c8', 'Albania', 'Albania', '/countries/europe/albania', null, 'Albania', 'Albania', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 39, 'Southern Europe', null, null, 8, 'f', 'f', 'f', 'AL', 'ALB'),('6f0eead4-ef3a-402e-aea2-56b525193dee', 'Andorra', 'Andorra', '/countries/europe/andorra', null, 'Andorra', 'Andorra', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 39, 'Southern Europe', null, null, 20, 'f', 'f', 'f', 'AD', 'AND'),('7411f417-42dc-41ec-afd0-e15afc06c9be', 'Bosnia and Herzegovina', 'Bosnia and Herzegovina', '/countries/europe/bosnia%20and%20herzegovina', null, 'Bosnia and Herzegovina', 'Bosnia and Herzegovina', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 39, 'Southern Europe', null, null, 70, 'f', 'f', 'f', 'BA', 'BIH'),('e68920b6-7845-46ad-9eb9-f9ca1d88ea7c', 'Croatia', 'Croatia', '/countries/europe/croatia', null, 'Croatia', 'Croatia', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 39, 'Southern Europe', null, null, 191, 'f', 'f', 'f', 'HR', 'HRV'),('a87be65e-6be0-45d3-a969-f0043f346d8e', 'Gibraltar', 'Gibraltar', '/countries/europe/gibraltar', null, 'Gibraltar', 'Gibraltar', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 39, 'Southern Europe', null, null, 292, 'f', 'f', 'f', 'GI', 'GIB'),('27831361-6d7f-412e-a445-5dc29287f75a', 'Greece', 'Greece', '/countries/europe/greece', null, 'Greece', 'Greece', '{}', '2024-07-14 20:00:00-04', 1, '2024-07-14 20:00:00-04', 1, 'f', null, null, 'en', ' core_checksum', 1, null, 't', 't', 1, '2024-07-14 20:00:00-04', '1', '7c03ca95-efbc-406a-a245-9870cf54fedf', 1, 'World', 150, 'Europe', 39, 'Southern Europe', null, null, 300, 'f', 'f', 'f', 'GR', 'GRC');


INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('8b3b38fd-a6f5-4878-b4b4-0a251ec0363a', 'Unknown/Not Selected', 'Unknown/Not Selected', 'Unknown/Not Selected', 'Unknown/Not Selected','{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'f098938cd8cc7c4f1c71c8e97db0f075',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_slug, core_description_full, core_description_short, core_name_display, core_name,core_tags,  core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('7faf5507-9a0a-4554-aef3-6efe5cffee63','en-climate-scenario-historical', 'History (before 2014). See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'History (before 2014)', 'History (- 2014)', 'History (- 2014)','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_slug, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('0ab07b1d-864d-4f0a-9656-29e9b088df3b','en-climate-scenario-SSP1-19', 'SSP1-1.9 -  very low GHG emissions: CO2 emissions cut to net zero around 2050. See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'SSP1-1.9', 'SSP1-1.9', 'SSP1-1.9','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_slug, core_description_full, core_description_short, core_name_display, core_name,core_tags,  core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('cb68b9c6-6dff-4f0d-8650-768249f2689d', 'en-climate-scenario-SSP1-26', 'SSP1-2.6 - low GHG emissions: CO2 emissions cut to net zero around 2075. See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'SSP1-2.6', 'SSP1-2.6', 'SSP1-2.6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_slug, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('5d1081f3-fd0e-4f53-b06b-8358be82644c', 'en-climate-scenario-SSP2-45', 'SSP2-4.5 - intermediate GHG emissions: CO2 emissions around current levels until 2050, then falling but not reaching net zero by 2100. See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'SSP2-4.5', 'SSP2-4.5', 'SSP2-4.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_slug, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('f9ba343c-78b6-426c-be56-5d845e305d58', 'en-climate-scenario-SSP3-70', 'SSP3-7.0 - high GHG emissions: CO2 emissions double by 2100. See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'SSP3-7.0', 'SSP3-7.0', 'SSP3-7.0','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_slug, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('fd76becb-28e9-424b-8c6e-c96aaf6988e5', 'en-climate-scenario-SSP5-85', 'SSP5-8.5 - very high GHG emissions: CO2 emissions triple by 2075. See "Shared Socioeconomic Pathways in the IPCC Sixth Assessment Report" (https://www.ipcc.ch/report/sixth-assessment-report-working-group-i/).', 'SSP5-8.5', 'SSP5-8.5', 'SSP5-8.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_slug, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('3cd34fae-620a-47ae-862c-5349533e73b8', 'en-climate-scenario-RCP26', 'RCP2.6 - Peak in radiative forcing at ~ 3 W/m2 before 2100 and decline. See "REPRESENTATIVE CONCENTRATION PATHWAYS (RCPs)" (https://sedac.ciesin.columbia.edu/ddc/ar5_scenario_process/RCPs.html)', 'RCP2.6', 'RCP2.6', 'RCP2.6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_slug, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('e64b3f6a-69a6-403f-a4bb-e099fe099222', 'en-climate-scenario-RCP45', 'RCP4.5 - Stabilization without overshoot pathway to 4.5 W/m2 at stabilization after 2100. See "REPRESENTATIVE CONCENTRATION PATHWAYS (RCPs)" (https://sedac.ciesin.columbia.edu/ddc/ar5_scenario_process/RCPs.html)', 'RCP4.5', 'RCP4.5', 'RCP4.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_slug, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('bb01865e-2a53-48a3-9437-35764ba52639',  'en-climate-scenario-RCP6', 'RCP6 - Stabilization without overshoot pathway to 6 W/m2 at stabilization after 2100. See "REPRESENTATIVE CONCENTRATION PATHWAYS (RCPs)" (https://sedac.ciesin.columbia.edu/ddc/ar5_scenario_process/RCPs.html)', 'RCP6', 'RCP6', 'RCP6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_slug, core_description_full, core_description_short, core_name_display, core_name,core_tags,  core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('893a6b75-8660-47ff-80d3-08b4ddc259c3', 'en-climate-scenario-RCP85', 'RCP8.5 - Rising radiative forcing pathway leading to 8.5 W/m2 in 2100. See "REPRESENTATIVE CONCENTRATION PATHWAYS (RCPs)" (https://sedac.ciesin.columbia.edu/ddc/ar5_scenario_process/RCPs.html)', 'RCP8.5', 'RCP8.5', 'RCP8.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y', 1,'2024-07-15T00:00:01Z')
;

INSERT INTO osc_physrisk_vulnerability_analysis.vulnerability_type
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	(-1, 'Unknown Damage or Disruption', 'Unknown Damage or Disruption', 'Unknown Damage or Disruption', 'Unknown Damage or Disruption','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'f',NULL,NULL, 'en', 'core_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_vulnerability_analysis.vulnerability_type
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	(1, 'Damage as percentage of asset value', 'Damage as percentage of asset value', 'Damage as percentage of asset value', 'Damage as percentage of asset value','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'f',NULL,NULL, 'en', 'core_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_vulnerability_analysis.vulnerability_type
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	(2, 'Disruption in number of production units', 'Disruption in number of production units', 'Disruption in number of production units', 'Disruption in number of production units','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'f',NULL,NULL, 'en', 'core_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z')
;

INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	(-1, 'Unknown Damage or Disruption', 'Unknown Damage or Disruption', 'Unknown Damage or Disruption', 'Unknown Damage or Disruption','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'f',NULL,NULL, 'en', 'core_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, accounting_category)
VALUES 
	(1, 'Asset repairs and construction', 'Asset repairs and construction', 'Asset repairs and construction','Asset repairs and construction', '{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1, 'false',NULL,NULL, 'en', 'core_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z','Capex' );
INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, accounting_category)
VALUES 
	(2, 'Revenue loss due to asset restoration', 'Revenue loss due to asset restoration', 'Revenue loss due to asset restoration','Revenue loss due to asset restoration', '{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1, 'false',NULL,NULL, 'en', 'core_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z','Revenue' );
INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, accounting_category)
VALUES 
	(3, 'Revenue loss due to productivity impact', 'Revenue loss due to productivity impact', 'Revenue loss due to productivity impact','Revenue loss due to productivity impact', '{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1, 'false',NULL,NULL, 'en', 'core_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z','Revenue' );
INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, accounting_category)
VALUES 
	(4, 'Recurring cost increase (chronic)', 'Recurring cost increase (chronic)', 'Recurring cost increase (chronic)','Recurring cost increase (chronic)', '{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1, 'false',NULL,NULL, 'en', 'core_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z','OpEx' );
INSERT INTO osc_physrisk_financial_analysis.financial_impact_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, accounting_category)
VALUES 
	(5, 'Recurring cost increase (acute)', 'Recurring cost increase (acute)', 'Recurring cost increase (acute)','Recurring cost increase (acute)', '{ "key1":"value1", "key2":"value2"}', '2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1, 'false',NULL,NULL, 'en', 'core_checksum',1,NULL, 't',  't',1 ,'2024-07-15T00:00:01Z','OpEx' );
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('8159d927-e596-444d-8f1a-494494339fad', 'en-climate-hazard-type-unknown', 'Unknown hazard/Not selected', 'Unknown hazard/Not selected', 'Unknown hazard/Not selected', 'Unknown hazard/Not selected', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('63ed7943-c4c4-43ea-abd2-86bb1997a094', 'en-climate-hazard-type-inundation-riverine', 'Riverine Inundation', 'Riverine Inundation', 'Riverine Inundation', 'Riverine Inundation', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y', 'y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('28a095cd-4cde-40a1-90d9-cbb0ca673c06', 'en-climate-hazard-type-inundation-coastal', 'Coastal Inundation', 'Coastal Inundation', 'Coastal Inundation', 'Coastal Inundation', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug,core_name,  core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('338ea109-828e-4aaf-b212-12d8eaf70a7e', 'en-climate-hazard-type-inundation-combined','Combined Inundation', 'Combined Inundation', 'Combined Inundation', 'Combined Inundation', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('d08db675-ee1e-48fe-b9e1-b0da27de8f2b', 'en-climate-hazard-type-chronic-heat', 'Chronic Heat', 'Chronic Heat', 'Chronic Heat', 'Chronic Heat', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('64fee0d3-b78b-49bf-911a-029695585d6a', 'en-climate-hazard-type-fire','Fire', 'Fire', 'Fire', 'Fire', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('35ace20f-86dc-4735-9536-129b51b6d25d', 'en-climate-hazard-type-drought','Drought', 'Drought', 'Drought', 'Drought', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug,core_name,  core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('2faed491-2c5d-499e-9568-fad6e3b3c0ec', 'en-climate-hazard-type-precipitation','Precipitation', 'Precipitation', 'Precipitation', 'Precipitation', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('29514258-18cb-4f2b-8798-203e0d513803', 'en-climate-hazard-type-water-risk','Water Risk', 'Water Risk', 'Water Risk', 'Water Risk', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('e4e4e199-367e-4568-824d-3f916e355567', 'en-climate-hazard-type-hail','Hail', 'Hail', 'Hail', 'Hail', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('0184b858-404d-4282-8f0d-2b4c42f7acd7', 'en-climate-hazard-type-wind','Wind', 'Wind', 'Wind', 'Wind', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard
	(core_id, core_slug, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('4441cf3b-1460-4131-aff6-b51bf01cd084', 'en-climate-hazard-type-subsidence','subsidence', 'subsidence', 'subsidence', 'subsidence', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('57a7df66-420d-4730-9669-1547f8200272', 'Flood depth (TUDelft)', 'Flood depth (TUDelft)', 'Flood depth (TUDelft)', 'Flood depth (TUDelft)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('5fb27cc6-ee01-4133-b2e9-6c1f22ed5b40', 'Flood depth/GFDL-ESM2M (WRI)', 'Flood depth/GFDL-ESM2M (WRI)', 'Flood depth/GFDL-ESM2M (WRI)', 'Flood depth/GFDL-ESM2M (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('79555143-ba2a-47b0-bbe7-7aac3685dedb', 'Flood depth/HadGEM2-ES (WRI)', 'Flood depth/HadGEM2-ES (WRI)', 'Flood depth/HadGEM2-ES (WRI)', 'Flood depth/HadGEM2-ES (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('6fe5ccb1-5d38-4a3e-b0a5-d4cc70981035', 'Flood depth/IPSL-CM5A-LR (WRI)', 'Flood depth/IPSL-CM5A-LR (WRI)', 'Flood depth/IPSL-CM5A-LR (WRI)', 'Flood depth/IPSL-CM5A-LR (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('e4f10569-95be-4b5b-8d34-763eb95e730b', 'Flood depth/MIROC-ESM-CHEM (WRI)', 'Flood depth/MIROC-ESM-CHEM (WRI)', 'Flood depth/MIROC-ESM-CHEM (WRI)', 'Flood depth/MIROC-ESM-CHEM (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('690e01eb-f7e6-4fbf-84e4-f8195656abb3', 'Flood depth/NorESM1-M (WRI)', 'Flood depth/NorESM1-M (WRI)', 'Flood depth/NorESM1-M (WRI)', 'Flood depth/NorESM1-M (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('5f396b97-badc-40d2-b0b3-c8be8f3053ba', 'Flood depth/baseline (WRI)', 'Flood depth/baseline (WRI)', 'Flood depth/baseline (WRI)', 'Flood depth/baseline (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('901cbd14-9223-4d36-8ab4-658945d913a4', 'Standard of protection (TUDelft)', 'Standard of protection (TUDelft)', 'Standard of protection (TUDelft)', 'Standard of protection (TUDelft)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '63ed7943-c4c4-43ea-abd2-86bb1997a094')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('be44d6fb-08cb-4f52-8ff2-bf1b7366a7a0', 'Flood depth/5%, no subscore_idence (WRI)', 'Flood depth/5%, no subscore_idence (WRI)', 'Flood depth/5%, no subscore_idence (WRI)', 'Flood depth/5%, no subscore_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('c87fc5c3-c2ae-4732-ba52-7d9156044d7b', 'Flood depth/5%, with subscore_idence (WRI)', 'Flood depth/5%, with subscore_idence (WRI)', 'Flood depth/5%, with subscore_idence (WRI)', 'Flood depth/5%, with subscore_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('60c90be9-5cfb-4f6a-b9eb-e84e7da5a456', 'Flood depth/50%, no subscore_idence (WRI)', 'Flood depth/50%, no subscore_idence (WRI)', 'Flood depth/50%, no subscore_idence (WRI)', 'Flood depth/50%, no subscore_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('e7623e9e-649e-460a-8b81-ae9d01711f75', 'Flood depth/50%, with subscore_idence (WRI)', 'Flood depth/50%, with subscore_idence (WRI)', 'Flood depth/50%, with subscore_idence (WRI)', 'Flood depth/50%, with subscore_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('28fbe059-a661-4fe6-8ba7-0fa626a9312b', 'Flood depth/95%, no subscore_idence (WRI)', 'Flood depth/95%, no subscore_idence (WRI)', 'Flood depth/95%, no subscore_idence (WRI)', 'Flood depth/95%, no subscore_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('ea005e03-f025-4aa4-a37e-981eea5bcfdb', 'Flood depth/95%, with subscore_idence (WRI)', 'Flood depth/95%, with subscore_idence (WRI)', 'Flood depth/95%, with subscore_idence (WRI)', 'Flood depth/95%, with subscore_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('12651bc5-04a2-4225-ba25-f1c0e09bdb90', 'Flood depth/baseline, no subscore_idence (WRI)', 'Flood depth/baseline, no subscore_idence (WRI)', 'Flood depth/baseline, no subscore_idence (WRI)', 'Flood depth/baseline, no subscore_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('6ba57474-6c7a-4ea3-aca8-25e30f27cec1', 'Flood depth/baseline, with subscore_idence (WRI)', 'Flood depth/baseline, with subscore_idence (WRI)', 'Flood depth/baseline, with subscore_idence (WRI)', 'Flood depth/baseline, with subscore_idence (WRI)', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', '28a095cd-4cde-40a1-90d9-cbb0ca673c06')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('e0b5afc2-eed8-4760-9667-c14fdbf374db', 'Days with average temperature above 25°C/ACCESS-CM2', 'Days with average temperature above 25°C/ACCESS-CM2', 'Days with average temperature above 25°C/ACCESS-CM2', 'Days with average temperature above 25°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('b795a8af-12cc-4773-83ee-a50badd1fe74', 'Days with average temperature above 25°C/CMCC-ESM2', 'Days with average temperature above 25°C/CMCC-ESM2', 'Days with average temperature above 25°C/CMCC-ESM2', 'Days with average temperature above 25°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('81213608-0a01-42b0-a54f-a070fb104b95', 'Days with average temperature above 25°C/CNRM-CM6-1', 'Days with average temperature above 25°C/CNRM-CM6-1', 'Days with average temperature above 25°C/CNRM-CM6-1', 'Days with average temperature above 25°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('98692238-6a8f-4e58-a779-9f96eeaf1abd', 'Days with average temperature above 25°C/MIROC6', 'Days with average temperature above 25°C/MIROC6', 'Days with average temperature above 25°C/MIROC6', 'Days with average temperature above 25°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('3dbf253a-d880-4440-baa5-3e4a9fcac355', 'Days with average temperature above 25°C/ESM1-2-LR', 'Days with average temperature above 25°C/ESM1-2-LR', 'Days with average temperature above 25°C/ESM1-2-LR', 'Days with average temperature above 25°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('5fcca03b-ffff-4632-b896-78ceb9777e4b', 'Days with average temperature above 25°C/NorESM2-MM', 'Days with average temperature above 25°C/NorESM2-MM', 'Days with average temperature above 25°C/NorESM2-MM', 'Days with average temperature above 25°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('77f04d46-303f-40f2-a892-d0068d6ab64a', 'Days with average temperature above 30°C/ACCESS-CM2', 'Days with average temperature above 30°C/ACCESS-CM2', 'Days with average temperature above 30°C/ACCESS-CM2', 'Days with average temperature above 30°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('c47e4dfa-e850-4060-aed9-af9100c65986', 'Days with average temperature above 30°C/CMCC-ESM2', 'Days with average temperature above 30°C/CMCC-ESM2', 'Days with average temperature above 30°C/CMCC-ESM2', 'Days with average temperature above 30°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('ba1e06be-1cf5-4b5d-8f93-8f64e47af2b8', 'Days with average temperature above 30°C/CNRM-CM6-1', 'Days with average temperature above 30°C/CNRM-CM6-1', 'Days with average temperature above 30°C/CNRM-CM6-1', 'Days with average temperature above 30°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('b882a67c-acea-4dbe-9939-1594775e6f78', 'Days with average temperature above 30°C/MIROC6', 'Days with average temperature above 30°C/MIROC6', 'Days with average temperature above 30°C/MIROC6', 'Days with average temperature above 30°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('0ae16260-45b7-48fe-924e-a2bd2bc25f39', 'Days with average temperature above 30°C/ESM1-2-LR', 'Days with average temperature above 30°C/ESM1-2-LR', 'Days with average temperature above 30°C/ESM1-2-LR', 'Days with average temperature above 30°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('151fe933-f1be-4fb1-bcaf-d534a5023c78', 'Days with average temperature above 30°C/NorESM2-MM', 'Days with average temperature above 30°C/NorESM2-MM', 'Days with average temperature above 30°C/NorESM2-MM', 'Days with average temperature above 30°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('96e6fcc5-d843-4f59-9746-2d0d341b6bdc', 'Days with average temperature above 35°C/ACCESS-CM2', 'Days with average temperature above 35°C/ACCESS-CM2', 'Days with average temperature above 35°C/ACCESS-CM2', 'Days with average temperature above 35°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('2c485594-5220-4e5e-85f0-3e67a09bacd9', 'Days with average temperature above 35°C/CMCC-ESM2', 'Days with average temperature above 35°C/CMCC-ESM2', 'Days with average temperature above 35°C/CMCC-ESM2', 'Days with average temperature above 35°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('db9a09b3-3386-4081-bf0c-79b6c8ebd38e', 'Days with average temperature above 35°C/CNRM-CM6-1', 'Days with average temperature above 35°C/CNRM-CM6-1', 'Days with average temperature above 35°C/CNRM-CM6-1', 'Days with average temperature above 35°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('3f77c47d-9a26-4a3f-a289-ecf56678ec69', 'Days with average temperature above 35°C/MIROC6', 'Days with average temperature above 35°C/MIROC6', 'Days with average temperature above 35°C/MIROC6', 'Days with average temperature above 35°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('f197975a-acea-4514-acbf-35cb070b0b5c', 'Days with average temperature above 35°C/ESM1-2-LR', 'Days with average temperature above 35°C/ESM1-2-LR', 'Days with average temperature above 35°C/ESM1-2-LR', 'Days with average temperature above 35°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('d4d610b4-060e-4212-9b0c-05fe551a0128', 'Days with average temperature above 35°C/NorESM2-MM', 'Days with average temperature above 35°C/NorESM2-MM', 'Days with average temperature above 35°C/NorESM2-MM', 'Days with average temperature above 35°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('f38a4529-0b9e-4a31-9b16-f6e070a4f001', 'Days with average temperature above 40°C/ACCESS-CM2', 'Days with average temperature above 40°C/ACCESS-CM2', 'Days with average temperature above 40°C/ACCESS-CM2', 'Days with average temperature above 40°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('bae5ce0d-079c-44c8-87f2-705e13806371', 'Days with average temperature above 40°C/CMCC-ESM2', 'Days with average temperature above 40°C/CMCC-ESM2', 'Days with average temperature above 40°C/CMCC-ESM2', 'Days with average temperature above 40°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('19049eb2-9270-4b1b-9aea-8e2c610ea6b0', 'Days with average temperature above 40°C/CNRM-CM6-1', 'Days with average temperature above 40°C/CNRM-CM6-1', 'Days with average temperature above 40°C/CNRM-CM6-1', 'Days with average temperature above 40°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('a35f8652-5736-4b83-b9ec-2bcd53dd2b75', 'Days with average temperature above 40°C/MIROC6', 'Days with average temperature above 40°C/MIROC6', 'Days with average temperature above 40°C/MIROC6', 'Days with average temperature above 40°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('6a23417d-27fc-49f5-9147-43f9a761e13d', 'Days with average temperature above 40°C/ESM1-2-LR', 'Days with average temperature above 40°C/ESM1-2-LR', 'Days with average temperature above 40°C/ESM1-2-LR', 'Days with average temperature above 40°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('9fd1aafe-d942-4dd7-8b5f-cc3983d12616', 'Days with average temperature above 40°C/NorESM2-MM', 'Days with average temperature above 40°C/NorESM2-MM', 'Days with average temperature above 40°C/NorESM2-MM', 'Days with average temperature above 40°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('801009ff-7135-4252-a956-8f32cd9fb17d', 'Days with average temperature above 45°C/ACCESS-CM2', 'Days with average temperature above 45°C/ACCESS-CM2', 'Days with average temperature above 45°C/ACCESS-CM2', 'Days with average temperature above 45°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('ea8be4c4-a3f0-441f-b1cd-b4de8b9e885c', 'Days with average temperature above 45°C/CMCC-ESM2', 'Days with average temperature above 45°C/CMCC-ESM2', 'Days with average temperature above 45°C/CMCC-ESM2', 'Days with average temperature above 45°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('69053bee-35fd-45bd-9dd1-8fe485ae7715', 'Days with average temperature above 45°C/CNRM-CM6-1', 'Days with average temperature above 45°C/CNRM-CM6-1', 'Days with average temperature above 45°C/CNRM-CM6-1', 'Days with average temperature above 45°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('1f48f1f2-03ab-43b8-9185-038fd656ebcd', 'Days with average temperature above 45°C/MIROC6', 'Days with average temperature above 45°C/MIROC6', 'Days with average temperature above 45°C/MIROC6', 'Days with average temperature above 45°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('8960452e-86b1-4134-b03d-5bea69079fcc', 'Days with average temperature above 45°C/ESM1-2-LR', 'Days with average temperature above 45°C/ESM1-2-LR', 'Days with average temperature above 45°C/ESM1-2-LR', 'Days with average temperature above 45°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('3676521f-16ee-4ce6-b8b4-d00aaba44281', 'Days with average temperature above 45°C/NorESM2-MM', 'Days with average temperature above 45°C/NorESM2-MM', 'Days with average temperature above 45°C/NorESM2-MM', 'Days with average temperature above 45°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('8bfe29fb-85e3-4497-b340-ad3f4eadfc3f', 'Days with average temperature above 50°C/ACCESS-CM2', 'Days with average temperature above 50°C/ACCESS-CM2', 'Days with average temperature above 50°C/ACCESS-CM2', 'Days with average temperature above 50°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('fb684a2f-ce48-4d02-ba49-9c5cd49654df', 'Days with average temperature above 50°C/CMCC-ESM2', 'Days with average temperature above 50°C/CMCC-ESM2', 'Days with average temperature above 50°C/CMCC-ESM2', 'Days with average temperature above 50°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('56fb7c3a-7d9c-41d2-ab1d-37bab5544748', 'Days with average temperature above 50°C/CNRM-CM6-1', 'Days with average temperature above 50°C/CNRM-CM6-1', 'Days with average temperature above 50°C/CNRM-CM6-1', 'Days with average temperature above 50°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('12a84609-f114-4975-a90a-aed809452897', 'Days with average temperature above 50°C/MIROC6', 'Days with average temperature above 50°C/MIROC6', 'Days with average temperature above 50°C/MIROC6', 'Days with average temperature above 50°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('22ce6754-f68b-4f96-b083-8bb2a5c4deb6', 'Days with average temperature above 50°C/ESM1-2-LR', 'Days with average temperature above 50°C/ESM1-2-LR', 'Days with average temperature above 50°C/ESM1-2-LR', 'Days with average temperature above 50°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('ec4c8b74-816a-4260-8321-fc03b6850c37', 'Days with average temperature above 50°C/NorESM2-MM', 'Days with average temperature above 50°C/NorESM2-MM', 'Days with average temperature above 50°C/NorESM2-MM', 'Days with average temperature above 50°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('7f06ac9f-f6ac-467a-9a88-d14a91465141', 'Days with average temperature above 55°C/ACCESS-CM2', 'Days with average temperature above 55°C/ACCESS-CM2', 'Days with average temperature above 55°C/ACCESS-CM2', 'Days with average temperature above 55°C/ACCESS-CM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('c9edfa0d-5450-4de5-8680-4a26874cac2d', 'Days with average temperature above 55°C/CMCC-ESM2', 'Days with average temperature above 55°C/CMCC-ESM2', 'Days with average temperature above 55°C/CMCC-ESM2', 'Days with average temperature above 55°C/CMCC-ESM2', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('431a89ea-17bd-4dee-a2af-9ba18e737fe5', 'Days with average temperature above 55°C/CNRM-CM6-1', 'Days with average temperature above 55°C/CNRM-CM6-1', 'Days with average temperature above 55°C/CNRM-CM6-1', 'Days with average temperature above 55°C/CNRM-CM6-1', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('158038b5-1f09-471a-ac5b-85aae409148b', 'Days with average temperature above 55°C/MIROC6', 'Days with average temperature above 55°C/MIROC6', 'Days with average temperature above 55°C/MIROC6', 'Days with average temperature above 55°C/MIROC6', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('a5810ce7-eec7-4881-a182-33e0e3156a26', 'Days with average temperature above 55°C/ESM1-2-LR', 'Days with average temperature above 55°C/ESM1-2-LR', 'Days with average temperature above 55°C/ESM1-2-LR', 'Days with average temperature above 55°C/ESM1-2-LR', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;
INSERT INTO osc_physrisk_scenarios.hazard_indicator
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published, hazard_id)
VALUES 
	('41705043-bdad-4d2d-ab2b-3d884375b52d', 'Days with average temperature above 55°C/NorESM2-MM', 'Days with average temperature above 55°C/NorESM2-MM', 'Days with average temperature above 55°C/NorESM2-MM', 'Days with average temperature above 55°C/NorESM2-MM', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1, NULL,'y','y',1,'2024-07-15T00:00:01Z', 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b')
;

-- DATA IN ENGLISH ENDS


-- INSERT ASSET PORTFOLIO EXAMPLE
-- INCLUDING EXAMPLE ASSET WITH OED AND NAICS core_tags
INSERT INTO osc_physrisk_assets.asset_class
	(core_id, core_abbreviation, core_name, core_slug, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('db4a14a2-a27b-4bb0-8249-a07fb78438f4', 'Residential','Residential Buildings','en-asset-class-residential', 'Residential Buildings', 'Homes, apartments, and other residential structures.', 'Homes, apartments, and other residential structures.', '{"naics":[53],"oed:occupancy:oed_code":1050,"oed:occupancy:air_code":301}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(core_id, core_abbreviation, core_name, core_slug, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('536e8cee-682f-4cd6-b23e-b32e885cc094', 'Commercial', 'Commercial Buildings','en-asset-class-commercial', 'Commercial Buildings', 'Offices, retail spaces, and other commercial properties.', 'Offices, retail spaces, and other commercial properties.', '{"naics":[44,45,49],"oed:occupancy:oed_code":1100,"oed:occupancy:air_code":311}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(core_id, core_abbreviation, core_name, core_slug, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('f2baa602-44fe-49be-a5c9-d8b8208d9499', 'Infra','Infrastructure','en-asset-class-infrastructure', 'Infrastructure', 'Roads, bridges, railways, airports, ports, and utilities (water, electricity, telecommunications).', 'Roads, bridges, railways, airports, ports, and utilities (water, electricity, telecommunications).', '{"oed:occupancy:oed_code":1256,"oed:occupancy:oed_code":1305}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(core_id, core_abbreviation, core_name, core_slug, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('a9da716f-6667-4efe-bac7-f91c1cdcc2f1', 'Agri','Agricultural Assets','en-asset-class-agricultural', 'Agricultural Assets', 'Cropland, livestock, agricultural facilities, and equipment.', 'Cropland, livestock, agricultural facilities, and equipment.', '{"oed:occupancy:oed_code":2700,"oed:occupancy:air_code":484}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(core_id, core_abbreviation, core_name, core_slug, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('1ad910c8-fba0-4f45-845e-5a1901b9ffbe', 'Industrial','Industrial Facilities', 'en-asset-class-industrial','Industrial Facilities', 'Factories, warehouses, and other industrial properties.', 'Factories, warehouses, and other industrial properties.', '{"oed:occupancy:oed_code":1150,"oed:occupancy:air_code":321}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(core_id, core_abbreviation, core_name, core_slug, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('2b5557e6-05ee-49d6-b6a6-b7ef54948af7', 'Natural','Natural Assets', 'en-asset-class-natural','Natural Assets', 'Forests, wetlands, rivers, and other natural environments.', 'Forests, wetlands, rivers, and other natural environments.', '{"oed:occupancy:oed_code":1000,"oed:occupancy:air_code":300}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');
INSERT INTO osc_physrisk_assets.asset_class
	(core_id, core_abbreviation, core_name, core_slug, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('beafc1fa-f6c8-4c72-9717-a243eea1a2ef', 'Cultural','Cultural Heritage Sites', 'en-asset-class-cultural','Cultural Heritage Sites', 'Historical buildings, monuments, and sites of cultural significance.', 'Historical buildings, monuments, and sites of cultural significance.', '{"oed:occupancy:oed_code":1000,"oed:occupancy:air_code":300}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z');


INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('fa3d647a-4ab8-494a-b68e-6abf48404462', 'Single-family Homes', 'Single-family Homes', 'Single-family Homes', 'Single-family Homes', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','db4a14a2-a27b-4bb0-8249-a07fb78438f4');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('d1317024-2a21-4c89-8e7c-8609798dcc09', 'Multi-family apartments', 'Multi-family apartments', 'Multi-family apartments', 'Multi-family apartments', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','db4a14a2-a27b-4bb0-8249-a07fb78438f4');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('6ba2fda4-c6a7-4142-9e63-19948fe385f3', 'High-rise residential buildings', 'High-rise residential buildings', 'High-rise residential buildings', 'High-rise residential buildings', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','db4a14a2-a27b-4bb0-8249-a07fb78438f4');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('85246f30-e622-4af9-af86-16b23e8671a7', 'Retail Stores', 'Retail Stores', 'Retail Stores', 'Retail Stores', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','536e8cee-682f-4cd6-b23e-b32e885cc094');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('e9d9c1d6-915b-4450-ae2e-9fb2ad624478', 'Office buildings', 'Office buildings', 'Office buildings', 'Office buildings', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','536e8cee-682f-4cd6-b23e-b32e885cc094');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('f403566e-04eb-47aa-8327-ce6a43220867', 'Hotels and hospitality facilities', 'Hotels and hospitality facilities', 'Hotels and hospitality facilities', 'Hotels and hospitality facilities', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','536e8cee-682f-4cd6-b23e-b32e885cc094');

INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('ce606ca8-8f4c-429b-bdea-da87ed28087e', 'Highways', 'Highways', 'Highways', 'Highways', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','f2baa602-44fe-49be-a5c9-d8b8208d9499');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('20265e12-495b-46ee-af68-246216f0dacb', 'Bridges', 'Bridges', 'Bridges', 'Bridges', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','f2baa602-44fe-49be-a5c9-d8b8208d9499');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('64d4ffe2-e8b2-480d-9234-da51e53661d1', 'Railroads', 'Railroads', 'Railroads', 'Railroads', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','f2baa602-44fe-49be-a5c9-d8b8208d9499');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('3a568df0-cf71-4598-9bc7-2fb5997fb30d', 'Power transmission lines', 'Power transmission lines', 'Power transmission lines', 'Power transmission lines', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','f2baa602-44fe-49be-a5c9-d8b8208d9499');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('c7431f81-f1a7-42ca-90bd-6f43defe7931', 'Water treatment plants', 'Water treatment plants', 'Water treatment plants', 'Water treatment plants', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','f2baa602-44fe-49be-a5c9-d8b8208d9499');

INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('34ec5bde-96dc-4f50-86f4-71bef7f2271a', 'Irrigated cropland', 'Irrigated cropland', 'Irrigated cropland', 'Irrigated cropland', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','a9da716f-6667-4efe-bac7-f91c1cdcc2f1');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('9115c6ec-776f-45c2-a74b-010f7a21355c', 'Non-irrigated cropland', 'Non-irrigated cropland', 'Non-irrigated cropland', 'Non-irrigated cropland', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','a9da716f-6667-4efe-bac7-f91c1cdcc2f1');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('076c1110-a9e8-435c-994e-499bed18bc11', 'Livestock farms', 'Livestock farms', 'Livestock farms', 'Livestock farms', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','a9da716f-6667-4efe-bac7-f91c1cdcc2f1');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('8135bb62-54e7-4eb4-ad76-5b2b8e08c02e', 'Greenhouses', 'Greenhouses', 'Greenhouses', 'Greenhouses', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','a9da716f-6667-4efe-bac7-f91c1cdcc2f1');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('8bd9e90c-cfa9-404e-ad02-c3e53fad0210', 'Manufacturing plants', 'Manufacturing plants', 'Manufacturing plants', 'Manufacturing plants', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','1ad910c8-fba0-4f45-845e-5a1901b9ffbe');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('b5c703ea-336e-4a97-8883-971f1a275b69', 'Storage warehouses', 'Storage warehouses', 'Storage warehouses', 'Storage warehouses', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','1ad910c8-fba0-4f45-845e-5a1901b9ffbe');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('94face63-24ef-46ef-ac13-7565c7d81789', 'Chemical processing facilities', 'Chemical processing facilities', 'Chemical processing facilities', 'Chemical processing facilities', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','1ad910c8-fba0-4f45-845e-5a1901b9ffbe');


INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('7eb31e49-883b-4c0d-9464-404fc49b8eaa', 'Forest ecosystems', 'Forest ecosystems', 'Forest ecosystems', 'Forest ecosystems', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','2b5557e6-05ee-49d6-b6a6-b7ef54948af7');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('ae7851b9-123f-4ab6-8d26-594c88e2a6f5', 'River basins', 'River basins', 'River basins', 'River basins', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','2b5557e6-05ee-49d6-b6a6-b7ef54948af7');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('ef7cbcbc-adec-462f-84e6-d49de80fb882', 'Coastal wetlands', 'Coastal wetlands', 'Coastal wetlands', 'Coastal wetlands', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','2b5557e6-05ee-49d6-b6a6-b7ef54948af7');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('27628236-0486-4816-9487-dd9d9ccc9c5d', 'Historic buildings', 'Historic buildings', 'Historic buildings', 'Historic buildings', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','beafc1fa-f6c8-4c72-9717-a243eea1a2ef');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('82a14f2d-4db9-4df4-b62b-11b4aa157ebf', 'Archaeological Sites', 'Archaeological Sites', 'Archaeological Sites', 'Archaeological Sites', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','beafc1fa-f6c8-4c72-9717-a243eea1a2ef');
INSERT INTO osc_physrisk_assets.asset_type
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published,asset_class_id)
VALUES 
	('bdea3237-f764-4907-98cd-e0d131e099c5', 'Museums', 'Museums', 'Museums', 'Museums', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y','y',1,'2024-07-25T00:00:01Z','beafc1fa-f6c8-4c72-9717-a243eea1a2ef');



INSERT INTO osc_physrisk_assets.portfolio
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_tenant_id, core_is_published, core_publisher_id, core_datetime_utc_published, value_total, value_currency_alphabetic_code)
VALUES 
	('07c629be-42c6-4dbe-bd56-83e64253368d', 'Example Portfolio 1', 'Example Portfolio 1', 'Example Portfolio 1', 'Example Portfolio 1', '{}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y', 1,'y',1,'2024-07-25T00:00:01Z', 12345678.90, 'USD');

INSERT INTO osc_physrisk_assets.asset_realestate
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active,core_tenant_id, core_is_published, core_publisher_id, core_datetime_utc_published, portfolio_id, core_geo_location_name, core_geo_location_coordinates, core_geo_overture_features, core_geo_h3_index, core_geo_h3_resolution, asset_type_id, owner_bloomberg_id, owner_lei_id, value_total, value_currency_alphabetic_code, value_ltv)
VALUES 
	('281d68cc-ffd3-4740-acd6-1ea23bce902f', 'Commercial Real Estate asset example', 'Commercial Real Estate asset example', 'Commercial Real Estate asset example', 'Commercial Real Estate asset example', '{"naics":[531111],"oed:occupancy:oed_code":1050,"oed:occupancy:air_code":301}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y', 1,'y',1,'2024-07-25T00:00:01Z' , '07c629be-42c6-4dbe-bd56-83e64253368d', 'Fake location', ST_GeomFromText('POINT(-71.064544 42.28787)'), '{}', '1234', 12, '85246f30-e622-4af9-af86-16b23e8671a7', 'BBG000BLNQ16', '', 12345678.90, 'USD','{LTV value ratio}')
;
INSERT INTO osc_physrisk_assets.asset_powergeneratingutility
	(core_id, core_name, core_name_display, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_tenant_id, core_is_published, core_publisher_id, core_datetime_utc_published, portfolio_id, core_geo_location_name, core_geo_location_coordinates, core_geo_overture_features, core_geo_h3_index, core_geo_h3_resolution,asset_type_id,  owner_bloomberg_id, owner_lei_id, value_total, value_currency_alphabetic_code, production, capacity, availability_rate)
VALUES 
	('78cb5382-5e4f-4762-b2e8-7cb33954f788', 'Electrical Power Generating Utility example', 'Electrical Power Generating Utility example', 'Electrical Power Generating Utility example', 'Electrical Power Generating Utility example', '{"naics":[22111],"oed:occupancy:oed_code":1300,"oed:occupancy:air_code":361}','2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL, 'y', 1,'y',1,'2024-07-25T00:00:01Z' , '07c629be-42c6-4dbe-bd56-83e64253368d', 'Fake location', ST_GeomFromText('POINT(-71.064544 42.28787)'), '{}', '1234', 12, '3a568df0-cf71-4598-9bc7-2fb5997fb30d', 'BBG000BLNQ16', '', 12345678.90, 'USD', 12345.0,100.00,95.00)
;

-- INSERT EXPOSURE, VULNERABILITY, AND FINANCIAL MODELS
INSERT INTO osc_physrisk.osc_physrisk_vulnerability_analysis.exposure_function
	(core_id, core_name, core_name_display, core_slug, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_active, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_tenant_id, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_published, core_publisher_id, core_datetime_utc_published, core_version, core_dataset_id)
VALUES 
	('3f2a5033-cd68-4a04-93a6-a1ce2b5270eb', 'OS-C Phys Risk Flood Exposure & Vulnerability Model', 'OS-C Phys Risk Flood Exposure & Vulnerability Model', 'osc-physrisk-model-vulnerability-flooda','OS-C Flood', 'OS-C Phys Risk Flood Vulnerability Model', 'OS-C Phys Risk Flood Vulnerability Model', '{}', '2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'y','n',NULL,NULL, 1,'en', 'core_checksum',1,NULL, 'y', 1,'2024-07-25T00:00:01Z','1.0',NULL)
;

INSERT INTO osc_physrisk.osc_physrisk_vulnerability_analysis.vulnerability_function
	(core_id, core_name, core_name_display, core_slug, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_active, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_tenant_id, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_published, core_publisher_id, core_datetime_utc_published, core_version, core_dataset_id)
VALUES 
	('0a980ae7-5c2c-4996-8d87-e0337d92c13b', 'OS-C Phys Risk Flood Vulnerability Model', 'OS-C Phys Risk Flood Vulnerability Model', 'osc-physrisk-model-vulnerability-flooda','OS-C Flood', 'OS-C Phys Risk Flood Vulnerability Model', 'OS-C Phys Risk Flood Vulnerability Model', '{}', '2024-07-25T00:00:01Z',1,'2024-07-25T00:00:01Z',1,'y','n',NULL,NULL, 1,'en', 'core_checksum',1,NULL, 'y', 1,'2024-07-25T00:00:01Z','1.0',NULL)
;

-- INSERT PRECALCULATED IMPACT EXAMPLE
INSERT INTO osc_physrisk_vulnerability_analysis.geolocated_precalculated_vulnerability
	(core_id, core_name, core_name_display, core_abbreviation, core_description_full, core_description_short, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_tenant_id,core_is_published, core_publisher_id, core_datetime_utc_published, hazard_indicator_id, scenario_id, scenario_year, core_geo_location_name, core_geo_location_address, core_geo_location_coordinates, core_geo_overture_features, core_geo_h3_index, core_geo_h3_resolution, vulnerability_level, vulnerability_historically, core_datetime_utc_start, core_datetime_utc_end, exposure_function_id, exposure_level, exposure_data_raw, vulnerability_function_id, vulnerability_type_id, vulnerability_data_raw)
VALUES 
	('3bbb4a0e-f719-4e78-864b-3962e7f9e3a4', 'Example stored precalculated impact damage curve for Utility', 'Example stored precalculated impact damage curve for Utility', NULL, 'Example stored precalculated impact damage curve for Utility','Example stored precalculated impact damage curve for Utility', '{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'en', 'core_checksum',1,NULL,'y', 1,'y',1,'2024-07-15T00:00:01Z','57a7df66-420d-4730-9669-1547f8200272', '5d1081f3-fd0e-4f53-b06b-8358be82644c', 2040, '07c629be-42c6-4dbe-bd56-83e64253368d', 'Fake location', ST_GeomFromText('POINT(-71.064544 42.28787)'), '{}', '1234', 12, 0.5, 'n',NULL ,NULL ,	
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
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('0c438638-0ce2-4be1-b669-4d3e0d0e97e5', 'Inconnu/Aucun selection', 'Inconnu/Aucun selection', 'Inconnu/Aucun selection', 'Inconnu/Aucun selection','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'core_checksum',1,'8b3b38fd-a6f5-4878-b4b4-0a251ec0363a', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('c7450c04-42d3-41bf-a2a7-eb9af0e70873', 'Historique (avant 2014). Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'Historique (avant 2014)', 'Historique (avant 2014)', 'Historique (avant 2014)','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'core_checksum',1,'7faf5507-9a0a-4554-aef3-6efe5cffee63', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('08501b6b-92eb-407b-8b37-e6d23645a2d8', 'SSP1-1,9 — émissions de GES en baisse dès 2025, zéro émission nette de CO2 avant 2050, émissions négatives ensuite. Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'SSP1-1,9', 'SSP1-1,9', 'SSP1-1,9','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'core_checksum',1,'0ab07b1d-864d-4f0a-9656-29e9b088df3b', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('cb86a7f4-7116-497a-8f7b-14b8b5710e6a', 'SSP1-2,6 — similaire au précédent, mais le zéro émission nette de CO2 est atteint après 2050. Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'SSP1-2,6', 'SSP1-2,6', 'SSP1-2,6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'core_checksum',1,'cb68b9c6-6dff-4f0d-8650-768249f2689d', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('877f33ef-bfc9-47ff-80ed-9fe4bc20f873', 'SSP2-4,5 — maintien des émissions courantes jusqu''en 2050, division par quatre d''ici 2100. Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'SSP2-4,5', 'SSP2-4,5', 'SSP2-4,5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'core_checksum',1,'5d1081f3-fd0e-4f53-b06b-8358be82644c', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('a29cf80d-3c13-4be4-989f-afb8e0ae4a1a', 'SSP3-7,0 — doublement des émissions de GES en 2100. Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'SSP3-7,0', 'SSP3-7,0', 'SSP3-7,0','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'core_checksum',1,'f9ba343c-78b6-426c-be56-5d845e305d58', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('8568c7aa-6052-42f0-9c7d-fb2b0962571a', 'SSP5-8,5 — émissions de GES en forte augmentation, doublement en 2050. Voir "Scénarios d''émissions et de réchauffement futurs dans le sixième Rapport d''évaluation du GIEC" (https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WG1_SPM_French.pdf).', 'SSP5-8,5', 'SSP5-8,5', 'SSP5-8,5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'core_checksum',1,'fd76becb-28e9-424b-8c6e-c96aaf6988e5', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('38fa655f-7caf-4102-968f-f4d9420e143e', 'RCP2.6 - le scénario d''émissions faibles, nous présente un futur où nous limitons les changements climatiques d''origine humaine. Le maximum des émissions de carbone est atteint rapcore_idement, suivi d''une réduction qui mène vers une valeur presque nulle bien avant la fin du siècle. Voir « Scénarios d''émissions : les RCP » (https://donneesclimatiques.ca/interactive/scenarios-demissions-les-rcp/)', 'RCP2.6', 'RCP2.6', 'RCP2.6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'core_checksum',1,'3cd34fae-620a-47ae-862c-5349533e73b8', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('6cd8cb27-7682-4340-95c3-eec02dc69d07', 'RCP4.5 - un scénario d''émissions modérées, nous présente un futur où nous incluons des mesures pour limiter les changements climatiques d''origine humaine. Ce scénario exige que les émissions mondiales de carbone soient stabilisées d''ici la fin du siècle. Voir « Scénarios d''émissions : les RCP » (https://donneesclimatiques.ca/interactive/scenarios-demissions-les-rcp/)', 'RCP4.5', 'RCP4.5', 'RCP4.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'core_checksum',1,'e64b3f6a-69a6-403f-a4bb-e099fe099222', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('980ae46b-f6e6-408c-8536-0794e1e2f7a9', 'RCP6 -  Voir « Scénarios d''émissions : les RCP » (https://donneesclimatiques.ca/interactive/scenarios-demissions-les-rcp/)', 'RCP6', 'RCP6', 'RCP6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'core_checksum',1,'bb01865e-2a53-48a3-9437-35764ba52639', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('ab959faf-edd2-4ea1-ac1e-b824c3b8f4d8', 'RCP8.5 - le scénario d''émissions élevées, nous présente un futur où peu de restrictions aux émissions ont été mises en place. Les émissions continuent d''augmenter rapcore_idement au cours de ce siècle, et se stabilisent seulement après 2250. Voir « Scénarios d''émissions : les RCP » (https://donneesclimatiques.ca/interactive/scenarios-demissions-les-rcp/)', 'RCP8.5', 'RCP8.5', 'RCP8.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'fr', 'core_checksum',1,'893a6b75-8660-47ff-80d3-08b4ddc259c3', 'y','y', 1,'2024-07-15T00:00:01Z')
;
-- DATA IN FRENCH ENDS

-- DATA IN SPANISH BEGINS
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('ad206f5e-865c-4f8c-a837-3ea65a894e07', 'Desconoccore_ido/no seleccionado', 'Desconoccore_ido/no seleccionado', 'Desconoccore_ido/no seleccionado', 'Desconoccore_ido/no seleccionado','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'core_checksum',1,'8b3b38fd-a6f5-4878-b4b4-0a251ec0363a', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('9a50e648-2619-48af-94cb-e18cbe9b07bd', 'Histórico (antes 2014). Ver "El Grupo Intergubercore_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'Histórico (antes 2014)', 'Histórico (antes 2014)', 'Histórico (antes 2014)','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'core_checksum',1,'7faf5507-9a0a-4554-aef3-6efe5cffee63', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('0cd4961c-2f86-4a3c-94c9-817eb0e53028', 'SSP1-1.9 — Las trayectorias socioeconómicas compartcore_idas (SSP, por sus siglas en inglés) son escenarios de cambios socioeconómicos globales proyectados hasta 2100. Ver "El Grupo Intergubercore_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'SSP1-1,9', 'SSP1-1,9', 'SSP1-1,9','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'core_checksum',1,'0ab07b1d-864d-4f0a-9656-29e9b088df3b', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('c4176c8b-be83-4e2d-8fcb-1e5660a0224e', 'SSP1-2.6 - Las trayectorias socioeconómicas compartcore_idas (SSP, por sus siglas en inglés) son escenarios de cambios socioeconómicos globales proyectados hasta 2100. Ver "El Grupo Intergubercore_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'SSP1-2.6', 'SSP1-2.6', 'SSP1-2.6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'core_checksum',1,'cb68b9c6-6dff-4f0d-8650-768249f2689d', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name,core_tags,  core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('41ab06bc-506e-4d73-ba2d-20f2b48075e1', 'SSP2-4.5 Las trayectorias socioeconómicas compartcore_idas (SSP, por sus siglas en inglés) son escenarios de cambios socioeconómicos globales proyectados hasta 2100. Ver "El Grupo Intergubercore_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'SSP2-4.5', 'SSP2-4.5', 'SSP2-4.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'core_checksum',1,'5d1081f3-fd0e-4f53-b06b-8358be82644c', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('0190968c-5146-4bec-a3bb-c710d192517e', 'SSP3-7.0 - Las trayectorias socioeconómicas compartcore_idas (SSP, por sus siglas en inglés) son escenarios de cambios socioeconómicos globales proyectados hasta 2100. Ver "El Grupo Intergubercore_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'SSP3-7.0', 'SSP3-7.0', 'SSP3-7.0','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'core_checksum',1,'f9ba343c-78b6-426c-be56-5d845e305d58', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('f200a91a-bdbe-4983-a423-de84026b729e', 'SSP5-8.5 - Las trayectorias socioeconómicas compartcore_idas (SSP, por sus siglas en inglés) son escenarios de cambios socioeconómicos globales proyectados hasta 2100. Ver "El Grupo Intergubercore_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'SSP5-8.5', 'SSP5-8.5', 'SSP5-8.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'core_checksum',1,'fd76becb-28e9-424b-8c6e-c96aaf6988e5', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('50a460ce-3eff-404c-bd51-73e8df75c2af', 'RCP2.6 Una trayectoria de concentración representativa (RCP, por sus siglas en inglés) es una proyección teórica de una trayectoria de concentración de gases de efecto invernadero (no emisiones) adoptada por el IPCC. Ver "El Grupo Intergubercore_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'RCP2.6', 'RCP2.6', 'RCP2.6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'core_checksum',1,'3cd34fae-620a-47ae-862c-5349533e73b8', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('61421647-083e-4f1a-8aa7-60314caec48c', 'RCP4.5 - Una trayectoria de concentración representativa (RCP, por sus siglas en inglés) es una proyección teórica de una trayectoria de concentración de gases de efecto invernadero (no emisiones) adoptada por el IPCC. Ver "El Grupo Intergubercore_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'RCP4.5', 'RCP4.5', 'RCP4.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'core_checksum',1,'e64b3f6a-69a6-403f-a4bb-e099fe099222', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name,core_tags,  core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('1eb58f59-7e05-4e80-b226-2034e18fe8ac', 'RCP6 - Una trayectoria de concentración representativa (RCP, por sus siglas en inglés) es una proyección teórica de una trayectoria de concentración de gases de efecto invernadero (no emisiones) adoptada por el IPCC. Ver "El Grupo Intergubercore_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'RCP6', 'RCP6', 'RCP6','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'core_checksum',1,'bb01865e-2a53-48a3-9437-35764ba52639', 'y','y', 1,'2024-07-15T00:00:01Z')
;
INSERT INTO osc_physrisk_scenarios.scenario
	(core_id, core_description_full, core_description_short, core_name_display, core_name, core_tags, core_datetime_utc_created, core_creator_user_id, core_datetime_utc_last_modified, core_last_modifier_user_id, core_is_deleted, core_deleter_user_id, core_datetime_utc_deleted, core_culture, core_checksum, core_seq_num, core_translated_from_id, core_is_active, core_is_published, core_publisher_id, core_datetime_utc_published)
VALUES 
	('5faf38ce-ad9a-4cce-a2a8-807f61b7ec5f', 'RCP8.5 - Una trayectoria de concentración representativa (RCP, por sus siglas en inglés) es una proyección teórica de una trayectoria de concentración de gases de efecto invernadero (no emisiones) adoptada por el IPCC. Ver "El Grupo Intergubercore_namental de Expertos sobre el Cambio Climático (IPCC)" (https://www.ipcc.ch/languages-2/spanish/).', 'RCP8.5', 'RCP8.5', 'RCP8.5','{ "key1":"value1", "key2":"value2"}','2024-07-15T00:00:01Z',1,'2024-07-15T00:00:01Z',1,'n',NULL,NULL, 'es', 'core_checksum',1,'893a6b75-8660-47ff-80d3-08b4ddc259c3', 'y','y', 1,'2024-07-15T00:00:01Z')
;

-- DATA IN SPANISH ENDS

-- EXAMPLE QUERIES
-- VIEW SCENARIOS IN DIFFERENT LANGUAGES
SELECT * FROM osc_physrisk_scenarios.scenario WHERE core_culture='en';
SELECT * FROM osc_physrisk_scenarios.scenario WHERE core_culture='fr';
SELECT * FROM osc_physrisk_scenarios.scenario WHERE core_culture='es';

SELECT a.core_name as "English core_name",  b.core_culture as "Translated core_culture",  b.core_name as "Translated core_name", b.core_description_full as "Translated Description", b.core_tags as "Translated core_tags" FROM osc_physrisk_scenarios.scenario a 
INNER JOIN osc_physrisk_scenarios.scenario b ON a.core_id = b.core_translated_from_id
WHERE b.core_culture='es'  ;

-- QUERY BY core_tags EXAMPLE: FIND ASSETS WITH A CERTAIN NAICS OR OED OCCUPANCY VALUE (SHOWS HOW TO SUPPORT MULTIPLE STANDARDS)
SELECT a.core_name,  a.core_description_full, a.core_tags, b.core_name as asset_class FROM osc_physrisk_assets.asset_powergeneratingutility a INNER JOIN osc_physrisk_assets.asset_class b ON a.core_id = b.core_id
--WHERE a.core_tags -> 'naics'='22111' OR a.core_tags -> 'oed:occupancy:oed_code'='1300' OR a.core_tags -> 'oed:occupancy:air_code'='361' 
;

SELECT a.core_name,  a.core_description_full, a.core_tags, b.core_name as asset_class FROM osc_physrisk_assets.asset_powergeneratingutility a INNER JOIN osc_physrisk_assets.asset_class b ON a.core_id = b.core_id
WHERE a.core_tags -> 'naics' =  '53'
 ;

-- QUERY BY core_tags EXAMPLE: FIND SCENARIOS WITH CERTAIN core_tags
SELECT a.core_name,  a.core_description_full, a.core_tags FROM osc_physrisk_scenarios.scenario a
WHERE a.core_tags -> 'key1'='"value1"' OR a.core_tags -> 'key2'='"value4"'  
;

-- SHOW IMPACT ANALYSIS EXAMPLE (CURRENTLY EMPTY - TODO MISSING TEST DATA)
SELECT	* FROM	osc_physrisk_financial_analysis.portfolio_financial_impact;
SELECT * FROM osc_physrisk_financial_analysis.asset_financial_impact;

-- VIEW RIVERINE INUNDATION HAZARD INDICATORS
SELECT	*
FROM
	osc_physrisk_scenarios.hazard haz INNER JOIN osc_physrisk_scenarios.hazard_indicator hi ON hi.hazard_id = haz.core_id
WHERE haz.core_name = 'Riverine Inundation' -- more likely written as WHERE haz.core_id = '63ed7943-c4c4-43ea-abd2-86bb1997a094'
;

-- VIEW COASTAL INUNDATION HAZARD INDICATORS
SELECT	*
FROM
	 osc_physrisk_scenarios.hazard haz INNER JOIN osc_physrisk_scenarios.hazard_indicator hi ON hi.hazard_id = haz.core_id
WHERE haz.core_id = '28a095cd-4cde-40a1-90d9-cbb0ca673c06'
;

-- VIEW CHRONIC HEAT HAZARD INDICATORS
SELECT	*
FROM
	 osc_physrisk_scenarios.hazard haz INNER JOIN osc_physrisk_scenarios.hazard_indicator hi ON hi.hazard_id = haz.core_id
WHERE haz.core_id = 'd08db675-ee1e-48fe-b9e1-b0da27de8f2b'
;

-- SAMPLE core_checksum UPDATE
--UPDATE osc_physrisk_scenarios.scenario
--	SET core_checksum = md5(concat('Unknown/Not Selected', 'Unknown/Not Selected', 'Unknown/Not Selected', 'Unknown/Not Selected')) WHERE scenario_core_id = -1
--;

-- SELECT DIFFERENT ASSET TYPES
SELECT b.core_name as "Asset Class", a.core_name as "Asset Type", a.core_description_full as "Asset Type Description", b.core_tags as "Asset Class Tags", a.core_tags as "Asset Type Tags" FROM osc_physrisk_assets.asset_type a INNER JOIN osc_physrisk_assets.asset_class b ON a.asset_class_id = b.core_id
WHERE b.core_tags -> 'naics' @>  '45'
--WHERE b.core_tags ->> 'oed:occupancy:oed_code' = '1100'
ORDER BY b.core_name ASC
;

SELECT * from osc_physrisk_assets.generic_asset; -- NOTICE THESE ARE THE GENERIC ASSET COLUMNS AND ALL ASSETS ARE RETURNED
SELECT core_name, value_loan, value_ltv from osc_physrisk_assets.asset_realestate; -- NOTICE THE COLUMNS INCLUDE RE-SPECIFIC FIELDS AND ONLY RE ASSETS ARE RETURNED
SELECT core_name, production, capacity, availability_rate from osc_physrisk_assets.asset_powergeneratingutility; -- NOTICE THE COLUMNS INCLUDE UTILITY-SPECIFIC FIELDS AND ONLY UTILITY ASSETS ARE RETURNED

-- WE CAN ALSO DO A JOIN BY ASSET CLASS TO FILTER THE RESULTS
SELECT * from osc_physrisk_assets.generic_asset a INNER JOIN osc_physrisk_assets.asset_class b ON a.core_id = b.core_id
WHERE b.core_name LIKE '%Utility%'
; -- NOTICE ONLY UTILITY ROW IS RETURNED

-- QUERY PRECALCULATED DAMAGE CURVES AT A CERTAIN LOCATION
SELECT
	core_geo_h3_index, core_geo_h3_resolution, ST_X(core_geo_location_coordinates::geometry) as Long, ST_Y(core_geo_location_coordinates::geometry) as Lat, core_geo_overture_features, vulnerability_level, vulnerability_historically, vulnerability_data_raw
FROM
	osc_physrisk_vulnerability_analysis.geolocated_precalculated_vulnerability
WHERE core_geo_h3_index = '1234'
	;
