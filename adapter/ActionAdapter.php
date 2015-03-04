<?php 

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