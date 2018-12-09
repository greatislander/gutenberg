# Exit if any command fails
set -e

# Check for theme input, or set to default
if [ -z "$1" ]; then
	THEME="twentynineteen"
else
	THEME="$1"
fi

# Change to the expected directory
cd "$(dirname "$0")/../"

# Setup local environement
( ./bin/setup-local-env.sh )

# Activate theme
if [ "$THEME" != "twentynineteen" ]; then
	docker-compose $DOCKER_COMPOSE_FILE_OPTIONS run -T --rm cli theme activate $THEME
	# TODO Install and activate theme
fi

# Get theme name
THEME_NAME=$(docker-compose $DOCKER_COMPOSE_FILE_OPTIONS run -T --rm cli theme get $THEME --field=title)

if [ "$E2E_ROLE" = "author" ]; then
	echo "Testing $THEME_NAME...\n"
	WP_PASSWORD=authpass WP_USERNAME=author npm run test-theme
else
	echo "Testing $THEME_NAME...\n"
	npm run test-theme
fi
