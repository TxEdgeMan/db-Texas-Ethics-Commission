-- Created while TEC updates the CFS-Codes.txt file

DROP TABLE IF EXISTS codes_filer_jdi;

CREATE TABLE codes_filer_jdi (
	filerJdiCd	 text PRIMARY KEY,
	filerJdiCd_name  text
);

INSERT INTO codes_filer_jdi( filerJdiCd, filerJdiCd_name )
VALUES
	( 'Y',   'Yes' ),
	( 'N',   'No' ),
	( 'IA',   'Interim Appointment' )
;
