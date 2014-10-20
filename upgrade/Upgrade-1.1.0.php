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

if (!defined('_PS_VERSION_'))
	exit;

function formatConfiguration($configuration, $hook_name)
{
	$hook_configuration = new stdClass();
	foreach ($configuration as $key => $value)
	{
		$k = str_replace($hook_name, '', $key);
		$hook_configuration->{$k} = $value;
	}
	return $hook_configuration;
}

function updateGlobalValue($key, $value)
{
	if (version_compare(_PS_VERSION_, '1.5', '>='))
		Configuration::updateGlobalValue($key, $value);
	else
		Configuration::updateValue($key, $value);
}

function execSqlInstall()
{
	$sql = array();
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

foreach ($sql as $s)
{
	if (!Db::getInstance()->execute($s))
		return false;
}

return true;
}

function countTheme() 
{
		$count = Db::getInstance()->executeS('SELECT count(*) as count FROM '._DB_PREFIX_.'ae_theme');
		return $count[0]['count'];
}


function retrieveConfiguration()
{
	$sql = array();
	$hook_list = array('Home', 'Left', 'Right', 'Product', 'Cart', 'Category', 'Search');
	foreach ($hook_list as $hook)
	{
		$configuration = formatConfiguration(unserialize(Configuration::get('AE_CONFIGURATION_'.Tools::strtoupper($hook).'')), $hook);
		$theme_serialized = AEAdapter::getThemeById(1);
		$theme = unserialize($theme_serialized[0]['configuration']);
		
		if (isset($configuration->parentId))
			$theme['backgroundProductsBlockId'] = $configuration->parentId;
		if (isset($configuration->classParent))
			$theme['backgroundProductsBlockClass'] = $configuration->classParent;
		if (isset($configuration->contentId))
			$theme['backgroundContentId'] = $configuration->contentId;
		if (isset($configuration->classContent))
			$theme['backgroundContentClass'] = $configuration->classContent;
		if (isset($configuration->listId))
			$theme['backgroundListId'] = $configuration->listId;
		if (isset($configuration->classList))
			$theme['backgroundListClass'] = $configuration->classList;
		if (isset($configuration->classTitle))
			$theme['titleClass'] = $configuration->classTitle;
		if (isset($configuration->elementListId))
			$theme['productId'] = $configuration->elementListId;
		if (isset($configuration->classElementList))
			$theme['productClass'] = $configuration->classElementList;
		if (isset($configuration->classElementName))
			$theme['productTitleClass'] = $configuration->classElementName;
		if (isset($configuration->classElementDescription))
			$theme['productDescriptionClass'] = $configuration->classElementDescription;
		if (isset($configuration->classElementImage))
			$theme['pictureClass'] = $configuration->classElementImage;
		if (isset($configuration->classPriceContainer))
			$theme['priceContainerClass'] = $configuration->classPriceContainer;
		if (isset($configuration->classPrice))
			$theme['priceClass'] = $configuration->classPrice;
		if (countTheme() < 8)
			$sql[] = 'INSERT INTO '._DB_PREFIX_.'ae_theme(name, configuration) VALUES("'.$hook.'", \''.serialize($theme).'\')';
	}

	foreach ($sql as $s)
	{
		if (!Db::getInstance()->execute($s))
			return false;
	}

	return true;
}

