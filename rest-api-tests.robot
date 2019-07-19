*** Settings ***
Documentation         This is suite for OMDb REST API testing sample
Library               RequestsLibrary
Library               JSONLibrary
Library               Collections
Test Setup            OMDb session
Test Teardown         Delete All Sessions

*** Variables ***
${YOUR_KEY}           your_key
${TITLE}              movie_title
${TYPE}               movie_type
${EXPECTED_CODE}      200

*** Test Cases ***
Get data by required parameter
  [Documentation]     Test case for get OMDb data using required parameter
  ${response}         Get Request           ${session}
                      ...                   ?apikey=${YOUR_KEY}&s=${TITLE}
  ${actual_code}      Convert To String     ${response.status_code}
  Should Be Equal     ${actual_code}        ${EXPECTED_CODE}
  ${jsonresponse}     To Json               ${response.content}
  @{title_list}       Get Value From Json   ${jsonresponse}           $..Title
  Should Contain      ${title_list}         ${TITLE}

Get data by adding optional parameters
  [Documentation]     Test case for get OMDb data using required and optional parameters
  ${response}         Get Request           ${session}
                      ...                   ?apikey=${YOUR_KEY}&s=${TITLE}&type=${TYPE}
  ${actual_code}      Convert To String     ${response.status_code}
  Should Be Equal     ${actual_code}        ${EXPECTED_CODE}
  ${jsonresponse}     To Json               ${response.content}
  @{type_list}        Get Value From Json   ${jsonresponse}           $..Type
  Should Contain      ${type_list}          ${TYPE}

Get not found data
  [Documentation]     Test case for get OMDb not found data
  ${response}         Get Request           ${session}
                      ...                   ?apikey=${YOUR_KEY}&=${TITLE}&type=episode
  ${actual_code}      Convert To String     ${response.status_code}
  Should Be Equal     ${actual_code}        ${EXPECTED_CODE}
  ${jsonresponse}     To Json               ${response.content}
  @{not_found}        Get Value From Json   ${jsonresponse}           $..Title
  Should Be Empty     ${not_found}

*** Keywords ***
OMDb session
  [Documentation]       Keyword for OMDb-API session
  Create Session        omdb-api        http://www.omdbapi.com/
  Set Suite Variable    ${session}      omdb-api
