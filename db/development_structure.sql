CREATE TABLE `attachments` (
  `id` int(11) NOT NULL auto_increment,
  `filename` varchar(255) default NULL,
  `description` varchar(255) default 'No Description',
  `container_id` int(11) default NULL,
  `user_id` int(11) default '1',
  `file_size` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `parent_id` int(11) default '0',
  `description` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `companies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `address` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `zip` varchar(255) default NULL,
  `country` varchar(255) default 'USA',
  `phone` varchar(255) default NULL,
  `user_id` int(11) default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_viewable` varchar(1) default '1',
  `description` varchar(255) default 'No Description.',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `container_test_others` (
  `id` int(11) NOT NULL auto_increment,
  `container_id` int(11) default NULL,
  `user_id` int(11) default '1',
  `tech_name` varchar(255) default 'Nobody',
  `tds` varchar(255) default 'Untested',
  `ph` varchar(255) default 'Untested',
  `test_date` datetime default '1979-01-02 00:00:00',
  `notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `container_test_petries` (
  `id` int(11) NOT NULL auto_increment,
  `container_id` int(11) default NULL,
  `user_id` int(11) default '1',
  `tech_name` varchar(255) default 'Nobody',
  `notes` text,
  `has_growth` varchar(1) default '0',
  `test_date` datetime default '1979-01-02 00:00:00',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `container_test_spectros` (
  `id` int(11) NOT NULL auto_increment,
  `container_id` int(11) default NULL,
  `user_id` int(11) default '1',
  `tech_name` varchar(255) default 'Nobody',
  `notes` text,
  `test_date` datetime default '1979-01-02 00:00:00',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `container_test_zetas` (
  `id` int(11) NOT NULL auto_increment,
  `container_id` int(11) default NULL,
  `user_id` int(11) default '1',
  `tech_name` varchar(255) default 'Nobody',
  `notes` text,
  `average_size` varchar(255) default 'Untested',
  `zeta_potential` varchar(255) default 'Untested',
  `test_date` datetime default '1979-01-02 00:00:00',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `containers` (
  `id` int(11) NOT NULL auto_increment,
  `product_id` int(11) default NULL,
  `title` varchar(255) default 'Untitled',
  `description` varchar(255) default 'No Description.',
  `user_id` int(11) default '1',
  `quantity_measurement` varchar(255) default 'mg',
  `quantity` int(11) default '0',
  `quantity_remaining` int(11) default '0',
  `nn_id` varchar(255) default 'None',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `date_obtained` datetime default '1979-01-02 00:00:00',
  `flag` varchar(255) default 'Normal',
  `user_viewable` varchar(1) default '1',
  `location` varchar(255) default '',
  `conversion_to_mg` float default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `logs` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `log_type` varchar(255) default NULL,
  `log` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `production_items` (
  `id` int(11) NOT NULL auto_increment,
  `production_id` int(11) default NULL,
  `product_name` varchar(255) default NULL,
  `description` varchar(255) default 'No Description.',
  `quantity_measurement_needed` varchar(255) default 'mg',
  `quantity_needed` float default '0',
  `unique_nn_id` varchar(255) default '0000000000',
  `user_id` int(11) default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_viewable` varchar(1) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `production_record_items` (
  `id` int(11) NOT NULL auto_increment,
  `production_record_id` int(11) default NULL,
  `notes` varchar(255) default '',
  `container_id` int(11) default NULL,
  `quantity_used` float default '0',
  `quantity_used_measurement` varchar(255) default 'mg',
  `quantity_remaining_before_use` float default '0',
  `quantity_remaining_after_use` float default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_viewable` varchar(1) default '1',
  `user_id` int(11) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `production_record_shipments` (
  `id` int(11) NOT NULL auto_increment,
  `production_record_id` int(11) default NULL,
  `shipment_barcode` varchar(255) default '0000000000',
  `notes` varchar(255) default '',
  `address` varchar(255) default '',
  `quantity_shipped` float default '0',
  `quantity_shipped_measurement` varchar(255) default 'gallons',
  `shipment_date` datetime default '1979-01-02 00:00:00',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_viewable` varchar(1) default '1',
  `user_id` int(11) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `production_records` (
  `id` int(11) NOT NULL auto_increment,
  `production_id` int(11) default NULL,
  `date_ran` datetime default '1979-01-02 00:00:00',
  `description` varchar(255) default 'No Description',
  `production_number` varchar(255) default 'None',
  `gallons_produced` float default '0',
  `record_html` text,
  `record_raw` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_viewable` varchar(1) default '1',
  `user_id` int(11) default '1',
  `undone` varchar(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `productions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default 'No Description',
  `user_id` int(11) default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_viewable` varchar(1) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `products` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `company_id` int(11) default '0',
  `description` text,
  `upc` varchar(255) default NULL,
  `image_url` varchar(255) default NULL,
  `user_id` int(11) default '1',
  `category_id` int(11) default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `flag` varchar(255) default 'Normal',
  `user_viewable` varchar(1) default '1',
  `price` varchar(255) default '0.00',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `qualities` (
  `id` int(11) NOT NULL auto_increment,
  `product_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `product_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `tmp_production_containers` (
  `id` int(11) NOT NULL auto_increment,
  `container_id` int(11) default NULL,
  `production_id` int(11) default NULL,
  `production_item_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `username` varchar(255) default NULL,
  `password_hash` varchar(255) default NULL,
  `phone_number` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `description` varchar(255) default 'No Description',
  `is_admin` varchar(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (1026)