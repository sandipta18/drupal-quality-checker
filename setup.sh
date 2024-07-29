#!/bin/bash


read -p "Enter the site name: " site_name
read -p "Enter the theme name: " theme_name


BASE_DIR="docroot/sites/$site_name/themes/custom/$theme_name"
ORIGINAL_DIR=$(pwd)


lando composer require --dev innoraft/drupal-quality-checker

cd "$BASE_DIR" || { echo "Base directory not found"; exit 1; }


npm install eslint@8.57.0
if ! npm install eslint-config-airbnb --save-dev; then
  npm install eslint-config-airbnb --save-dev --force
fi
npm install stylelint --save-dev
npm install stylelint-config-standard --save-dev


cd "$ORIGINAL_DIR"


SRC_ESLINTRC_PATH="vendor/innoraft/drupal-quality-checker/eslintrc.json.dist"
DEST_ESLINTRC_PATH="$BASE_DIR/.eslintrc.json"
SRC_STYLELINTRC_PATH="vendor/innoraft/drupal-quality-checker/stylelintrc.json.dist"
DEST_STYLELINTRC_PATH="$BASE_DIR/.stylelintrc.json"


if [ -f "$SRC_ESLINTRC_PATH" ]; then
  cp "$SRC_ESLINTRC_PATH" "$DEST_ESLINTRC_PATH"
  echo "Copied $SRC_ESLINTRC_PATH to $DEST_ESLINTRC_PATH"
else
  echo "Source file $SRC_ESLINTRC_PATH not found"
  exit 1
fi

if [ -f "$SRC_STYLELINTRC_PATH" ]; then
  cp "$SRC_STYLELINTRC_PATH" "$DEST_STYLELINTRC_PATH"
  echo "Copied $SRC_STYLELINTRC_PATH to $DEST_STYLELINTRC_PATH"
else
  echo "Source file $SRC_STYLELINTRC_PATH not found"
  exit 1
fi


SRC_GRUMPHP_PATH="vendor/innoraft/drupal-quality-checker/grumphp.yml.dist"
DEST_GRUMPHP_PATH="grumphp.yml"


if [ -f "$SRC_GRUMPHP_PATH" ]; then
  cp "$SRC_GRUMPHP_PATH" "$DEST_GRUMPHP_PATH"
  echo "Replaced $DEST_GRUMPHP_PATH with $SRC_GRUMPHP_PATH"
else
  echo "Source file $SRC_GRUMPHP_PATH not found"
  exit 1
fi

if [ -f "$DEST_GRUMPHP_PATH" ]; then
  sed -i "s|bin: \"web/themes/custom/<theme_name>/node_modules/.bin/eslint\"|bin: \"docroot/sites/$site_name/themes/custom/$theme_name/node_modules/.bin/eslint\"|" "$DEST_GRUMPHP_PATH"
  sed -i "s|config: \".eslintrc.json\"|config: \"docroot/sites/$site_name/themes/custom/$theme_name/.eslintrc.json\"|" "$DEST_GRUMPHP_PATH"
  sed -i "s|bin: \"web/themes/custom/<theme_name>/node_modules/.bin/stylelint\"|bin: \"docroot/sites/$site_name/themes/custom/$theme_name/node_modules/.bin/stylelint\"|" "$DEST_GRUMPHP_PATH"
  sed -i "s|config: \".stylelintrc.json\"|config: \"docroot/sites/$site_name/themes/custom/$theme_name/.stylelintrc.json\"|" "$DEST_GRUMPHP_PATH"
  echo "Updated $DEST_GRUMPHP_PATH with the correct paths"
else
  echo "$DEST_GRUMPHP_PATH not found, cannot update paths"
  exit 1
fi


mkdir -p tasks


cp vendor/innoraft/drupal-quality-checker/tasks/SecurityLeaks.php tasks/
if [ $? -eq 0 ]; then
  echo "Copied SecurityLeaks.php to tasks directory"
else
  echo "Failed to copy SecurityLeaks.php"
  exit 1
fi


if [ -f "composer.json" ]; then
  sed -i '/"autoload": {/a \
    "psr-4": {\
        "Innoraft\\\\QualityChecker\\\\Trufflehog\\\\": "tasks"\
    },' composer.json
  echo "Updated composer.json with autoload information"
else
  echo "composer.json not found"
  exit 1
fi


lando composer dump-autoload


curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b $HOME/.local/bin
if [ $? -eq 0 ]; then
  echo "trufflehog installed successfully"
else
  echo "Failed to install trufflehog"
  exit 1
fi

echo "All tasks completed in $BASE_DIR"
