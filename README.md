# Drupal Code Quality Checker
---

## Overview

This composer package will provide some basic code quality checks before committing code by using https://github.com/phpro/grumphp. Check out this [Lullabot article](https://www.lullabot.com/articles/how-enforce-drupal-coding-standards-git) for more details.

This has been customised from [vijaycs85/drupal-quality-checker](https://packagist.org/packages/vijaycs85/drupal-quality-checker) for Innoraft needs.


## Install

1. Add `innoraft/drupal-quality-checker` to `composer.json` or
just `composer require --dev innoraft/drupal-quality-checker`
2. Replace `grumphp.yml` in project's root directory (not Drupal root directory)
with `vendor/innoraft/drupal-quality-checker/grumphp.yml.dist`

That's it. Now, all tasks (listed below) run on every `git commit`.

>*Note:* As part of install, GrumPHP adds `pre-commit` hook to repository. Existing `pre-commit` might get [destroyed](https://github.com/phpro/grumphp/issues/416) when install/uninstall.

## Out of the box

1. [PHPCS](https://github.com/squizlabs/PHP_CodeSniffer) with Drupal standard.
2. [PHP Lint](http://www.icosaedro.it/phplint/)
3. [YAML Lint](http://www.yamllint.com/)
4. [Composer](https://github.com/composer/composer)
5. [Composer Normalize](https://github.com/ergebnis/composer-normalize)
6. [JSONLint](https://jsonlint.com/)
7. [PHP Copy/Paste Detector (CPD)](https://github.com/sebastianbergmann/phpcpd)

Long list of additional checks/validators available [here](https://github.com/phpro/grumphp/blob/master/doc/tasks.md#tasks-1).

## ESLint task Setup

1. Go to custom theme folder and add eslint package with npm
```bash
npm install eslint --save-dev
npm install eslint-config-airbnb --save-dev
```

2. Now run this command at project's root directory
```bash
cp vendor/innoraft/drupal-quality-checker/eslintrc.json.dist .eslintrc.json
```
3. Update bin key for eslint task under grumphp.yml file with relative address to eslint's bin file.

## Stylelint task Setup

1. Go to custom theme folder and add stylelint package with npm
```bash
npm install stylelint --save-dev
```

2. Now run this command at project's root directory
```bash
cp vendor/innoraft/drupal-quality-checker/stylelintrc.json.dist .stylelintrc.json
```
3. Update bin key for eslint task under grumphp.yml file with relative address to eslint's bin file.