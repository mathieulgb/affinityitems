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

class ActionAdapter {

	public static function countAction()
	{
		return Db::getInstance()->getValue('SELECT count(*) as countElement FROM `'._DB_PREFIX_.'ae_guest_action_repository`');
	}

	public static function getActionList($bulk)
	{
		return Db::getInstance()->executeS('
			SELECT id_guest as id, action
			FROM '._DB_PREFIX_.'ae_guest_action_repository
			ORDER BY id ASC
			LIMIT 0,'.(int)$bulk.';');
	}

	public static function getGuestActionList($guest_id)
	{
		return Db::getInstance()->executeS('SELECT action
			FROM '._DB_PREFIX_.'ae_guest_action_repository
			WHERE id_guest = \''.pSQL((string)$guest_id).'\'');
	}

	public static function insertAction($action)
	{
		Db::getInstance()->execute('INSERT INTO `'._DB_PREFIX_.'ae_guest_action_repository` VALUES(\''.pSQL($action->guestId).'\'
			, \''.pSQL(serialize($action)).'\');');
	}

	public static function deleteAction($action)
	{
		Db::getInstance()->execute('DELETE FROM `'._DB_PREFIX_.'ae_guest_action_repository` WHERE id_guest = \''.pSQL($action->guestId).'\'
			AND action = \''.pSQL(serialize($action)).'\';');
	}

}

?>