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

function upgrade_module_2_0_0($module)
{
	Configuration::updateValue('AE_BULK_PACKAGE', '50');
	Configuration::updateValue('AE_FUNNEL', 1);
	Configuration::updateValue('AE_TRACKING_JS', 0);
	Configuration::updateValue('AE_LIMIT', 2);
	return true;
}