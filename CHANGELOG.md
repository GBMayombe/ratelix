# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-09-05

### Changed

    - Downgraded Ratelix from an OTP application to a standalone library.
        - Removed application supervision tree and related startup logic.
        - Ratelix no longer starts automatically as an application; users must supervise components manually if needed.

## [0.3.0] - 2025-06-19

### Added

    - Compliance to hex.pm

## [0.2.0] - 2025-06-19

### Added

    - Leaky and token bucket implementation
    - README improvement

## [0.1.0] - 2025-06-17

### Added

    - Initial implementation