function updateConfiguration() 
{
	$properties = array();
	$properties['AE_CONFIGURATION_HOME'] = 'O:8:"stdClass":19:{s:10:"recoHome_1";s:1:"0";s:15:"recoThemeHome_1";s:1:"1";s:14:"recoTypeHome_1";s:7:"recoAll";s:14:"recoSizeHome_1";s:1:"4";s:15:"recoTitleHome_1";s:22:"Nous vous recommandons";s:16:"recoFilterHome_1";s:6:"onSale";s:17:"categoryIdsHome_1";s:0:"";s:18:"attributeIdsHome_1";s:0:"";s:16:"featureIdsHome_1";s:0:"";s:10:"recoHome_2";s:1:"0";s:15:"recoThemeHome_2";s:1:"1";s:14:"recoTypeHome_2";s:7:"recoAll";s:14:"recoSizeHome_2";s:1:"4";s:15:"recoTitleHome_2";s:22:"Nous vous recommandons";s:16:"recoFilterHome_2";s:6:"onSale";s:17:"categoryIdsHome_2";s:0:"";s:18:"attributeIdsHome_2";s:0:"";s:16:"featureIdsHome_2";s:0:"";s:4:"area";s:4:"home";}';
	$properties['AE_CONFIGURATION_CART'] = 'O:8:"stdClass":11:{s:10:"recoCart_1";s:1:"0";s:15:"recoThemeCart_1";s:1:"1";s:14:"recoTypeCart_1";s:8:"recoCart";s:14:"recoSizeCart_1";s:1:"4";s:15:"recoTitleCart_1";s:22:"Nous vous recommandons";s:10:"recoCart_2";s:1:"0";s:15:"recoThemeCart_2";s:1:"1";s:14:"recoTypeCart_2";s:8:"recoCart";s:14:"recoSizeCart_2";s:1:"4";s:15:"recoTitleCart_2";s:22:"Nous vous recommandons";s:4:"area";s:4:"cart";}';
	$properties['AE_CONFIGURATION_LEFT'] = 'O:8:"stdClass":19:{s:10:"recoLeft_1";s:1:"0";s:15:"recoThemeLeft_1";s:1:"1";s:14:"recoTypeLeft_1";s:7:"recoAll";s:14:"recoSizeLeft_1";s:1:"4";s:15:"recoTitleLeft_1";s:22:"Nous vous recommandons";s:16:"recoFilterLeft_1";s:6:"onSale";s:17:"categoryIdsLeft_1";s:0:"";s:18:"attributeIdsLeft_1";s:0:"";s:16:"featureIdsLeft_1";s:0:"";s:10:"recoLeft_2";s:1:"0";s:15:"recoThemeLeft_2";s:1:"1";s:14:"recoTypeLeft_2";s:7:"recoAll";s:14:"recoSizeLeft_2";s:1:"4";s:15:"recoTitleLeft_2";s:22:"Nous vous recommandons";s:16:"recoFilterLeft_2";s:6:"onSale";s:17:"categoryIdsLeft_2";s:0:"";s:18:"attributeIdsLeft_2";s:0:"";s:16:"featureIdsLeft_2";s:0:"";s:4:"area";s:4:"left";}';
	$properties['AE_CONFIGURATION_RIGHT'] = 'O:8:"stdClass":19:{s:11:"recoRight_1";s:1:"0";s:16:"recoThemeRight_1";s:1:"1";s:15:"recoTypeRight_1";s:7:"recoAll";s:15:"recoSizeRight_1";s:1:"4";s:16:"recoTitleRight_1";s:22:"Nous vous recommandons";s:17:"recoFilterRight_1";s:6:"onSale";s:18:"categoryIdsRight_1";s:0:"";s:19:"attributeIdsRight_1";s:0:"";s:17:"featureIdsRight_1";s:0:"";s:11:"recoRight_2";s:1:"0";s:16:"recoThemeRight_2";s:1:"1";s:15:"recoTypeRight_2";s:7:"recoAll";s:15:"recoSizeRight_2";s:1:"4";s:16:"recoTitleRight_2";s:22:"Nous vous recommandons";s:17:"recoFilterRight_2";s:6:"onSale";s:18:"categoryIdsRight_2";s:0:"";s:19:"attributeIdsRight_2";s:0:"";s:17:"featureIdsRight_2";s:0:"";s:4:"area";s:5:"right";}';
	$properties['AE_CONFIGURATION_PRODUCT'] = 'O:8:"stdClass":11:{s:13:"recoProduct_1";s:1:"0";s:18:"recoThemeProduct_1";s:1:"1";s:17:"recoTypeProduct_1";s:11:"recoSimilar";s:17:"recoSizeProduct_1";s:1:"4";s:18:"recoTitleProduct_1";s:22:"Nous vous recommandons";s:13:"recoProduct_2";s:1:"0";s:18:"recoThemeProduct_2";s:1:"1";s:17:"recoTypeProduct_2";s:11:"recoSimilar";s:17:"recoSizeProduct_2";s:1:"4";s:18:"recoTitleProduct_2";s:22:"Nous vous recommandons";s:4:"area";s:7:"product";}';

	if (version_compare(_PS_VERSION_, '1.4', '>=') && version_compare(_PS_VERSION_, '1.5', '<')) 
	{
		$properties['AE_CONFIGURATION_SEARCH'] = 'O:8:"stdClass":15:{s:12:"recoSearch_1";s:1:"0";s:17:"recoThemeSearch_1";s:1:"1";s:16:"recoTypeSearch_1";s:10:"recoSearch";s:16:"recoSizeSearch_1";s:1:"4";s:17:"recoTitleSearch_1";s:22:"Nous vous recommandons";s:20:"recoSelectorSearch_1";s:17:".productsSortForm";s:28:"recoSelectorPositionSearch_1";s:6:"before";s:12:"recoSearch_2";s:1:"0";s:17:"recoThemeSearch_2";s:1:"1";s:16:"recoTypeSearch_2";s:10:"recoSearch";s:16:"recoSizeSearch_2";s:1:"4";s:17:"recoTitleSearch_2";s:22:"Nous vous recommandons";s:20:"recoSelectorSearch_2";s:17:".productsSortForm";s:28:"recoSelectorPositionSearch_2";s:6:"before";s:4:"area";s:6:"search";}';
		$properties['AE_CONFIGURATION_CATEGORY'] = 'O:8:"stdClass":21:{s:17:"categoryIdsHome_1";s:0:"";s:17:"categoryIdsHome_2";s:0:"";s:17:"categoryIdsLeft_1";s:0:"";s:17:"categoryIdsLeft_2";s:0:"";s:18:"categoryIdsRight_1";s:0:"";s:18:"categoryIdsRight_2";s:0:"";s:14:"recoCategory_1";s:1:"0";s:19:"recoThemeCategory_1";s:1:"1";s:18:"recoTypeCategory_1";s:12:"recoCategory";s:18:"recoSizeCategory_1";s:1:"4";s:19:"recoTitleCategory_1";s:22:"Nous vous recommandons";s:22:"recoSelectorCategory_1";s:17:".productsSortForm";s:30:"recoSelectorPositionCategory_1";s:6:"before";s:14:"recoCategory_2";s:1:"0";s:19:"recoThemeCategory_2";s:1:"1";s:18:"recoTypeCategory_2";s:12:"recoCategory";s:18:"recoSizeCategory_2";s:1:"4";s:19:"recoTitleCategory_2";s:22:"Nous vous recommandons";s:22:"recoSelectorCategory_2";s:17:".productsSortForm";s:30:"recoSelectorPositionCategory_2";s:6:"before";s:4:"area";s:8:"category";}';
	}
	else if (version_compare(_PS_VERSION_, '1.5', '>=') && version_compare(_PS_VERSION_, '1.6', '<')) 
	{
		$properties['AE_CONFIGURATION_SEARCH'] = 'O:8:"stdClass":15:{s:12:"recoSearch_1";s:1:"0";s:17:"recoThemeSearch_1";s:1:"1";s:16:"recoTypeSearch_1";s:10:"recoSearch";s:16:"recoSizeSearch_1";s:1:"4";s:17:"recoTitleSearch_1";s:22:"Nous vous recommandons";s:20:"recoSelectorSearch_1";s:21:".sortPagiBar.clearfix";s:28:"recoSelectorPositionSearch_1";s:6:"before";s:12:"recoSearch_2";s:1:"0";s:17:"recoThemeSearch_2";s:1:"1";s:16:"recoTypeSearch_2";s:10:"recoSearch";s:16:"recoSizeSearch_2";s:1:"4";s:17:"recoTitleSearch_2";s:22:"Nous vous recommandons";s:20:"recoSelectorSearch_2";s:21:".sortPagiBar.clearfix";s:28:"recoSelectorPositionSearch_2";s:6:"before";s:4:"area";s:6:"search";}';
		$properties['AE_CONFIGURATION_CATEGORY'] = 'O:8:"stdClass":21:{s:17:"categoryIdsHome_1";s:0:"";s:17:"categoryIdsHome_2";s:0:"";s:17:"categoryIdsLeft_1";s:0:"";s:17:"categoryIdsLeft_2";s:0:"";s:18:"categoryIdsRight_1";s:0:"";s:18:"categoryIdsRight_2";s:0:"";s:14:"recoCategory_1";s:1:"0";s:19:"recoThemeCategory_1";s:1:"1";s:18:"recoTypeCategory_1";s:12:"recoCategory";s:18:"recoSizeCategory_1";s:1:"4";s:19:"recoTitleCategory_1";s:22:"Nous vous recommandons";s:22:"recoSelectorCategory_1";s:21:".sortPagiBar.clearfix";s:30:"recoSelectorPositionCategory_1";s:6:"before";s:14:"recoCategory_2";s:1:"0";s:19:"recoThemeCategory_2";s:1:"1";s:18:"recoTypeCategory_2";s:12:"recoCategory";s:18:"recoSizeCategory_2";s:1:"4";s:19:"recoTitleCategory_2";s:22:"Nous vous recommandons";s:22:"recoSelectorCategory_2";s:21:".sortPagiBar.clearfix";s:30:"recoSelectorPositionCategory_2";s:6:"before";s:4:"area";s:8:"category";}';
	}
	else if (version_compare(_PS_VERSION_, '1.6', '>=')) 
	{
		$properties['AE_CONFIGURATION_SEARCH'] = 'O:8:"stdClass":15:{s:12:"recoSearch_1";s:1:"0";s:17:"recoThemeSearch_1";s:1:"1";s:16:"recoTypeSearch_1";s:10:"recoSearch";s:16:"recoSizeSearch_1";s:1:"4";s:17:"recoTitleSearch_1";s:22:"Nous vous recommandons";s:20:"recoSelectorSearch_1";s:21:".sortPagiBar.clearfix";s:28:"recoSelectorPositionSearch_1";s:6:"before";s:12:"recoSearch_2";s:1:"0";s:17:"recoThemeSearch_2";s:1:"1";s:16:"recoTypeSearch_2";s:10:"recoSearch";s:16:"recoSizeSearch_2";s:1:"4";s:17:"recoTitleSearch_2";s:22:"Nous vous recommandons";s:20:"recoSelectorSearch_2";s:21:".sortPagiBar.clearfix";s:28:"recoSelectorPositionSearch_2";s:6:"before";s:4:"area";s:6:"search";}';
		$properties['AE_CONFIGURATION_CATEGORY'] = 'O:8:"stdClass":21:{s:17:"categoryIdsHome_1";s:0:"";s:17:"categoryIdsHome_2";s:0:"";s:17:"categoryIdsLeft_1";s:0:"";s:17:"categoryIdsLeft_2";s:0:"";s:18:"categoryIdsRight_1";s:0:"";s:18:"categoryIdsRight_2";s:0:"";s:14:"recoCategory_1";s:1:"0";s:19:"recoThemeCategory_1";s:1:"1";s:18:"recoTypeCategory_1";s:12:"recoCategory";s:18:"recoSizeCategory_1";s:1:"4";s:19:"recoTitleCategory_1";s:22:"Nous vous recommandons";s:22:"recoSelectorCategory_1";s:21:".sortPagiBar.clearfix";s:30:"recoSelectorPositionCategory_1";s:6:"before";s:14:"recoCategory_2";s:1:"0";s:19:"recoThemeCategory_2";s:1:"1";s:18:"recoTypeCategory_2";s:12:"recoCategory";s:18:"recoSizeCategory_2";s:1:"4";s:19:"recoTitleCategory_2";s:22:"Nous vous recommandons";s:22:"recoSelectorCategory_2";s:21:".sortPagiBar.clearfix";s:30:"recoSelectorPositionCategory_2";s:6:"before";s:4:"area";s:8:"category";}';
	}
	foreach ($properties as $key => $value)
		updateGlobalValue($key, $value);
	
	return true;
}

function upgrade_module_1_1_0($module)
{
	if (!execSqlInstall())
		return false;

	if (!retrieveConfiguration())
		return false;

	if (!updateConfiguration())
		return false;
	Configuration::updateValue('AE_VERSION', '1.1.0');
	return ($module->registerHook('createAccount'));
}