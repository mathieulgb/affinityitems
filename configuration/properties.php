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

$properties = array(
	'AE_BULK_PACKAGE' => 50,
	'AE_BREAK_CONTRACT' => 0,
	'AE_LIMIT' => 2,
	'AE_FUNNEL' => 0,
	'AE_CONF_HOST' => '',
	'AE_TRACKING_JS' => 0,
	'AE_CONF_PORT' => '',
	'AE_LOGIN' => '',
	'AE_PASSWORD' => '',
	'AE_SITE_ID' => '',
	'AE_VERSION' => '1.2.0',
	'AE_SECURITY_KEY' => '',
	'AE_LAST_SYNC_START' => '',
	'AE_LAST_SYNC_END' => '',
	'AE_LAST_SYNC_STEP' => '',
	'AE_LAST_SYNC_LOCK' => 0,
	'AE_SYNC_DIFF' => 60,
	'AE_A_TESTING' => 100,
	'AE_AB_TESTING_BLACKLIST' => serialize(array()),
	'AE_HOST_LIST' => '',
	'AE_BOT_SEO_ACTIVATION' => 0,
	'AE_RECOMMENDATION' => 0,
	'AE_ADDITIONAL_CSS' => '',
	'AE_BACKOFFICE_TOKEN' => md5(uniqid(rand(), true))
	);

$properties['AE_CONFIGURATION_HOME'] = 'O:8:"stdClass":19:{s:10:"recoHome_1";s:1:"1";s:15:"recoThemeHome_1";s:1:"1";s:14:"recoTypeHome_1";s:7:"recoAll";s:14:"recoSizeHome_1";s:1:"4";s:15:"recoTitleHome_1";s:22:"Nous vous recommandons";s:16:"recoFilterHome_1";s:6:"onSale";s:17:"categoryIdsHome_1";s:0:"";s:18:"attributeIdsHome_1";s:0:"";s:16:"featureIdsHome_1";s:0:"";s:10:"recoHome_2";s:1:"0";s:15:"recoThemeHome_2";s:1:"1";s:14:"recoTypeHome_2";s:7:"recoAll";s:14:"recoSizeHome_2";s:1:"4";s:15:"recoTitleHome_2";s:22:"Nous vous recommandons";s:16:"recoFilterHome_2";s:6:"onSale";s:17:"categoryIdsHome_2";s:0:"";s:18:"attributeIdsHome_2";s:0:"";s:16:"featureIdsHome_2";s:0:"";s:4:"area";s:4:"home";}';
$properties['AE_CONFIGURATION_CART'] = 'O:8:"stdClass":11:{s:10:"recoCart_1";s:1:"1";s:15:"recoThemeCart_1";s:1:"1";s:14:"recoTypeCart_1";s:8:"recoCart";s:14:"recoSizeCart_1";s:1:"4";s:15:"recoTitleCart_1";s:22:"Nous vous recommandons";s:10:"recoCart_2";s:1:"0";s:15:"recoThemeCart_2";s:1:"1";s:14:"recoTypeCart_2";s:8:"recoCart";s:14:"recoSizeCart_2";s:1:"4";s:15:"recoTitleCart_2";s:22:"Nous vous recommandons";s:4:"area";s:4:"cart";}';
$properties['AE_CONFIGURATION_LEFT'] = 'O:8:"stdClass":19:{s:10:"recoLeft_1";s:1:"0";s:15:"recoThemeLeft_1";s:1:"1";s:14:"recoTypeLeft_1";s:7:"recoAll";s:14:"recoSizeLeft_1";s:1:"4";s:15:"recoTitleLeft_1";s:22:"Nous vous recommandons";s:16:"recoFilterLeft_1";s:6:"onSale";s:17:"categoryIdsLeft_1";s:0:"";s:18:"attributeIdsLeft_1";s:0:"";s:16:"featureIdsLeft_1";s:0:"";s:10:"recoLeft_2";s:1:"0";s:15:"recoThemeLeft_2";s:1:"1";s:14:"recoTypeLeft_2";s:7:"recoAll";s:14:"recoSizeLeft_2";s:1:"4";s:15:"recoTitleLeft_2";s:22:"Nous vous recommandons";s:16:"recoFilterLeft_2";s:6:"onSale";s:17:"categoryIdsLeft_2";s:0:"";s:18:"attributeIdsLeft_2";s:0:"";s:16:"featureIdsLeft_2";s:0:"";s:4:"area";s:4:"left";}';
$properties['AE_CONFIGURATION_RIGHT'] = 'O:8:"stdClass":19:{s:11:"recoRight_1";s:1:"0";s:16:"recoThemeRight_1";s:1:"1";s:15:"recoTypeRight_1";s:7:"recoAll";s:15:"recoSizeRight_1";s:1:"4";s:16:"recoTitleRight_1";s:22:"Nous vous recommandons";s:17:"recoFilterRight_1";s:6:"onSale";s:18:"categoryIdsRight_1";s:0:"";s:19:"attributeIdsRight_1";s:0:"";s:17:"featureIdsRight_1";s:0:"";s:11:"recoRight_2";s:1:"0";s:16:"recoThemeRight_2";s:1:"1";s:15:"recoTypeRight_2";s:7:"recoAll";s:15:"recoSizeRight_2";s:1:"4";s:16:"recoTitleRight_2";s:22:"Nous vous recommandons";s:17:"recoFilterRight_2";s:6:"onSale";s:18:"categoryIdsRight_2";s:0:"";s:19:"attributeIdsRight_2";s:0:"";s:17:"featureIdsRight_2";s:0:"";s:4:"area";s:5:"right";}';
$properties['AE_CONFIGURATION_PRODUCT'] = 'O:8:"stdClass":11:{s:13:"recoProduct_1";s:1:"1";s:18:"recoThemeProduct_1";s:1:"1";s:17:"recoTypeProduct_1";s:11:"recoSimilar";s:17:"recoSizeProduct_1";s:1:"4";s:18:"recoTitleProduct_1";s:22:"Nous vous recommandons";s:13:"recoProduct_2";s:1:"0";s:18:"recoThemeProduct_2";s:1:"1";s:17:"recoTypeProduct_2";s:11:"recoSimilar";s:17:"recoSizeProduct_2";s:1:"4";s:18:"recoTitleProduct_2";s:22:"Nous vous recommandons";s:4:"area";s:7:"product";}';

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
?>