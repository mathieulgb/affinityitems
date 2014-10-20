<?php
/**
* 2014 Affinity-Engine
*
* NOTICE OF LICENSE
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade AffinityItems to newer
* versions in the future.If you wish to customize AffinityItems for your
* needs please refer to http://www.affinity-engine.fr for more information.
*
*  @author    Affinity-Engine SARL <contact@affinity-engine.fr>
*  @copyright 2014 Affinity-Engine SARL
*  @license   http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL Version 2 (GPLv2)
*  International Registered Trademark & Property of Affinity Engine SARL
*/

$sql = array();

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ae_log` (
	`id_log` int(16) NOT NULL AUTO_INCREMENT,
	`date_add` DATETIME NOT NULL,
	`severity` VARCHAR(50) NOT NULL,
	`message` VARCHAR(200) NOT NULL,
	`id_shop` int(11) NOT NULL,
	PRIMARY KEY  (`id_log`)
	) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ae_product_repository` (
	`id_product` int(16) NOT NULL,
	`id_shop` int(16) NOT NULL,
	`date_upd` DATETIME,
	PRIMARY KEY  (`id_product`, `id_shop`)
	) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ae_category_repository` (
	`id_category` int(16) NOT NULL,
	`id_shop` int(16) NOT NULL,
	`date_upd` DATETIME,
	PRIMARY KEY  (`id_category`, `id_shop`)
	) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ae_member_repository` (
	`id_member` int(16) NOT NULL AUTO_INCREMENT,
	`date_upd` DATETIME,
	PRIMARY KEY  (`id_member`)
	) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ae_order_repository` (
	`id_order` int(16) NOT NULL,
	`date_add` DATETIME,
	`date_upd` DATETIME,
	PRIMARY KEY  (`id_order`)
	) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ae_cart_repository` (
	`id_cart` int(16) NOT NULL,
	`id_product` int(16) NOT NULL,
	`id_product_attribute` int(16) NOT NULL,
	`quantity` int(16) NOT NULL,
	`date_add` DATETIME,
	PRIMARY KEY  (`id_cart`, `id_product`, `id_product_attribute`)
	) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ae_guest_action_repository` (
	`id_guest` VARCHAR(200) NOT NULL,
	`action` VARCHAR(1000) NOT NULL
	) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ae_notification` (
	`id_notification` VARCHAR(200) NOT NULL,
	`date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`nread` tinyint(1) NOT NULL,
	PRIMARY KEY(id_notification)
	) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ae_notification_lang` (
	`language` VARCHAR(10) NOT NULL,
	`title` VARCHAR(200),
	`text` VARCHAR(2000),
	`id_notification` VARCHAR(200) NOT NULL,
	PRIMARY KEY(language, id_notification),
	FOREIGN KEY(id_notification) REFERENCES `'._DB_PREFIX_.'ae_notification`(id_notification)
	) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ae_cart_ab_testing` (
	`id_cart` int(16) NOT NULL,
	`id_guest` VARCHAR(200) NOT NULL,
	`cgroup` VARCHAR(1) NOT NULL,
	`date_add` DATE NULL,
	`ip` VARCHAR(200) NULL,
	PRIMARY KEY(id_cart)
	) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ae_theme` (
	`id_theme` int(16) NOT NULL AUTO_INCREMENT,
	`name` varchar(50),
	`configuration` varchar(10000),
	PRIMARY KEY(id_theme)
	) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

if (version_compare(_PS_VERSION_, '1.4', '>=') && version_compare(_PS_VERSION_, '1.5', '<'))
	$sql[] = 'INSERT INTO '._DB_PREFIX_.'ae_theme(name, configuration) VALUES("Prestashop", \'a:94:{s:24:"backgroundDisplayOptions";s:1:"0";s:15:"backgroundColor";s:7:"#000000";s:26:"backgroundColorTransparent";s:1:"0";s:21:"backgroundBorderColor";s:7:"#000000";s:27:"backgroundBorderRoundedSize";s:0:"";s:20:"backgroundBorderSize";s:0:"";s:25:"backgroundProductsBlockId";s:33:"ae_featured-products_block_center";s:28:"backgroundProductsBlockClass";s:35:"ae_block ae_products_block clearfix";s:19:"backgroundContentId";s:0:"";s:22:"backgroundContentClass";s:16:"ae_block_content";s:16:"backgroundListId";s:0:"";s:19:"backgroundListClass";s:0:"";s:19:"titleDisplayOptions";s:1:"1";s:10:"titleColor";s:7:"#ffffff";s:20:"titleBackgroundColor";s:7:"#969ba5";s:31:"titleBackgroundColorTransparent";s:1:"0";s:9:"titleSize";s:0:"";s:16:"titleBorderColor";s:7:"#000000";s:22:"titleBorderRoundedSize";s:1:"4";s:15:"titleBorderSize";s:1:"1";s:10:"titleAlign";s:4:"left";s:15:"titleLineHeight";s:0:"";s:7:"titleId";s:0:"";s:10:"titleClass";s:14:"ae_title_block";s:21:"productDisplayOptions";s:1:"0";s:22:"productBackgroundColor";s:7:"#ffffff";s:33:"productBackgroundColorTransparent";s:1:"0";s:18:"productBorderColor";s:7:"#ffffff";s:24:"productBorderRoundedSize";s:1:"0";s:17:"productBorderSize";s:1:"0";s:13:"productHeight";s:3:"356";s:12:"productWidth";s:0:"";s:19:"productNumberOnLine";s:1:"4";s:18:"productMarginRight";s:1:"5";s:9:"productId";s:0:"";s:12:"productClass";s:21:"ae_ajax_block_product";s:26:"productTitleDisplayOptions";s:1:"0";s:17:"productTitleColor";s:7:"#000000";s:16:"productTitleSize";s:0:"";s:18:"productTitleHeight";s:0:"";s:17:"productTitleAlign";s:4:"left";s:22:"productTitleLineHeight";s:0:"";s:14:"productTitleId";s:0:"";s:17:"productTitleClass";s:16:"ae_s_title_block";s:32:"productDescriptionDisplayOptions";s:1:"0";s:23:"productDescriptionColor";s:7:"#000000";s:22:"productDescriptionSize";s:0:"";s:24:"productDescriptionHeight";s:0:"";s:23:"productDescriptionAlign";s:4:"left";s:28:"productDescriptionLineHeight";s:0:"";s:20:"productDescriptionId";s:0:"";s:23:"productDescriptionClass";s:15:"ae_product_desc";s:21:"pictureDisplayOptions";s:1:"0";s:18:"pictureBorderColor";s:7:"#000000";s:24:"pictureBorderRoundedSize";s:1:"0";s:17:"pictureBorderSize";s:1:"0";s:13:"pictureHeight";s:0:"";s:12:"pictureWidth";s:0:"";s:17:"pictureResolution";s:4:"home";s:13:"pictureLinkId";s:0:"";s:16:"pictureLinkClass";s:0:"";s:9:"pictureId";s:0:"";s:12:"pictureClass";s:16:"ae_product_image";s:19:"priceDisplayOptions";s:1:"0";s:10:"priceColor";s:7:"#000000";s:9:"priceSize";s:0:"";s:11:"priceHeight";s:2:"15";s:16:"priceContainerId";s:0:"";s:19:"priceContainerClass";s:18:"ae_price_container";s:7:"priceId";s:0:"";s:10:"priceClass";s:8:"ae_price";s:18:"cartDisplayOptions";s:1:"0";s:9:"cartColor";s:7:"#000000";s:14:"cartBorderSize";s:0:"";s:8:"cartSize";s:0:"";s:19:"cartBackgroundColor";s:7:"#000000";s:30:"cartBackgroundColorTransparent";s:1:"0";s:15:"cartBorderColor";s:7:"#000000";s:21:"cartBorderRoundedSize";s:0:"";s:9:"cartAlign";s:4:"left";s:14:"cartLineHeight";s:0:"";s:6:"cartId";s:0:"";s:9:"cartClass";s:33:"exclusive ajax_add_to_cart_button";s:20:"detailDisplayOptions";s:1:"1";s:11:"detailColor";s:7:"#ffffff";s:10:"detailSize";s:0:"";s:8:"detailId";s:0:"";s:11:"detailClass";s:11:"ae_lnk_more";s:15:"titleActivation";s:1:"1";s:22:"productTitleActivation";s:1:"1";s:28:"productDescriptionActivation";s:1:"1";s:15:"priceActivation";s:1:"1";s:14:"cartActivation";s:1:"1";s:16:"detailActivation";s:1:"1";}\')';
else if (version_compare(_PS_VERSION_, '1.5', '>=') && version_compare(_PS_VERSION_, '1.6', '<')) 
	$sql[] = 'INSERT INTO '._DB_PREFIX_.'ae_theme(name, configuration) VALUES("Prestashop", \'a:94:{s:24:"backgroundDisplayOptions";s:1:"0";s:15:"backgroundColor";s:7:"#000000";s:26:"backgroundColorTransparent";s:1:"0";s:21:"backgroundBorderColor";s:7:"#000000";s:27:"backgroundBorderRoundedSize";s:0:"";s:20:"backgroundBorderSize";s:0:"";s:25:"backgroundProductsBlockId";s:33:"ae_featured-products_block_center";s:28:"backgroundProductsBlockClass";s:35:"ae_block ae_products_block clearfix";s:19:"backgroundContentId";s:0:"";s:22:"backgroundContentClass";s:16:"ae_block_content";s:16:"backgroundListId";s:0:"";s:19:"backgroundListClass";s:0:"";s:19:"titleDisplayOptions";s:1:"0";s:10:"titleColor";s:7:"#000000";s:20:"titleBackgroundColor";s:7:"#000000";s:31:"titleBackgroundColorTransparent";s:1:"0";s:9:"titleSize";s:0:"";s:16:"titleBorderColor";s:7:"#000000";s:22:"titleBorderRoundedSize";s:0:"";s:15:"titleBorderSize";s:0:"";s:10:"titleAlign";s:4:"left";s:15:"titleLineHeight";s:0:"";s:7:"titleId";s:0:"";s:10:"titleClass";s:14:"ae_title_block";s:21:"productDisplayOptions";s:1:"1";s:22:"productBackgroundColor";s:7:"#ffffff";s:33:"productBackgroundColorTransparent";s:1:"0";s:18:"productBorderColor";s:7:"#ffffff";s:24:"productBorderRoundedSize";s:1:"0";s:17:"productBorderSize";s:1:"0";s:13:"productHeight";s:3:"270";s:12:"productWidth";s:0:"";s:19:"productNumberOnLine";s:1:"4";s:18:"productMarginRight";s:1:"5";s:9:"productId";s:0:"";s:12:"productClass";s:21:"ae_ajax_block_product";s:26:"productTitleDisplayOptions";s:1:"0";s:17:"productTitleColor";s:7:"#000000";s:16:"productTitleSize";s:0:"";s:18:"productTitleHeight";s:0:"";s:17:"productTitleAlign";s:4:"left";s:22:"productTitleLineHeight";s:0:"";s:14:"productTitleId";s:0:"";s:17:"productTitleClass";s:16:"ae_s_title_block";s:32:"productDescriptionDisplayOptions";s:1:"0";s:23:"productDescriptionColor";s:7:"#000000";s:22:"productDescriptionSize";s:0:"";s:24:"productDescriptionHeight";s:0:"";s:23:"productDescriptionAlign";s:4:"left";s:28:"productDescriptionLineHeight";s:0:"";s:20:"productDescriptionId";s:0:"";s:23:"productDescriptionClass";s:15:"ae_product_desc";s:21:"pictureDisplayOptions";s:1:"0";s:18:"pictureBorderColor";s:7:"#000000";s:24:"pictureBorderRoundedSize";s:1:"0";s:17:"pictureBorderSize";s:1:"0";s:13:"pictureHeight";s:0:"";s:12:"pictureWidth";s:0:"";s:17:"pictureResolution";s:12:"home_default";s:13:"pictureLinkId";s:0:"";s:16:"pictureLinkClass";s:0:"";s:9:"pictureId";s:0:"";s:12:"pictureClass";s:16:"ae_product_image";s:19:"priceDisplayOptions";s:1:"0";s:10:"priceColor";s:7:"#000000";s:9:"priceSize";s:0:"";s:11:"priceHeight";s:2:"15";s:16:"priceContainerId";s:0:"";s:19:"priceContainerClass";s:15:"price_container";s:7:"priceId";s:0:"";s:10:"priceClass";s:8:"ae_price";s:18:"cartDisplayOptions";s:1:"0";s:9:"cartColor";s:7:"#000000";s:14:"cartBorderSize";s:0:"";s:8:"cartSize";s:0:"";s:19:"cartBackgroundColor";s:7:"#000000";s:30:"cartBackgroundColorTransparent";s:1:"0";s:15:"cartBorderColor";s:7:"#000000";s:21:"cartBorderRoundedSize";s:0:"";s:9:"cartAlign";s:4:"left";s:14:"cartLineHeight";s:0:"";s:6:"cartId";s:0:"";s:9:"cartClass";s:33:"exclusive ajax_add_to_cart_button";s:20:"detailDisplayOptions";s:1:"0";s:11:"detailColor";s:7:"#000000";s:10:"detailSize";s:0:"";s:8:"detailId";s:0:"";s:11:"detailClass";s:11:"ae_lnk_more";s:15:"titleActivation";s:1:"1";s:22:"productTitleActivation";s:1:"1";s:28:"productDescriptionActivation";s:1:"1";s:15:"priceActivation";s:1:"1";s:14:"cartActivation";s:1:"1";s:16:"detailActivation";s:1:"1";}\')';
else if (version_compare(_PS_VERSION_, '1.6', '>=')) 
	$sql[] = 'INSERT INTO '._DB_PREFIX_.'ae_theme(name, configuration) VALUES("Prestashop", \'a:106:{s:24:"backgroundDisplayOptions";s:1:"0";s:15:"backgroundColor";s:7:"#000000";s:26:"backgroundColorTransparent";s:1:"0";s:21:"backgroundBorderColor";s:7:"#000000";s:27:"backgroundBorderRoundedSize";s:0:"";s:20:"backgroundBorderSize";s:0:"";s:25:"backgroundProductsBlockId";s:0:"";s:28:"backgroundProductsBlockClass";s:32:"ae_block products_block clearfix";s:19:"backgroundContentId";s:0:"";s:22:"backgroundContentClass";s:0:"";s:16:"backgroundListId";s:0:"";s:19:"backgroundListClass";s:25:"ae_product_list grid row ";s:19:"titleDisplayOptions";s:1:"0";s:10:"titleColor";s:7:"#000000";s:20:"titleBackgroundColor";s:7:"#000000";s:31:"titleBackgroundColorTransparent";s:1:"0";s:9:"titleSize";s:1:"0";s:16:"titleBorderColor";s:7:"#000000";s:22:"titleBorderRoundedSize";s:0:"";s:15:"titleBorderSize";s:0:"";s:10:"titleAlign";s:4:"left";s:15:"titleLineHeight";s:0:"";s:7:"titleId";s:0:"";s:10:"titleClass";s:14:"ae_title_block";s:21:"productDisplayOptions";s:1:"1";s:22:"productBackgroundColor";s:7:"#ffffff";s:33:"productBackgroundColorTransparent";s:1:"0";s:18:"productBorderColor";s:7:"#ffffff";s:24:"productBorderRoundedSize";s:1:"0";s:17:"productBorderSize";s:1:"0";s:13:"productHeight";s:3:"315";s:12:"productWidth";s:3:"285";s:19:"productNumberOnLine";s:1:"4";s:18:"productMarginRight";s:1:"5";s:9:"productId";s:0:"";s:12:"productClass";s:21:"ae_ajax_block_product";s:18:"productContainerId";s:0:"";s:21:"productContainerClass";s:0:"";s:18:"productLeftBlockId";s:0:"";s:21:"productLeftBlockClass";s:13:"ae_left-block";s:19:"productRightBlockId";s:0:"";s:22:"productRightBlockClass";s:14:"ae_right-block";s:26:"productTitleDisplayOptions";s:1:"1";s:17:"productTitleColor";s:7:"#000000";s:16:"productTitleSize";s:2:"16";s:18:"productTitleHeight";s:2:"25";s:17:"productTitleAlign";s:4:"left";s:22:"productTitleLineHeight";s:0:"";s:14:"productTitleId";s:0:"";s:17:"productTitleClass";s:16:"ae_s_title_block";s:18:"productLinkTitleId";s:0:"";s:21:"productLinkTitleClass";s:12:"product-name";s:32:"productDescriptionDisplayOptions";s:1:"0";s:23:"productDescriptionColor";s:7:"#000000";s:22:"productDescriptionSize";s:0:"";s:24:"productDescriptionHeight";s:0:"";s:23:"productDescriptionAlign";s:4:"left";s:28:"productDescriptionLineHeight";s:0:"";s:20:"productDescriptionId";s:0:"";s:23:"productDescriptionClass";s:15:"ae_product_desc";s:21:"pictureDisplayOptions";s:1:"0";s:18:"pictureBorderColor";s:7:"#000000";s:24:"pictureBorderRoundedSize";s:0:"";s:17:"pictureBorderSize";s:0:"";s:13:"pictureHeight";s:0:"";s:12:"pictureWidth";s:0:"";s:17:"pictureResolution";s:12:"home_default";s:13:"pictureLinkId";s:0:"";s:16:"pictureLinkClass";s:0:"";s:9:"pictureId";s:0:"";s:12:"pictureClass";s:16:"ae_product_image";s:19:"priceDisplayOptions";s:1:"1";s:10:"priceColor";s:7:"#000000";s:9:"priceSize";s:2:"25";s:11:"priceHeight";s:2:"30";s:16:"priceContainerId";s:0:"";s:19:"priceContainerClass";s:0:"";s:7:"priceId";s:0:"";s:10:"priceClass";s:25:"ae_price ae_product-price";s:10:"oldPriceId";s:0:"";s:13:"oldPriceClass";s:29:"ae_old-price ae_product-price";s:16:"priceReductionId";s:0:"";s:19:"priceReductionClass";s:26:"ae_price-percent-reduction";s:18:"cartDisplayOptions";s:1:"0";s:9:"cartColor";s:7:"#000000";s:14:"cartBorderSize";s:0:"";s:8:"cartSize";s:0:"";s:19:"cartBackgroundColor";s:7:"#000000";s:30:"cartBackgroundColorTransparent";s:1:"0";s:15:"cartBorderColor";s:7:"#000000";s:21:"cartBorderRoundedSize";s:0:"";s:9:"cartAlign";s:4:"left";s:14:"cartLineHeight";s:0:"";s:6:"cartId";s:0:"";s:9:"cartClass";s:30:"button ajax_add_to_cart_button";s:20:"detailDisplayOptions";s:1:"0";s:11:"detailColor";s:7:"#000000";s:10:"detailSize";s:0:"";s:8:"detailId";s:0:"";s:11:"detailClass";s:15:"button lnk_view";s:15:"titleActivation";s:1:"1";s:22:"productTitleActivation";s:1:"1";s:28:"productDescriptionActivation";s:1:"0";s:15:"priceActivation";s:1:"1";s:14:"cartActivation";s:1:"1";s:16:"detailActivation";s:1:"1";}\')';