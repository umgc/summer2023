class TestFormFields {
  static const dynamic umgcRegistrationFormFields = [
    [
      {"firstNameField": "text"},
      {"lastNameField": "text"},
      {"emailField": "text"},
      {"country": "tel"},
      {"input-7": "text"},
      {
        "select-di-01-0": {
          "inputType": "select",
          "optionList": [
            "",
            "Undergraduate/Bachelors",
            "Graduate/Master's",
            "Doctorate",
            "Not Sure"
          ]
        }
      },
      {
        "select-02-0": {
          "inputType": "select",
          "optionList": [
            "",
            "Business & Management",
            "Cybersecurity",
            "Data Analytics",
            "Education & Teaching",
            "Health Care & Sciences",
            "Information Technology",
            "Liberal Arts & Communication",
            "Psychology",
            "Public Safety & Criminal Justice",
            "Not Sure/Other"
          ]
        }
      },
      {
        "select-03-0": {
          "inputType": "select",
          "optionList": [
            "",
            "Active-duty servicemember",
            "Spouse of active-duty servicemember",
            "Family member of active-duty servicemember",
            "Veteran",
            "National Guard",
            "Reservist",
            "Other",
            "None / Civilian"
          ]
        }
      }
    ],
  ];
}
