<?php 

class MemberAdapter {
	
	public static function countMember($clause) 
	{
		return Db::getInstance()->executeS('SELECT DISTINCT count(*) as cmember
			FROM '._DB_PREFIX_.'customer c
			LEFT JOIN '._DB_PREFIX_.'guest g ON c.id_customer = g.id_customer
			'.$clause.';');
	}

	public static function newMemberClause() 
	{
		return 'WHERE c.id_customer NOT IN (SELECT id_member FROM '._DB_PREFIX_.'ae_member_repository)';
	}

	public static function updateMemberClause() 
	{
		return 'WHERE c.date_upd > (SELECT mr.date_upd FROM '._DB_PREFIX_.'ae_member_repository mr WHERE mr.id_member = c.id_customer)';
	}

	public static function getMemberList($clause, $bulk) 
	{
		return Db::getInstance()->executeS('SELECT DISTINCT c.id_customer, c.firstname, c.lastname, c.email, c.birthday, c.date_upd, g.accept_language
			FROM '._DB_PREFIX_.'customer c 
			LEFT JOIN '._DB_PREFIX_.'guest g ON c.id_customer = g.id_customer
			'.$clause.' 
			LIMIT 0,'.(int)$bulk.';');
	}

	public static function insertMember($member) 
	{
		Db::getInstance()->execute('INSERT INTO `'._DB_PREFIX_.'ae_member_repository` VALUES('.$member->memberId.', \''.$member->updateDate.'\');');
	}

	public static function updateMember($member) 
	{
		Db::getInstance()->execute('UPDATE `'._DB_PREFIX_.'ae_member_repository` SET date_upd = \''.$member->updateDate.'\' WHERE id_member = '.$member->memberId.';');
	}

}

?>