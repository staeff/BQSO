# Modeling Data with dbt and BigQuery

[Article at dataschool.com](https://dataschool.com/sql-optimization/start-modeling-data/)

This example uses `dbt` and `BigQuery` to introduce Data Modeling. `BigQuery` has many public data sets that are great for practicing data modeling on.

## Installation of dbt

I personally prefer to install `dbt` in a conda environment instead of installing it systemwide using `brew`.
Installing a [dbt adapter](https://docs.getdbt.com/docs/available-adapters), here `dbt-bigquery` already installs `dbt-core` as a dependency.

```
$ pip install dbt-bigquery
```

## Initialising the dbt project

The project has been initialised with the following command:

```
$ dbt init BQSO
```

In the initialisation you have to answer some questions that are used to create a profile in  `~/.dbt/profiles.yml` where all the info to connect to the provider in question are stored.
The particular profile, in this case 'BQSO', is refered to in `dbt_project.yml`.

## Modeling the data

We create an additional model, keeping the two default ones, that come with dbt around. Its called `stackover_model.sql`
and contains the following code:

```sql
{{ config(materialized='table') }}
SELECT *
FROM bigquery-public-data.stackoverflow.posts_questions
ORDER BY view_count DESC
LIMIT 1
```

The output of the query, which looks for the most viewed question on stackoverflow is materialized as a table, which
can be queried after `dbt run` has been issued and finished:

```sql
SELECT *
FROM soCleaned.stackover_model
```

## What did we gain from doing the modeling?

The newly created table is much smaller, because it is just a single row with 20 columns. The whole public Stack Overflow data set is 26.64 GB.
So queries against the new materialized table are faster and consume less bandwith, a metric that google is charging for in BigQuery.

`dbt run` needs to be run to load the latest data into the modeled table. Maybe another article has become the most viewed on StackOverflow.
Such update runs can be scheduled. `dbt cloud` offers the possibility the schedule runs, but it is also possible to use `github actions`
as a tool to run this.

[Michael Whitaker - Running dbt with Github Actions](https://www.michaelwhitaker.com/posts/2020-09-25-dbt-github-action/)
