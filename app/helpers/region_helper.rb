module RegionHelper

  COUNTY_REGION_MAPPINGS = {
    "Aberdeenshire": "Scotland",
    "Angus": "Scotland",
    "Argyll and Bute": "Scotland",
    "Bedfordshire": "East of England",
    "Berkshire": "South East",
    "Bristol": "South West",
    "Buckinghamshire": "South East",
    "Cambridgeshire": "East of England",
    "Cheshire": "North West",
    "City of Aberdeen": "Scotland",
    "City of Dundee": "Scotland",
    "City of Edinburgh": "Scotland",
    "City of Glasgow": "Scotland",
    "Clackmannanshire": "Scotland",
    "Clwyd": "Wales",
    "Cornwall": "South West",
    "County Antrim": "Northern Ireland",
    "County Armagh": "Northern Ireland",
    "County Down": "Northern Ireland",
    "County Durham": "North East",
    "County Fermanagh": "Northern Ireland",
    "County Londonderry": "Northern Ireland",
    "County Tyrone": "Northern Ireland",
    "Cumbria": "North West",
    "Derbyshire": "East Midlands",
    "Devon": "South West",
    "Dorset": "South West",
    "Dumfries and Galloway": "Scotland",
    "Dyfed": "Wales",
    "East Ayrshire": "Scotland",
    "East Dunbartonshire": "Scotland",
    "East Lothian": "Scotland",
    "East Renfrewshire": "Scotland",
    "East Riding of Yorkshire": "Yorkshire & The Humber",
    "East Sussex": "South East",
    "Essex": "East of England",
    "Falkirk": "Scotland",
    "Fife": "Scotland",
    "Gloucestershire": "South West",
    "Greater London": "Greater London",
    "Gwynedd": "Wales",
    "Hampshire": "South East",
    "Herefordshire": "West Midlands",
    "Hertfordshire": "East of England",
    "Highland": "Scotland",
    "Inverclyde": "Scotland",
    "Isle of Wight": "South East",
    "Isles of Scilly": "South West",
    "Kent": "South East",
    "Lancashire": "North West",
    "Leicestershire": "East Midlands",
    "Lincolnshire - East Midlands region (includes Boston, East Lindsey, Lincoln, North Kesteven, South Holland, South Kesteven, West Lindsey)": "East Midlands",
    "Lincolnshire - Yorkshire & The Humber region (includes North East Lincolnshire, North Lincolnshire)": "Yorkshire & The Humber",
    "Manchester": "North West",
    "Merseyside": "North West",
    "Mid Glamorgan": "Wales",
    "Midlothian": "Scotland",
    "Gwent - Blaenau Gwent, Caerphilly, Monmouthshire, Newport, Torfaen": "Wales",
    "Moray": "Scotland",
    "Na h-Eileanan Siar - Western Isles": "Scotland",
    "Norfolk": "East of England",
    "North Ayrshire": "Scotland",
    "North Lanarkshire": "Scotland",
    "North Yorkshire - Yorkshire & The Humber region (includes Craven, Hambleton, Harrogate, Richmondshire, Ryedale, Scarborough, Selby, York)": "Yorkshire & The Humber",
    "North Yorkshire - North East England region (includes Middlesbrough, Redcar and Cleveland, Stockton-on-Tees)": "North East",
    "Northamptonshire": "East Midlands",
    "Northumberland": "North East",
    "Nottinghamshire": "East Midlands",
    "Orkney Islands": "Scotland",
    "Oxfordshire": "South East",
    "Perth and Kinross": "Scotland",
    "Powys": "Wales",
    "Renfrewshire": "Scotland",
    "Rutland": "East Midlands",
    "Scottish Borders": "Scotland",
    "Shetland Islands": "Scotland",
    "Shropshire": "West Midlands",
    "Somerset": "South West",
    "South Ayrshire": "Scotland",
    "South Glamorgan": "Wales",
    "South Lanarkshire": "Scotland",
    "South Yorkshire": "Yorkshire & The Humber",
    "Staffordshire": "West Midlands",
    "Stirling": "Scotland",
    "Suffolk": "East of England",
    "Surrey": "South East",
    "Tyne and Wear": "North East",
    "Warwickshire": "West Midlands",
    "West Dunbartonshire": "Scotland",
    "West Glamorgan": "Wales",
    "West Lothian": "Scotland",
    "West Midlands": "West Midlands",
    "West Sussex": "South East",
    "West Yorkshire": "Yorkshire & The Humber",
    "Wiltshire": "South West",
    "Worcestershire": "West Midlands",
    "Bailiwick of Guernsey": "Channel Islands",
    "Bailiwick of Jersey": "Channel Islands",
    "Isle of Man": "Isle of Man",
  }

  def counties
    COUNTY_REGION_MAPPINGS.keys.sort
  end

  def regions
    COUNTY_REGION_MAPPINGS.values.uniq.sort
  end

  def lookup_region_for_county(county)
    COUNTY_REGION_MAPPINGS[county]
  end

end
