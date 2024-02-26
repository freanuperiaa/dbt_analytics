
# DE Zoomcamp Module 4  - Module Code & Homework

### Freanu Peria


my answers are in already in this repository. 

the following are the models & scripts that I have updated/written in order to answer the homework:

```
models\core\dm_fhv_taxi_trips.sql
models\core\fact_fhv_trips.sql
models\staging\stg_fhv_tripdata.sql

models\staging\schema.yml
# i wasn't able to update core\schema.yml as I am running out of time :((
```

Here is the link to the dashboard
`https://lookerstudio.google.com/reporting/8615b56a-95b1-44c7-ab9c-1c76f796494c`
it is basically the same with the dashboard done in the module.
i just added the new model `dm_fhv_taxi_trips.sql`

finally, `dm_fhv_taxi_trips.sql` is basically just `fact_trips` UNION-ed to `fhv_taxi_trips`. non-existent columns were given blank/null values so that columns can be matched for the UNION (go see models\core\dm_fhv_taxi_trips.sql)


Thank you!