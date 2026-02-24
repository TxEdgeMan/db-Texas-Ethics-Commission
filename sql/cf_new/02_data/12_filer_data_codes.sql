-- Created while TEC updates the CFS-Codes.txt file

DROP TABLE IF EXISTS codes_persent_types;

CREATE TABLE codes_persent_types (
	PersentTypeCd text PRIMARY KEY,
	PersentTypeName  text
);

INSERT INTO codes_persent_types( persentTypeCd, persentTypeName )
VALUES
	( 'INDIVIDUAL',   'INDIVIDUAL' ),
	( 'ENTITY',   'Entity' ),
	( 'NOT_OFFICEHOLDER',   'Not Officeholder' ),
	( 'OFFICEHOLDER',   'Officeholder' ),
	( 'CANDIDATE',   'Candidate' ),
	( 'POLITICAL_COMMITTEE',   'Political Committee' ),
	( 'PAC_SUPPORT_ORGANIZATION',   'PAC Support Organization' ),
	( 'SPAC_SUPPORT_ORGANIZATION',   'SPAC Support Org'),
	( 'GPACSUPPORT',  'GPAC support' ),
	( 'SPACSUPPORT',  'SPAC support' ),
	-- filerFilerPersentTypeCd values added 2026 01
	( 'ACTIVE',  'Active' ),
	( 'X',  'X' ),
	( 'CURRENT_OFFICEHOLDER',  'Current Officeholder' )
;

DROP TABLE IF EXISTS codes_states;
CREATE TABLE codes_states (
	state_code varchar(15) PRIMARY KEY,  -- some records have longer codes than 2 characters, so we need to allow for that
 	state_name varchar(50)
);	

INSERT INTO codes_states (state_code, state_name)
VALUES
('AL','ALABAMA'),
('AK','ALASKA'),
('AB','ALBERTA'),
('AS','AMERICAN SAMOA'),
('AZ','ARIZONA'),
('AR','ARKANSAS'),
('BC','BRITISH COLUMBIA'),
('CA','CALIFORNIA'),
('PW','CAROLINE ISLANDS'),
('CO','COLORADO'),
('CT','CONNETICUT'),
('DE','DELAWARE'),
('DC','DISTRICT OF COLUMBIA'),
('FM','FEDERATED STATE'),
('FL','FLORIDA'),
('GA','GEORGIA'),
('GU','GUAM'),
('HI','HAWAII'),
('ID','IDOHA'),
('IL','ILLINOIS'),
('IN','INDIANA'),
('IA','IOWA'),
('KS','KANSAS'),
('KY','KENTUCKY'),
('LA','LOUSIANA'),
('ME','MAINE'),
('MB','MANITOBA'),
('MP','MARIANA ISLANDS'),
('MH','MARSHALL ISLANDS'),
('MD','MARYLAND'),
('MA','MASSACHUSETTS'),
('MI','MICHIGAN'),
('MN','MINNESOTA'),
('MS','MISSISSIPPI'),
('MO','MISSOURI'),
('MT','MONTANA'),
('NE','NEBRASKA'),
('NV','NEVADA'),
('NB','NEW BRUNSWICK'),
('NH','NEW HAMPSHIRE'),
('NJ','NEW JERSEY'),
('NM','NEW MEXICO'),
('NY','NEW YORK'),
('NF','NEWFOUNDLAND'),
('NC','NORTH CAROLINA'),
('ND','NORTH DAKOTA'),
('NT','NORTHWEST TERRITORIES'),
('NS','NOVA SCOTIA'),
('NU','NUNAVUT'),
('OH','OHIO'),
('OK','OKLAHOMA'),
('ON','ONTARIO'),
('OR','OREGON'),
('PA','PENNSYLVANIA'),
('PE','PRINCE EDWARD ISLAND'),
('PR','PUERTO RICO'),
('PQ','QUEBEC'),
('RI','RHODE ISLAND'),
('SK','SASKATCHEWAN'),
('SC','SOUTH CAROLINA'),
('SD','SOUTH DAKOTA'),
('TN','TENNESSEE'),
('TX','TEXAS'),
('UT','UTAH'),
('VT','VERMONT'),
('VI','VIRGIN ISLANDS'),
('VA','VIRGINIA'),
('WA','WASHINGTON'),
('WV','WEST VIRGINIA'),
('WI','WISCONSIN'),
('WY','WYOMING'),
('YT','YUKON TERRITORY'),
('AE','ARMED FORCES - EUROPE'),
('AA','ARMED FORCES - AMERICAS'),
('AP','ARMED FORCES - PACIFIC'),
('ZZ','FOREIGN COUNTRY'),
('XX','UNKNOWN')
;

-- Unknown state code values added 2026 01
INSERT INTO codes_states (state_code, state_name)
VALUES
('NL','UNKNOWN'),
('UM','UNKNOWN'),
('TE','UNKNOWN'),
('BA','UNKNOWN'),
('CZ','UNKNOWN'),
('LY','UNKNOWN'),
('HESSEN','UNKNOWN'),
('DA','UNKNOWN'),
('18','UNKNOWN'),
('68','UNKNOWN'),
('0','UNKNOWN'),
('HO','UNKNOWN'),
('KA', 'UNKNOWN'),
('BR', 'UNKNOWN'),
('ONTARIO', 'UNKNOWN'),
('EL', 'UNKNOWN')
;

-- Additional need to handle additional unexpected values in the data (preexisting values added 2026 01)
INSERT INTO codes_states (state_code, state_name)
SELECT DISTINCT v.state_code, 'UNKNOWN'
FROM (
    VALUES
    ('EN'),('ZZ'),('LY'),
    ('HESSEN'),('AE'),('DA'),('GU'),('18'),
    ('NL'),('68'),('0'),('HO'),
    ('KA'),('BR'),('ONTARIO'),
    ('EL'),('XX'),('MP'),('SA'),('VI'),('ZH'),('DE'),
    ('HESSE'),('BO'),('12'),('AA'),('AB'),('LO'),
    ('PR'),('CY'),('#'),('FI'),
    ('SU'),('SP'),('OM'),
    ('KI'),('24'),('AP'),('78'),('UM'),('TH'),('BA'),
    ('GB'),('QL'),('TE'),('98'),('GR'),
    ('FS'),('ON'), (' TX'),('UN'),('RZ'),('X'),('??'),('AP'),('T'),('BE'),('X7')
) AS v(state_code)
ON CONFLICT (state_code) DO NOTHING;
