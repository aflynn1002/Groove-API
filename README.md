# tapin_api

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)

An example application built with dart_frog

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis


How to start database:
    dart_frog dev

How to start docker:
    docker-compose up

How to connect to postgres:
    docker exec -it postgres-tapin-dev psql -U postgres -d tapin-dev

Future Considerations:
    Implement redis to cache location data for my heatmap --> improve performance
    Why Redis is a Good Choice:
        1. Fast Read/Write Performance: Redis is an in-memory data store, meaning it provides extremely fast access compared to querying a traditional SQL database.
        2. Real-Time Updates: Redis supports high write throughput, making it suitable for real-time applications where user locations are frequently updated.
        3. Geospatial Data Support: Redis provides built-in geospatial capabilities with commands like GEOADD, GEORADIUS, and GEOSEARCH. This makes it easier to work with location-based data.
        4. Reduced Database Load: Frequently accessed data (like user locations) can be stored in Redis, reducing the number of expensive queries to your SQL database.

    https://redis.io/solutions/caching/