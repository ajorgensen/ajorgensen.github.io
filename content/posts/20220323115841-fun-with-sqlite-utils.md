---
title: "Fun With sqlite-utils"
slug: fun-with-sqlite-utils
date: 2022-03-23T11:58:41-04:00
draft: true
tags: 
    - sqlite
---

sqlite-utils has a fun feature that allows you to easily create sql schema from json or csv.

<!--more-->

First we should make sure that we have sqlite3 and sqlite-utils installed.

```bash
brew install sqlite3 sqlite-utils
```

Lets say we have an external service that we want to store the data that comes back from an api request.

```json
{
    "id": "E3A2E012-2BCB-4236-8D4B-98E1D0C7DE73",
    "first_name": "Shepard",
    "last_name": "Balshen",
    "email": "sbalshen0@feedburner.com",
    "update_at": 1648051756
}
```

Now we can use sqlite-utils to generate a new table to store the data from this request

```bash
cat response.json | sqlite-utils insert api-responses.db users -
```

Then we can easily check the schema to see how the table was created 


```bash
sqlite-utils schema api-responses.db
CREATE TABLE [users] (
   [id] TEXT,
   [first_name] TEXT,
   [last_name] TEXT,
   [email] TEXT,
   [update_at] INTEGER
);
```

You might want to modify the schema to add, remove, or change columns or types but this should give a good starting point. 

If you want to get even fancier you can pipe the api response directly from curl into sqlite-utils to make this even easier. For example if we had a slightly more complicated json response.

```json
{
    "id": "E3A2E012-2BCB-4236-8D4B-98E1D0C7DE73",
    "first_name": "Shepard",
    "last_name": "Balshen",
    "email": "sbalshen0@feedburner.com",
    "activities": [
        { 
            "id": "4988998C-24C2-4874-932C-80B9B24CCD7C",
            "type": "bike",
            "time": 1648051756,
            "distance": 20
        },
        { 
            "id": "5013FDC9-B6CF-41AF-9E0C-84A9D3F8092D",
            "type": "run",
            "time": 1648051756,
            "distance": 8
        }
    ],
    "update_at": 1648051756
}
```

We can then pipe the response from the api request directly into jq and then into sqlite-utils to easily create a schema that can be used to store the data

```bash
curl -X GET -s localhost:8000 | \ 
jq '.activities[0]' | \
sqlite-utils insert activities.db activities -

sqlite-utils schema activities.db
CREATE TABLE [activities] (
   [id] TEXT,
   [type] TEXT,
   [time] INTEGER,
   [distance] INTEGER
);
```

