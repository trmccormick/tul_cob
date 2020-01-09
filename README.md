# Catalog on Blacklight

A minimal Blacklight Application for exploring Temple University MARC data in preparation for migration to Alma.

[![View performance data on Skylight](https://badges.skylight.io/status/UMsaUKxxdxMC.svg)](https://oss.skylight.io/app/applications/UMsaUKxxdxMC)
[![Coverage Status](https://coveralls.io/repos/github/tulibraries/tul_cob/badge.svg?branch=master)](https://coveralls.io/github/tulibraries/tul_cob?branch=master)

## Getting started


### Install the Application
This only needs to happen the first time.

```bash
git clone git@github.com:tulibraries/tul_cob
cd tul_cob
bundle install
cp config/secrets.yml.example config/secrets.yml
```

We also need to configure the application with our Alma and Primo apikey for development work on the Bento box or User account. Start by copying the example alma and bento config files.

```bash
cp config.alma.yml.example config/alma.yml
cp config/bento.yml.example config/bento.yml
```

Then edit them adding in the API keys for our application specified in our Ex Libris Developer Network.

```bash
bundle exec rails db:migrate
```

### Start the Application

We need to run two commands in separate terminal windows in order to start the application.
* In the first terminal window, start solr with run
```bash
bundle exec rake server
```

### Start the Application with some sample data for Development

You can also have it ingest a few thousand sample records by setting the
`DO_INGEST` environment variable to yes. For example:

`DO_INGEST="yes" bundle exec rake server`

### Start the Application using Docker as an alternative

If Docker is available, we defined a Makefile with many useful commands.

* To start the dockerized app, run ```make up```
* To stop the dockerized app, run ```make down```
* To restart the app, run ```make restart```
* To enter into the app container, run ```make tty-app```
* To enter into the solr container, run ```make tty-solr```
* To run the linter, run ```make lint```
* To run the Ruby tests, run ```make test```
* To run Javascript tests, run ```make test-js```
* To load sample data, run ```DO_INGEST=yes make up``` or ```make load-data```

### Preparing Alma Data

For the marcxml sample data that has been generated by Alma and exported by FTP, it needs to be processed before committing it to the sample_data folder:

```bash

./bin/massage.sh sample_data/alma_bibs.xml

```

### Ingest the sample Alma data with Traject

Now you are ready to ingest:

The simplest way to ingest a marc data file into your local solr is with the `ingest` rake task. Called with no parameters, it will ingest the data at [sample_data/alma_bibs.xml](https://github.com/tulibraries/tul_cob/blob/master/sample_data/alma_bibs.xml)


```bash
bundle exec rake ingest
```

You can also pass in their path to a separate file you would like to ingest as a parameter

```bash
bundle exec rake ingest[/some/other/path.xml]
```

If you need to ingest a file multiple times locally an not have it rejected by SOLR do to update_date you can set `SOLR_DISABLE_UPDATE_DATE_CHECK=yes`:

```bash
SOLR_DISABLE_UPDATE_DATE_CHECK=yes rake ingest[spec/fixtures/purchase_online_bibs.xml]
```

Under the hood, that command uses [traject](https://github.com/traject/traject), with hard coded defaults. If you need to override a default to ingest your data, You can call traject directly:

```bash
bundle exec traject -s solr.url=http://somehere/solr -c lib/traject/indexer_config.rb sample_data/alma_bibs.xml
```

If using docker, then ingest using `docker-compose exec app traject -c app/models/traject_indexer.rb sample_data/alma_bibs.xml`.

### Ingesting URLs
Additionally, you can now use `bin/ingest.rb`. This is a ruby executable that
works on both files and URLs. So now, if you want to quickly ingest a marc xml
record from production, you can run something like:

```bash
bin/ingest.rb http://example.com/catalog/foo.xml
```

### Ingest AZ Database data
AZ Database fixture data is loaded automatically when you run
`bundle exec rake tul_cob:solr:load_fixtures`. If you want to ingest a single file or URL, use `bundle exec cob_az_index ingest $path_to_file_or_url`.

Note: If you make an update to cob_az_index, you will need to run `bundle update cob_az_index` locally.


### Ingest web content data
Web content fixture data is loaded automatically when you run
`bundle exec rake tul_cob:solr:load_fixtures`. If you want to ingest a single file or URL, use `bundle exec cob_web_index ingest $path_to_file_or_url`.

Note: If you make an update to cob_web_index, you will need to run `bundle update cob_web_index` locally.

## Importing from Alma

In order to import from Alma directly execute the following Rake tasks. Harvest may be supplied with
an optional date/time ranges in ISO8901 format and enclosed in brackets. You may provide `from` and/or `ta`o
date/times. You may not provide only a `to` date/time

```bash
bundle exec rake tul_cob:oai:harvest[from,to]
bundle exec rake tul_cob:oai:conform_all
bundle exec rake tul_cob:oai:ingest_all
```

## Running the Tests

`bundle exec rake ci` will start solr, clean out all solr records, ingest the
test records, and run your test suite.

`bundle exec rake rspec` will start your solr and run your test suite, assuming
you already have the test records in your test solr.

The `rake rspec` rake task can also take any `rspec` command line parameters, for
example to [use a seed to determine order](https://relishapp.com/rspec/rspec-core/v/3-7/docs/command-line/order) , you can run:

`bundle exec rake rspec["--seed=12345"]`

### Relevance Tests

#### Running relevance tests

Relevance tests are run separate from other tests, to avoid loading tens of thousands of
MARC records every time test run. To run relevance tests along with regular tests
just preface any test running command with `RELEVANCE=y`.(y or any other character)
for example:

`RELEVANCE=y bundle exec rake ci`

This will cause all xml fixture files in `spec/relevance/fixtures/` to be ingested via traject,
and will run all `describe`/`context` blocks that have the `relevance: true` option.

#### Creating new relevance tests
By convention,these tests exist in (`spec/relevance/`)[https://github.com/tulibraries/tul_cob/tree/master/spec/relevance].

When creating a new test, be sure to pass the `relevance: true` option to the wrapping `describe`, as in

```ruby
RSpec.describe CatalogController, type: :controller, relevance: true do
#lots of expectations
...
end
```

You can also tak advantage of some custom Rspec matchers to make checking for documents easier.

`include_docs(array_of_doc_ids)` - Check that the expected ids are in the first set of results

```
# fetch the json solr response from Blacklight index and parse it
let(:response) { JSON.parse(get(:index, params: { q: "SEARC TERM", per_page: 100 }, format: "json").body) }

it "has expected results " do
  expect(response)
    .to include_docs(%w[991024847639703811 991024847639703811 991033452769703811])
end
```

You can also chain extra matchers onto `include_docs` for more precision:

`before([other_array_doc_ids])` - second array of IDs that should come after set you expect included
```
it "has expected results before a less relevant result" do
  expect(response)
    .to include_docs(%w[991024847639703811 991024847639703811 991033452769703811])
    .before(["991036813237303811"])
end
```

`within_the_first(integer)` - the included docs should appear before this number in the results array index
```
it "has expected results within the first 20 results" do
  expect(response)
    .to include_docs(%w[991024847639703811 991024847639703811 991033452769703811])
    .within_the_first(20)
end
```

#### Getting relevance tests examples

A utility has been added to fetch records for example queries. It takes the URL from a known
search in an existing blacklight (probably libqa), downloads the marcxml for each record
and adds them all to a file. By default, it saves to `marc_from_query.xml` locally, but you
can also provide a path  and filename with the `--save_to` command line flag.

```
./bin/get_records from  "https://libqa.library.temple.edu/catalog/?q=Contingent+labor" \
--save_to=spec/relevance/fixtures/contingent+labor.xml
```


#### Ingest LibGuide AZ documents
Locally you will need to add 'az-database' core to solr (handled automatically for docker/libqa/production)

Ingest AZ database documents by running

```
./bin/libguide_cache.rb
./bin/ingest-libguides.sh
```
