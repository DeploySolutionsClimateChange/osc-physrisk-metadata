.. These are examples of badges you might want to add to your README:
   please update the URLs accordingly

    .. image:: https://api.cirrus-ci.com/github/<USER>/osc-physrisk-metadata.svg?branch=main
        :alt: Built Status
        :target: https://cirrus-ci.com/github/<USER>/osc-physrisk-metadata
    .. image:: https://readthedocs.org/projects/osc-physrisk-metadata/badge/?version=latest
        :alt: ReadTheDocs
        :target: https://osc-physrisk-metadata.readthedocs.io/en/stable/
    .. image:: https://img.shields.io/coveralls/github/<USER>/osc-physrisk-metadata/main.svg
        :alt: Coveralls
        :target: https://coveralls.io/r/<USER>/osc-physrisk-metadata
    .. image:: https://img.shields.io/pypi/v/osc-physrisk-metadata.svg
        :alt: PyPI-Server
        :target: https://pypi.org/project/osc-physrisk-metadata/
    .. image:: https://img.shields.io/conda/vn/conda-forge/osc-physrisk-metadata.svg
        :alt: Conda-Forge
        :target: https://anaconda.org/conda-forge/osc-physrisk-metadata
    .. image:: https://pepy.tech/badge/osc-physrisk-metadata/month
        :alt: Monthly Downloads
        :target: https://pepy.tech/project/osc-physrisk-metadata
    .. image:: https://img.shields.io/twitter/url/http/shields.io.svg?style=social&label=Twitter
        :alt: Twitter
        :target: https://twitter.com/osc-physrisk-metadata

.. image:: https://img.shields.io/badge/-PyScaffold-005CA0?logo=pyscaffold
    :alt: Project generated with PyScaffold
    :target: https://pyscaffold.org/

|

=====================
osc-physrisk-metadata
=====================


    OS-Climate Python Project



Purpose
---------------------
Physical Risk & Resilience-related metadata, standardization, and schema information for a variety of supporting technologies and formats, including CSV, JSON, and SQL. The intent is to facilitate application, data, and model development by having standard tools and taxonomies (where possible).

Getting Started
---------------------
Because metadata, standards, and tools are useful in all kinds of different formats and applications, we have grouped them loosely in subfolders by technology type. Currently we support code and tools formatted for use in PostgreSQL databases, Frictionless Data toolkit for CSV files, and OpenMetadata.

1. If you want to generate a sample Postgres database with table schemas and sample data, create a new database in a PostgreSQL-supporting database management tool and then run the code in the :file:`src/sql/create_database.sql`. To populate the tables with data, run :file:`src/sql/insert_seed_data.sql`
2. To populate a running OpenMetadata instance (<https://open-metadata.org/>), manually import the csv files contained in code in the ``src/openmetadata/glossary/`` folder. 
3. We support Frictionless Data validation for CSV files (<https://frictionlessdata.io/>). The csv schemas are contained in code in the ``src/csv/frictionless/`` folder. 

.. _pyscaffold-notes:

Note
====

This project has been set up using PyScaffold 4.5. For details and usage
information on PyScaffold see https://pyscaffold.org/.
