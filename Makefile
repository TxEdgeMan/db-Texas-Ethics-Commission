#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

.PHONY: all clean unzip devgen perlinstall fixups perlscripts mkdir

all: prepare perlscripts fixups

DIR_DATA=./data
DIR_TEC_DOCS=${DIR_DATA}/tec_docs
TEC_URL=https://ethics.state.tx.us/data

devgen: prepare textify gen_schema.pl

.PHONY: prepare
prepare: download unzip combinecerts perlinstall

%.pl:
	perl "scripts/$@"

textify: $(DIR_TEC_DOCS)/cf_new.txt $(DIR_TEC_DOCS)/cf_old.txt

mkdir:
	- mkdir ${DIR_DATA} ${DIR_TEC_DOCS} 2>/dev/null || true

download:
	curl --progress-bar \
		-o "${DIR_TEC_DOCS}/TX_ERF13_7.pdf"                              "${TEC_URL}/search/cf/TX_ERF13_7.pdf"                                \
		-o "${DIR_TEC_DOCS}/HowToImportContributionsAndExpenditures.pdf" "${TEC_URL}/filinginfo/HowToImportContributionsAndExpenditures.pdf"  \
		-o "${DIR_TEC_DOCS}/CampaignFinanceCSVFileFormat.pdf"            "${TEC_URL}/search/cf/CampaignFinanceCSVFileFormat.pdf"              \
		-o "${DIR_TEC_DOCS}/1295CertificatesCSVFormat.pdf"               "${TEC_URL}/search/1295/1295CertificatesCSVFormat.pdf"               \
		-o "$(DIR_DATA)/1295Certificates_2016_to_2020.csv"               "${TEC_URL}/search/1295/1295Certificates_2016_to_2020.csv"           \
		-o "$(DIR_DATA)/1295Certificates_2021_to_2025.csv"               "${TEC_URL}/search/1295/1295Certificates_2021_to_2025.csv"           \
		-o "$(DIR_DATA)/1295Certificates_2026_to_2030.csv"               "${TEC_URL}/search/1295/1295Certificates_2026_to_2030.csv"           \
		-o "${DIR_DATA}/TEC_LA_CSV.zip"                                  "https://prd.tecprd.ethicsefile.com/public/lobby/public/TEC_LA_CSV.zip"                             \
		-o "${DIR_DATA}/TEC_CF_CSV.zip"                                  "https://prd.tecprd.ethicsefile.com/public/cf/public/TEC_CF_CSV.zip";

unzip:
	unzip -o -d "${DIR_DATA}/TEC_LA_CSV" "${DIR_DATA}/TEC_LA_CSV.zip"
	unzip -o -d "${DIR_DATA}/TEC_CF_CSV" "${DIR_DATA}/TEC_CF_CSV.zip"

# Combine the split 1295 cert files to single file
combinecerts:
	cat "$(DIR_DATA)/1295Certificates_2016_to_2020.csv" \
	    "$(DIR_DATA)/1295Certificates_2021_to_2025.csv" \
		  "$(DIR_DATA)/1295Certificates_2026_to_2030.csv" \
	> "$(DIR_DATA)/1295Certificates.csv"
	rm "$(DIR_DATA)/1295Certificates_2016_to_2020.csv"  \
		"$(DIR_DATA)/1295Certificates_2021_to_2025.csv"   \
		"$(DIR_DATA)/1295Certificates_2026_to_2030.csv"

%cf_old.txt:
	ps2txt "$(DIR_TEC_DOCS)/TX_ERF13_7.pdf" > "$@"

%cf_new.txt:
	ps2txt "$(DIR_TEC_DOCS)/CampaignFinanceCSVFileFormat.pdf" > "$@"

clean:
	git clean -fx data/

perlinstall:
	perl -Mlocal::lib -MMoose -e1 2>/dev/null || cpanm --local-lib=~/perl5 Moose
	perl -Mlocal::lib -MDataExtract::FixedWidth -e1 2>/dev/null || cpanm --local-lib=~/perl5 DataExtract::FixedWidth
	perl -Mlocal::lib -MText::CSV -e1 2>/dev/null || cpanm --local-lib=~/perl5 Text::CSV

perlscripts:
	perl -Mlocal::lib scripts/1295_seperator.pl

fixups:
	echo "Running fixups"
	sed -i -e 's/ LANDCOMM/LANDCOMM/g'                            \
		-e 's/" NONE"/"NONE"/g' data/TEC_CF_CSV/*.csv # strip leading space
	## Clear filerIdent field if it contains an email address (field 2, should be integer)
	perl -Mlocal::lib scripts/clear_email_filerident.pl data/TEC_CF_CSV/filers.csv
	echo "FINISHED Make fixups"
