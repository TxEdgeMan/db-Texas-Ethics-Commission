-- Created while TEC updates the CFS-Codes.txt file

DROP TABLE IF EXISTS codes_committee_status;

CREATE TABLE codes_committee_status (
	committeeStatusCd text PRIMARY KEY,
	committeeStatusCd_name  text
);

INSERT INTO codes_committee_status( committeeStatusCd, committeeStatusCd_name )
VALUES
	( 'ACTIVE',   'Active' ),
	( 'INACTIVE',   'Inactive' ),
	( 'TERMINATED',   'Terminated' )
;
