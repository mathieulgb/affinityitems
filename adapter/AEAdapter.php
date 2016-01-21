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

require_once(dirname(__FILE__).'/../backward_compatibility/backward.php');

class AEAdapter {

	public static function getCartGuestId($cart_id) 
	{
		return Db::getInstance()->getValue('SELECT id_guest FROM '._DB_PREFIX_.'ae_cart_ab_testing WHERE id_cart = '.(int)$cart_id);
	}

	public static function getCartGroup($cart_id)
	{
		return Db::getInstance()->getValue('SELECT cgroup FROM '._DB_PREFIX_.'ae_cart_ab_testing WHERE id_cart = '.(int)$cart_id);
	}

	public static function setCartGroup($cart_id, $group, $person_id, $ip)
	{
		Db::getInstance()->Execute('INSERT INTO '._DB_PREFIX_.'ae_cart_ab_testing(id_cart, id_guest, cgroup, date_add, ip)
			VALUES('.(int)$cart_id.', \''.pSQL($person_id).'\' , \''.pSQL($group).'\', NOW(), \''.pSQL($ip).'\')
			ON DUPLICATE KEY UPDATE cgroup = \''.pSQL($group).'\' , ip = \''.pSQL($ip).'\', id_guest = \''.pSQL($person_id).'\'');
	}

	public static function getRecommendationSelect()
	{
		if (version_compare(_PS_VERSION_, '1.4.0.1', '>='))
		{
			$select = '
			SELECT p.*, pa.id_product_attribute, pl.description, pl.description_short, pl.available_now, pl.available_later, pl.link_rewrite,
			pl.meta_description, pl.meta_keywords, pl.meta_title, pl.name, i.id_image, il.legend, m.name as manufacturer_name,
			tl.name as tax_name, t.rate, cl.name as category_default, cl.`link_rewrite` as category_rewrite
			';
		}
		else
		{
			$select = '
			SELECT p.*, pa.`id_product_attribute`, pl.`description`, pl.`description_short`, pl.`available_now`,
			pl.`available_later`, pl.`link_rewrite`, pl.`meta_description`,
			pl.`meta_keywords`, pl.`meta_title`, pl.`name`, i.`id_image`, il.`legend`, m.`name` AS manufacturer_name,
			tl.`name` AS tax_name, t.`rate`, cl.`name` AS category_default,
			(p.`price` * IF(t.`rate`,((100 + (t.`rate`))/100),1) - IF((DATEDIFF(`reduction_from`, CURDATE()) <= 0
				AND DATEDIFF(`reduction_to`, CURDATE()) >=0) OR `reduction_from` = `reduction_to`,
			IF(`reduction_price` > 0, `reduction_price`,
			(p.`price` * IF(t.`rate`,((100 + (t.`rate`))/100),1) * `reduction_percent` / 100)),0)) AS orderprice
			';
		}

		return $select;
	}

	public static function getRecommendationTax()
	{
		$tax = '
		LEFT JOIN '._DB_PREFIX_.'tax_rule tr ON (p.id_tax_rules_group = tr.id_tax_rules_group AND tr.id_country = 1 AND tr.id_state = 0)
		LEFT JOIN '._DB_PREFIX_.'tax t ON (t.id_tax = tr.id_tax)
		LEFT JOIN '._DB_PREFIX_.'tax_lang tl ON (t.id_tax = tl.id_tax AND tl.id_lang = 1)
		';
		return $tax;
	}

	public static function renderRecommendation($select, $tax, $product_pool, $lang_id)
	{
		$products = Db::getInstance()->ExecuteS('
			'.$select.'
			FROM '._DB_PREFIX_.'product p
			LEFT JOIN '._DB_PREFIX_.'product_lang pl ON (pl.id_product = p.id_product)
			LEFT JOIN '._DB_PREFIX_.'product_attribute pa ON (p.id_product = pa.id_product AND default_on = 1)
			LEFT JOIN '._DB_PREFIX_.'manufacturer m ON m.id_manufacturer = p.id_manufacturer
			LEFT JOIN '._DB_PREFIX_.'image i ON (i.id_product = p.id_product AND i.cover = 1)
			LEFT JOIN '._DB_PREFIX_.'image_lang il ON (il.id_image = i.id_image)
			LEFT JOIN '._DB_PREFIX_.'category_lang cl ON (cl.id_category = p.id_category_default)
			'.$tax.'
			WHERE p.id_product IN ('.implode(',', array_map('intval', $product_pool)).')
			AND pl.id_lang = '.(int)$lang_id.'
			AND cl.id_lang = '.(int)$lang_id.'
			AND p.active = 1
			GROUP BY p.id_product
			ORDER BY FIELD(p.id_product,'.implode(',', array_map('intval', $product_pool)).')');

		$products = Product::getProductsProperties((int)$lang_id, $products);

		return $products;
	}

	public static function renderPreviewRecommendation($lang_id)
	{
		$product_number = version_compare(_PS_VERSION_, '1.6', '>=') ? 1 : 4;
		$products = Db::getInstance()->ExecuteS('
			'.self::getRecommendationSelect().'
			FROM '._DB_PREFIX_.'product p
			LEFT JOIN '._DB_PREFIX_.'product_lang pl ON (pl.id_product = p.id_product)
			LEFT JOIN '._DB_PREFIX_.'product_attribute pa ON (p.id_product = pa.id_product AND default_on = 1)
			LEFT JOIN '._DB_PREFIX_.'manufacturer m ON m.id_manufacturer = p.id_manufacturer
			LEFT JOIN '._DB_PREFIX_.'image i ON (i.id_product = p.id_product AND i.cover = 1)
			LEFT JOIN '._DB_PREFIX_.'image_lang il ON (il.id_image = i.id_image)
			LEFT JOIN '._DB_PREFIX_.'category_lang cl ON (cl.id_category = p.id_category_default)
			'.self::getRecommendationTax().'
			AND pl.id_lang = '.(int)$lang_id.'
			AND cl.id_lang = '.(int)$lang_id.'
			AND p.active = 1
			GROUP BY p.id_product
			LIMIT 0,'.$product_number.'');

		$products = Product::getProductsProperties((int)$lang_id, $products);

		return $products;
	}


	public static function getEmployeesByProfile($id_employee)
	{
		if (version_compare(_PS_VERSION_, '1.5', '>='))
			return EmployeeCore::getEmployeesByProfile((int)$id_employee);
		else
		{
			return Db::getInstance()->executeS('
				SELECT *
				FROM `'._DB_PREFIX_.'employee`
				WHERE `id_profile` = '.(int)$id_employee);
		}
	}

	public static function insertTheme($name, $configuration)
	{
		Db::getInstance()->execute('INSERT INTO `'._DB_PREFIX_.'ae_theme` VALUES(\'\', \''.$name.'\', \''.$configuration.'\');');
	}

	public static function updateTheme($theme_id, $configuration)
	{
		Db::getInstance()->execute('UPDATE `'._DB_PREFIX_.'ae_theme` SET configuration = \''.$configuration.'\' WHERE id_theme = '.$theme_id.';');
	}

	public static function getThemeList()
	{
		return Db::getInstance()->executeS('SELECT DISTINCT id_theme, name, configuration
			FROM `'._DB_PREFIX_.'ae_theme`;');
	}

	public static function getThemeById($theme_id)
	{
		return Db::getInstance()->executeS('SELECT DISTINCT id_theme, name, configuration
			FROM `'._DB_PREFIX_.'ae_theme`
			WHERE id_theme = '.$theme_id.';');
	}

	public static function getLastCreatedTheme()
	{
		return Db::getInstance()->getValue('SELECT DISTINCT MAX(id_theme) as id_theme
			FROM `'._DB_PREFIX_.'ae_theme`;');
	}

	public static function getStoreList() 
	{
		return Db::getInstance()->executeS('SELECT name, address1, city, email, phone
			FROM `'._DB_PREFIX_.'store`;');
	}

	public static function insertNotification($notification)
	{
		Db::getInstance()->execute('INSERT INTO `'._DB_PREFIX_.'ae_notification`
			VALUES(\''.pSQL($notification->id).'\', \''.pSQL($notification->date).'\', 0);');
	}

	public static function insertTranslation($translation)
	{
		Db::getInstance()->execute('INSERT INTO `'._DB_PREFIX_.'ae_notification_lang` VALUES(\''.pSQL($translation->language).'\'
			, \''.pSQL($translation->title).'\' , \''.pSQL($translation->text).'\' , \''.pSQL($translation->notificationId).'\');');
	}

	public static function updateNotification($notification)
	{
		Db::getInstance()->execute('UPDATE `'._DB_PREFIX_.'ae_notification` SET nread = 1 WHERE id_notification = \''.pSQL($notification->id).'\';');
	}

	public static function getNotifications($lang)
	{
		return Db::getInstance()->ExecuteS('SELECT n.id_notification, nl.title, nl.text FROM '._DB_PREFIX_.'ae_notification n,
			`'._DB_PREFIX_.'ae_notification_lang` nl
			WHERE nread = 0 and n.id_notification = nl.id_notification
			AND nl.language = (SELECT iso_code FROM `'._DB_PREFIX_.'lang` WHERE id_lang = '.(int)$lang.')');
	}

	public static function log($severity, $message)
	{
		$multishop = (Context::getContext()->shop->isFeatureActive()) ? Shop::getContextShopID(true) : 1;
		Db::getInstance()->execute('INSERT INTO `'._DB_PREFIX_.'ae_log` VALUES(\'\', NOW(), \''.pSQL($severity).'\'
			, \''.pSQL($message).'\', '.(int)$multishop.');');
		error_log($severity.' '.$message);
	}

	public static function getLog()
	{
		$multishop = (Context::getContext()->shop->isFeatureActive()) ? Shop::getContextShopID(true) : 1;
		return Db::getInstance()->ExecuteS('SELECT * FROM '._DB_PREFIX_.'ae_log WHERE id_shop = '.(int)$multishop.'
			ORDER BY date_add DESC LIMIT 0, 500');
	}

	public static function getActiveLanguageIds()
	{
		$ids = array();
		$languages = Language::getLanguages();
		foreach ($languages as $language)
			array_push($ids, $language['id_lang']);
		return implode(',', $ids);
	}

	public static function deleteCategorySync() 
	{
		Db::getInstance()->execute('TRUNCATE `'._DB_PREFIX_.'ae_category_repository`;');
	}

	public static function deleteProductSync()
	{
		Db::getInstance()->execute('TRUNCATE `'._DB_PREFIX_.'ae_product_repository`;');
	}

	public static function deleteOrderSync() 
	{
		Db::getInstance()->execute('TRUNCATE `'._DB_PREFIX_.'ae_order_repository`;');
	}

	public static function deleteActionSync() 
	{
		Db::getInstance()->execute('TRUNCATE `'._DB_PREFIX_.'ae_guest_action_repository`;');
	}

	public static function getBulkPackage() 
	{
		return Configuration::get('AE_BULK_PACKAGE');
	}

	public static function getHost()
	{
		return Configuration::get('AE_CONF_HOST');
	}

	public static function getPort()
	{
		return Configuration::get('AE_CONF_PORT');
	}

	public static function getSiteId()
	{
		return Configuration::get('AE_SITE_ID');
	}

	public static function getSecurityKey()
	{
		return Configuration::get('AE_SECURITY_KEY');
	}

	public static function getStartDate()
	{
		return Configuration::get('AE_LAST_SYNC_START');
	}

	public static function getEndDate()
	{
		return Configuration::get('AE_LAST_SYNC_END');
	}

	public static function getLock()
	{
		return Configuration::get('AE_LAST_SYNC_LOCK');
	}

	public static function getStep()
	{
		return Configuration::get('AE_LAST_SYNC_STEP');
	}

	public static function authentication($email, $password, $site_id, $security_key)
	{
		Configuration::updateValue('AE_LOGIN', $email);
		Configuration::updateValue('AE_PASSWORD', $password);
		Configuration::updateValue('AE_SITE_ID', $site_id);
		Configuration::updateValue('AE_SECURITY_KEY', $security_key);
	}

	public static function setStartDate($timestamp)
	{
		Configuration::updateValue('AE_LAST_SYNC_START', $timestamp);
	}

	public static function setEndDate($timestamp)
	{
		Configuration::updateValue('AE_LAST_SYNC_END', $timestamp);
	}

	public static function setBulkPackage($bulk) 
	{
		Configuration::updateValue('AE_BULK_PACKAGE', $bulk);
	}

	public static function setLock($state)
	{
		Configuration::updateValue('AE_LAST_SYNC_LOCK', $state);
	}

	public static function setStep($step)
	{
		Configuration::updateValue('AE_LAST_SYNC_STEP', $step);
	}

	public static function getShopName()
	{
		return Configuration::get('PS_SHOP_NAME');
	}

	public static function getActivity()
	{
		return Configuration::get('PS_SHOP_ACTIVITY');
	}

	public static function getSyncDiff()
	{
		return Configuration::get('AE_SYNC_DIFF');
	}

	public static function getLocalHosts()
	{
		return Configuration::get('AE_HOST_LIST');
	}

	public static function setLocalHosts($hosts)
	{
		Configuration::updateValue('AE_HOST_LIST', $hosts);
	}

	public static function getAbTestingPercentage()
	{
		return Configuration::get('AE_A_TESTING');
	}

	public static function setAbTestingPercentage($percentage)
	{
		Configuration::updateValue('AE_A_TESTING', $percentage);
	}

	public static function getBlackListIp()
	{
		return Configuration::get('AE_AB_TESTING_BLACKLIST');
	}

	public static function setBlackListIp($black_list)
	{
		Configuration::updateValue('AE_AB_TESTING_BLACKLIST', $black_list);
	}

	public static function getBackOfficeToken()
	{
		return Configuration::get('AE_BACKOFFICE_TOKEN');
	}

	public static function setTrackingJs($trackingJs)
	{
		Configuration::updateValue('AE_TRACKING_JS', $trackingJs);
	}

	public static function getActiveRecommendation()
	{
		return Configuration::get('AE_RECOMMENDATION');
	}

	public static function setActiveRecommendation($active)
	{
		Configuration::updateValue('AE_RECOMMENDATION', $active);
	}

	public static function isConfig()
	{
		if (!AELibrary::isEmpty(Configuration::get('AE_SITE_ID'))
		&& !AELibrary::isEmpty(Configuration::get('AE_SECURITY_KEY')))
			return true;
		return false;
	}

	public static function isLastSync()
	{
		if (!AELibrary::isEmpty(Configuration::get('AE_LAST_SYNC_END')))
			return true;
		return false;
	}

}
