import json
import typetraits


const data = """
{
  "account_number": "218538",
  "address": "4740 N WESTERN AVE 5-6",
  "application_created_date": "2017-12-21T00:00:00.000",
  "application_requirements_complete": "2018-01-05T00:00:00.000",
  "application_type": "ISSUE",
  "business_activity": "Indoor Special Event",
  "business_activity_id": "892",
  "city": "CHICAGO",
  "conditional_approval": "N",
  "date_issued": "2018-01-18T00:00:00.000",
  "doing_business_as_name": "WINTER BREW 2018 - JAN 27, 2018",
  "expiration_date": "2018-01-27T00:00:00.000",
  "id": "2574594-20180118",
  "latitude": "41.967961972",
  "legal_name": "LINCOLN SQUARE RAVENSWOOD CHAMBER OF COMMERCE",
  "license_approved_for_issuance": "2018-01-18T00:00:00.000",
  "license_code": "1058",
  "license_description": "Indoor Special Event",
  "license_id": "2574594",
  "license_number": "2574594",
  "license_start_date": "2018-01-18T00:00:00.000",
  "license_status": "AAI",
  "location": {
    "type": "Point",
    "coordinates": [
      -87.689032131482,
      41.9679619719
    ]
  },
  "longitude": "-87.689032131",
  "payment_date": "2018-01-05T00:00:00.000",
  "police_district": "19",
  "precinct": "40",
  "site_number": "50",
  "ssa": "21",
  "state": "IL",
  "ward": "40",
  "ward_precinct": "40-40",
  "zip_code": "60625"
}
"""

type
  BusinessLicense = object
    doing_business_as_name: string
    legal_name: string
    address: string
    longitude: string
    latitude: string
    business_activity: string
    date_issued: string


let jsonNode = parseJson(data)
var lic = jsonNode.to(BusinessLicense)
lic.date_issued = lic.date_issued.substr(0, 9)
assert lic.type is BusinessLicense
assert lic.type.name == "BusinessLicense"
echo lic.repr
