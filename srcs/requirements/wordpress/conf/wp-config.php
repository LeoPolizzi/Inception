<?php

// Set settings for WordPress database connection
define( 'DB_NAME', getenv( 'MDB_NAME' ) );
define( 'DB_USER', getenv( 'MDB_USER' ) );
define( 'DB_PASSWORD', trim(file_get_contents('/secrets/mariadb/mdb_user_pwd.txt')) );
define( 'DB_HOST', getenv('WP_MDB_HOST') . ':' . getenv('MDB_PORT'));
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', 'utf8_bin' );

// Setup the URLs for WordPress
define('WP_SITEURL', 'https://' . getenv('DOMAIN_NAME'));
define('WP_HOME', 'https://' . getenv('DOMAIN_NAME'));

// Set the authentication unique keys and salts
define('AUTH_KEY',         'H`%ZElSW6U(],mU%Mb^E/&JwLt]jBB<]cmXA5d4@5~0[gV(}>|<W=,gMSlNW^~(j');
define('SECURE_AUTH_KEY',  '?/alk)mp-p|/jc;1|.Q3AHQX 4~4-.lL]Lo[`E;5(h|P! Fk+$nfc)mxy+oI#I=u');
define('LOGGED_IN_KEY',    ',?LuyGB^ZlTN&E,6`OQJh~Xd`e6KV%c*hGZ1fS^!_|,o|H||u38N^]I?-q !gEKG');
define('NONCE_KEY',        'uDh6wZ|P:dga8]c|@j 2W6Siz 4e]iFo0z+Xv]j2H`T#3`@>b*5+l3uV5HsOzREW');
define('AUTH_SALT',        'rlH|vm5~_x?YEd7Z%fTXN{%:~[|C{/[y wjzaVq+/0L-/^lxaMcMzG.IBL&NH%6;');
define('SECURE_AUTH_SALT', '4J-U<Gl$NWKsqo|%z,f6*ylkmFU,+m*u>H|&%h.5(R@TD5H8e3L&_MMYkC 6z5Q2');
define('LOGGED_IN_SALT',   ')V5aq0vR5s)os9!ywLm{>=~V=D6B<v%`/f{A)_XNO^*cKq{?xDA?yV-w-zQn#-r+');
define('NONCE_SALT',       'zp 5m_N0Cn(@u=.ECk)&uJ,cQ+HS1 zokE_exHGJvG}d8)3oo3_v0g,*es`*^WB_');

// Set the database table prefix
$table_prefix = 'wp_';

// Set debug setting to false
define( 'WP_DEBUG', false );

// Set the absolute path to the WordPress directory
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

// Load WordPress settings
require_once ABSPATH . 'wp-settings.php';
