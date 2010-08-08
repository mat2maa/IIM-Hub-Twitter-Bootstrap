CREATE TABLE `airlines` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `code` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `album_playlist_items` (
  `id` int(11) NOT NULL auto_increment,
  `album_playlist_id` int(11) default NULL,
  `album_id` int(11) default NULL,
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `album_playlists` (
  `id` int(11) NOT NULL auto_increment,
  `programme` varchar(255) default NULL,
  `client_playlist_code` varchar(255) default NULL,
  `airline_id` int(11) default NULL,
  `in_out` varchar(255) default NULL,
  `start_playdate` date default NULL,
  `end_playdate` date default NULL,
  `vo` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `albums` (
  `id` int(11) NOT NULL auto_increment,
  `label_id` int(11) default NULL,
  `title_original` varchar(255) default NULL,
  `title_english` varchar(255) default NULL,
  `artwork` varchar(255) default NULL,
  `cd_code` varchar(255) default NULL,
  `disc_num` int(11) default NULL,
  `disc_count` int(11) default NULL,
  `release_year` int(11) default NULL,
  `artist_original` varchar(255) default NULL,
  `artist_english` varchar(255) default NULL,
  `synopsis` text,
  `publisher_id` int(11) default NULL,
  `live_album` tinyint(1) default NULL,
  `explicit_lyrics` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `albums_genres` (
  `genre_id` int(11) default NULL,
  `album_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `audio_playlist_tracks` (
  `id` int(11) NOT NULL auto_increment,
  `audio_playlist_id` int(11) default NULL,
  `track_id` int(11) default NULL,
  `position` int(11) default NULL,
  `mastering` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_audio_playlist_tracks_on_audio_playlist_id` (`audio_playlist_id`),
  KEY `index_audio_playlist_tracks_on_track_id` (`track_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `audio_playlists` (
  `id` int(11) NOT NULL auto_increment,
  `programme` varchar(255) default NULL,
  `client_playlist_code` varchar(255) default NULL,
  `airline_id` int(11) default NULL,
  `in_out` varchar(255) default NULL,
  `start_playdate` date default NULL,
  `end_playdate` date default NULL,
  `vo` varchar(255) default NULL,
  `mastering` text,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `genres` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `genres_albums` (
  `genre_id` int(11) default NULL,
  `album_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `genres_tracks` (
  `genre_id` int(11) default NULL,
  `track_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `labels` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `languages` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `origins` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL auto_increment,
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `updated_by` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `publishers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `updated_by` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tempos` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `tracks` (
  `id` int(11) NOT NULL auto_increment,
  `album_id` int(11) default NULL,
  `title_english` varchar(255) default NULL,
  `title_original` varchar(255) default NULL,
  `artist_english` varchar(255) default NULL,
  `artist_original` varchar(255) default NULL,
  `composer` varchar(255) default NULL,
  `publisher` varchar(255) default NULL,
  `distributor` varchar(255) default NULL,
  `description` text,
  `info` text,
  `duration` int(11) default NULL,
  `ending` varchar(255) default NULL,
  `tempo_intro` varchar(255) default NULL,
  `tempo_outro` varchar(255) default NULL,
  `tempo` varchar(255) default NULL,
  `track_num` int(11) default NULL,
  `lyrics` text,
  `language` varchar(255) default NULL,
  `gender` varchar(255) default NULL,
  `program_type` varchar(255) default NULL,
  `category` varchar(255) default NULL,
  `origin_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tracks_genres` (
  `genre_id` int(11) default NULL,
  `track_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `password_reset_code` varchar(40) default NULL,
  `enabled` tinyint(1) default '1',
  `updated_by` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20080720150337');

INSERT INTO schema_migrations (version) VALUES ('20080720150515');

INSERT INTO schema_migrations (version) VALUES ('20080720150652');

INSERT INTO schema_migrations (version) VALUES ('20080721171328');

INSERT INTO schema_migrations (version) VALUES ('20080723181831');

INSERT INTO schema_migrations (version) VALUES ('20080726124034');

INSERT INTO schema_migrations (version) VALUES ('20080727095952');

INSERT INTO schema_migrations (version) VALUES ('20080728094029');

INSERT INTO schema_migrations (version) VALUES ('20080806134447');

INSERT INTO schema_migrations (version) VALUES ('20080807162708');

INSERT INTO schema_migrations (version) VALUES ('20080807162932');

INSERT INTO schema_migrations (version) VALUES ('20080807170333');

INSERT INTO schema_migrations (version) VALUES ('20080807171458');

INSERT INTO schema_migrations (version) VALUES ('20080810062138');

INSERT INTO schema_migrations (version) VALUES ('20080810073218');

INSERT INTO schema_migrations (version) VALUES ('20080810074506');

INSERT INTO schema_migrations (version) VALUES ('20080810074536');

INSERT INTO schema_migrations (version) VALUES ('20080812174458');

INSERT INTO schema_migrations (version) VALUES ('20080812174729');

INSERT INTO schema_migrations (version) VALUES ('20080812174807');

INSERT INTO schema_migrations (version) VALUES ('20080912183625');

INSERT INTO schema_migrations (version) VALUES ('20080912184031');