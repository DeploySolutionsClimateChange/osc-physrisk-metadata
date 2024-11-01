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
