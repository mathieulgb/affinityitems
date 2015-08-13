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

function upgrade_module_3_0_0($module)
{
	$themeList = Db::getInstance()->executeS('SELECT DISTINCT id_theme, name, configuration FROM `'._DB_PREFIX_.'ae_theme`;');

	foreach ($themeList as $theme) {
		$configuration = array();
		$configuration = unserialize($theme['configuration']);
		$configuration['titleContainerId'] = '';
		$configuration['titleContainerClass'] = '';
		$configuration['titleBeforeId'] = '';
		$configuration['titleBeforeClass'] = '';
		$configuration['titleAfterId'] = '';
		$configuration['titleAfterClass'] = '';
		$configuration = serialize($configuration);
		$sql[] = 'UPDATE `'._DB_PREFIX_.'ae_theme` SET configuration = \''.$configuration.'\' WHERE id_theme = '.$theme['id_theme'].';';
	}

	foreach ($sql as $s)
	{
		if (!Db::getInstance()->execute($s))
			return false;
	}

	Configuration::updateValue('AE_VERSION', '3.0.0');	
	return true;
}