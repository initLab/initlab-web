#!/bin/bash

set -e

BASE_URL="${1:-http://initlab-web.localhost}"

cd "$(dirname "$0")"/../public

if [ -e wp-config.php ] && wp core is-installed
then
	wp db clean --yes
fi

if [ -e index.php ]
then
	echo Deleting Wordpress files
	rm -rf -- *
	echo Wordpress files deleted
fi

# base install
wp core download
wp config create --dbname="${2:-initlab}" --dbuser="${3:-initlab}" --dbpass="${4:-initlab}"
wp core install --url="${BASE_URL}" --title='init Lab' --admin_user=admin --admin_password="${5:-admin}" --admin_email=dev@6bez10.info --skip-email

# sample posts/pages
wp post delete 1 2 3 --force

# user
wp user meta update admin show_welcome_panel 0

# general options
wp option update blogdescription 'Sofia'\''s Hackerspace'
wp option update date_format d.m.Y
wp option update time_format H:i
wp option update timezone_string Europe/Sofia

# reading options
wp option update permalink_structure '/%post_id%/%postname%/'
wp rewrite flush
wp option update blog_public 0

# plugins
wp plugin uninstall hello
wp option update wordpress_api_key df2237efb5cb
wp plugin activate akismet
wp plugin install --activate broken-link-checker
wp plugin install --activate classic-editor
wp plugin install --activate contact-form-7
wp plugin install --activate events-manager
# TODO: WPML
#wp plugin install --activate events-manager-wpml
wp plugin install --activate https://github.com/initLab/initlab-addons/archive/master.zip
wp plugin install --activate better-wp-security
wp plugin install --activate loco-translate
wp plugin install --activate mainwp-child
wp plugin install --activate ninja-forms
wp plugin install --activate siteorigin-panels
wp plugin install --activate redirection
wp plugin install --activate regenerate-thumbnails
wp plugin install --activate responsive-lightbox
wp plugin install --activate simple-google-analytics-tracking
wp plugin install --activate so-widgets-bundle
wp plugin install --activate underconstruction
wp plugin install --activate updraftplus
wp plugin install --activate user-role-editor
wp plugin install --activate wpremote
wp plugin install --activate wp-pagenavi
wp plugin install --activate duplicate-post
wp plugin install --activate wordpress-importer

# theme
wp option update fresh_site 0
wp theme delete twentyseventeen
wp theme delete twentynineteen
wp theme install typecore --activate
#ln -sv "$(realpath ../themes/typecore-child)" wp-content/themes/
#wp theme activate typecore-child

# widgets
wp widget delete search-2 recent-posts-2 recent-comments-2 archives-2 categories-2 meta-2

# customize

# front page

# other pages

# language
wp language core install bg_BG
wp language plugin install akismet bg_BG
wp language plugin install classic-editor bg_BG
wp site switch-language bg_BG
